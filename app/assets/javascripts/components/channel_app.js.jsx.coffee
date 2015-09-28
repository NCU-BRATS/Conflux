@ChannelApp = React.createClass
  propTypes:
    user_id: React.PropTypes.number.isRequired
    project: React.PropTypes.object.isRequired
    channel: React.PropTypes.object.isRequired

  getInitialState: () ->
    return {messages: [], channel: @props.channel, loading: true, noMessages: false}

  componentDidMount: () ->
    @$mainContainer    = $('#main_container')
    @$contentContainer = $('.content-container')
    @$messageContainer = $(@refs.list.getDOMNode())
    @$channelHeader    = $(@refs.header.getDOMNode())
    @$channelFooter    = $(@refs.footer.getDOMNode())

    @getMessages()

    @resetContainerSize()
    $(window).bind 'resize', () => @resetContainerSize()
    PrivatePub.subscribe("/projects/#{@props.project.id}/channels/#{@props.channel.id}", @messageRecieve)

  componentWillUnmount: ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/channels/#{@props.channel.id}")
    $(window).unbind('resize')

  calculateMessageContainerValue: ()->
    windowHeight  = if (window.innerHeight > 0) then window.innerHeight else window.screen.height
    paddingTop    = @$mainContainer.outerHeight()    - @$mainContainer.height()
    paddingBottom = @$contentContainer.outerHeight() - @$contentContainer.height()
    headerHeight  = @$channelHeader.outerHeight()
    footerHeight  = @$channelFooter.outerHeight()

    height = windowHeight - paddingTop - paddingBottom - headerHeight - footerHeight
    return [height, @$messageContainer[0].scrollHeight - height]

  resetContainerSize: ()->
    @$messageContainer.css('height', @calculateMessageContainerValue()[0])

  scrollToBottom: ()->
    @$messageContainer.scrollTop(@calculateMessageContainerValue()[1]) # navigate to bottom
    @readMessage()

  processMessage: (messages, i) ->
    curr = messages[i]
    curr.appendMode = false
    curr.divider    = true

    return if i <= 0

    prev = messages[i-1]
    prevTime = new Date(prev.created_at)
    currTime = new Date(curr.created_at)
    if prevTime.toDateString() == currTime.toDateString()
      curr.divider = false
      curr.appendMode = (prev.user.id == curr.user.id && currTime - prevTime < 600000)

  messageRecieve: (res, channel) ->
    @appendMessage(res.data)  if res.target == 'message' && res.action == 'create'
    @replaceMessage(res.data) if res.target == 'message' && res.action == 'update'
    @destroyMessage(res.data) if res.target == 'message' && res.action == 'destroy'
    @replaceChannel(res.data) if res.target == 'channel' && res.action == 'update'

  appendMessage: (msg) ->
    newMessages = @state.messages.concat(msg)
    @processMessage(newMessages, newMessages.length-1)
    @setState {messages: newMessages}, ()=>
      diffToBottom = @calculateMessageContainerValue()[1] - @$messageContainer.scrollTop()
      if msg.user.id == @props.user_id || diffToBottom < 200
        @scrollToBottom()

  replaceMessage: (msg) ->
    messages = @state.messages.slice()
    i = _.findIndex(messages, (m)-> m.id == msg.id)
    messages[i] = msg
    @processMessage(messages, i)
    @setState({messages: messages})

  destroyMessage: (msg) ->
    messages = @state.messages.slice()
    i = _.findIndex(messages, (m)-> m.id == msg.id)
    messages.splice(i,1)
    @processMessage(messages, i) if i < messages.length # check appendMode of next message which index is now i after splice.
    @setState({messages: messages})

  readMessage: () ->
    message = @state.messages[@state.messages.length - 1]
    return unless message

    return if @lastReadFloor == message.sequential_id

    $.ajax("#{@props.channel.slug}/read.json", {
      method: 'PUT'
      data: { last_read_floor: message.sequential_id }
    })

    @lastReadFloor = message.sequential_id

  replaceChannel: (channel) ->
    @setState({channel: channel})

  handleOnWheel: (e)->
    if @$messageContainer.scrollTop() == 0 && e.deltaY < 0 && !@state.loading
      firstMsgId = @state.messages[0].id if @state.messages[0]
      @getMessages(firstMsgId)

  handleLoadMore: (e)->
    e.preventDefault()
    firstMsgId = @state.messages[0].id if @state.messages[0]
    @getMessages(firstMsgId)

  getMessages: (firstMsgId) ->
    return if @state.noMessages

    @setState({loading: true})
    $.get("#{@props.channel.slug}/messages.json", { q: { id_lt : firstMsgId } })
      .done (data)=>
        newMessages = data.concat(@state.messages)
        for msg, i in newMessages
          @processMessage(newMessages, i) # reprocess all messages

        @setState {messages: newMessages, noMessages: (data.length < 50)}, ()=>
          if firstMsgId
            @refs.list.refs[firstMsgId].getDOMNode().scrollIntoView()
          else
            @scrollToBottom()

      .fail (jqXHR, status, err)=>
        console.log(jqXHR, status, err.toString())

      .always () =>
        setTimeout(() =>
          @setState({loading: false}) # delay 1.5 sec for avoiding loading many times at once.
        , 1500)

  render: ->
    `<div className='ChnnelApp'>
      <ChannelHeader ref="header" channel={this.state.channel}/>
      <MessagesList ref="list" messages={this.state.messages} user_id={this.props.user_id} noMessages={this.state.noMessages} loading={this.state.loading} handleLoadMore={this.handleLoadMore} handleOnWheel={this.handleOnWheel}/>
      <MessageCreateForm ref="footer" channel={this.props.channel} readMessage={this.readMessage} />
    </div>`

