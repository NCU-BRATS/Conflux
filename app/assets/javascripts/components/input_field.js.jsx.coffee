@AssociationInput = React.createClass
  propTypes:
    name:          React.PropTypes.node.isRequired
    collection:    React.PropTypes.array
    data_set:      React.PropTypes.object
    multiple:      React.PropTypes.bool
    onChange:      React.PropTypes.func

  componentDidMount: ->
    $element = $(@refs.select.getDOMNode())
    selectizeDefault = unless $element.data('resource-path') then {} else
      preload: 'focus'
      valueField: 'id'
      render:
        option: (item, escape)->
          template = "selectize/#{$element.data('option-tpl') || 'option-default'}"
          HandlebarsTemplates[template](item)
        item: (item, escape)->
          template = "selectize/#{$element.data('item-tpl') || 'item-default'}"
          HandlebarsTemplates[template](item)
      load: (query, callback)=>
        queryData = {}
        queryData['q'] = this.parseJson($element.data('query-param'))
        queryData['q'][$element.data('search-field').join('_or_') + '_cont'] = query
        queryData['per'] = $element.data('query-size')

        $.get($element.data('resource-path')+'.json?', queryData)
        .done (res)-> callback(res)

    settings = $.extend({
      plugins: ['select_add_new', 'remove_button']
    }, selectizeDefault, $element.data())
    selectizeControl = $element.selectize settings
    for element in @props.collection
      if element
        selectizeControl[0].selectize.addOption( element )
        selectizeControl[0].selectize.addItem( element.id )
    selectizeControl[0].selectize.refreshItems()

    if @props.multiple
      selectizeControl[0].selectize.on 'blur', @props.onChange
    else
      selectizeControl[0].selectize.on 'change', @props.onChange

  parseJson: (json) ->
    if json instanceof Object then json else {}

  render: ->

    if @props.multiple
      multiple = "multiple"

    dataAttributes = {}
    for key, value of @props.data_set
      dataAttributes["data-"+key] = value

    `<div>
        <input name={this.props.name} type="hidden"/>
        <select ref="select" multiple={multiple} {...dataAttributes}/>
    </div>`

@DateTimeInput = React.createClass
  propTypes:
    name:  React.PropTypes.node.isRequired
    time:  React.PropTypes.node
    is_time_enable: React.PropTypes.bool
    onChange: React.PropTypes.func.isRequired

  componentDidMount: ->
    $input   = $(@refs.input.getDOMNode())
    picktime = @props.is_time_enable
    format   = if picktime then 'YYYY-MM-DD HH:mm' else 'YYYY-MM-DD'

    $input.val(moment($input.val()).format(format)) if $input.val() != ''

    $input.datetimepicker
      language: 'zh-tw'
      pickTime: picktime
      pick12HourFormat: false
      format: format

    $input.on 'dp.hide', () =>
      @props.onChange( $input.val() )

    $input.on 'keydown', (e) =>
      $input.data('DateTimePicker').setDate(null)

  defaultOnChange: ->
#    nothing to do

  render: ->
    `<div className="ui fluid input datetime-input">
        <input data-toggle="datatime-picker" type="text" className="datetime optional"
               value={this.props.time} name={this.props.name} onChange={this.defaultOnChange} ref="input" />
    </div>`
