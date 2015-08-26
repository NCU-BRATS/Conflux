@ChannelList = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired

  getInitialState: () ->
    return {channels: []}

  componentDidMount: () ->
    $.get("/projects/#{@props.project.slug}/channels.json?q[s]=order asc&q[archived_eq]=false")
      .done (data) => @setState({channels: data})

    PrivatePub.subscribe("/projects/#{@props.project.id}/channels", @messageRecieve)

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/channels")

  messageRecieve: (res, channel) ->
    if res.data.archived
      @destroyChannel(res.data) if res.target == 'channel' && res.action == 'update'
    else
      @appendChannel(res.data)  if res.target == 'channel' && res.action == 'create'
      @replaceChannel(res.data) if res.target == 'channel' && res.action == 'update'

  appendChannel: (channel) ->
    newChannels = @state.channels.concat(channel)
    newChannels = _.sortBy newChannels, (channel) ->
      channel.order
    @setState({channels: newChannels})

  replaceChannel: (channel) ->
    channels = @state.channels.slice()
    i = _.findIndex(channels, (c)-> c.id == channel.id)
    if i >= 0
      channels[i] = channel
    else
      channels = @state.channels.concat(channel)
    channels = _.sortBy channels, (channel) ->
      channel.order
    @setState({channels: channels})

  destroyChannel: (channel) ->
    channels = @state.channels.slice()
    i = _.findIndex(channels, (c)-> c.id == channel.id)
    if i >= 0
      channels.splice(i,1)
      @setState({channels: channels})

  render: ->
    project = @props.project
    channelNodes = @state.channels.map (channel) ->
      `<ChannelLink channel={channel} project={project} ref={channel.id} key={channel.id}/>`

    `<div ref='channelsList'>{channelNodes}</div>`

@ChannelLink = React.createClass
  render: ->
    channelPath = "/projects/#{@props.project.slug}/channels/#{@props.channel.slug}"
    `<a className="item overflow ellipsis" href={channelPath}>{this.props.channel.name}</a>`
