module SimpleForm
  module Components

    module Icons
      def icon
        icon_class unless options[:icon].nil?
      end

      def icon_class
        template.content_tag(:i, '', class: options[:icon])
      end
    end

    module ActionLabels
      def action_label
        action_label_class unless options[:action_label].nil?
      end
      def action_label_class
        template.content_tag(:div, options[:action_label], class: 'ui label' )
      end
    end

  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Icons)
SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::ActionLabels)