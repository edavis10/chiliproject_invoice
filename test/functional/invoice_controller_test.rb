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

    should_assign_to(:p) {@project}
    should_assign_to(:customer) {@customer}
    should_assign_to :date_from
    should_assign_to :date_to
    should_assign_to :activities
    should_assign_to :issues
    should_assign_to :total_time
    should_assign_to :time_entries
    should_assign_to :total

    should_respond_with :success
    should_render_template :autofill
    should_not_set_the_flash
  end
end
