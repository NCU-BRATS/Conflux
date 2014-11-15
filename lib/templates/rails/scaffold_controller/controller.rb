<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  respond_to :html, :json, :js

  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  def index
    @<%= plural_table_name %> = <%= class_name %>.search(params[:q]).result.page(params[:page]).per(params[:per])
    respond_with @<%= plural_table_name %>
  end

  def show
    respond_with @<%= singular_table_name %>
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    respond_with @<%= singular_table_name %>
  end

  def edit
    respond_with @<%= singular_table_name %>
  end

  def create
    @<%= singular_table_name %> = <%= class_name %>.create(<%= "#{singular_table_name}_params" %>)
    respond_with @<%= singular_table_name %>
  end

  def update
    @<%= singular_table_name %>.update_attributes(<%= "#{singular_table_name}_params" %>)
    respond_with @<%= singular_table_name %>
  end

  def destroy
    respond_with @<%= orm_instance.destroy %>
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
