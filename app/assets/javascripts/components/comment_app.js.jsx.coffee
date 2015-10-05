@CommentApp = React.createClass
  propTypes:
    user:                    React.PropTypes.object.isRequired
    project:                 React.PropTypes.object.isRequired
    comments:                React.PropTypes.array.isRequired
    commentable_type:        React.PropTypes.string.isRequired
    commentable_resource_id: React.PropTypes.any.isRequired
    commentable_record_id:   React.PropTypes.any.isRequired
    commentable_socket_path: React.PropTypes.string
    is_user_in_project:      React.PropTypes.bool.isRequired
    is_unsubscribable:       React.PropTypes.bool

  getDefaultProps: () ->
    { is_unsubscribable: true }

  getInitialState: () ->
    return {comments: @props.comments}

  componentWillReceiveProps: (props) ->
    if (!@props.notReset)
      @setState({comments: props.comments})

  componentDidMount: () ->
    if @props.commentable_socket_path
      PrivatePub.subscribe( @props.commentable_socket_path, @dataRecieve )
    else
      PrivatePub.subscribe("/#{@props.commentable_type}/#{@props.commentable_record_id}/comments", @dataRecieve)

  componentWillUnmount: () ->
    if @props.is_unsubscribable
      if @props.commentable_socket_path
        PrivatePub.unsubscribe( @props.commentable_socket_path )
      else
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
      commentCreateForm = `<CommentCreateForm {...this.props}/>`

    `<div className='commentApp'>
        <CommentList {...this.props} comments={this.state.comments} />
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
    user:               React.PropTypes.object.isRequired
    comments:           React.PropTypes.array.isRequired
    project:            React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  render: ->
    user = @props.user
    project = @props.project
    is_user_in_project = @props.is_user_in_project
    commentNodes = @props.comments.map (comment) =>
      `<Comment key={comment.id} comment={comment}
          user={user} project={project} is_user_in_project={is_user_in_project} />`

    `<div className='commentList' ref='commentList'>
      {commentNodes}
    </div>`

@Comment = React.createClass
  propTypes:
    user:               React.PropTypes.object.isRequired
    comment:            React.PropTypes.object.isRequired
    project:            React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: ->
    return {editMode: false}

  toggleEdit: (e)->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  render: ->

    if @state.editMode
      commentContent =
        `<div className="content">
            <CommentEditForm  toggleEdit={this.toggleEdit} {...this.props}/>
        </div>`
    else

      if @props.is_user_in_project
        commentControl = `<CommentControl toggleEdit={this.toggleEdit} {...this.props} />`

      commentContent =
        `<div className="content">
            <div className="ui segment top attached comment-content-header content-header">
                <CommentHeader comment={this.props.comment}/>
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
    time = moment(new Date(@props.comment.created_at)).fromNow()
    `<span className="time">{time}</span>`

@CommentControl = React.createClass
  propTypes:
    user:       React.PropTypes.object.isRequired
    project:    React.PropTypes.object.isRequired
    comment:    React.PropTypes.object.isRequired
    toggleEdit: React.PropTypes.func.isRequired

  handleLike: (e) ->
    e.preventDefault()
    Ajaxer.put
      path: "/projects/#{@props.project.slug}/comments/#{@props.comment.id}/likes"

  render: ->
    deletePath = "../comments/#{@props.comment.id}.json"

    liked_users = @props.comment.liked_users

    if _.find( liked_users , (u)=> u.id == @props.user.id )
      like_icon = `<i className="green heart icon" />`
    else
      like_icon = `<i className="heart icon" />`

    `<div className="ui control" >
        <a className="gray simple link" onClick={this.props.toggleEdit} href="">
            <i className="icon write"></i>
        </a>
        <a className="gray simple link" onClick={this.handleLike} href="" >
            {like_icon} { liked_users.length }
        </a>
    </div>`

