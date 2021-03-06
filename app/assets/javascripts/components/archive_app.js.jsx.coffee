@ArchiveApp = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    current_user: React.PropTypes.object.isRequired

  getInitialState: () ->
    { model: 'sprint' }

  handleOnClickMode: (e) ->
    $('.archive-menu-item').removeClass( 'active' )
    $(e.currentTarget).addClass( 'active' )
    @setState( { model: e.currentTarget.getAttribute('data-mode') } )

  render: ->
    `<div className="archive-app">
        <div className="ui two item teal menu">
            <a className="active item archive-menu-item" data-mode="sprint" onClick={this.handleOnClickMode}><i className="icon flag"/>sprint</a>
            <a className="item archive-menu-item" data-mode="channel" onClick={this.handleOnClickMode}><i className="icon comments"/>channel</a>
        </div>
        <div className="">
            <ArchiveModelApp model={this.state.model} key={this.state.model} {...this.props} />
        </div>
    </div>`

@ArchiveModelApp = React.createClass
  propTypes:
    model:   React.PropTypes.string.isRequired
    project: React.PropTypes.object.isRequired

  getInitialState: () ->
    { items: [], per: 40 }

  componentDidMount: () ->
    PrivatePub.subscribe("/projects/#{@props.project.id}/#{@props.model}s", @itemRecieve)
    @$list = $('body')
    @list  = @$list[0]
    @loadMoreItems()

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/#{@props.model}s")

  itemRecieve: (res, channel) ->
    if res.data.archived
      @updateItem(res.data)  if res.target == @props.model && res.action == 'update'
    else
      @removeItem(res.data)  if res.target == @props.model && res.action == 'update'

  updateItem: (item) ->
    items = @state.items.slice()
    i = _.findIndex(items, (c)-> c.id == item.id)
    if i >= 0
      items[i] = item
    else
      items = [ item ].concat(@state.items)
    @setState({items: items})

  removeItem: (item) ->
    items = @state.items.slice()
    i = _.findIndex(items, (c)-> c.id == item.id)
    if i >= 0
      items.splice(i,1)
      @setState({items: items})

  handleOnWheel: (e)->
    if e.deltaY > 0 && @list.scrollTop == @list.scrollHeight - @$list.height()
      e.preventDefault()
      @loadMoreItems()

  loadMoreItems: () ->
    return if @state.loading || @state.noMoreItems
    lastUpdated = _.last(@state.items).updated_at if @state.items.length > 0
    @setState({loading: true})
    Ajaxer.get
      path: "/projects/#{@props.project.slug}/#{@props.model}s.json?q[s]=updated_at desc&q[archived_eq]=true&per=#{@state.per}" + if lastUpdated then "&q[updated_at_lt]=#{lastUpdated}" else ''
      done: (data) =>
        items = @state.items.concat(data)
        @setState({items: items, loading: false, noMoreItems: (data.length < @state.per)})

  render: ->
    props = @props

    content = if @state.items.length > 0
      list = @state.items.map (item,i) =>
        `<ArchiveModelViewSelector item={item} key={item.id} {...props}/>`
      `<div className="ui four doubling cards">
          { list }
      </div>`
    else
      `<div className="ui secondary segment">
          <div className="ui center aligned icon header">
              <i className="icon info circle"/>
              <div className="content">目前還沒有任何已封存資料</div>
          </div>
      </div>`

    `<div className="archive-model-app ui one column center aligned grid">
        <div className="archive-list column" ref="list" onWheel={this.handleOnWheel}>
            { content }
        </div>
    </div>`

@ArchiveModelViewSelector = React.createClass
  propTypes:
    item:    React.PropTypes.object.isRequired
    model:   React.PropTypes.string.isRequired
    project: React.PropTypes.object.isRequired

  render: ->

    return `<ArchiveSprintItem {...this.props}/>` if @props.model == 'sprint'
    return `<ArchiveChannelItem {...this.props}/>` if @props.model == 'channel'
    return `<div>NOT VALID MODEL</div>`

@ArchiveSprintItem = React.createClass
  propTypes:
    item:    React.PropTypes.object.isRequired
    project: React.PropTypes.object.isRequired

  handleOnDearchive: () ->
    if confirm( '確定要解除封存?' )
      Ajaxer.patch
        path: "/projects/#{this.props.project.slug}/sprints/#{this.props.item.sequential_id}.json"
        data: { sprint: { archived: false } }

  render: ->
    item = @props.item
    undoneCount = item.issues_count - item.issues_done_count
    undoneClass = if undoneCount > 0 then 'red' else ''
    `<div className="ui card">
        <div className="content">
            <a className="ui corner label" title="解除封存" onClick={this.handleOnDearchive}>
                <i className="icon reply"/>
            </a>
            <div className="header">
                ##{ item.sequential_id }-{ item.title }
            </div>
            <div className="meta">
                { new moment( new Date(item.updated_at) ).fromNow() }
            </div>
        </div>
        <div className="extra content">
            <div className="ui label">
                已完成
                <div className="detail">{ item.issues_done_count }</div>
            </div>
            <div className={"ui label "+undoneClass}>
                未完成
                <div className="detail ">{ undoneCount }</div>
            </div>

        </div>
    </div>`

@ArchiveChannelItem = React.createClass
  propTypes:
    item:    React.PropTypes.object.isRequired
    project: React.PropTypes.object.isRequired

  handleOnDearchive: () ->
    if confirm( '確定要解除封存?' )
      Ajaxer.patch
        path: "/projects/#{this.props.project.slug}/channels/#{this.props.item.slug}.json"
        data: { channel: { archived: false } }

  render: ->
    item = @props.item
    `<div className="ui card">
        <div className="content">
            <a className="ui corner label" title="解除封存" onClick={this.handleOnDearchive}>
                <i className="icon reply"/>
            </a>
            <div className="header">
                { item.name }
            </div>
            <div className="meta">
                { new moment( new Date(item.updated_at) ).fromNow() }
            </div>
        </div>
    </div>`
