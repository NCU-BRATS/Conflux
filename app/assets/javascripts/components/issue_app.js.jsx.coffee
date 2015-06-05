@IssueApp = React.createClass
  propTypes:
    issue:              React.PropTypes.object.isRequired
    project:            React.PropTypes.object.isRequired
    comments:           React.PropTypes.array.isRequired
    user:               React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {issue: @props.issue}

  componentDidMount: () ->
    PrivatePub.subscribe("/projects/#{@props.project.id}/issues/#{@props.issue.sequential_id}", @dataRecieve)

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/issues/#{@props.issue.sequential_id}")

  dataRecieve: (res, channel) ->
    @replaceIssue(res.data) if res.target == 'issue' && res.action == 'update'

  replaceIssue: (issue) ->
    @setState({issue: issue})

  render: ->
    is_user_in_project = @props.is_user_in_project
    issue = @state.issue
    `<div className='issue-app'>
        <div className='contents'>
          <IssueHeader ref='header' issue={issue}/>
          <div className="ui divider"/>
          <CommentApp is_user_in_project={is_user_in_project} project={this.props.project} user={this.props.user}
                      comments={this.props.comments}
                      commentable_type="issue"
                      commentable_record_id={this.props.issue.id}
                      commentable_resource_id={this.props.issue.sequential_id} />
        </div>
        <div className='attributes'>
          <IssueAttribute ref='attribute' {...this.props} issue={issue}/>
        </div>
    </div>`

@IssueHeader = React.createClass
  propTypes:
    issue: React.PropTypes.object.isRequired
  render: ->
    issue = @props.issue

    `<div className="issue-header">
        <h3>
            <IssueStatusMark issue={issue} />
            {"#"+issue.sequential_id} {issue.title}
        </h3>
    </div>`

@IssueStatusMark = React.createClass
  propTypes:
    issue: React.PropTypes.object.isRequired

  componentDidMount:  ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  handleOpen: ->
    Ajaxer.put
      path: "../issues/#{@props.issue.sequential_id}/reopen.json"

  handleClose: ->
    Ajaxer.put
      path: "../issues/#{@props.issue.sequential_id}/close.json"

  render: ->
    issue = @props.issue
    if issue.status == 'open'
      mark = `<div> <i className="icon green unlock"/> 開啟 </div>`
      items = `<div className="item" onClick={this.handleClose}>CLOSE</div>`
    else
      mark = `<div> <i className="icon red lock"/> 關閉 </div>`
      items = `<div className="item" onClick={this.handleOpen}>OPEN</div>`

    `<a className="ui label large issue-mark dropdown" ref="dropdown" >
        {mark}
        <div className="menu">
            {items}
        </div>
    </a>`

@IssueAttribute = React.createClass
  propTypes:
    project:            React.PropTypes.object.isRequired
    issue:              React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  render: ->

    `<div className="container">
      <IssueCreaterBlock     {...this.props} />
      <IssueScheduleBlock    {...this.props} />
      <IssueAssigneeBlock    {...this.props} />
      <IssueSprintBlock      {...this.props} />
      <IssueLabelBlock       {...this.props} />
      <IssueParticipantBlock {...this.props} />
    </div>`

@IssueCreaterBlock = React.createClass
  propTypes:
    issue: React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  render: ->
    content = `<LabelAvatar user={this.props.issue.user} />`

    `<IssueAttributeBlock title="創建者" content={content}/>`

