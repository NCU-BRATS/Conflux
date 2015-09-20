DragDropContext = ReactDnD.DragDropContext
HTML5Backend = ReactDnD.HTML5
DragSource = ReactDnD.DragSource
DropTarget = ReactDnD.DropTarget

ItemTypes = {
  ISSUE: 'issue'
}

issueSource = {
  beginDrag: (props, monitor, component) ->
    { issue: props.issue, height: component.getDOMNode().offsetHeight }
}

issueGapTarget = {
  drop: (props, monitor) ->
    data = monitor.getItem()
    issue = data.issue
    prevOrder = props.prevOrder || 999
    nextOrder = props.nextOrder || -2999
    order = (prevOrder + nextOrder) / 2
    Ajaxer.patch
      path: "issues/#{issue.sequential_id}.json"
      data: { issue: { status: props.status.id, order: order } }
    {}
  canDrop: (props, monitor) ->
    issue = monitor.getItem().issue
    id = issue.id.toString()
    id != props.nextId && id != props.prevId
};

dragCollect = (connect, monitor) ->
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  }

dropCollect = (connect, monitor) ->
  return {
    connectDropTarget: connect.dropTarget(),
    isOver: monitor.isOver(),
    canDrop: monitor.canDrop(),
    draggingIssue: monitor.getItem()
  }

IssueGapPrototype = React.createClass
  propTypes:
    status: React.PropTypes.object.isRequired
    # prevOrder: React.PropTypes.number.isRequired
    # nextOrder: React.PropTypes.number.isRequired
    isOver: React.PropTypes.bool.isRequired
    connectDropTarget: React.PropTypes.func.isRequired

  render: ->
    connectDropTarget = @props.connectDropTarget
    isOver = @props.isOver
    isLast = @props.nextOrder == undefined
    canDrop = @props.canDrop
    draggingIssue = @props.draggingIssue

    connectDropTarget(
      `<div className='issue-gap' style={{
        height: isOver && canDrop ? draggingIssue.height + 20 : 10,
        zIndex: draggingIssue && canDrop ? 3 : 1
      }}>
        {this.props.children}
        { draggingIssue &&
          <div style={{
            height: '100%',
            width: '100%',
            zIndex: 1,
            opacity: 0.5,
            backgroundColor: '#C1DBB5'
          }}>
          </div>
        }
      </div>`
    )
@IssueGap = DropTarget(ItemTypes.ISSUE, issueGapTarget, dropCollect)(IssueGapPrototype)

KanbanApp = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    current_user: React.PropTypes.object.isRequired

  getInitialState: () ->
    { sprints: [], sprint: null, issues: [], issue: null, mode: 'issue', loading: false }

  componentDidMount: () ->
    PrivatePub.subscribe("/projects/#{@props.project.id}/sprints", @sprintRecieve)
    PrivatePub.subscribe("/projects/#{@props.project.id}/issues", @issueRecieve)
    Ajaxer.get
      path: "/projects/#{@props.project.slug}/sprints.json?q[s]=id asc&q[archived_eq]=false"
      done: (data) =>
        @setState {sprints: data}, () ->
          params = @getURLParams()
          if params['sprint_sequential_id']
            @chooseSprintAndIssue( params['sprint_sequential_id'], params['issue_sequential_id'] )

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/sprints")
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/issues")

  sprintRecieve: (res, channel) ->
    @appendSprint(res.data)  if res.target == 'sprint' && res.action == 'create'
    @replaceSprint(res.data) if res.target == 'sprint' && res.action == 'update'

  appendSprint: (sprint) ->
    sprints = @state.sprints.concat(sprint)
    @setState({sprints: sprints})

  replaceSprint: (sprint) ->
    sprints = @state.sprints.slice()
    i = _.findIndex(sprints, (c)-> c.id == sprint.id)
    if sprint.archived
      sprints.splice(i,1)
    else if i >= 0
      sprints[i] = sprint
    else
      sprints = sprints.concat(sprint)
    if @state.sprint and sprint.id == @state.sprint.id
      if sprint.archived
        @setState({sprints: sprints, sprint: null})
      else
        @setState({sprints: sprints, sprint: sprint})
    else
      @setState({sprints: sprints})

  issueRecieve: (res, channel) ->
    if @state.sprint
      @appendIssue(res.data)  if res.target == 'issue' && res.action == 'create'
      @replaceIssue(res.data) if res.target == 'issue' && res.action == 'update'

  appendIssue: (issue) ->
    if issue.sprint.id == @state.sprint.id
      issues = @state.issues.concat(issue)
      @setState({issues: issues})

  replaceIssue: (issue) ->
    issues = @state.issues.slice()
    i = _.findIndex(issues, (c)-> c.id == issue.id)
    return if i < 0
    if issue.sprint.id == @state.sprint.id
      issues[i] = issue
    else
      issues.splice(i,1)
    if @state.issue and issue.id == @state.issue.id
      @setState( { issues: issues, issue: issue } )
    else
      @setState( { issues: issues } )

  chooseSprintAndIssue: (sprint_sequential_id, issue_sequential_id) ->
    @setState({loading: true})
    sprint_index = _.findIndex(@state.sprints, (c)-> "#{c.sequential_id}" == sprint_sequential_id)
    if sprint_index >= 0
      @chooseSprintAndIssues @state.sprints[ sprint_index ], () =>
        if issue_sequential_id
          issue_index = _.findIndex(@state.issues, (c)-> "#{c.sequential_id}" == issue_sequential_id)
          if issue_index >= 0
            @openIssuePanel( @state.issues[ issue_index ] )
          else
            alert( '不存在的任務' )
    else
      alert( '不存在的戰役' )

  chooseSprintAndIssues: (sprint,callback) ->
    @setState({loading: true})
    if sprint
      Ajaxer.get
        path: "/projects/#{@props.project.slug}/issues.json?q[sprint_id_eq]=#{sprint.id}&per=200"
        done: (data) =>
          window.history.pushState('kanban', 'Title', "kanban?sprint_sequential_id=#{sprint.sequential_id}")
          @setState {sprint: sprint, issues: data, loading: false}, ()->
            $('#kanban-panel').sidebar('hide')
            callback() if callback
    else
      @setState({sprint: sprint, loading: false})

  openIssuePanel: (issue) ->
    @setState { issue: issue, mode: 'issue' }, () ->
      window.history.pushState('kanban', 'Title', "kanban?sprint_sequential_id=#{@state.sprint.sequential_id}&issue_sequential_id=#{issue.sequential_id}")
      $('#kanban-panel').sidebar('show')

  openSprintPanel: () ->
    @setState { mode: 'sprint' }, () ->
      window.history.pushState('kanban', 'Title', "kanban?sprint_sequential_id=#{@state.sprint.sequential_id}")
      $('#kanban-panel').sidebar('show')

  getURLParams: () ->
    query = window.location.search.substring(1)
    raw_vars = query.split("&")
    params = {}
    for v in raw_vars
      [key, val] = v.split("=")
      params[key] = decodeURIComponent(val)
    params

  render: ->
      `<div className="kanban-app">
          <div className="">
              <KanbanMenu {...this.props}
                  sprint={this.state.sprint}
                  sprints={this.state.sprints}
                  openIssuePanel={this.openIssuePanel}
                  openSprintPanel={this.openSprintPanel}
                  chooseSprintAndIssues={this.chooseSprintAndIssues}/>
          </div>
          <div className="">
              <Kanban {...this.props}
                  sprint={this.state.sprint}
                  sprints={this.state.sprints}
                  issues={this.state.issues}
                  issue={this.state.issue}
                  mode={this.state.mode}
                  loading={this.state.loading}
                  openIssuePanel={this.openIssuePanel}/>
          </div>
      </div>`

