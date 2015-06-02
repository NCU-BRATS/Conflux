@ChannelList = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired

  getInitialState: () ->
    return {channels: []}

  componentDidMount: () ->
    $.get("/projects/#{@props.project.slug}/channels.json")
      .done (data) => @setState({channels: data})

    PrivatePub.subscribe("/projects/#{@props.project.id}/channels", @messageRecieve)

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/channels")

  messageRecieve: (res, channel) ->
    @appendChannel(res.data)  if res.target == 'channel' && res.action == 'create'
    @replaceChannel(res.data) if res.target == 'channel' && res.action == 'update'
    @destroyChannel(res.data) if res.target == 'channel' && res.action == 'destroy'

  appendChannel: (channel) ->
    newChannels = @state.channels.concat(channel)
    @setState({channels: newChannels})

  replaceChannel: (channel) ->
    channels = @state.channels.slice()
    i = _.findIndex(channels, (c)-> c.id == channel.id)
    channels[i] = channel
    @setState({channels: channels})

  destroyChannel: (channel) ->
    channels = @state.channels.slice()
    i = _.findIndex(channels, (c)-> c.id == channel.id)
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