@IssueScheduleBlock = React.createClass
  propTypes:
    issue:              React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {editMode: false}

  toggleEdit: (e) ->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  handleChangeBegin: (value) ->
    Ajaxer.patch
      path: "../issues/#{@props.issue.sequential_id}.json"
      data: {issue: {begin_at: value}}
      done: =>
        @setState({editMode: false})


  handleChangeDue: (value) ->
    Ajaxer.patch
      path: "../issues/#{@props.issue.sequential_id}.json"
      data: {issue: {due_at: value}}
      done: =>
        @setState({editMode: false})


  render: ->
    begin_at = @props.issue.begin_at
    due_at   = @props.issue.due_at

    if @state.editMode
      content =
        `<div>
            <DateTimeInput name="issue[begin_at]" time={begin_at} onChange={this.handleChangeBegin} />
            <DateTimeInput name="issue[due_at]"   time={due_at}   onChange={this.handleChangeDue} />
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

    `<IssueAttributeBlock title="時程" content={content} controlFunc={controlFunc}/>`

@IssueAssigneeBlock = React.createClass
  propTypes:
    project:            React.PropTypes.object.isRequired
    issue:              React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {editMode: false}

  toggleEdit: (e) ->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  handleChange: (value) ->
    Ajaxer.patch
      path: "../issues/#{@props.issue.sequential_id}.json"
      data: {issue: {assignee_id: value}}
      done: =>
        @setState({editMode: false})


  render: ->
    assignee = @props.issue.assignee

    if @state.editMode
      if @props.is_user_in_project
        content =
          `<AssociationInput name="issue[assignee_id]" collection={[assignee]} onChange={this.handleChange}
              data_set={
                {
                    'resource-path' : "/projects/"+ this.props.project.id + "/settings/members",
                    'search-field' : '[ "name", "email" ]',
                    'option-tpl' : 'option-user'
                }
              }
          />`
    else
      if assignee
        content = `<div><LabelAvatar user={assignee} /></div>`
      else
        content = `<div>NOT SPECIFIED</div>`

    if @props.is_user_in_project
      controlFunc = @toggleEdit

    `<IssueAttributeBlock title="負責人" content={content} controlFunc={controlFunc}/>`

@IssueSprintBlock = React.createClass
  propTypes:
    project:            React.PropTypes.object.isRequired
    issue:              React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {editMode: false}

  toggleEdit: (e) ->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  handleChange: (value) ->
    Ajaxer.patch
      path: "../issues/#{@props.issue.sequential_id}.json"
      data: {issue: {sprint_id: value}}
      done: =>
        @setState({editMode: false})


  render: ->
    sprint = @props.issue.sprint

    if @state.editMode
      if @props.is_user_in_project
        content =
          `<AssociationInput name="issue[spring_id]" collection={[sprint]} onChange={this.handleChange}
              data_set={
                {
                    'resource-path' : "/projects/"+ this.props.project.id + "/sprints",
                    'search-field' : '[ "title" ]',
                    'add-new' : 'true'
                }
              }
          />`
    else
      if sprint
        content = `<div><SprintSmallLabel sprint={sprint} project={this.props.project}/></div>`
      else
        content = `<div>NOT SPECIFIED</div>`

    if @props.is_user_in_project
      controlFunc = @toggleEdit

    `<IssueAttributeBlock title="戰役" content={content} controlFunc={controlFunc}/>`

@IssueLabelBlock = React.createClass
  propTypes:
    project:            React.PropTypes.object.isRequired
    issue:              React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {editMode: false}

  toggleEdit: (e) ->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  handleChange: (e) ->
    label_ids = @refs.input.refs.select.getDOMNode().selectize.getValue()
    Ajaxer.patch
      path: "../issues/#{@props.issue.sequential_id}.json"
      data: {issue: {label_ids: label_ids}}
      done: =>
        @setState({editMode: false})

  render: ->
    labels = @props.issue.labels

    if @state.editMode
      if @props.is_user_in_project
        content =
          `<AssociationInput ref="input" name="issue[label_ids][]" collection={labels} onChange={this.handleChange} multiple={true}
            data_set={
              {
                  'resource-path' : "/projects/"+ this.props.project.id + "/settings/labels",
                  'search-field' : '[ "title" ]',
                  'option-tpl' : 'option-label',
                  'item-tpl' : 'item-label',
                  'add-new' : 'true'
              }
            }
          />`
    else
      if labels
        labelsContent = labels.map (label) =>
          `<IssueLabel label={label} key={label.id}/>`
        content = `<div className="ui list">{labelsContent}</div>`
      else
        content = `<div>NOT SPECIFIED</div>`

    if @props.is_user_in_project
      controlFunc = @toggleEdit

    `<IssueAttributeBlock title="標籤" content={content} controlFunc={controlFunc}/>`

@IssueLabel = React.createClass
  propTypes:
    label: React.PropTypes.object
  render: ->
    label = @props.label
    `<div className="item">
        <div className="ui horizontal label" style={ { 'background' : label.color, 'color' : '#fff' } }>
            {label.title}
        </div>
    </div>`

@IssueParticipantBlock = React.createClass
  propTypes:
    issue: React.PropTypes.object.isRequired

  render: ->
    content = @props.issue.participations.map (participant) =>
      `<PopupLinkAvatar user={participant.user} key={participant.id} />`

    `<IssueAttributeBlock title="參與者" content={content}/>`


@IssueAttributeBlock = React.createClass
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


@IssueSmallLabel = React.createClass
  propTypes:
    issue :  React.PropTypes.object.isRequired
    project: React.PropTypes.object.isRequired

  render: ->
    issue = @props.issue
    if issue.status == 'open'
      color = 'green'
    else
      color = 'red'

    href = "/projects/#{this.props.project.id}/issues/#{this.props.issue.sequential_id}"
    `<a className={"ui label "+color} href={href}>
        <i className="icon tasks" />
        { issue.title }
    </a>`
