# Empty redmine plguin
require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting Invoice plugin for RedMine'

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
    'invoice_payment_terms' => '30'
  }, :partial => 'settings/settings'
  
  project_module :invoice_module do
    permission :show_invoices, { :invoice => [:index, :show]}
    permission :edit_invoices, { :invoice => [:new, :edit, :autocreate, :create, :update, :autofill]}
    permission :delete_invoices, { :invoice => [:destroy]}
  end
  
  menu :project_menu, "Invoices", :controller => 'invoice', :action => 'index'
end