@KanbanMenu = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object
    sprints: React.PropTypes.array.isRequired
    openIssuePanel:  React.PropTypes.func.isRequired
    openSprintPanel: React.PropTypes.func.isRequired
    chooseSprintAndIssues: React.PropTypes.func.isRequired

  chooseSprint: (sprint) ->
    (e) =>
      $('.kanban-sprint-item').removeClass('active')
      $(e.currentTarget).addClass('active')
      @props.chooseSprintAndIssues( sprint )

  chooseDefault: () ->
    @chooseSprint(null)

  render: ->
    sprintItems = @props.sprints.map (sprint,i) =>
      sprintActiveClass = if @props.sprint && @props.sprint.id == sprint.id then "active" else ""
      sprintDateClass = if sprint.due_at && moment(new Date(sprint.due_at)) < moment() then "out-of-date" else ""
      handleClick = @chooseSprint(sprint)
      `<a className={ sprintActiveClass + " item inverted kanban-sprint-item " + sprintDateClass } onClick={handleClick} key={sprint.id} >
          {sprint.title}
          <div className="ui label">
              { sprint.issues_count - sprint.issues_done_count }
          </div>
      </a>`

    if @props.sprint
      sprintInfo = `<KanbanShowSprintInfoButton openSprintPanel={this.props.openSprintPanel}/>`

    homeActiveClass = if @props.sprint then "" else "active"

    `<div className="ui green labeled menu sprint">
        <a className={ homeActiveClass + " item kanban-sprint-item" } onClick={this.chooseDefault()}><i className="icon home"/></a>
        { sprintItems }
        <KanbanAddSprintButton project={this.props.project} />
        { sprintInfo }
    </div>`

@KanbanShowSprintInfoButton = React.createClass
  propTypes:
    openSprintPanel: React.PropTypes.func.isRequired

  render: ->
    `<a className="right item" onClick={this.props.openSprintPanel}>
        <i className="icon info circle" />
        屬性
    </a>`


@KanbanAddSprintButton = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired

  handleCreateSprint: () ->
    sprintName = prompt( '請輸入新戰役名稱 留空則使用預設值' )
    if sprintName isnt null
      Ajaxer.post
        path: "/projects/#{this.props.project.slug}/sprints.json"
        data: {
          sprint: {
            title: if sprintName is '' then '新增戰役' else sprintName
          }
        }

  render: ->
    `<a className="right item" onClick={this.handleCreateSprint}>
        <i className="icon add circle"/>
        新增
    </a>`

