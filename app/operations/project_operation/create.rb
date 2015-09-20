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
      PostOperation::Create.new(@current_user, @model).process(new_param({post: post}))
      labels.each do |label|
        LabelOperation::Create.new(@current_user, @model).process(new_param({label: label}))
      end
      roles.each do |role|
        ProjectRoleOperation::Create.new(@current_user, @model).process(new_param({project_role: role}))
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

    def roles
      [
        {name: '工程師'},
        {name: '前端工程師'},
        {name: '後端工程師'},
        {name: 'UX 設計師'},
        {name: '測試員'},
        {name: '架構師'},
        {name: '領導者'},
        {name: '管理者'},
        {name: '客戶'},
      ]
    end

    def post
      {
        name: '檔案頁面使用說明',
        content: "# 歡迎來到檔案頁面!\n此為檔案頁面的使用說明，您可以：\n* 從右側欄進行檔案的 搜尋、篩選、新增\n* 檔案上傳支援圖片預覽\n* 貼文支援 markdown\n* 程式碼片段支援語法高亮\n\n祝您工作愉快！"
      }
    end
  end
end