@ChannelHeader = React.createClass
  showModal: ->
    $(@refs.modal.getDOMNode()).modal({detachable: false}).modal('show')
  render: ->
    editPath = "#{@props.channel.slug}/edit"
    `<div className='channelHeader'>
      <div className="page-header">
        <h3 className="ui header search-field">
          <i className="comments icon"></i>
          <div className="content">
            {this.props.channel.name}
            <div className="sub header">{this.props.channel.description}</div>
          </div>
        </h3>
        <div className="ui right floated buttons">
          <div className="ui button basic orange" onClick={this.showModal}>
            <i className="icon flag"></i>公告
          </div>
          <a className="ui button basic red" href={editPath}><i className="icon edit"></i>編輯</a>
        </div>
      </div>
      <div className="ui standard modal" ref="modal">
        <div className="header">公告</div>
        <div className="content">
          <div className="description" dangerouslySetInnerHTML={{__html:this.props.channel.html}}></div>
        </div>
      </div>
    </div>`

@MessagesList = React.createClass
  render: ->
    user_id = @props.user_id

    if !@props.noMessages
      if @props.loading
        loader = `<div className="ui center aligned segment"><div className="ui active loader"></div></div>`
      else
        loader = `<div className="ui center aligned segment"><p className="loading-hint"><a href="" onClick={this.props.handleLoadMore}>讀取更多</a></p></div>`

    messageNodes = @props.messages.map (msg) ->
      `<Message msg={msg} ref={msg.id} key={msg.id} user_id={user_id}/>`

    `<div id='message_container' ref='messagesList' onWheel={this.props.handleOnWheel}>
      {loader}
      {messageNodes}
    </div>`

@Message = React.createClass
  getInitialState: ->
    return {editMode: false}
  toggleEdit: (e)->
    e.preventDefault() if e
    @setState({editMode: !@state.editMode})
  shouldComponentUpdate: (nextProps, nextState)->
    @props.msg.content != nextProps.msg.content || @state.editMode != nextState.editMode
  render: ->
    msg = @props.msg;
    if msg.divider
      dateDivider = `<MessageDateDivider msg={this.props.msg}/>`
    if @state.editMode
      messageAvatar = `<Avatar user={this.props.msg.user}/>`
      messageBody   = `<MessageEditForm msg={this.props.msg} toggleEdit={this.toggleEdit}/>`
    else
      messageBody   = `<div className="description" dangerouslySetInnerHTML={{__html:this.props.msg.html}}></div>`
      if !msg.appendMode
        messageHeader = `<MessageHeader msg={this.props.msg}/>`
        messageAvatar = `<Avatar user={this.props.msg.user}/>`
      else
        messageAvatar = `<MessageTime msg={this.props.msg}/>`
      if msg.user.id == @props.user_id
        messageControl = `<MessageControl msg={this.props.msg} toggleEdit={this.toggleEdit}/>`

    if msg.appendMode
      classStr = "message inline"
    else
      classStr = "message header"
    if @state.editMode
      classStr = "message edit"

    `<div className={classStr}>
      {dateDivider}
      <div className="thumb">{messageAvatar}</div>
      <div className="content">
        {messageHeader}
        <div className="body">
          {messageBody}
          {messageControl}
        </div>
      </div>
    </div>`

@MessageDateDivider = React.createClass
  render: ->
    time = moment(new Date(@props.msg.created_at)).format("YYYY Mo Do, dddd")
    `<h4 className="ui horizontal header divider">{time}</h4>`

