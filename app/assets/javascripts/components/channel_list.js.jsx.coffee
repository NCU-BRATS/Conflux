@ChannelList = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired

  getInitialState: () ->
    return {channels: []}

  componentDidMount: () ->
    $.get("/projects/#{@props.project.slug}/channels.json?q[s]=order asc&q[archived_eq]=false")
      .done (channels) =>
        if @props.policy
          $.get("/projects/#{@props.project.slug}/channels/read_status.json")
            .done (data) =>
              $.each data, (id, readed) =>
                if !readed
                  i = _.findIndex(channels, (c)-> +c.id == +id)
                  if i >= 0 && !@isCurrentChannel(channels[i])
                    channels[i].unread = true
                    $('#channel_notice').show()
                    $('#favicon').attr('href', '/favicon-unread.png')
              @setState {channels: channels}
        else
          @setState {channels: channels}

    PrivatePub.subscribe("/projects/#{@props.project.id}/channels", @messageRecieve)

  componentWillUnmount: () ->
    PrivatePub.unsubscribe("/projects/#{@props.project.id}/channels")

  messageRecieve: (res, channel) ->
    if res.data.archived
      @destroyChannel(res.data) if res.target == 'channel' && res.action == 'update'
    else
      @appendChannel(res.data)  if res.target == 'channel' && res.action == 'create'
      @replaceChannel(res.data) if res.target == 'channel' && res.action == 'update'
      @unreadChannel(res.data) if res.target == 'channel' && res.action == 'unread' && @props.policy

  isCurrentChannel: (channel) ->
    project = encodeURIComponent(@props.project.slug)
    channel = encodeURIComponent(channel.slug)
    window.location.pathname == "/projects/#{project}/channels/#{channel}"

  unreadChannel: (id) ->
    channels = @state.channels.slice()
    i = _.findIndex(channels, (c)-> +c.id == +id)
    if i >= 0 && !@isCurrentChannel(channels[i])
      channels[i].unread = true
      $('#channel_notice').show()
      $('#favicon').attr('href', '/favicon-unread.png')
    @setState({channels: channels})

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
    unread = `<span className="channel-unread ui circular red label"></span>` if @props.channel.unread
    `<a className="item overflow ellipsis" href={channelPath}>
      {unread}
      {this.props.channel.name}
    </a>`
