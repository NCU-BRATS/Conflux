@CommentApp = React.createClass
  propTypes:
    is_user_in_project: React.PropTypes.bool.isRequired
    user: React.PropTypes.object.isRequired
    project: React.PropTypes.object.isRequired
    comments: React.PropTypes.array.isRequired
    commentable_type: React.PropTypes.string.isRequired
    commentable_resource_id: React.PropTypes.any.isRequired
    commentable_record_id: React.PropTypes.any.isRequired

  getInitialState: () ->
    return {comments: @props.comments}

  componentDidMount: () ->
    PrivatePub.subscribe("/#{@props.commentable_type}/#{@props.commentable_record_id}/comments", @dataRecieve)

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/#{@props.commentable_type}/#{@props.commentable_record_id}/comments")

  dataRecieve: (res, channel) ->
    @appendComment(res.data)  if res.target == 'comment' && res.action == 'create'
    @replaceComment(res.data) if res.target == 'comment' && res.action == 'update'
    @destroyComment(res.data) if res.target == 'comment' && res.action == 'destroy'

  appendComment: (comment) ->
    newComments = @state.comments.concat(comment)
    @setState({comments: newComments})

  replaceComment: (comment) ->
    comments = @state.comments.slice()
    i = _.findIndex(comments, (c)-> c.id == comment.id)
    comments[i] = comment
    @setState({comments: comments})

  destroyComment: (comment) ->
    comments = @state.comments.slice()
    i = _.findIndex(comments, (c)-> c.id == comment.id)
    comments.splice(i,1)
    @setState({comments: comments})

  render: ->

    is_user_in_project = @props.is_user_in_project

    if is_user_in_project
      commentCreateForm = `<CommentCreateForm project={this.props.project} commentable_resource_id={this.props.commentable_resource_id}/>`

    `<div className='commentApp'>
        <CommentList is_user_in_project={is_user_in_project} comments={this.state.comments} project={this.props.project}/>
        <div className="ui divider hidden"></div>

      <div className="comment header">
        <div className="thumb">
          <Avatar user={this.props.user}/>
        </div>
        <div className="content">
            {commentCreateForm}
        </div>
      </div>
    </div>`

@CommentList = React.createClass
  propTypes:
    is_user_in_project: React.PropTypes.bool.isRequired
    comments: React.PropTypes.array.isRequired
    project: React.PropTypes.object.isRequired
  render: ->
    project = @props.project
    is_user_in_project = @props.is_user_in_project
    commentNodes = @props.comments.map (comment) =>
      `<Comment comment={comment} is_user_in_project={is_user_in_project} project={project} ref={comment.id} key={comment.id}/>`

    `<div className='commentList' ref='commentList'>
      {commentNodes}
    </div>`

@Comment = React.createClass
  propTypes:
    is_user_in_project: React.PropTypes.bool.isRequired
    comment: React.PropTypes.object.isRequired
    project: React.PropTypes.object.isRequired

  getInitialState: ->
    return {editMode: false}

  toggleEdit: (e)->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  render: ->

    if @state.editMode
      commentContent =
        `<div className="content">
            <CommentEditForm comment={this.props.comment} project={this.props.project} toggleEdit={this.toggleEdit}/>
        </div>`
    else

      if @props.is_user_in_project
        commentControl = `<CommentControl comment={this.props.comment} toggleEdit={this.toggleEdit}/>`

      commentContent =
        `<div className="content">
            <div className="ui segment top attached comment-content-header">
                <CommentHeader comment={this.props.comment}/>
                <i className="icon star"></i>
                {commentControl}
            </div>
            <div className="ui segment bottom attached">
                <div className="body">
                    <div className="description" dangerouslySetInnerHTML={{__html:this.props.comment.html}}></div>
                </div>
            </div>
        </div>`

    `<div className="comment header">
        <div className="thumb">
            <Avatar user={this.props.comment.user}/>
        </div>
        {commentContent}
    </div>`

@CommentHeader = React.createClass
  propTypes:
    comment: React.PropTypes.object.isRequired
  render: ->
    userPath = "/users/#{@props.comment.user.slug}"
    `<div className="header">
        <a className="bold black link" href={userPath}>{this.props.comment.user.name}</a>
        <CommentTime comment={this.props.comment}/>
    </div>`

@CommentTime = React.createClass
  propTypes:
    comment: React.PropTypes.object.isRequired
  render: ->
    time = moment(new Date(@props.comment.created_at)).format('h:mm a')
    `<span className="time">{time}</span>`

@CommentControl = React.createClass
  propTypes:
    comment: React.PropTypes.object.isRequired
    toggleEdit: React.PropTypes.func.isRequired
  render: ->
    deletePath = "../comments/#{@props.comment.id}.json"
    `<div className="ui control" >
        <a className="gray simple link" onClick={this.props.toggleEdit} href="">
            <i className="icon write"></i>
        </a>
        <a className="gray simple link" data-confirm="你確定要刪除嗎?" data-method="delete" data-remote="" href={deletePath}>
            <i className="icon trash"></i>
        </a>
    </div>`