@Kanban = React.createClass
  propTypes:
    mode:    React.PropTypes.string
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object
    sprints: React.PropTypes.array.isRequired
    issues:  React.PropTypes.array
    issue:   React.PropTypes.object
    loading: React.PropTypes.bool.isRequired
    current_user: React.PropTypes.object.isRequired
    openIssuePanel:  React.PropTypes.func.isRequired

  getInitialState: () ->
    { isEnable: false }

  componentDidMount: () ->
    $(@refs.kanbanPanel.getDOMNode()).sidebar
      context: $(@refs.kanban.getDOMNode())
      dimPage: false
      transition: 'overlay'
      onVisible: () =>
        @setState({ isEnable: true })
      onHidden: () =>
        @setState({ isEnable: false })

  closePanel: () ->
    $(@refs.kanbanPanel.getDOMNode()).sidebar('hide')

  render: ->

    panelContent =  if @props.mode == 'issue'
      `<KanbanIssuePanel closePanel={this.closePanel} {...this.props} />`
    else
      `<KanbanSprintPanel closePanel={this.closePanel} {...this.props} />`

    `<div className="ui pushable kanban" ref="kanban">
        <KanbanColumns {...this.props} />
        <KanbanPanel isEnable={this.state.isEnable} ref="kanbanPanel">
            { panelContent }
        </KanbanPanel>
    </div>`

@KanbanColumns = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object
    issues:  React.PropTypes.array
    loading: React.PropTypes.bool.isRequired
    openIssuePanel: React.PropTypes.func.isRequired

#  mixins: [ SortableMixin ]

  sortableOptions:
    group: "column-container"
    handle: ".kanban-column-title"

  getInitialState: () ->
    { items: @props.issues }

  componentWillReceiveProps: (props) ->
    @setState( { items: props.issues } )

  render: ->

    if @props.sprint
      props = @props
      issuesMap = _.groupBy @state.items, (issue) ->
        issue.status
      columns = _.map @props.sprint.statuses, (status,i) =>
        `<KanbanColumn status={status} issues={issuesMap[status.id] || []} key={status.id} sprint={props.sprint} project={props.project}
                       openIssuePanel={props.openIssuePanel}/>`

      loadingClass = if @props.loading then "loading" else ""

      `<div className={ "kanban-columns pusher " + loadingClass }>{columns}</div>`
    else
      `<div className="kanban-columns pusher">
          <KanbanDefaultPage />
      </div>`

@KanbanDefaultPage = React.createClass
  render: ->
    `<div>
        <p>
            <ul>
                <li>點擊左上方各戰役項目以開啟看板</li>
                <li>點擊右上方按鈕新增戰役</li>
            </ul>
        </p>
        <p>
            <ul>
                <li>各戰役名稱旁顯示之數字代表未完成任務數量</li>
                <li>各戰役名稱旁顯示之日曆圖案代表該戰役已過期</li>
            </ul>
        </p>
        <p>
            <ul>
                <li>此看板功能尚處於實驗階段</li>
            </ul>
        </p>
    </div>`

@KanbanColumn = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object
    status:  React.PropTypes.node.isRequired
    issues:  React.PropTypes.array.isRequired
    openIssuePanel: React.PropTypes.func.isRequired

  render: ->
    isDone = @props.status.id == 2

    if @props.sprint
      controlPanel =
        `<div className="ui right floated buttons ">
            <KanbanColumnControl {...this.props} isDone={isDone}/>
        </div>`
      unless isDone
        addIssueButton = `<KanbanColumnAddIssueButton {...this.props} />`

    `<div className="kanban-column">
        <div className="ui top attached segment tertiary kanban-column-title">
            { controlPanel }
            { this.props.status.name }
            <span>
              -( {this.props.issues.length} )
            </span>
        </div>
        <KanbanColumnContainer {...this.props} isDone={isDone}/>
        { addIssueButton }
    </div>`

@KanbanColumnAddIssueButton = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object
    status:  React.PropTypes.node.isRequired

  handleCreateIssue: () ->
    issueName = prompt( '請輸入新任務名稱 留空則使用預設值' )
    if issueName isnt null
      Ajaxer.post
        path: "/projects/#{this.props.project.slug}/issues.json"
        data: {
          issue: {
            title: if issueName is '' then '新增任務' else issueName,
            sprint_id: @props.sprint.id,
            status: @props.status.id
          }
        }

  render: ->
    `<div className="ui bottom attached segment tertiary kanban-column-bottom" onClick={this.handleCreateIssue}>
        <i className="icon add square"/>
        快速新增任務
    </div>`

@KanbanColumnControl = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object
    status:  React.PropTypes.node.isRequired
    issues:  React.PropTypes.array.isRequired
    isDone:  React.PropTypes.bool.isRequired

  componentDidMount: () ->
    $(@refs.link.getDOMNode()).popup
      popup : $(@refs.panel.getDOMNode())
      on    : 'click'
      position: 'bottom center'
      exclusive: true

  render: () ->
    `<div className="kanban-column-control">
        <a className="gray simple link" ref="link">
            <i className="icon chevron down"/>
        </a>
        <KanbanColumnControlPanel ref="panel" {...this.props} />
    </div>`

