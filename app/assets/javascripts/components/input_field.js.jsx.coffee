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

@ContentClickEditableInput = React.createClass
  propTypes:
    type:         React.PropTypes.string.isRequired
    content1:     React.PropTypes.node.isRequired
    content2:     React.PropTypes.node.isRequired
    onSave:       React.PropTypes.func
    onCancel:     React.PropTypes.func
    getFocusNode: React.PropTypes.func
    quickSave:    React.PropTypes.bool

  mixins: [React.addons.LinkedStateMixin]

  getInitialState: () ->
    { inputValue: @props.content2 }

  getFocusNode: () ->
    @refs.input.getDOMNode()

  handleSave: () ->
    @props.onSave( @state.inputValue ) if @props.onSave

  handleCancel: () ->
    @props.onCancel( @state.inputValue ) if @props.onCancel
    @setState( @getInitialState() )

  handleOnEnter: (e) ->
    if e.keyCode == 27
      @toShowMode()
    if @props.quickSave && e.keyCode == 13
      if @props.content2 != @state.inputValue
        @handleSave(e)
      @toShowMode()

  setToShowMode: (toShowMode) ->
    @toShowMode = toShowMode

  render: ->
    content2 =
      `<div className="ui form">
          <div className="field" >
              <input type={this.props.type} ref="input" valueLink={this.linkState('inputValue')} onKeyUp={this.handleOnEnter}/>
          </div>
      </div>`

    `<ContentClickEditable
        content1={this.props.content1}
        content2={content2}
        onSave={this.handleSave}
        onCancel={this.handleCancel}
        getFocusNode={this.getFocusNode}
        simpleMode={this.props.quickSave}
        setToShowMode={this.setToShowMode}/>`

@ContentClickEditableTextArea = React.createClass
  propTypes:
    content1:     React.PropTypes.node.isRequired
    content2:     React.PropTypes.node.isRequired
    onSave:       React.PropTypes.func
    onCancel:     React.PropTypes.func
    getFocusNode: React.PropTypes.func

  mixins: [React.addons.LinkedStateMixin]

  getInitialState: () ->
    { text: @props.content2 }

  getFocusNode: () ->
    @refs.textarea.getDOMNode()

  handleSave: () ->
    @props.onSave( @state.text ) if @props.onSave

  handleCancel: () ->
    @props.onCancel( @state.text ) if @props.onCancel
    @setState( @getInitialState() )

  render: ->
    content2 =
      `<div className="ui form">
          <div className="field" >
              <textarea type="text" ref="textarea" valueLink={this.linkState('text')}/>
          </div>
      </div>`

    `<ContentClickEditable
        content1={this.props.content1}
        content2={content2}
        onSave={this.handleSave}
        onCancel={this.handleCancel}
        getFocusNode={this.getFocusNode} />`

@ContentClickEditable = React.createClass
  propTypes:
    content1:     React.PropTypes.node.isRequired
    content2:     React.PropTypes.node.isRequired
    onSave:       React.PropTypes.func
    onCancel:     React.PropTypes.func
    getFocusNode: React.PropTypes.func
    setToShowMode:React.PropTypes.func
    simpleMode:   React.PropTypes.bool

  getInitialState: () ->
    { editMode: false }

  componentDidMount: () ->
    @props.setToShowMode( @toShowMode ) if @props.setToShowMode
    $(@refs.editable1.getDOMNode()).click () =>
      if !getSelection().toString()
        @setState { editMode: true }

  toShowMode: () ->
    @setState( { editMode: false } )

  handleSave: (e) ->
    e.preventDefault() if e
    @props.onSave() if @props.onSave
    @toShowMode()

  handleCancel: (e) ->
    e.preventDefault() if e
    @props.onCancel() if @props.onCancel
    @toShowMode()

  render: ->
    if @state.editMode
      editable1Class = "not_show"
    else
      editable2Class = "not_show"

    unless @props.simpleMode
      if @props.onSave
        saveButton = ` <div className="ui button" onClick={this.handleSave}>儲存</div>`
      control = `
          <div className="control-btns">
              <div className="ui right floated small buttons">
                  { saveButton }
                  <div className="ui button" onClick={this.handleCancel}>返回</div>
              </div>
          </div>`

    `<div className="content-click-editable">
        <div ref="editable1" title="點擊即可編輯" className={ editable1Class || "" }>
            { this.props.content1 }
        </div>
        <div ref="editable2" className={ editable2Class || "" }>
            <div>
                { this.props.content2 }
            </div>
            { control }
        </div>
    </div>`

@ContentClickEditablePopupInput = React.createClass
  propTypes:
    type:      React.PropTypes.string.isRequired
    content1:  React.PropTypes.node.isRequired
    content2:  React.PropTypes.node.isRequired
    onSave:    React.PropTypes.func
    focusNode: React.PropTypes.func
    popupWidth: React.PropTypes.string

  mixins: [React.addons.LinkedStateMixin]

  getInitialState: () ->
    { inputValue: @props.content2 }

  handleSave: () ->
    @props.onSave( @state.inputValue )

  focusNode: () ->
    @refs.input.getDOMNode()

  render: ->
    content2 =
      `<div className="ui form">
          <div className="field" >
              <input type={this.props.type} ref="input" valueLink={this.linkState('inputValue')}/>
          </div>
          <div className="ui center floated buttons">
              <div className="ui button" onClick={this.handleSave}>保存</div>
          </div>
      </div>`

    `<ContentClickEditablePopup
        content1={this.props.content1}
        content2={content2}
        popupWidth={this.props.popupWidth}
        focusNode={this.focusNode} />`

@ContentClickEditablePopup = React.createClass
  propTypes:
    content1:  React.PropTypes.node.isRequired
    content2:  React.PropTypes.node.isRequired
    focusNode: React.PropTypes.func
    popupWidth: React.PropTypes.string

  componentDidMount: () ->
    $(@refs.content1.getDOMNode()).popup
      popup: $(@refs.content2.getDOMNode())
      on: 'click'
      exclusive: false
      onVisible: () =>
        if @props.focusNode
          $(@props.focusNode()).focus()

  render: ->
    if @props.popupWidth
      style = { 'minWidth' : @props.popupWidth }

    `<div>
        <div ref="content1" title="點擊即可編輯" >
            { this.props.content1 }
        </div>
        <div ref="content2" className="content2 ui hidden transition inline popup" style={ style }>
            { this.props.content2 }
        </div>
    </div>`
