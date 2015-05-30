@EventListApp = React.createClass
  LOAD_SIZE: 30

  getInitialState: ->
    return {events: [], loading: false, noMoreEvent: false, f: {comment: null, issue: null, poll: null, user: null, attachment: null}}

  componentDidMount: ->
    @$container = $('body')
    @container  = @$container[0]

    @loadEvent()

  handleOnWheel: (e)->
    if e.deltaY > 0 && @container.scrollTop > @container.scrollHeight - @$container.height() - 100
      @loadEvent()

  toggleFilter: (filter)->
    f = @state.f
    f[filter] = !f[filter]
    @setState {f: f, events: [], noMoreEvent: false}, => @loadEvent()

  loadEvent: () ->
    return if @state.loading || @state.noMoreEvent

    lastId = _.last(@state.events).id if @state.events.length > 0

    @setState({loading: true})
    $.get('events.json', {f: @state.f, q: {id_lt: lastId}})
     .done (data) =>
        newEvents = @state.events.concat(data)
        @setState({events: newEvents, loading: false, noMoreEvent: (data.length < @LOAD_SIZE)})

  render: ->
    `<div>
      <EventFilter f={this.state.f} toggleFilter={this.toggleFilter} />
      <EventList events={this.state.events} loading={this.state.loading} handleOnWheel={this.handleOnWheel} />
    </div>`

@EventList = React.createClass
  render: ->
    if @props.loading
      loader = `<div className="show-all loader"><div className="ui active inverted dimmer"><div className="ui loader"></div></div></div>`

    eventNodes = @props.events.map (event, i) ->
      `<Event event={event} ref={event.id} key={event.id} i={i} />`

    `<div className="event-list" ref="container" onWheel={this.props.handleOnWheel}>
      {eventNodes}
      {loader}
    </div>`

@EventFilter = React.createClass
  render: ->
    attachmentClass = if @props.f.attachment then 'item active' else 'item'
    commentClass    = if @props.f.comment    then 'item active' else 'item'
    issueClass      = if @props.f.issue      then 'item active' else 'item'
    pollClass       = if @props.f.poll       then 'item active' else 'item'
    userClass       = if @props.f.user       then 'item active' else 'item'
    `<div className="ui secondary menu event-toggle">
      <a className={commentClass} onClick={this.props.toggleFilter.bind(null, 'comment')}>
        <i className="comment icon"></i> 回覆
      </a>
      <a className={issueClass} onClick={this.props.toggleFilter.bind(null, 'issue')}>
        <i className="tasks icon"></i> 任務
      </a>
      <a className={pollClass} onClick={this.props.toggleFilter.bind(null, 'poll')}>
        <i className="signal icon"></i> 投票
      </a>
      <a className={attachmentClass} onClick={this.props.toggleFilter.bind(null, 'attachment')}>
        <i className="file icon"></i> 檔案
      </a>
      <a className={userClass} onClick={this.props.toggleFilter.bind(null, 'user')}>
        <i className="users icon"></i> 團隊
      </a>
    </div>`
