class InvoiceController < ApplicationController
  unloadable
  layout 'base'
  before_filter :authorize_global, :get_settings
  before_filter :find_invoice, :only => [:show, :edit, :update, :destroy]
  before_filter :default_invoice, :only => [:new, :autocreate]
  before_filter :last_invoice_number, :only => [:new, :autocreate, :edit]
  
  helper :invoices
  
  def index
    @open_invoices = Invoice.open
    @late_invoices = Invoice.late
    @closed_invoices = Invoice.closed
  end

  def new
  end

  def autocreate
    @autofill = Autofill.new
  end

  def show
    @payments = @invoice.payments.find(:all, :order => 'applied_on DESC')
    render :layout => 'print' if params[:print]
  end
  
  def edit
  end
  
  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
      flash[:notice] = "Invoice created"
      redirect_to invoice_path(@invoice)
    else
      render :action => 'new'
    end    
      
  end
  
  def update
    if @invoice.update_attributes(params[:invoice])
      flash[:notice] = "Invoice saved"
      redirect_to invoice_path(@invoice)
    else
      render :action => 'edit'
    end    
  end
  
  def destroy
    if @invoice.destroy
      flash[:notice] = "Invoice deleted"
      redirect_to invoice_index_path
    else
      flash[:notice] = "Error"
      redirect_to invoice_index_path
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
    @settings = Setting.plugin_chiliproject_invoice
  end

  def default_invoice
    @invoice = Invoice.default
  end

  def last_invoice_number
    @last_number = Invoice.last_invoice_number
  end

end