@KanbanColumnControlPanel = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object
    status:  React.PropTypes.node.isRequired
    issues:  React.PropTypes.array.isRequired
    isDone:  React.PropTypes.bool.isRequired

  handleAddStatus: (e) ->
    newStatusName = prompt( '新增狀態名稱' )
    if newStatusName isnt null
      if newStatusName is ''
        alert( '請輸入非空字串' )
      else
        statuses =  @props.sprint.statuses
        currentIndex = _.findIndex statuses, { id: @props.status.id }
        maxIdStatus = _.max statuses, (status) ->
          status.id
        statuses.splice(currentIndex+1,0,{ id: maxIdStatus.id + 1, name: newStatusName })
        Ajaxer.patch
          path: "/projects/#{@props.project.slug}/sprints/#{@props.sprint.sequential_id}.json"
          data: JSON.stringify( {sprint: {statuses: @props.sprint.statuses}} )
          contentType: 'application/json'

  handleDeleteStatus: (e) ->
    if confirm( '確定要刪除此狀態？' )
      if @props.issues.length != 0
        alert( '請先清空屬於此狀態的任務' )
      else if @props.sprint.statuses.length <= 2
        alert( '已達戰役最少狀態數量' )
      else
        newStatuses = _.difference( @props.sprint.statuses, [ @props.status ] )
        Ajaxer.patch
          path: "/projects/#{@props.project.slug}/sprints/#{@props.sprint.sequential_id}.json"
          data: JSON.stringify( {sprint: {statuses: newStatuses}} )
          contentType: 'application/json'

  handleUpdateStatus: (e) ->
    newStatusName = prompt( '修改狀態名稱' )
    if newStatusName isnt null
      if newStatusName is ''
        alert( '請輸入非空字串' )
      else
        statuses = @props.sprint.statuses
        index = _.findIndex statuses, { id: @props.status.id }
        statuses.splice(index,1,{ id: @props.status.id, name: newStatusName })
        Ajaxer.patch
          path: "/projects/#{@props.project.slug}/sprints/#{@props.sprint.sequential_id}.json"
          data: JSON.stringify( {sprint: {statuses: statuses}} )
          contentType: 'application/json'

  render: ->
    unless @props.isDone
      addButton =
        `<a className="item" onClick={this.handleAddStatus}>
            <i className="icon plus" />
            <div className="content">新增階段</div>
        </a>`
      divider = `<div className="ui divider"/>`
      deleteButton =
        `<a className="item" onClick={this.handleDeleteStatus}>
            <i className="icon trash red" />
            <div className="content"> 刪除階段</div>
        </a>`

    `<div className="kanban-column-control-panel ui hidden transition inline popup">
        <div className="ui huge relaxed list">
            <a className="item" onClick={this.handleUpdateStatus}>
                <i className="icon write" />
                <div className="content">編輯階段</div>
            </a>
            { addButton }
            { divider }
            { deleteButton }
        </div>
    </div>`


@KanbanColumnContainer = React.createClass
  propTypes:
    status: React.PropTypes.node.isRequired
    issues: React.PropTypes.array.isRequired
    isDone: React.PropTypes.bool.isRequired
    openIssuePanel: React.PropTypes.func.isRequired

#  mixins: [ SortableMixin ]

  sortableOptions:
    group: "issue-container"

  getInitialState: () ->
    { items: @sortIssues( @props.issues ) }

  componentWillReceiveProps: (prop) ->
    @setState( { items: @sortIssues( prop.issues ) } )

  sortIssues: (issues) ->
    issues.sort (a,b) ->
      b.order - a.order

  render: ->
    isDone = @props.isDone
    openIssuePanel = @props.openIssuePanel
    issues = []
    for issue, i in @state.items
      pre = @state.items[i-1]
      prevId = if pre then pre.id.toString() else ''
      next = @state.items[i]
      nextId = next.id.toString()
      prevOrder = if pre then pre.order else undefined
      issues.push(`<IssueGap key={prevId + '-' + nextId} status={this.props.status} nextOrder={next.order} nextId={nextId} prevOrder={prevOrder} prevId={prevId} />`)
      issues.push(`<KanbanIssue issue={issue} key={issue.id} openIssuePanel={openIssuePanel} isDone={isDone} />`)
    prevOrder = if i then @state.items[i - 1].order else undefined
    issues.push(`<IssueGap key={(nextId || '') + '-'} status={this.props.status} nextOrder={undefined} nextId={''} prevOrder={prevOrder} prevId={nextId}/>`)
    `<div className={ "ui attached segment secondary kanban-column-container " + ( isDone ? "done" : "" ) }>
        {issues}
    </div>`

