@ChannelSettingApp = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    current_user: React.PropTypes.object.isRequired

  getInitialState: () ->
    { channels: [], loading: false }

  componentDidMount: () ->
    PrivatePub.subscribe("/projects/#{@props.project.id}/channels", @channelRecieve)
    Ajaxer.get
      path: "/projects/#{@props.project.slug}/channels.json?q[s]=order asc&q[archived_eq]=false"
      done: (data) =>
        @setState({channels: data})

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/channels")

  channelRecieve: (res, channel) ->
    if res.data.archived
      @destroyChannel(res.data) if res.target == 'channel' && res.action == 'update'
    else
      @appendChannel(res.data)  if res.target == 'channel' && res.action == 'create'
      @replaceChannel(res.data) if res.target == 'channel' && res.action == 'update'

  appendChannel: (channel) ->
    channels = @state.channels.concat(channel)
    @setState({channels: channels})

  replaceChannel: (channel) ->
    channels = @state.channels.slice()
    i = _.findIndex(channels, (c)-> c.id == channel.id)
    if i >= 0
      channels[i] = channel
    else
      channels = channels.concat(channel)
    channels = _.sortBy channels, (channel) ->
      channel.order
    @setState({channels: channels})

  destroyChannel: (channel) ->
    channels = @state.channels.slice()
    i = _.findIndex(channels, (c)-> c.id == channel.id)
    channels.splice(i,1)
    @setState({channels: channels})

  render: ->
    `<div className="channel-setting-app">
        <ChannelSettingList channels={this.state.channels} project={this.props.project}/>
    </div>`

@ChannelSettingList = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    channels: React.PropTypes.array.isRequired

  mixins: [ SortableMixin ]

  sortableOptions:
    handle: '.channel-setting-item-handle'

  getInitialState: () ->
    { items: @props.channels, loading: false }

  componentWillReceiveProps: (props) ->
    @setState({ items: props.channels })

  handleEnd: (e) ->
    if @state.items.length > 1
      nextOrder = if e.newIndex == 0
        n1 = @state.items[ e.newIndex + 1 ].order
        n1 - 99
      else if e.newIndex == @state.items.length - 1
        p1 = @state.items[ e.newIndex - 1 ].order
        p1 + 99
      else
        nextOrder = @state.items[ e.newIndex + 1 ].order
        prevOrder = @state.items[ e.newIndex - 1 ].order
        Math.random() * ( nextOrder - prevOrder ) + prevOrder
      Ajaxer.patch
        path: "/projects/#{this.props.project.slug}/channels/#{@state.items[e.newIndex].slug}.json"
        data: { channel: { order: nextOrder } }

  render: ->
    props = @props
    channelItems = @state.items.map (channel,i) =>
      `<ChannelSettingItem channel={channel} project={props.project}key={channel.id}/>`
    `<div>
        { channelItems }
    </div>`

@ChannelSettingItem = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    channel: React.PropTypes.object.isRequired

  render: ->
    `<div className="channel-setting-item ui middle aligned segment">
        <a className="channel-setting-item-handle">
            <i className="big icon sidebar"/>
        </a>
        <ChannelSettingItemName {...this.props} />
        <div className="ui right floated buttons channel-setting-item-control">
            <ChannelSettingItemArchiveButton {...this.props} />
        </div>
    </div>`

@ChannelSettingItemName = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    channel: React.PropTypes.object.isRequired

  handleSave: (value) ->
    Ajaxer.patch
      path: "/projects/#{this.props.project.slug}/channels/#{this.props.channel.slug}.json"
      data: { channel: { name: value } }

  render: ->
    content1 = ` <h1 style={{cursor: 'pointer'}}>{ this.props.channel.name } <i className="write icon"></i></h1>`

    `<span className="channel-setting-item-name">
        <span className="">
        </span>
        <span className="">
            <ContentClickEditableInput type="text" content1={content1} content2={this.props.channel.name} onSave={this.handleSave} quickSave={true} />
        </span>
    </span>`

@ChannelSettingItemArchiveButton = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    channel: React.PropTypes.object.isRequired

  handleArchive: () ->
    if confirm( '確定要封存?' )
      Ajaxer.patch
        path: "/projects/#{this.props.project.slug}/channels/#{@props.channel.slug}.json"
        data: { channel: { archived: true } }

  render: ->
    `<div className="ui button" onClick={this.handleArchive}>
        <i className="icon archive"/>
        封存
    </div>`
