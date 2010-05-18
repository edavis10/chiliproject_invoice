class InvoiceController < ApplicationController
  unloadable
  layout 'base'
  before_filter :authorize_global, :get_settings
  before_filter :find_invoice, :only => [:show, :edit, :update, :destroy]

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
    @payments = @invoice.payments.find(:all, :order => 'applied_on DESC')
    render :layout => 'print' if params[:print]
  end
  
  def edit
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
    if @invoice.update_attributes(params[:invoice])
      flash[:notice] = "Invoice saved"
      redirect_to :action => "show", :id => params[:id], :invoice => { :id => @invoice }
    else
      render :action => 'edit', :id => params[:id], :invoice => { :id => @invoice }
    end    
  end
  
  def destroy
    if @invoice.destroy
      flash[:notice] = "Invoice deleted"
      redirect_to :action => "index", :id => params[:id]
    else
      flash[:notice] = "Error"
      render :action => 'index', :id => params[:id]
    end
  end
  
  def autofill
    @autofill = Autofill.new_from_params(params[:autofill])

    respond_to do |format|
      format.js
    end
  end
  
  def outstanding
    @invoice = Invoice.find_by_id(params[:invoice_id])
    @invoice ||= Invoice.find_by_id(params[:id])
    render :text => @invoice.outstanding
  end

  private
  def find_invoice
    @invoice = Invoice.find(params[:invoice][:id]) if params[:invoice]
    @invoice ||= Invoice.find(params[:id])
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