KanbanIssuePrototype = React.createClass
  propTypes:
    issue:  React.PropTypes.object.isRequired
    isDone: React.PropTypes.bool.isRequired
    openIssuePanel: React.PropTypes.func.isRequired
    connectDragSource: React.PropTypes.func.isRequired
    isDragging: React.PropTypes.bool.isRequired

  handleOnClick: () ->
    setTimeout( ()=>
      @props.openIssuePanel( @props.issue )
    , 510)

  render: ->
    connectDragSource = @props.connectDragSource
    isDragging = @props.isDragging

    issue = @props.issue

    if issue.labels
      labelsContent = issue.labels.map (label) =>
        `<KanbanIssueLabel label={label} key={label.id}/>`

    connectDragSource(
      `<div style={{
        opacity: this.props.isDone ? 0.5 : 1,
        display: isDragging ? 'none' : 'block',
        cursor: 'move'
      }} className={ "ui items segment kanban-issue " } onClick={this.handleOnClick}>
          <div className="ui corner teal label" >
              <span className="kanban-issue-point">
                  { issue.point }
              </span>
          </div>
          <div className="ui large list kanban-issue-content">
              <div className="item">
                  <div className="ui image kanban-issue-avatar">
                      <AvatarImage user={issue.assignee} />
                  </div>
                  <div className="middle aligned content">
                      <div className="header">
                          #{issue.sequential_id} {issue.title}
                      </div>
                  </div>
              </div>
              <div className="item">
                  <div className="content">
                      <div className="description">
                          {labelsContent}
                      </div>
                  </div>
              </div>
          </div>
      </div>`
     )

@KanbanIssue = DragSource(ItemTypes.ISSUE, issueSource, dragCollect)(KanbanIssuePrototype)

@KanbanIssueLabel = React.createClass
  propTypes:
    label: React.PropTypes.object
  render: ->
    label = @props.label
    `<div className="ui label kanban-issue-label">
        <i className="certificate icon"  style={ { 'color' : label.color } } />
        {label.title}
    </div>`

@KanbanDueAtLabel = React.createClass
  propTypes:
    issue:  React.PropTypes.object
    isDone: React.PropTypes.bool.isRequired

  render: ->

    color = if @props.isDone
      'grey'
    else
      if moment(new Date(this.props.issue.due_at)) < moment()
        '#db2828'
      else
        '#16ab39'

    `<div className="ui basic label kanban-issue-label" style={ { 'color' : color } }>
        <i className="calendar icon" />
        { moment( new Date( this.props.issue.due_at ) ).format("MM-DD") }
    </div>`

@KanbanPanel = React.createClass
  propTypes:
    isEnable: React.PropTypes.bool.isRequired

  render: ->
    if @props.isEnable
      content =
        `<div>
            { this.props.children }
        </div>`
    `<div className="ui right sidebar" id="kanban-panel">
        { content }
    </div>`

@KanbanSprintPanel = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object
    issues:  React.PropTypes.array
    closePanel: React.PropTypes.func.isRequired

  componentWillReceiveProps: (props) ->
    unless props.sprint
      props.closePanel()

  render: ->
    if @props.sprint
      content =
        `<div>
            <div>
                <KanbanSprintPanelCreatedAt {...this.props} />
                <KanbanSprintPanelSetting {...this.props} />
            </div>
            <KanbanSprintPanelTitle   {...this.props} />
            <KanbanSprintPanelMessage {...this.props} />
            <KanbanSprintPanelStatistics  {...this.props} />
            <KanbanSprintPanelBeginAt {...this.props} />
            <KanbanSprintPanelDueAt   {...this.props} />
        </div>`

    `<div id="kanban-sprint-panel">
        { content }
    </div>`

@KanbanSprintPanelCreatedAt = React.createClass
  propTypes:
    sprint:   React.PropTypes.object.isRequired

  render: ->
    `<span className="kanban-sprint-panel-meta">
        <span className="kanban-sprint-panel-meta">創建時間:</span>
        <span className="text simple gray bold link"> { moment(new Date(this.props.sprint.created_at)).format('YYYY-MM-DD') }</span>
    </span>`

@KanbanSprintPanelSetting = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object.isRequired
    issues:  React.PropTypes.array

  componentDidMount: () ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  componentDidUpdate: () ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  render: ->
    `<div className="ui right floated buttons">
        <div className="ui dropdown" ref="dropdown">
            <div className="text simple gray bold link">其他操作</div>
            <i className="icon dropdown" />
            <div className="menu">
                <KanbanSprintPanelSettingArchive {...this.props} />
            </div>
        </div>
    </div>`

@KanbanSprintPanelSettingArchive = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:  React.PropTypes.object.isRequired
    issues:  React.PropTypes.array

  handleArchive: () ->
    if confirm( '確定要封存?' )
      Ajaxer.patch
        path: "/projects/#{this.props.project.slug}/sprints/#{@props.sprint.sequential_id}.json"
        data: { sprint: {archived: true } }

  render: ->
    `<a className="item" onClick={this.handleArchive}><i className="icon archive"/>封存</a>`

@KanbanSprintPanelTitle = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:   React.PropTypes.object.isRequired

  handleSave: (value) ->
    Ajaxer.patch
      path: "/projects/#{this.props.project.slug}/sprints/#{this.props.sprint.sequential_id}.json"
      data: { sprint: { title: value } }

  render: ->
    content1 = ` <h1>{ this.props.sprint.title } </h1>`

    `<div className="ui raised segment kanban-issue-panel-container">
        <div className="kanban-issue-panel-container-tag">
            <h1>#{ this.props.sprint.sequential_id }</h1>
        </div>
        <div className="kanban-issue-panel-container-content">
            <ContentClickEditableInput type="text" content1={content1} content2={this.props.sprint.title} onSave={this.handleSave} />
        </div>
    </div>`

