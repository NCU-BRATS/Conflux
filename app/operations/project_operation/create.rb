module ProjectOperation
  class Create < BaseForm

    def initialize(current_user)
      @current_user = current_user
      super(Project.new)
    end

    def process(params)
      if validate(project_params(params)) && sync
        @model.members << @current_user
        if @model.save
          generate_default_data
        end
      end
    end

    def generate_default_data
      SprintOperation::Create.new(@current_user, @model).process(new_param({sprint: {title: '預設'}}))
      ChannelOperation::Create.new(@current_user, @model).process(new_param({channel: {name: '大廳'}}))
      labels.each do |label|
        LabelOperation::Create.new(@current_user, @model).process(new_param({label: label}))
      end
    end

    private

    def new_param(param = {})
      ActionController::Parameters.new(param)
    end

    def labels
      [
        {title: 'Bug', color: '#D9534F'},
        {title: '優化', color: '#428BCA'},
        {title: '修改', color: '#F0AD4E'},
        {title: '功能', color: '#5CB85C'},
        {title: '問題', color: '#7F8C8D'},
        {title: '重複', color: '#FFECDB'},
        {title: '需要幫助', color: '#8E44AD'},
      ]
    end
  end
end
