@IssueApp = React.createClass
  propTypes:
    issue: React.PropTypes.object.isRequired
    project: React.PropTypes.object.isRequired
    comments: React.PropTypes.array.isRequired
    user: React.PropTypes.object.isRequired
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
    issue = @props.issue
    comments = @state.comments
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
          <IssueAttribute ref='attribute' {...this.props} issue={this.state.issue}/>
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
  render: ->
    issue = @props.issue
    if issue.status == 'open'
      `<div className="ui label large issue-mark">
          <i className="icon green unlock"></i>
          開啟
      </div>`
    else
      `<div className="ui label large issue-mark">
          <i className="icon red lock"></i>
          關閉
      </div>`

@IssueAttribute = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue: React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  render: ->

    `<div className="container">
      <IssueCreaterBlock {...this.props} />
      <IssueScheduleBlock {...this.props} />
      <IssueAssigneeBlock {...this.props} />
      <IssueSprintBlock {...this.props} />
      <IssueLabelBlock {...this.props} />
      <IssueParticipantBlock {...this.props} />
    </div>`

@IssueCreaterBlock = React.createClass
  propTypes:
    issue: React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  render: ->
    content1 = `<UserSmallLabel user={this.props.issue.user} />`

    `<IssueAttributeBlock title="創建者" content1={content1}/>`

@IssueScheduleBlock = React.createClass
  propTypes:
    issue: React.PropTypes.object.isRequired
    is_user_in_project: React.PropTypes.bool.isRequired

  getInitialState: () ->
    return {editMode: false}

  toggleEdit: (e) ->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})

  handleChangeBegin: (value) ->
    putPath = "../issues/#{@props.issue.sequential_id}.json"
    $.ajax(putPath, {
      method: 'PATCH'
      data: {issue: {begin_at: value}}
    }).done () =>
      @setState({editMode: false})
    .fail () =>
      console.log("patch error")

  handleChangeDue: (value) ->
    putPath = "../issues/#{@props.issue.sequential_id}.json"
    $.ajax(putPath, {
      method: 'PATCH'
      data: {issue: {due_at: value}}
    }).done () =>
      @setState({editMode: false})
    .fail () =>
      console.log("patch error")

  render: ->
    begin_at = @props.issue.begin_at
    due_at   = @props.issue.due_at

    if begin_at
      begin_time = moment(new Date(begin_at)).format("YYYY-MM-DD")
      begin =
          `<div><div className="ui green circular empty label"/> {begin_time} </div>`
    if due_at
      due_time = moment(new Date(due_at)).format("YYYY-MM-DD")
      due =
          `<div><div className="ui red circular empty label"/> {due_time} </div>`

    if begin || due
      content1 = `<div>{begin} {due}</div>`
    else
      content1 = "NOT SPECIFIED"

    if @props.is_user_in_project
      content2 =
        `<div>
            <DateTimeInput name="issue[begin_at]" time={begin_at} onChange={this.handleChangeBegin} />
            <DateTimeInput name="issue[due_at]"   time={due_at}   onChange={this.handleChangeDue} />
        </div>`

    `<IssueAttributeBlock title="時程" content1={content1} content2={content2}
        editMode={this.state.editMode} toggleEdit={this.toggleEdit}/>`

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
    putPath = "../issues/#{@props.issue.sequential_id}.json"
    $.ajax(putPath, {
      method: 'PATCH'
      data: {issue: {assignee_id: value}}
    }).done () =>
      @setState({editMode: false})
    .fail () =>
      console.log("patch error")

  render: ->
    assignee = @props.issue.assignee
    if assignee
      content1 = `<div><UserSmallLabel user={assignee} /></div>`
    else
      content1 = `<div>NOT SPECIFIED</div>`


    if @props.is_user_in_project
      content2 =
        `<AssociationInput name="issue[assignee_id]" collection={[assignee]} onChange={this.handleChange}
            data_set={
              {
                  'resource-path' : "/projects/"+ this.props.project.id + "/settings/members",
                  'search-field' : '[ "name", "email" ]',
                  'option-tpl' : 'option-user'
              }
            }
        />`

    `<IssueAttributeBlock title="負責人" content1={content1} content2={content2} editMode={this.state.editMode} toggleEdit={this.toggleEdit}/>`

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
    putPath = "../issues/#{@props.issue.sequential_id}.json"
    $.ajax(putPath, {
      method: 'PATCH'
      data: {issue: {sprint_id: value}}
    }).done () =>
      @setState({editMode: false})
    .fail () =>
      console.log("patch error")

  render: ->
    sprint = @props.issue.sprint
    if sprint
      content1 = `<div><SprintSmallLabel sprint={sprint}/></div>`
    else
      content1 = `<div>NOT SPECIFIED</div>`

    if @props.is_user_in_project
      content2 =
        `<AssociationInput name="issue[spring_id]" collection={[sprint]} onChange={this.handleChange}
            data_set={
                {
                    'resource-path' : "/projects/"+ this.props.project.id + "/sprints",
                    'search-field' : '[ "title" ]',
                    'add-new' : 'true'
                }
            }
        />`

    `<IssueAttributeBlock title="戰役" content1={content1} content2={content2}
        editMode={this.state.editMode}
        toggleEdit={this.toggleEdit}/>`

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
    putPath = "../issues/#{@props.issue.sequential_id}.json"
    label_ids = @refs.input.refs.select.getDOMNode().selectize.getValue()
    $.ajax(putPath, {
      method: 'PATCH'
      data: {issue: {label_ids: label_ids}}
    }).done () =>
      @setState({editMode: false})
    .fail () =>
      console.log("patch error")

  render: ->
    labels = @props.issue.labels
    if labels
      labelsContent = labels.map (label) =>
        `<IssueLabel label={label} key={label.id}/>`
      content1 = `<div className="ui list">{labelsContent}</div>`
    else
      content1 = `<div>NOT SPECIFIED</div>`

    if @props.is_user_in_project
      content2 =
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

    `<IssueAttributeBlock title="標籤" content1={content1} content2={content2}
        editMode={this.state.editMode}
        toggleEdit={this.toggleEdit}/>`

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
    content1 = @props.issue.participations.map (participant) =>
      `<UserImageSmallLabel user={participant.user} key={participant.id} />`

    `<IssueAttributeBlock title="參與者" content1={content1}/>`


@IssueAttributeBlock = React.createClass
  propTypes:
    editMode:   React.PropTypes.bool
    title:      React.PropTypes.node.isRequired
    content1:   React.PropTypes.node.isRequired
    content2:   React.PropTypes.node
    toggleEdit: React.PropTypes.func

  render: ->

    if @props.content2
      controlBlock =
        `<div className="ui right floated buttons">
          <a className="gray simple link" href="" onClick={this.props.toggleEdit}>
              <i className="icon setting"/>
          </a>
        </div>`

    if @props.editMode
      content = @props.content2
    else
      content = @props.content1

    `<div className="block">
        <div className="ui top attached tertiary segment">
            {controlBlock}
            {this.props.title}
        </div>
        <div className="ui bottom attached segment" >
            {content}
        </div>
    </div>`