@KanbanSprintPanelMessage = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:   React.PropTypes.object.isRequired

  render: ->
    dueTime = moment(new Date(@props.sprint.due_at))

    if @props.sprint.due_at and dueTime < moment()
      `<div className="ui huge icon negative message">
          <i className="calendar icon" />
          <div className="content">
              <div className="header">
                  嚴重！ 此戰役已截止於{ dueTime.fromNow() }！
              </div>
          </div>
      </div>`
    else
      `<div></div>`

@KanbanSprintPanelStatistics = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:   React.PropTypes.object.isRequired
    issues:  React.PropTypes.array

  render: ->
    counts = _.countBy @props.issues, (issue) ->
      if issue.status == 2
        'done'
      else
        'undone'
    counts.done = 0   if counts.done is undefined
    counts.undone = 0 if counts.undone is undefined

    `<div className="ui four item menu">
        <div className="item">
            <div className="ui teal statistic">
                <div className="value">{ this.props.sprint.issues_count }</div>
                <div className="label">任務總數</div>
            </div>
        </div>
        <div className="item">
            <div className="ui green statistic">
                <div className="value">{ counts.done }</div>
                <div className="label">完成任務</div>
            </div>
        </div>
        <div className="item">
            <div className="ui red statistic">
                <div className="value">{ counts.undone }</div>
                <div className="label">未完成任務</div>
            </div>
        </div>
        <div className="item">
            <div className="ui orange statistic">
                <div className="value">{ Math.floor( counts.done / ( counts.done + counts.undone ) * 100 ) }</div>
                <div className="label">達成率</div>
            </div>
        </div>
    </div>`

@KanbanSprintPanelBeginAt = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:   React.PropTypes.object.isRequired

  handleChange: (value) ->
    Ajaxer.patch
      path: "/projects/#{this.props.project.slug}/sprints/#{@props.sprint.sequential_id}.json"
      data: { sprint: {begin_at: value } }

  render: ->
    beginTime = moment( new Date( this.props.sprint.begin_at ) )

    content1 = if @props.sprint.begin_at
      `<div>
          <div className="header">
              開始時間
          </div>
          <p>{ beginTime.format("YYYY-MM-DD") }</p>
      </div>`
    else
      `<div className="header">
          請選擇
      </div>`

    content2 =
      `<div>
          <DateTimeInput name="sprint[begin_at]" time={this.props.sprint.begin_at} onChange={this.handleChange} />
      </div>`

    `<div className="ui huge icon message">
        <i className="flag outline icon" />
        <div className="content">
            <ContentClickEditablePopup content1={content1} content2={content2} />
        </div>
    </div>`

@KanbanSprintPanelDueAt = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    sprint:   React.PropTypes.object.isRequired

  handleChange: (value) ->
    Ajaxer.patch
      path: "/projects/#{this.props.project.slug}/sprints/#{@props.sprint.sequential_id}.json"
      data: { sprint: {due_at: value } }

  render: ->
    dueTime = moment( new Date( this.props.sprint.due_at ) )

    content1 = if @props.sprint.due_at
      `<div>
          <div className="header">
              截止時間
          </div>
          <p>{ dueTime.format("YYYY-MM-DD") }</p>
      </div>`
    else
      `<div className="header">
          請選擇
      </div>`

    content2 =
      `<div>
          <DateTimeInput name="sprint[due_at]" time={this.props.sprint.due_at} onChange={this.handleChange} />
      </div>`

    `<div className="ui huge icon message">
        <i className="checkered flag icon" />
        <div className="content">
            <ContentClickEditablePopup content1={content1} content2={content2} />
        </div>
    </div>`

@KanbanIssuePanel = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object
    sprint:  React.PropTypes.object
    sprints: React.PropTypes.array.isRequired
    closePanel:   React.PropTypes.func.isRequired
    current_user: React.PropTypes.object.isRequired

  componentWillReceiveProps: (props) ->
    unless props.issue
      props.closePanel()

  render: ->
    if @props.issue
      content =
        `<div>
            <div className="">
                <KanbanIssuePanelSprint {...this.props} />
                <KanbanIssuePanelStatus {...this.props} />
                <KanbanIssuePanelSetting {...this.props} />
            </div>
            <KanbanIssuePanelTitle {...this.props} />
            <div className="ui three item menu">
                <KanbanIssuePanelAssignee {...this.props} />
                <KanbanIssuePanelPriority {...this.props} />
                <KanbanIssuePanelPoint {...this.props} />
            </div>
            <KanbanIssuePanelLabels {...this.props} />
            <KanbanIssuePanelmMemo {...this.props} />
            <KanbanIssuePanelParticipations {...this.props} />
            <KanbanIssuePanelComments {...this.props} />
        </div>`
    `<div id="kanban-issue-panel">
        { content }
    </div>`

