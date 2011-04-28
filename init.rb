require 'redmine'

require 'dispatcher'
Dispatcher.to_prepare :chiliproject_invoice do
  # Needed for the compatibility check
  begin
    require_dependency 'time_entry_activity'
  rescue LoadError
    # TimeEntryActivity is not available
  end
end


Redmine::Plugin.register :chiliproject_invoice do
  name 'Invoice'
  author 'Eric Davis'
  description 'Plugin to create and manage invoices'
  version '0.1.0'
  url 'https://projects.littlestreamsoftware.com/projects/chiliproject_invoice'
  author_url 'http://www.littlestreamsoftware.com'

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
  
  permission :show_invoices, { :invoice => [:index, :show]}
  permission :edit_invoices, { :invoice => [:new, :edit, :autocreate, :create, :update, :autofill]}
  permission :delete_invoices, { :invoice => [:destroy]}

  permission :pay_invoices, { :payments => [:new, :create], :invoice => [:outstanding]}
  
  menu :top_menu, "Invoices", {:controller => 'invoice', :action => 'index'}, :if => Proc.new {
    User.current.allowed_to?(:show_invoices, nil, :global => true)
  }
end

begin
  require_dependency 'customer' unless Object.const_defined?('Customer')
rescue LoadError
  # customer_plugin is not installed
  raise Exception.new("ERROR: The Customer plugin is not installed.  Please install the Customer plugin")
end

