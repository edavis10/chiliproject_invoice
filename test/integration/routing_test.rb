require "#{File.dirname(__FILE__)}/../test_helper"

class RoutingTest < ActionController::IntegrationTest
  context "invoices" do
    should_route :get, "/invoice/index/name", :controller => 'invoice', :action => 'index', :id => 'name'
    should_route :get, "/invoice/new/name", :controller => 'invoice', :action => 'new', :id => 'name'
    should_route :get, "/invoice/autocreate/name", :controller => 'invoice', :action => 'autocreate', :id => 'name'
    should_route :get, "/invoice/show/name", :controller => 'invoice', :action => 'show', :id => 'name'
    should_route :get, "/invoice/edit/name", :controller => 'invoice', :action => 'edit', :id => 'name'
    should_route :get, "/invoice/autofill/name", :controller => 'invoice', :action => 'autofill', :id => 'name'
    should_route :get, "/invoice/outstanding/name", :controller => 'invoice', :action => 'outstanding', :id => 'name'


    should_route :post, "/invoice/create/name", :controller => 'invoice', :action => 'create', :id => 'name'
    should_route :post, "/invoice/update/name", :controller => 'invoice', :action => 'update', :id => 'name'
    should_route :post, "/invoice/destroy/name", :controller => 'invoice', :action => 'destroy', :id => 'name'
  end

end
