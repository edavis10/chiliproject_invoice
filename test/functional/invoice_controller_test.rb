require File.dirname(__FILE__) + '/../test_helper'

class InvoiceControllerTest < ActionController::TestCase
  context "on GET to autofill.js" do
    setup do
      @user = User.generate_with_protected!(:admin => true)
      @request.session[:user_id] = @user.id

      @customer = Customer.create!(:name => 'customer')
      @project = Project.generate!(:customer_id => @customer.id)

      get :autofill, :format => 'js', :autofill => {
        :project_id => @project.id,
        :date_from => '2010-01-01',
        :date_to => '2010-02-01'
      },
      :id => @project.id
    end

    should_assign_to :autofill

    should_respond_with :success
    should_render_template :autofill
    should_not_set_the_flash
  end
end