@KanbanIssuePanelSprint = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired
    sprints: React.PropTypes.array.isRequired

  componentDidMount: () ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  componentDidUpdate: () ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  handleChooseSprint: (sprint) ->
    Ajaxer.patch
      path: "/projects/#{this.props.project.slug}/issues/#{@props.issue.sequential_id}.json"
      data: { issue: { sprint_id: sprint.id, status: sprint.statuses[0].id } }

  render: ->
    issue = @props.issue
    sprintItems = @props.sprints.map (sprint) =>
      if sprint.title == issue.sprint.title
        activeable = 'active'
      handleClick = () =>
        @handleChooseSprint(sprint)
      `<a className={ "item " + activeable } key={sprint.id} onClick={handleClick}>{ sprint.title }</a>`

    `<span className="kanban-issue-panel-meta">
        <span className="kanban-issue-panel-meta"> 戰役:</span>
        <div className="ui dropdown" ref="dropdown">
            <div className="text simple gray bold link"> { this.props.issue.sprint.title } </div>
            <div className="menu">
                { sprintItems }
            </div>
        </div>
    </span>`

@KanbanIssuePanelStatus = React.createClass
  propTypes:
    sprint:  React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired

  componentDidMount: () ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  componentDidUpdate: () ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  handleChooseStatus: (status) ->
    Ajaxer.patch
      path: "/projects/#{this.props.project.slug}/issues/#{@props.issue.sequential_id}.json"
      data: { issue: { status: status.id } }

  render: ->
    currentStatus = _.find @props.sprint.statuses, (status) =>
      status.id.toString() == @props.issue.status.toString()
    statusItems = @props.sprint.statuses.map (status) =>
      if status.name == currentStatus.name
        activeable = 'active'
      handleClick = () =>
        @handleChooseStatus(status)
      `<a className={ "item " + activeable } key={status.id} onClick={handleClick}>{ status.name }</a>`

    `<span className="kanban-issue-panel-meta">
        <span className="kanban-issue-panel-meta">狀態:</span>
        <div className="ui dropdown" ref="dropdown">
            <div className="text simple gray bold link">
                { currentStatus.name }
            </div>
            <div className="menu">
                { statusItems }
            </div>
        </div>
    </span>`

@KanbanIssuePanelSetting = React.createClass
  propTypes:
    issue:   React.PropTypes.object.isRequired

  componentDidMount: () ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  componentDidUpdate: () ->
    $(@refs.dropdown.getDOMNode()).dropdown()

  render: ->
    `<div className="ui right floated buttons">
        <div className="ui dropdown" ref="dropdown">
            <div className="text simple gray bold link">其他操作</div>
            <i className="icon dropdown" />
            <div className="menu">
                <a className="item">NOTHING</a>
            </div>
        </div>
    </div>`

@KanbanIssuePanelTitle = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired

  handleSave: (value) ->
    Ajaxer.patch
      path: "/projects/#{this.props.project.slug}/issues/#{this.props.issue.sequential_id}.json"
      data: { issue: { title: value } }

  render: ->
    content1 = ` <h1>{ this.props.issue.title } </h1>`

    `<div className="ui segment kanban-issue-panel-container">
        <div className="kanban-issue-panel-container-tag">
            <h1>#{ this.props.issue.sequential_id }</h1>
        </div>
        <div className="kanban-issue-panel-container-content">
            <ContentClickEditableInput type="text" content1={content1} content2={this.props.issue.title} onSave={this.handleSave} />
        </div>
    </div>`

@KanbanIssuePanelAssignee = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired

  render: ->

    content1 = if @props.issue.assignee
      `<KanbanIssuePanelLabelAvatar user={this.props.issue.assignee} />`
    else
      `<a className="ui label">請選擇</a>`

    content2 = `<IssueAssigneeInput {...this.props}/>`

    `<div className="item">
        <h6 className="ui header">
            執行者
        </h6>
        <div className="">
            <ContentClickEditablePopup content1={content1} content2={content2} popupWidth="300px"/>
        </div>
    </div>`

@KanbanIssuePanelLabelAvatar = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  render: ->
    user = @props.user
    `<a className="ui image label label-avatar">
        <Avatar user={ user } />
        { user.name }
    </a>`

@IssueAssigneeInput = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired

  handleChange: (value) ->
    Ajaxer.patch
      path: "/projects/#{this.props.project.slug}/issues/#{@props.issue.sequential_id}.json"
      data: { issue: {assignee_id: value } }

  render: ->
    `<AssociationInput name="issue[assignee_id]" collection={[this.props.issue.assignee]} onChange={this.handleChange}
                       data_set={
                {
                    'resource-path' : "/projects/"+ this.props.project.slug + "/settings/members",
                    'search-field' : '[ "name", "email" ]',
                    'option-tpl' : 'option-user'
                }
              }
        />`

@KanbanIssuePanelPriority = React.createClass
  propTypes:
    issue:   React.PropTypes.object.isRequired

  handleSave: (value) ->
    if value >= 0 && value <= 999
      Ajaxer.patch
        path: "/projects/#{this.props.project.slug}/issues/#{this.props.issue.sequential_id}.json"
        data: { issue: { order: value } }
    else
      alert( '數值必須是整數且介於0~999' )

  render: ->
    content1 =
      `<a className="ui icon label">
          <i className="ui icon asterisk" />
          { this.props.issue.order }
      </a>`

    `<div className="item">
        <h6 className="ui header">
            優先級
        </h6>
        <div className="">
            <ContentClickEditablePopupInput type="number" content1={content1} content2={this.props.issue.order} onSave={this.handleSave} />
        </div>
    </div>`

