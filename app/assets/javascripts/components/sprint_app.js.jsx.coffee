@SprintApp = React.createClass
  propTypes:
    sprint:              React.PropTypes.object.isRequired
    project:            React.PropTypes.object.isRequired
    comments:           React.PropTypes.array.isRequired
    user:               React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {sprint: @props.sprint}

  componentDidMount: () ->
    PrivatePub.subscribe("/projects/#{@props.project.id}/sprints/#{@props.sprint.sequential_id}", @dataRecieve)

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/sprints/#{@props.sprint.sequential_id}")

  dataRecieve: (res, channel) ->
    @replaceSprint(res.data) if res.target == 'sprint' && res.action == 'update'

  replaceSprint: (sprint) ->
    @setState({sprint: sprint})

  render: ->
    is_user_in_project = @props.is_user_in_project
    sprint = @state.sprint
    `<div className='sprint-app'>
        <div className='contents'>
            <SprintHeader ref='header' sprint={sprint}/>
            <div className="ui divider"/>
            <CommentApp is_user_in_project={is_user_in_project} project={this.props.project} user={this.props.user}
                comments={this.props.comments}
                commentable_type="sprint"
                commentable_record_id={this.props.sprint.id}
                commentable_resource_id={this.props.sprint.sequential_id} />
        </div>
        <div className='attributes'>
            <SprintAttribute ref='attribute' {...this.props} sprint={sprint}/>
        </div>
    </div>`

@SprintHeader = React.createClass
  propTypes:
    sprint: React.PropTypes.object.isRequired
  render: ->
    sprint = @props.sprint

    `<div className="sprint-header">
        <h3>
            <SprintStatusMark sprint={sprint} />
            {"#"+sprint.sequential_id} {sprint.title}
        </h3>
    </div>`

@SprintStatusMark = React.createClass
  propTypes:
    sprint: React.PropTypes.object.isRequired

  componentDidMount:  ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  handleOpen: ->
    Ajaxer.put
      path: "../sprints/#{@props.sprint.sequential_id}/reopen.json"

  handleClose: ->
    Ajaxer.put
      path: "../sprints/#{@props.sprint.sequential_id}/close.json"

  render: ->
    sprint = @props.sprint
    if sprint.status == 'open'
      mark = `<div> <i className="icon green unlock"/> 開啟 </div>`
      items = `<div className="item" onClick={this.handleClose}>CLOSE</div>`
    else
      mark = `<div> <i className="icon red lock"/> 關閉 </div>`
      items = `<div className="item" onClick={this.handleOpen}>OPEN</div>`

    `<a className="ui label large sprint-mark dropdown" ref="dropdown" >
        {mark}
        <div className="menu">
            {items}
        </div>
    </a>`

@SprintAttribute = React.createClass
  propTypes:
    project:            React.PropTypes.object.isRequired
    sprint:              React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  render: ->
    console.log(@props.sprint)

    `<div className="container">
        <SprintCreaterBlock     {...this.props} />
        <SprintScheduleBlock    {...this.props} />
        <SprintProgressBlock    {...this.props} />
        <SprintIssueBlock       {...this.props} />
        <SprintParticipantBlock {...this.props} />
    </div>`

@SprintCreaterBlock = React.createClass
  propTypes:
    sprint: React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  render: ->
    content = `<LabelAvatar user={this.props.sprint.user} />`

    `<SprintAttributeBlock title="創建者" content={content}/>`

@SprintProgressBlock = React.createClass
  propTypes:
    sprint: React.PropTypes.object.isRequired

  componentDidMount:  ->
    $(@refs.progress.getDOMNode()).progress
      percent: @calculatePercent()

  componentDidUpdate: ->
    console.log("gg")
    $(@refs.progress.getDOMNode()).progress
      percent: @calculatePercent()

  calculatePercent: ->
    counts = _.countBy @props.sprint.issues, (issue) ->
      if issue.status == 'open'
        'open'
      else
        'close'
    counts.open / ( counts.open + counts.close )

  render: ->

    content = `<div className="ui indicating progress" ref="progress">
                  <div className="bar">
                      <div className="progress" />
                  </div>
              </div>`

    `<SprintAttributeBlock title="進度" content={content}/>`

