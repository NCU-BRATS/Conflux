@AttachmentUploaderSearchInput = React.createClass
  propTypes:
    project: React.PropTypes.object.isRequired
    current_uploader: React.PropTypes.object.isRequired

  handleChange: (value) ->
    inputor = $("input[name='q[user_id_eq]']")
    inputor.val(value)
    inputor.closest('form').submit()


  render: ->
    `<AssociationInput name="q[user_id_eq]" collection={[this.props.current_uploader]} onChange={this.handleChange}
                       data_set={
                {
                    'resource-path' : "/projects/"+ this.props.project.id + "/settings/members",
                    'search-field' : '[ "name", "email" ]',
                    'option-tpl' : 'option-user'
                }
              }
        />`