@KanbanIssuePanelPoint = React.createClass
  propTypes:
    issue:   React.PropTypes.object.isRequired

  handleSave: (value) ->
    if value >= 0 && value <= 999
      Ajaxer.patch
        path: "/projects/#{this.props.project.slug}/issues/#{this.props.issue.sequential_id}.json"
        data: { issue: { point: value } }
    else
      alert( '數值必須是整數且介於0~999' )

  render: ->
    content1 =
      `<a className="ui icon label">
          <i className="ui icon checkered flag" />
          { this.props.issue.point }
      </a>`

    `<div className="item">
        <h6 className="ui header">
            內容點數
        </h6>
        <div className="">
            <ContentClickEditablePopupInput type="number" content1={content1} content2={this.props.issue.point} onSave={this.handleSave} />
        </div>
    </div>`

@KanbanIssuePanelLabels = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired

  render: ->
    issue = @props.issue

    content1 = if issue.labels.length > 0
      issue.labels.map (label) =>
        `<KanbanIssueLabel label={label} key={label.id}/>`
    else
      `<div className="ui label"> 添加標籤 </div>`

    content2 = `<IssueLabelsInput {...this.props} />`

    `<div className="ui segment kanban-issue-panel-container">
        <div className="kanban-issue-panel-container-tag">
            <div className="" title="標籤">
                <i className="bordered icon tag"/>
            </div>
        </div>
        <div className="kanban-issue-panel-container-content">
            <ContentClickEditable content1={content1} content2={content2} />
        </div>
    </div>`

@IssueLabelsInput = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired

  handleChange: (e) ->
    if @refs.input
      label_ids = @refs.input.refs.select.getDOMNode().selectize.getValue()
      Ajaxer.patch
        path: "/projects/#{this.props.project.slug}/issues/#{this.props.issue.sequential_id}.json"
        data: {issue: {label_ids: if label_ids.length then label_ids else ''}}

  render: ->

    `<AssociationInput ref="input" name="issue[label_ids][]" collection={this.props.issue.labels} onChange={this.handleChange} multiple={true}
                       data_set={
              {
                  'resource-path' : "/projects/"+ this.props.project.slug + "/settings/labels",
                  'search-field' : '[ "title" ]',
                  'option-tpl' : 'option-label',
                  'item-tpl' : 'item-label',
                  'add-new' : 'true'
              }
            }
        />`

@KanbanIssuePanelmMemo = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired

  handleSave: (text) ->
    Ajaxer.patch
      path: "/projects/#{this.props.project.slug}/issues/#{this.props.issue.sequential_id}.json"
      data: { issue: { memo: text } }

  render: ->

    content1 = if @props.issue.memo == null or @props.issue.memo.trim() == ""
      `<div className="ui label"> 添加備註 </div>`
    else
      `<div dangerouslySetInnerHTML={{__html:this.props.issue.memo_html||""}} />`

    `<div className="ui segment kanban-issue-panel-container">
            <span className="kanban-issue-panel-container-tag">
                <div className="" title="備註">
                    <i className="bordered icon file text"/>
                </div>
            </span>
            <div className="kanban-issue-panel-container-content" >
                <ContentClickEditableTextArea content1={content1} content2={this.props.issue.memo||""} onSave={this.handleSave} />
            </div>
    </div>`

@KanbanIssuePanelParticipations = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired

  getInitialState: () ->
    { participations: [] }

  componentDidMount: () ->
    @refreshParticipations(@props)

  componentWillReceiveProps: (props) ->
    @refreshParticipations(props)

  refreshParticipations: (props) ->
    Ajaxer.get
      path: "/projects/#{props.project.slug}/issues/#{props.issue.sequential_id}/participations.json"
      done: (data) =>
        @setState({participations: data})

  render: ->

    participations = @state.participations.map (participation) ->
      `<LabelAvatar user={participation} key={participation.id} />`

    `<div className="ui segment kanban-issue-panel-container">
        <span className="kanban-issue-panel-container-tag">
            <div className="" title="參與者">
                <i className="bordered icon users"/>
            </div>
        </span>
        <div className="kanban-issue-panel-container-content">
            { participations }
        </div>
    </div>`

@KanbanIssuePanelComments = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    issue:   React.PropTypes.object.isRequired
    current_user: React.PropTypes.object.isRequired

  getInitialState: () ->
    { comments: [] }

  componentDidMount: () ->
    @refreshComments(@props)

  componentWillReceiveProps: (props) ->
    @refreshComments(props)

  refreshComments: (props) ->
    Ajaxer.get
      path: "/projects/#{props.project.slug}/issues/#{props.issue.sequential_id}/comments.json"
      done: (data) =>
        @setState({comments: data})

  render: ->
    commentableSocketPath = "/projects/#{@props.project.id}/issues/comments"
    `<div className="">
        <CommentApp is_user_in_project={true} project={this.props.project} user={this.props.current_user}
                    comments={this.state.comments}
                    commentable_type="issue"
                    commentable_record_id={this.props.issue.id}
                    commentable_resource_id={this.props.issue.sequential_id}
                    commentable_socket_path={commentableSocketPath}
                    is_unsubscribable={false} />
    </div>`

@KanbanApp = DragDropContext(HTML5Backend)(KanbanApp)
