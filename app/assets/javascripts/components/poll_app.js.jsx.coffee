@PollApp = React.createClass
  propTypes:
    poll:               React.PropTypes.object.isRequired
    project:            React.PropTypes.object.isRequired
    comments:           React.PropTypes.array.isRequired
    user:               React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {poll: @props.poll}

  componentDidMount: () ->
    PrivatePub.subscribe("/projects/#{@props.project.id}/polls/#{@props.poll.sequential_id}", @dataRecieve)

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/polls/#{@props.poll.sequential_id}")

  dataRecieve: (res, channel) ->
    @replacePoll(res.data) if res.target == 'poll' && res.action == 'update'

  replacePoll: (poll) ->
    @setState({poll: poll})

  render: ->
    is_user_in_project = @props.is_user_in_project
    poll = @state.poll
    `<div className='poll-app'>
        <div className='contents'>
          <PollHeader ref='header' poll={poll}/>
          <div className="ui divider"/>
          <CommentApp is_user_in_project={is_user_in_project} project={this.props.project} user={this.props.user}
                      comments={this.props.comments}
                      commentable_type="poll"
                      commentable_record_id={this.props.poll.id}
                      commentable_resource_id={this.props.poll.sequential_id} />
        </div>
        <div className='attributes'>
          <PollAttribute ref='attribute' {...this.props} poll={poll}/>
        </div>
    </div>`

@PollHeader = React.createClass
  propTypes:
    poll: React.PropTypes.object.isRequired
  render: ->
    poll = @props.poll

    `<div className="poll-header">
        <h3>
            <PollStatusMark poll={poll} />
            {" ^"+poll.sequential_id} {poll.title}
        </h3>
    </div>`

@PollStatusMark = React.createClass
  propTypes:
    poll: React.PropTypes.object.isRequired

  componentDidMount:  ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  handleOpen: ->
    Ajaxer.put
      path: "../polls/#{@props.poll.sequential_id}/reopen.json"

  handleClose: ->
    Ajaxer.put
      path: "../polls/#{@props.poll.sequential_id}/close.json"

  render: ->
    poll = @props.poll
    if poll.status == 'open'
      mark = `<div> <i className="icon green unlock"/> 開啟 </div>`
      items = `<div className="item" onClick={this.handleClose}>CLOSE</div>`
    else
      mark = `<div> <i className="icon red lock"/> 關閉 </div>`
      items = `<div className="item" onClick={this.handleOpen}>OPEN</div>`

    `<a className="ui label large poll-mark dropdown" ref="dropdown" >
        {mark}
        <div className="menu">
            {items}
        </div>
    </a>`

@PollAttribute = React.createClass
  propTypes:
    project:            React.PropTypes.object.isRequired
    poll:               React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  render: ->

    `<div className="container">
      <PollOptionsBlock     {...this.props} />
      <PollCreaterBlock     {...this.props} />
      <PollParticipantBlock {...this.props} />
    </div>`

@PollOptionsBlock = React.createClass
  propTypes:
    poll: React.PropTypes.object.isRequired
    user: React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  constructOptions: (sourceOptions) ->
    _.map(sourceOptions, (o) -> {id: o.id, title: o.title})

  getInitialState: ->
    return {editMode: false, editOptions: @constructOptions(@props.poll.options), multi: @props.poll.allow_multiple_choice}

  componentWillReceiveProps: (nextProps) ->
    @setState({editOptions: @constructOptions(nextProps.poll.options), multi: nextProps.poll.allow_multiple_choice})

  toggleMulti: (e) ->
    e.preventDefault() if e
    @setState({multi: !@state.multi})

  toggleEdit: (e) ->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  changeOptionTitle: (i, value) ->
    options = @state.editOptions.slice()
    options[i].title = value
    @setState({editOptions: options})

  addNewOption: () ->
    options = @state.editOptions.slice()
    options.push({isNew: true, title: ''})
    @setState({editOptions: options})

  toggleDestroyOption: (i) ->
    options = @state.editOptions.slice()
    options[i].destroy = !options[i].destroy
    options[i].error   = false
    @setState({editOptions: options})

  submitVote: (id) ->
    Ajaxer.patch
      path: "#{@props.poll.sequential_id}/polling_options/#{id}"

  submitOptions: (e) ->
    e.preventDefault()

    options = @state.editOptions.slice()

    data = []
    for option in options
      if !option.destroy && option.title == ''
        option.error = invalidate = true
      else
        data.push
          id: option.id
          title: option.title
          _destroy: if option.destroy then 1 else 0

    if invalidate
      @setState({editOptions: options})
    else
      Ajaxer.put
        path: "#{@props.poll.sequential_id}.json"
        data:
          poll:
            allow_multiple_choice: if @state.multi then 1 else 0
            options_attributes: data
        done: =>
          @setState({editMode: false})

  render: ->
    if @state.editMode
      contentNode = `<PollOptionEdit options={this.state.editOptions} multi={this.state.multi} changeOptionTitle={this.changeOptionTitle} addNewOption={this.addNewOption} toggleDestroyOption={this.toggleDestroyOption} toggleMulti={this.toggleMulti} submitOptions={this.submitOptions} />`
    else
      totalVotes  = _.reduce(@props.poll.options, (sum, option) ->
        sum + option.voted_users.length
      , 0)

      user       = @props.user
      submitVote = @submitVote

      contentNode = @props.poll.options.map (option) =>
        `<PollOption user={user} option={option} key={option.id} totalVotes={totalVotes} submitVote={submitVote} />`

    if @props.is_user_in_project
      toggleBtn = `<a className="gray simple link toggle" onClick={this.toggleEdit}><i className="setting icon"></i></a>`

    `<div className="poll-option-list">
      <h3>投票選項{toggleBtn}</h3>
      <div className="ui divider"></div>
      {contentNode}
    </div>`

