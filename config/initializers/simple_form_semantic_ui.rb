# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.form_class = 'ui error form'
  config.error_notification_class = 'ui error message'
  config.button_class = 'ui green submit button'
  config.boolean_label_class = nil
  config.item_wrapper_tag = :div
  config.item_wrapper_class = :filed

  config.wrappers :semantic_ui_form, tag: 'div', class: 'field', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label

    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'ui red pointing above label error' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'hint' }
  end

  config.wrappers :semantic_ui_file_input, tag: 'div', class: 'field', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'ui red pointing above label error' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'hint' }
  end

  config.wrappers :semantic_ui_icon_input, tag: 'div', class: 'field', error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label
    b.wrapper tag: 'div', class: 'ui left icon input' do |ba|
      ba.use :input
      ba.use :icon
    end
    b.use :error, wrap_with: { tag: 'span', class: 'ui red pointing above label error' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'hint' }
  end

  config.wrappers :semantic_ui_boolean, tag: 'div', class: 'inline field', error_class: 'error' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'ui checkbox' do |ba|
      ba.use :label_input
    end

    b.use :error, wrap_with: { tag: 'span', class: 'ui red pointing above label error' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'hint' }
  end

  config.wrappers :semantic_ui_radio_and_checkboxes, tag: 'div', class: 'grouped fields', error_class: 'error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'ui red pointing above label error' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'hint' }
  end

  config.wrappers :inline_radio_and_checkboxes, tag: 'div', class: 'inline fields', error_class: 'error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'ui red pointing above label error' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'hint' }
  end

  config.wrapper_mappings = {
    boolean: :semantic_ui_boolean,
    radio_buttons: :semantic_ui_radio_and_checkboxes,
    check_boxes: :semantic_ui_radio_and_checkboxes
  }
  config.default_wrapper = :semantic_ui_form
end
