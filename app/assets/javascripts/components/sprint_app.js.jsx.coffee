@SprintSmallLabel = React.createClass
  propTypes:
    sprint : React.PropTypes.object.isRequired

  render: ->
    sprint = @props.sprint
    `<div className="ui label">
        <i className="icon flag" />
        { sprint.title }
    </div>`