@CommentEditForm = React.createClass
  propTypes:
    comment: React.PropTypes.object.isRequired
    toggleEdit: React.PropTypes.func.isRequired
    project: React.PropTypes.object.isRequired

  handleSubmit: ( data, done ) ->
    path = "../comments/#{@props.comment.id}.json"
    $.ajax( path, {
      method: 'PATCH'
      data: { comment: { content: data } }
    })
    .done () =>
      @props.toggleEdit()

  render: () ->
    cancelButton =
      `<a className="ui right floated button" onClick={this.props.toggleEdit}>
          <i className="icon angle left"></i>
          cancel
      </a>`
    `<CommentForm handleSubmit={this.handleSubmit} controlPanel={cancelButton} project={this.props.project} commentText={this.props.comment.content}/>`


@CommentCreateForm = React.createClass
  propTypes:
    commentable_resource_id: React.PropTypes.any.isRequired
    project: React.PropTypes.object.isRequired

  handleSubmit: ( data, done ) ->
    postPath = "#{@props.commentable_resource_id}/comments.json"
    $.post( postPath, { comment: { content: data } } ).done () ->
      done()

  render: () ->
    `<CommentForm handleSubmit={this.handleSubmit} project={this.props.project} commentText=""/>`


@CommentForm = React.createClass
  propTypes:
    handleSubmit: React.PropTypes.func.isRequired
    controlPanel: React.PropTypes.node
    project: React.PropTypes.object.isRequired
    commentText: React.PropTypes.string

  mixins: [React.addons.LinkedStateMixin]

  getInitialState: () ->
    return {isPreviewMode: false, commentText: @props.commentText}

  componentDidMount: () ->
    this.enableSuggestion()

  enableSuggestion: () ->
    unless @refs.textarea
      $element = $(@refs.textarea.getDOMNode())
      $element.atwho
        at: '@'
        displayTpl: "<li>${name}</li>"
        insertTpl: "${atwho-at}${name}",
        searchKey: "name"

      $element.atwho
        at: '#'
        displayTpl: "<li>${title}</li>"
        insertTpl: "${atwho-at}${id}",
        searchKey: "title"

      $suggestionsPath = $element.attr('data-suggestions-path')

      $.getJSON($suggestionsPath).done (data) ->
        $element.atwho 'load', '@', data.members
        $element.atwho 'load', '#', data.issues

  handleSubmit: (e) ->
    e.preventDefault()
    if @state.commentText.trim().length == 0
      return
    @props.handleSubmit @state.commentText, () =>
      @setState({isPreviewMode: false, commentText: ''})

  handlePreviewMode: (e) ->
    @setState {isPreviewMode: true}, ()=>
      $(@refs.originModeButton.getDOMNode()).removeClass('active')
      $(@refs.previewModeButton.getDOMNode()).addClass('active')

  handleOriginMode: (e) ->
    @setState {isPreviewMode: false}, ()=>
      $(@refs.originModeButton.getDOMNode()).addClass('active')
      $(@refs.previewModeButton.getDOMNode()).removeClass('active')

  render: ->

    if @state.isPreviewMode
      displayField =
        `<div className="ui attached segment" id="comment_content_preview_field">
            <CommentPreviewField originText={this.state.commentText}/>
        </div>`
    else
      project_suggestions_path = "/projects/#{@props.project.id}/suggestions"
      displayField =
        `<div className="ui attached segment" id="comment_content_origin_field">
            <textarea type="text" ref="textarea" placeholder="撰寫評論 支援 markdown" valueLink={this.linkState('commentText')}
                data-toggle="suggestion" data-suggestions-path={project_suggestions_path}/>
        </div>`

    `<form className="ui form" onSubmit={this.handleSubmit}>
        <div className="ui top attached segment tertiary tabular menu" >
            <a className="ui gray item active" ref="originModeButton" onClick={this.handleOriginMode}>撰寫</a>
            <a className="ui gray item" ref="previewModeButton" onClick={this.handlePreviewMode}>預覽</a>
            {this.props.controlPanel}
        </div>
        <div>
            {displayField}
            <input className="ui fluid teal compact button comment-submit" type="submit" value="OK"/>
        </div>
    </form>`

@CommentPreviewField = React.createClass
  propTypes:
    originText: React.PropTypes.string.isRequired

  getInitialState: () ->
    return {loading: true, previewText: ''}

  componentDidMount: ->
    $.ajax( "/text/preview.json", {
      method: 'PUT'
      data: { content: @props.originText }
    })
    .done (data) =>
      @setState({loading: false, previewText: data.content })
    .fail () =>
      @setState({loading: false, previewText: "error: cannot fetch preview text"})

  render: ->
    if @state.loading
      `<div className="ui active inverted dimmer">
          <div className="ui text loader"></div>
      </div>`
    else
      `<div dangerouslySetInnerHTML={{__html: this.state.previewText }}></div>`