@NoticeListApp = React.createClass
  propTypes:
    mode:         React.PropTypes.string.isRequired
    seal_count:   React.PropTypes.number.isRequired
    unseal_count: React.PropTypes.number.isRequired

  LOAD_SIZE: 10

  getInitialState: () ->
    return {notices: [], loading: false, noMoreNotices: false, seal_count: @props.seal_count, unseal_count: @props.unseal_count}

  componentDidMount: () ->
    @$container = $('body')
    @container  = @$container[0]

    @loadMore()

  componentWillUnmount: () ->
    @markAllAsRead() if @props.mode == 'unseal'

  handleOnWheel: (e)->
    if e.deltaY > 0 && @container.scrollTop == @container.scrollHeight - @$container.height()
      @loadMore()

  loadNotices: (mode, reset) ->
    return if @state.loading || @state.noMoreNotices

    lastId = _.last(@state.notices).id if @state.notices.length > 0

    @setState({loading: true})
    $.get('/notices.json', {q: {state_eq: mode, id_lt: lastId}})
     .done (data) =>
        newNotices = @state.notices.concat(data)
        @setState({notices: newNotices, loading: false, noMoreNotices: (data.length < @LOAD_SIZE)})

  loadMore: (e) ->
    e.preventDefault() if e
    @loadNotices(@props.mode)

  markAllAsRead: () ->
    $.ajax("/notices/check", {method: 'put'})

  archiveAll: ()->
    $.ajax("/notices/archive", {method: 'put'})
    @setState({notices: [], seal_count: @state.seal_count + @state.unseal_count, unseal_count: 0})

  openNotice: (notice)->
    $.ajax("/notices/#{notice.id}/seal", {method: 'put'}) if notice.state == 'unseal'
    Turbolinks.visit(TranslateHelper.noticePath(notice))

  archiveNotice: (notice, i)->
    $.ajax("/notices/#{notice.id}/seal", {method: 'put'})
    newNotices = @state.notices
    newNotices.splice(i, 1)
    @setState({notices: newNotices, seal_count: @state.seal_count+1, unseal_count: @state.unseal_count-1})

  render: ->
    if @props.loading
      showAll = `<div className="show-all loader"><div className="ui active inverted dimmer"><div className="ui loader"></div></div></div>`
    else
      if @state.noMoreNotices
        if @state.notices.length == 0
          showAll = `<div className="all-read"><i className="alarm outline icon"></i>沒有通知了！</div>`
        else if @props.mode == 'unseal'
          showAll = `<div className="show-all"><a href="" onClick={this.archiveAll}>封存全部通知</a></div>`
      else
        showAll   = `<div className="show-all"><a href="" onClick={this.loadMore}>顯示更多通知</a></div>`

    archiveNotice = @archiveNotice
    openNotice    = @openNotice

    noticeNodes = @state.notices.map (notice, i) ->
      `<Notice notice={notice} ref={notice.id} key={notice.id} i={i} archiveNotice={archiveNotice} openNotice={openNotice} />`

    `<div id="dashboard_notice_list">
      <NoticeSwitchBar mode={this.props.mode} seal_count={this.state.seal_count} unseal_count={this.state.unseal_count} />
      <div className="ui one column center aligned grid notice-list">
        <div className="column" ref="container" onWheel={this.handleOnWheel}>
          {noticeNodes}
          {showAll}
        </div>
      </div>
    </div>`

@NoticeSwitchBar = React.createClass
  render: ->
    sealClass = unsealClass = "item"
    if @props.mode == "seal"
      sealClass   += " active"
    else
      unsealClass += " active"

    `<div className="ui fluid two item red menu">
      <a className={unsealClass} href="/dashboard/notices?type_eq=unseal"> 未封存
        <div className="floating ui teal label">
          {this.props.unseal_count}
        </div></a>
      <a className={sealClass} href="/dashboard/notices?type_eq=seal"> 封存
        <div className="floating ui teal label">
          {this.props.seal_count}
        </div></a>
    </div>`