@PollOptionEdit = React.createClass
  componentDidMount: () ->
    $(@refs.checkbox.getDOMNode()).checkbox()

  render: ->
    changeOptionTitle   = @props.changeOptionTitle
    toggleDestroyOption = @props.toggleDestroyOption

    options = @props.options.map (option, i) ->
      `<PollOptionInput i={i} option={option} key={i} changeOptionTitle={changeOptionTitle} toggleDestroyOption={toggleDestroyOption} />`

    `<form className="ui form" ref="form" onSubmit={this.props.submitOptions}>
      <div ref="checkbox" className="ui toggle checkbox" onClick={this.props.toggleMulti}>
        <input type="checkbox" defaultChecked={this.props.multi} />
        <label>可多選</label>
      </div>

      {options}

      <div className="option">
        <div className="input"><button className="fluid ui green button">確認更新</button></div>
        <a className="gray simple link plus" onClick={this.props.addNewOption}><i className="plus icon"></i></a>
      </div>
    </form>`

@PollOptionInput = React.createClass
  propTypes:
    option: React.PropTypes.object.isRequired

  handleOnChange: (e) ->
    @props.changeOptionTitle(@props.i, e.target.value);

  toggleDestroyOption: (e) ->
    @props.toggleDestroyOption(@props.i)

  render: ->
    errorClass = ''
    if @props.option.error
      errorClass       = "error"
      errorPlaceholder = "請輸入選項標題"

    `<div className="option">
      <div className={'input ' + errorClass}><input type="text" placeholder={errorPlaceholder} disabled={this.props.option.destroy} defaultValue={this.props.option.title} onChange={this.handleOnChange}/></div>
      <a className="gray simple link plus" onClick={this.toggleDestroyOption}><i className="minus icon"></i></a>
    </div>`

@PollOption = React.createClass
  propTypes:
    user:       React.PropTypes.object.isRequired
    option:     React.PropTypes.object.isRequired
    totalVotes: React.PropTypes.number.isRequired
    submitVote: React.PropTypes.func.isRequired

  handleOnClick: ->
    @props.submitVote(@props.option.id)

  render: ->
    displayUsers = @props.option.voted_users.slice(0, 2)
    popupUsers   = @props.option.voted_users.slice(2)
    popup_users  = `<PopupUsers users={popupUsers}/>` if popupUsers.length > 0
    voted_users  = displayUsers.map (user) ->
      `<PopupAvatar user={user} key={user.id} />`

    percent = 0
    percent = @props.option.voted_users.length * 100 / @props.totalVotes if @props.totalVotes

    optionClass = if _.find(@props.option.voted_users, (u) => u.id == @props.user.id) then ' active' else ''

    `<div className="poll-option">
      <div className={'option' + optionClass} onClick={this.handleOnClick}>
        <span className="bar" style={{width: percent+'%'}}></span>
        <div className="content">
          <div className="option-title">{this.props.option.title}</div>
          <div className="option-count">{this.props.option.voted_users.length}</div>
        </div>
      </div>
      <div className="users">
        {voted_users}
        {popup_users}
      </div>
    </div>`

@PopupUsers = React.createClass
  componentDidMount: ->
    $(@refs.popup.getDOMNode()).popup()
  render: ->
    count = @props.users.length
    users = _.map(@props.users, (u) -> u.name)
    `<div ref="popup" data-html={users} className="popup users"> + {count}</div>`

@PollCreaterBlock = React.createClass
  propTypes:
    poll: React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  render: ->
    content = `<PopupLinkAvatar user={this.props.poll.user} />`

    `<PollAttributeBlock title="創建者" content={content}/>`

@PollParticipantBlock = React.createClass
  propTypes:
    poll: React.PropTypes.object.isRequired

  render: ->
    content = @props.poll.participations.map (participant) =>
      `<PopupLinkAvatar user={participant.user} key={participant.id} />`

    `<PollAttributeBlock title="參與者" content={content}/>`

@PollAttributeBlock = React.createClass
  propTypes:
    title:       React.PropTypes.node.isRequired
    content:     React.PropTypes.node.isRequired
    controlFunc: React.PropTypes.func

  render: ->

    if @props.controlFunc
      controlBlock =
        `<div className="ui right floated buttons">
          <a className="gray simple link" href="" onClick={this.props.controlFunc}>
              <i className="icon setting"/>
          </a>
        </div>`

    `<div className="block">
        <div className="ui top attached tertiary segment">
            {controlBlock}
            {this.props.title}
        </div>
        <div className="ui bottom attached segment" >
            {this.props.content}
        </div>
    </div>`
