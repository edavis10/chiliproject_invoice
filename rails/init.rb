# Empty redmine plguin
require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting Invoice plugin for RedMine'

require 'dispatcher'
Dispatcher.to_prepare :invoice_plugin do
  # Needed for the compatibility check
  begin
    require_dependency 'time_entry_activity'
  rescue LoadError
    # TimeEntryActivity is not available
  end
end


# TODO: Change the name 
Redmine::Plugin.register :invoice_plugin do
  name 'Invoice plugin'
  author 'Eric Davis'
  description 'Redmine plugin to create and manage invoices'
  version '0.0.1'

  settings:default => {
    'invoice_company_name' => 'Your Company Name',
    'invoice_company_address' => '100 Address',
    'invoice_company_email' => 'email@example.com',
    'invoice_company_website' => 'http://www.example.com',
    'invoice_foot_note' => 'Thank you for your business',
    'invoice_currency_symbol' => '$',
    'invoice_payment_terms' => '30',
    'invoice_default_rate' => '50'
  }, :partial => 'settings/invoice_settings'
  
  project_module :invoice_module do
    permission :show_invoices, { :invoice => [:index, :show]}
    permission :edit_invoices, { :invoice => [:new, :edit, :autocreate, :create, :update, :autofill]}
    permission :delete_invoices, { :invoice => [:destroy]}

    permission :pay_invoices, { :payments => [:new, :create], :invoice => [:outstanding]}
    
  end
  
  menu :project_menu, "Invoices", :controller => 'invoice', :action => 'index'
end

begin
  require_dependency 'customer' unless Object.const_defined?('Customer')
rescue LoadError
  # customer_plugin is not installed
  raise Exception.new("ERROR: The Customer plugin is not installed.  Please install the Customer plugin")
end
