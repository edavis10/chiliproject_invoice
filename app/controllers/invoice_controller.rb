class InvoiceController < ApplicationController
  unloadable
  layout 'base'
  before_filter :find_project, :authorize, :get_settings

  def index
    @invoices = Invoice.find(:all)
  end

  def new
    @invoice = Invoice.new
  end

  def show
    @invoice = Invoice.find(params[:invoice][:id])
  end
  
  def edit
    @invoice = Invoice.find(params[:invoice][:id])
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
  
  private
  def find_project
    @project = Project.find(params[:id])
  end
  
  def get_settings
    @settings = Setting.plugin_invoice_plugin
  end
end

