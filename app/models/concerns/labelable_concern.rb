module LabelableConcern
  extend ActiveSupport::Concern

  included do
    has_many :label_links, as: :target, dependent: :destroy
    has_many :labels, through: :label_links
  end

  class_methods do

    def label_names
      labels.order('title ASC').pluck(:title)
    end

    def remove_labels
      labels.delete_all
    end

    def add_labels_by_names(label_names)
      label_names.each do |label_name|
        label = project.labels.create_with(
            color: Label::DEFAULT_COLOR).find_or_create_by(title: label_name.strip)
        self.labels << label
      end
    end

  end

end