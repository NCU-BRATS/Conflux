@SidemenuNotices = React.createClass
  propTypes:
    user: React.PropTypes.object.isRequired

  LOAD_SIZE: 10
  popupOpened: false

  getInitialState: () ->
    return {unreadNoticeSize: 0, notices: [], mode: 'seal', loading: false, shadow: 'none', noMoreNotices: false, initialLoad: true}

  componentDidMount: () ->
    $(@refs.avatar.refs.img.getDOMNode()).popup({on: 'click', onShow: @onPopupOpen, onHidden: @onPopupHide, exclusive: false})
    @container  = @refs.popup.refs.list.refs.container.getDOMNode()
    @$container = $(@container)

    @loadNoticesCount()

    PrivatePub.subscribe("/users/#{@props.user.id}", @loadNoticesCount)

  componentWillUnmount: ->
    PrivatePub.unsubscribe("/users/#{@props.user.id}")

  onPopupOpen: () ->
    $('[data-content]').popup({exclusive: false, position: 'top center'})
    @popupOpened = true;
    @setState({unreadNoticeSize: 0})
    @loadNotices('unseal')

  onPopupHide: () ->
    @markAllAsRead()
    @popupOpened = false;
    @setState(@getInitialState())

  handleOnWheel: (e)->
    if (newShadowState = @shadowState()) != @state.shadow
      @setState({shadow: newShadowState})

    if e.deltaY > 0 && @container.scrollTop == @container.scrollHeight - @$container.height()
      @loadMore()

  shadowState: () ->
    return if @container.scrollTop == 0 then 'none' else 'block'

  loadNoticesCount: () ->
    $.get('/notices/count').done (data) => @setState({unreadNoticeSize: data})
    @loadNotices('unseal', true) if @state.mode == 'unseal'

  loadNotices: (mode, reset) ->
    modeChanged = initialLoad = ((mode != @state.mode) || reset)

    return if !@popupOpened || @state.loading || (@state.noMoreNotices && !modeChanged)

    if modeChanged
      shadow = 'none'
    else
      shadow = @state.shadow
      lastId = _.last(@state.notices).id if @state.notices.length > 0

    @setState({loading: true, initialLoad: initialLoad})
    $.get('/notices.json', {q: {state_eq: mode, id_lt: lastId}})
     .done (data) =>
        if modeChanged
          newNotices = data
        else
          newNotices = @state.notices.concat(data)

        @setState {notices: newNotices, mode: mode, loading: false, shadow: shadow, noMoreNotices: (data.length < @LOAD_SIZE)}, ()=>
          @$container.scrollTop(0) if modeChanged

  loadMore: (e) ->
    e.preventDefault() if e
    @loadNotices(@state.mode)

  toggleUnread: () ->
    if @state.mode == 'seal'
      @loadNotices('unseal')
    else
      @loadNotices('seal')

  markAllAsRead: () ->
    $.ajax("/notices/check", {method: 'put'})

  archiveAll: ()->
    $.ajax("/notices/archive", {method: 'put'})
     .done () => @loadNotices('unseal', true)

  openNotice: (notice)->
    $.ajax("/notices/#{notice.id}/seal", {method: 'put'}) if notice.state == 'unseal'
    Turbolinks.visit(NoticeHelper.noticePath(notice))

  archiveNotice: (notice, i)->
    $.ajax("/notices/#{notice.id}/seal", {method: 'put'})
    newNotices = @state.notices
    newNotices.splice(i, 1)
    @setState({notices: newNotices, shadow: @shadowState()})

  render: ->
    if @state.unreadNoticeSize > 0
      noticeCounter = `<NoticeCounter counter={this.state.unreadNoticeSize} />`

    `var {unreadNoticeSize, ...otherState} = this.state`
    `<div id="sidebar-avatar">
      {noticeCounter}
      <Avatar ref="avatar" user={this.props.user} />
      <SidemenuPopup ref="popup" user={this.props.user} {...otherState} handleOnWheel={this.handleOnWheel} toggleUnread={this.toggleUnread} archiveAll={this.archiveAll} archiveNotice={this.archiveNotice} openNotice={this.openNotice} loadMore={this.loadMore} />
    </div>`

@NoticeCounter = React.createClass
  render: ->
    `<div className="circular floating ui label red" id="unread_notice_counter">{this.props.counter}</div>`

@SidemenuPopup = React.createClass
  render: ->
    `var {toggleUnread, mode, archiveAll, ...other} = this.props`
    `<div className="notice ui flowing popup">
      <SidemenuPopupHeader toggleUnread={toggleUnread} mode={mode} archiveAll={archiveAll} />
      <SidemenuNoticeList ref="list" {...other} />
      <SidemenuToolBar user={this.props.user} />
    </div>`

@SidemenuPopupHeader = React.createClass
  render: ->
    if @props.mode == 'seal'
      toggleClass = "inbox icon toggle"
      title       = "已封存的通知"
      archiveBtn  = "none"
      noticesPath = "/dashboard/notices?type_eq=seal"
    else
      toggleClass = "archive icon toggle"
      title       = "未封存的通知"
      archiveBtn  = "inherit"
      noticesPath = "/dashboard/notices?type_eq=unseal"

    `<div className="ui one column center aligned grid header" ref="header">
      <div className="column">
        <i className={toggleClass} onClick={this.props.toggleUnread} data-content="封存/未封存"></i>
        <a href={noticesPath}>{title}</a>
        <i className="checkmark icon batch" style={{display: archiveBtn}} onClick={this.props.archiveAll} data-content="封存所有通知"></i>
      </div>
    </div>`

@SidemenuNoticeList = React.createClass
  render: ->
    if @props.loading
      if @props.initialLoad
        loader  = `<div className="ui active inverted dimmer"><div className="ui loader"></div></div>`
      else
        showAll = `<div className="show-all loader"><div className="ui active inverted dimmer"><div className="ui loader"></div></div></div>`
    else
      if @props.noMoreNotices
        if @props.notices.length == 0
          showAll = `<div className="all-read"><i className="alarm outline icon"></i>沒有通知了！</div>`
      else
        showAll   = `<div className="show-all"><a href="" onClick={this.props.loadMore}>顯示更多通知</a></div>`

    {archiveNotice, openNotice} = @props

    noticeNodes = @props.notices.map (notice, i) ->
      `<Notice notice={notice} ref={notice.id} key={notice.id} i={i} archiveNotice={archiveNotice} openNotice={openNotice} />`

    `<div className="ui one column center aligned grid notice-list">
      <div className="shadow" style={{display: this.props.shadow}}></div>
      {loader}
      <div className="column" ref="container" onWheel={this.props.handleOnWheel}>
        {noticeNodes}
        {showAll}
      </div>
    </div>`

@SidemenuToolBar = React.createClass
  render: ->
    userPath = "/users/#{@props.user.slug}"

    `<div className="ui three column divided center aligned grid tool-bar" ref="toolBar">
      <a href={userPath} className="column" data-content="個人檔案">
        <i className="user icon"></i>
      </a>
      <a href="/profile" className="column" data-content="個人設定">
        <i className="setting icon"></i>
      </a>
      <a href="/users/sign_out" data-method="delete" className="column" data-content="登出">
        <i className="sign out icon"></i>
      </a>
    </div>`