@CommentEditForm = React.createClass
  propTypes:
    comment:    React.PropTypes.object.isRequired
    toggleEdit: React.PropTypes.func.isRequired
    project:    React.PropTypes.object.isRequired

  handleSubmit: ( data, done ) ->
    Ajaxer.patch
      path: "/projects/#{@props.project.slug}/comments/#{@props.comment.id}.json"
      data: { comment: { content: data } }
      done: =>
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
    commentable_type:        React.PropTypes.node.isRequired
    commentable_resource_id: React.PropTypes.node.isRequired
    project:                 React.PropTypes.object.isRequired

  handleSubmit: ( data, done ) ->
    Ajaxer.post
      path: "/projects/#{@props.project.slug}/#{@props.commentable_type}s/#{@props.commentable_resource_id}/comments.json"
      data: { comment: { content: data } }
      done: =>
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

  suggestions: null

  getInitialState: () ->
    return {isPreviewMode: false, commentText: @props.commentText}

  componentDidMount: () ->
    @enableSuggestion() if @refs.textarea

  componentDidUpdate: (prevProps, prevState) ->
    @enableSuggestion() if prevState.isPreviewMode && !@state.isPreviewMode

  enableSuggestion: () ->
    $element = $(@refs.textarea.getDOMNode())
    $element.atwho
      at: '@'
      displayTpl: "<li>${name}</li>"
      insertTpl: "${atwho-at}${name}",
      searchKey: "name"

    $element.atwho
      at: '#'
      displayTpl: "<li>${title}</li>"
      insertTpl: "${atwho-at}${sequential_id}",
      searchKey: "title"

    $element.atwho
      at: '!'
      displayTpl: "<li>${title}</li>"
      insertTpl: "${atwho-at}${sequential_id}",
      searchKey: "title"

    $element.atwho
      at: '^'
      displayTpl: "<li>${title}</li>"
      insertTpl: "${atwho-at}${sequential_id}",
      searchKey: "title"

    $element.atwho
      at: '~'
      displayTpl: "<li>${name}</li>"
      insertTpl: "${atwho-at}${sequential_id}",
      searchKey: "name"

    $element.on 'inserted.atwho', => @setState({commentText: $element.val()})

    if @suggestions
      $element.atwho 'load', '@', @suggestions.members
      $element.atwho 'load', '#', @suggestions.issues
      $element.atwho 'load', '!', @suggestions.sprints
      $element.atwho 'load', '^', @suggestions.polls
      $element.atwho 'load', '~', @suggestions.attachments
    else
      $suggestionsPath = $element.attr('data-suggestions-path')
      $.getJSON($suggestionsPath).done (data) =>
        @suggestions = data
        $element.atwho 'load', '@', data.members
        $element.atwho 'load', '#', data.issues
        $element.atwho 'load', '!', data.sprints
        $element.atwho 'load', '^', data.polls
        $element.atwho 'load', '~', data.attachments

  handleSubmit: (e) ->
    e.preventDefault()
    if @state.commentText.trim().length == 0
      console.log('zero')
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

  getConfigurations: ->
    configurations =
      mode: 'static'
      targets: [
        {
          flag: '@'
          stages: [{
            insertField: 'name'
            displayTpl: '${name}'
            dataFetcher: (stageChoices, callback) =>
              $.get "/projects/#{@props.project.slug}/suggestions.json", (data) =>
                callback(data.members)
          }]
        }
        {
          flag: '^'
          stages: [{
            insertField: 'sequential_id'
            displayTpl: '${sequential_id} ${title}'
            dataFetcher: (stageChoices, callback) =>
              $.get "/projects/#{@props.project.slug}/suggestions.json", (data) =>
                callback(data.polls)
          }]
        }
        {
          flag: '$'
          stages: [{
            insertField: 'sequential_id'
            displayTpl: '${sequential_id} ${name}'
            dataFetcher: (stageChoices, callback) =>
              $.get "/projects/#{@props.project.slug}/suggestions.json", (data) =>
                callback(data.attachments)
          }]
        }
        {
          flag: '#'
          stages: [{
            insertField: 'sequential_id'
            displayTpl: '${sequential_id} ${title}'
            dataFetcher: (stageChoices, callback) =>
              $.get "/projects/#{@props.project.slug}/suggestions.json", (data) =>
                callback(data.issues)
          }]
        }
        {
          flag: '##'
          stages: [{
            insertField: 'sequential_id'
            displayTpl: '${sequential_id} ${title}'
            dataFetcher: (stageChoices, callback) =>
              $.get "/projects/#{@props.project.slug}/suggestions.json", (data) =>
                callback(data.sprints)
          }]
        }
        {
          flag: ':'
          stages: [
            {
              insertField: 'sequential_id'
              displayTpl: '${sequential_id} ${name}'
              dataFetcher: (stageChoices, callback) =>
                $.get "/projects/#{@props.project.slug}/suggestions.json", (data) =>
                  callback(data.channels)
            }
            {
              insertField: 'sequential_id'
              displayTpl: '${sequential_id} ${content}'
              dataFetcher: (stageChoices, callback) =>
                $.get "/projects/#{@props.project.slug}/suggestions/channels/#{stageChoices[0]}/messages", (data) =>
                  callback(data.messages)
            }
          ]
        }
      ]

  handleTextareaChange: (textareaContent) ->
    this.setState({commentText: textareaContent})

  render: ->

    if @state.isPreviewMode
      displayField =
        `<div className="ui attached segment" id="comment_content_preview_field">
            <CommentPreviewField originText={this.state.commentText}/>
        </div>`
    else
      project_suggestions_path = "/projects/#{@props.project.slug}/suggestions"
      displayField =
        `<div className="ui attached segment">
            <MentionableTextarea placeholder={'撰寫評論 支援 Markdown\n\n使用 @ 可以通知成員\n使用 # 可以連結任務\n使用 ^ 可以連結投票\n使用 $ 可以連結檔案\n使用 : 可以連結頻道'}
                                 configurations={this.getConfigurations()} ref="textarea" valueLink={this.linkState('commentText')}
                                 data-suggestions-path={project_suggestions_path} limit={10}/>
        </div>`

    `<form className="ui form" onSubmit={this.handleSubmit}>
        <div className="ui top attached segment tertiary tabular menu comment-content-header" >
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
    Ajaxer.put
      path: "/text/preview.json"
      data: { content: @props.originText }
      done: ( data ) =>
        @setState({loading: false, previewText: data.content })
      fail: () =>
        @setState({loading: false, previewText: "error: cannot fetch preview text"})

  render: ->
    if @state.loading
      `<div className="ui active inverted dimmer">
          <div className="ui text loader"></div>
      </div>`
    else
      `<div dangerouslySetInnerHTML={{__html: this.state.previewText }}></div>`