@SprintScheduleBlock = React.createClass
  propTypes:
    sprint:              React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {editMode: false}

  toggleEdit: (e) ->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  handleChangeBegin: (value) ->
    Ajaxer.patch
      path: "../sprints/#{@props.sprint.sequential_id}.json"
      data: {sprint: {begin_at: value}}
      done: =>
        @setState({editMode: false})


  handleChangeDue: (value) ->
    Ajaxer.patch
      path: "../sprints/#{@props.sprint.sequential_id}.json"
      data: {sprint: {due_at: value}}
      done: =>
        @setState({editMode: false})


  render: ->
    begin_at = @props.sprint.begin_at
    due_at   = @props.sprint.due_at

    if @state.editMode
      content =
        `<div>
            <DateTimeInput name="sprint[begin_at]" time={begin_at} onChange={this.handleChangeBegin} />
            <DateTimeInput name="sprint[due_at]"   time={due_at}   onChange={this.handleChangeDue} />
        </div>`
    else
      if begin_at
        begin_time = moment(new Date(begin_at)).format("YYYY-MM-DD")
        begin =
          `<div><div className="ui green circular empty label"/> {begin_time} </div>`
      if due_at
        due_time = moment(new Date(due_at)).format("YYYY-MM-DD")
        due =
          `<div><div className="ui red circular empty label"/> {due_time} </div>`

      if begin || due
        content = `<div>{begin} {due}</div>`
      else
        content = "NOT SPECIFIED"

    if @props.is_user_in_project
      controlFunc = @toggleEdit

    `<SprintAttributeBlock title="時程" content={content} controlFunc={controlFunc}/>`

@SprintIssueBlock = React.createClass
  propTypes:
    project:             React.PropTypes.object.isRequired
    sprint:              React.PropTypes.object.isRequired
    is_user_in_project:  React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {editMode: false}

  toggleEdit: (e) ->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  handleChange: (e) ->
    issue_ids = @refs.input.refs.select.getDOMNode().selectize.getValue()
    Ajaxer.patch
      path: "../sprints/#{@props.sprint.sequential_id}.json"
      data: {sprint: {issue_ids: issue_ids}}
      done: =>
        @setState({editMode: false})

  render: ->
    issues = @props.sprint.issues
    project = @props.project

    if @state.editMode
      if @props.is_user_in_project
        content =
          `<AssociationInput ref="input" name="sprint[issue_ids][]" collection={issues} onChange={this.handleChange} multiple={true}
              data_set={
                {
                    'resource-path' : "/projects/"+ project.id + "/issues",
                    'search-field' : '[ "title" ]',
                    'option-tpl' : 'option-simple',
                    'item-tpl' : 'item-simple',
                    'add-new' : 'true',
                    'query-param' : '{ "sprint_id_null" : 1 }'
                }
              }
          />`
    else
      if issues
        issuesContent = issues.map (issue) =>
          `<div className="item" key={issue.id}>
              <IssueSmallLabel issue={issue} project={project} />
          </div>`
        content = `<div className="ui list"> {issuesContent} </div>`
      else
        content = `<div>NOT SPECIFIED</div>`

    if @props.is_user_in_project
      controlFunc = @toggleEdit

    `<SprintAttributeBlock title="任務" content={content} controlFunc={controlFunc}/>`

@SprintParticipantBlock = React.createClass
  propTypes:
    sprint: React.PropTypes.object.isRequired

  render: ->
    content = @props.sprint.participations.map (participant) =>
      `<PopupLinkAvatar user={participant.user} key={participant.id} />`

    `<SprintAttributeBlock title="參與者" content={content}/>`


@SprintAttributeBlock = React.createClass
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

@SprintSmallLabel = React.createClass
  propTypes:
    sprint : React.PropTypes.object.isRequired
    project: React.PropTypes.object.isRequired

  render: ->
    sprint = @props.sprint
    href = "/projects/#{this.props.project.id}/sprints/#{this.props.sprint.sequential_id}"
    `<a className="ui label" href={href}>
        <i className="icon flag" />
        { sprint.title }
    </a>`
