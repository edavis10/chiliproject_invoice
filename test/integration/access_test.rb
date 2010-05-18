require "#{File.dirname(__FILE__)}/../test_helper"

class AccessTest < ActionController::IntegrationTest
  def setup
    super
    @user = User.generate_with_protected!(:login => 'user', :password => 'password', :password_confirmation => 'password')
    log_user('user', 'password')

    @project = Project.generate!
    @role = Role.generate!(:permissions => [:view_issues])
    @member = Member.generate!(:principal => @user, :project => @project, :roles => [@role])
    @customer = Customer.create!(:name => 'customer')
    @invoice = Invoice.generate!(:customer => @customer)
  end

  def add_permission_to_role(permission)
    @role.permissions << permission
    @role.save!
  end
  
  context "as a user without :show_invoices permission" do
    should_be_denied_access_to("/invoices/index") { get "/invoice" }
    should_be_denied_access_to("/invoices/show") { get "/invoice/show" }
  end

  context "as a user with :show_invoices permission" do
    setup do
      add_permission_to_role(:show_invoices)
    end

    should_be_allowed_access_to("/invoices/index") { get "/invoice" }
    should_be_allowed_access_to("/invoices/show") { get "/invoice/#{@invoice.id}" }
  end

  context "as a user without :edit_invoices permission" do
    should_be_denied_access_to("/invoices/new") { get "/invoice/new" }
    should_be_denied_access_to("/invoices/edit") { get "/invoice/#{@invoice.id}/edit" }
    should_be_denied_access_to("/invoices/autocreate") { get "/invoice/autocreate" }
    should_be_denied_access_to("/invoices/autofill") { get "/invoice/autofill" }
    should_be_denied_access_to("/invoices/create") { post "/invoice/create" }
    should_be_denied_access_to("/invoices/update") { put "/invoice/#{@invoice.id}" }
  end

  context "as a user with :edit_invoices permission" do
    setup do
      add_permission_to_role(:show_invoices)
      add_permission_to_role(:edit_invoices)
    end

    should_be_allowed_access_to("/invoices/new") { get "/invoice/new" }
    should_be_allowed_access_to("/invoices/edit") { get "/invoice/#{@invoice.id}/edit" }
    should_be_allowed_access_to("/invoices/autocreate") { get "/invoice/autocreate" }
    should_be_allowed_access_to("/invoices/autofill") { get "/invoice/autofill" }
    should_be_allowed_access_to("/invoices/create") { post "/invoice/create" }
    should_be_allowed_access_to("/invoices/update") { put_via_redirect "/invoice/#{@invoice.id}" }
  end  

  context "as a user without :delete_invoices permission" do
    should_be_denied_access_to("/invoices/destroy") { delete "/invoice/#{@invoice.id}" }
  end

  context "as a user with :delete_invoices permission" do
    setup do
      add_permission_to_role(:show_invoices)
      add_permission_to_role(:delete_invoices)
    end
    
    should_be_allowed_access_to("/invoices/destroy") { delete_via_redirect "/invoice/#{@invoice.id}" }
  end

  context "as a user without :pay_invoices permission" do
    should_be_denied_access_to("/payments/new") { get "/payments/new" }
    should_be_denied_access_to("/payments/create") { post "/payments/create" }
    should_be_denied_access_to("/invoices/outstanding") { get "/invoice/#{@invoice.id}/outstanding" }
  end

  context "as a user with :pay_invoices permission" do
    setup do
      add_permission_to_role(:pay_invoices)
    end
    
    should_be_allowed_access_to("/payments/new") { get "/payments/new" }
    should_be_allowed_access_to("/payments/create") { post "/payments/create" }
    should_be_allowed_access_to("/invoices/outstanding") { get "/invoice/#{@invoice.id}/outstanding" }
  end
end