@MessageControl = React.createClass
  render: ->
    deletePath = "../messages/#{@props.msg.id}.json"
    `<div className="control">
      <div className="ui icon circular button basic" onClick={this.props.toggleEdit}>
        <i className="icon write"></i>
      </div>
    </div>`
@MessageHeader = React.createClass
  render: ->
    userPath = "/users/#{@props.msg.user.slug}"
    `<div className="header">
      <a className="bold black link" href={userPath}>{this.props.msg.user.name}</a>
      <MessageTime msg={this.props.msg}/>
    </div>`

@MessageTime = React.createClass
  render: ->
    time = moment(new Date(@props.msg.created_at)).format('h:mm a')
    `<span className="time">{time}</span>`

@MessageCreateForm = React.createClass
  componentDidMount: ->
    @inputDOMNode = @refs.input.getDOMNode()
    @$inputDOMNode = $(@inputDOMNode)
  handleSubmit: (e) -> e.preventDefault()
  handleClick: (e) -> @props.readMessage()
  handleKeyDown: (e) ->
    # press cmd+enter or ctrl+enter
    if ((e.keyCode == 10 || e.keyCode == 13) && (e.ctrlKey || e.metaKey))
      @inputDOMNode.value += '\n'
    # submit
    else if e.keyCode == 13
      e.preventDefault()
      inputValue = @inputDOMNode.value.trim()
      return if inputValue == ''

      postPath = "#{@props.channel.slug}/messages.json"
      $.post(postPath, { message: {content: inputValue}})

      @inputDOMNode.value = ''

  handleKeyUp: (e) ->
    if @inputDOMNode.value.split(/\r\n|\r|\n/).length <= 1
      @$inputDOMNode.css('height', '3em')
    else
      @$inputDOMNode.css('height', '12em')
    $(window).trigger('resize')

  render: ->
    `<form id="channel_footer" className="ui form" onSubmit={this.handleSubmit}>
      <div className="field">
        <textarea ref="input" onKeyDown={this.handleKeyDown} onKeyUp={this.handleKeyUp} onClick={this.handleClick} placeholder="按下 enter 發送，ctrl + enter 換行，支援 markdown"></textarea>
      </div>
    </form>`

@MessageEditForm = React.createClass
  getInitialState: ->
    return {loading: false}
  componentDidMount: ->
    @inputDOMNode = @refs.input.getDOMNode()
    @$inputDOMNode = $(@inputDOMNode)

    if @$inputDOMNode.val().split(/\r\n|\r|\n/).length > 1
      @$inputDOMNode.css('height', '12em')
    # set focus at the end
    tmp = @$inputDOMNode.val()
    @$inputDOMNode.val('')
    @$inputDOMNode.focus()
    @$inputDOMNode.val(tmp)

  handleSubmit: (e) -> e.preventDefault()
  handleKeyDown: (e) ->
    # press cmd+enter or ctrl+enter or cmd+v or ctrl+v
    if ((e.keyCode == 10 || e.keyCode == 13) && (e.ctrlKey || e.metaKey))
      @inputDOMNode.value += '\n'
    # submit
    else if e.keyCode == 13
      @submit(e)
    else if e.keyCode == 27
      @props.toggleEdit()

  handleKeyUp: (e) ->
    if @inputDOMNode.value.split(/\r\n|\r|\n/).length <= 1
      @$inputDOMNode.css('height', '3em')
    else
      @$inputDOMNode.css('height', '12em')

  submit: (e)->
    e.preventDefault()
    inputValue = @inputDOMNode.value.trim()
    if @props.msg.content == inputValue || inputValue == ''
      @inputDOMNode.value = @props.msg.content
      return @props.toggleEdit()

    @setState({loading: true})

    putPath = "../messages/#{@props.msg.id}.json"
    $.ajax(putPath, {
      method: 'PATCH'
      data: {message: {content: inputValue}}
    }).done () =>
      @setState {loading: false}, ()=>
        @props.toggleEdit()
    .fail () =>
      console.log("post err")

  render: ->
    formClass = "ui form"
    formClass += " loading" if @state.loading
    `<form className={formClass} id="edit_message" onSubmit={this.handleSubmit}>
      <div className="field">
        <textarea ref="input" defaultValue={this.props.msg.content} onKeyDown={this.handleKeyDown} onKeyUp={this.handleKeyUp}></textarea>
        <p className="hint">按下 <a href="" onClick={this.props.toggleEdit}>esc</a> 取消，按下 <a href="" onClick={this.submit}>enter</a> 儲存</p>
      </div>
    </form>`
