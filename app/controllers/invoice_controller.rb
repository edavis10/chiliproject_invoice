class InvoiceController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project, :authorize, :get_settings

  helper :invoices
  
  def index
    @open_invoices = Invoice.open
    @late_invoices = Invoice.late
    @closed_invoices = Invoice.closed
  end

  def new
    @invoice = Invoice.default
    @last_number = last_invoice_number
  end

  def autocreate
    @invoice = Invoice.default
    @autofill = Autofill.new
    @last_number = last_invoice_number
  end

  def show
    @invoice = Invoice.find(params[:invoice][:id])
    @payments = @invoice.payments.find(:all, :order => 'applied_on DESC')
    render :layout => 'print' if params[:print]
  end
  
  def edit
    @invoice = Invoice.find(params[:invoice][:id])
    @last_number = last_invoice_number
  end
  
  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
      flash[:notice] = "Invoice created"
      redirect_to :action => "show", :id => params[:id], :invoice => { :id => @invoice }
    else
      render :action => 'new', :id => params[:id]
    end    
      
  end
  
  def update
    @invoice = Invoice.find(params[:invoice][:id])
    if @invoice.update_attributes(params[:invoice])
      flash[:notice] = "Invoice saved"
      redirect_to :action => "show", :id => params[:id], :invoice => { :id => @invoice }
    else
      render :action => 'edit', :id => params[:id], :invoice => { :id => @invoice }
    end    
  end
  
  def destroy
    @invoice = Invoice.find(params[:invoice][:id])
    if @invoice.destroy
      flash[:notice] = "Invoice deleted"
      redirect_to :action => "index", :id => params[:id]
    else
      flash[:notice] = "Error"
      render :action => 'index', :id => params[:id]
    end
  end
  
  def autofill
    # Get project
    @p = Project.find_by_id(params[:autofill][:project_id])
    
    # Get customer
    @customer = Customer.find_by_id(@p.customer_id) # Customer plugin only has a 1-way relationship
    
    # Build date range
    @date_from = params[:autofill][:date_from]
    @date_to = params[:autofill][:date_to]
    
    # Build activities
    @activities =  params[:autofill][:activities].collect {|p| p.to_i }
    
    # Fetch issues
    @issues = @p.issues.find(:all,
                                  :conditions => ['time_entries.spent_on >= :from AND time_entries.spent_on <= :to AND time_entries.activity_id IN (:activities)',
                                                  {
                                                    :from => @date_from,
                                                    :to => @date_to,
                                                    :activities => @activities
                                                  }],
                                  :include => [:time_entries])
    
    @total_time = @issues.collect(&:time_entries).flatten.collect(&:hours).sum
    
    @total = @total_time.to_f * params[:autofill][:rate].to_f

    respond_to do |format|
      format.js
    end
  end
  
  private
  def find_project
    @project = Project.find(params[:id])
  end
  
  def get_settings
    @settings = Setting.plugin_invoice_plugin
  end
  
  def last_invoice_number
    last_invoice = Invoice.find(:first, :order => 'id DESC')
    unless last_invoice.nil?
      last_invoice.invoice_number
    else
      '-'
    end
  end
end
