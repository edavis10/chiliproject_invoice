module InvoicesHelper

  def invoice_list_tabs(invoices = { })
    tabs = [{:name => 'open', :label => "label_open_invoices", :items => invoices[:open]},
            {:name => 'late', :label => "label_late_invoices", :items => invoices[:late]},
            {:name => 'closed', :label => "label_closed_invoices", :items => invoices[:closed]}
            ]
  end
  
  def invoice_status(invoice)
    case true
    when invoice.fully_paid?
      return content_tag(:div,
                         content_tag(:p, l(:label_paid_invoice)),
                         :class => "invoice-message fully-paid nonprinting")
    when invoice.late?
      return content_tag(:div,
                         content_tag(:p, l(:label_late_invoices)),
                         :class => "invoice-message late nonprinting")
      
    else
      return content_tag(:div,
                         content_tag(:p, l(:label_open_invoices)),
                         :class => "invoice-message pending nonprinting")
      
    end
  end

  def invoice_menu(invoice=nil, &block)
    menu_items = []
    menu_items << link_to(l(:label_invoice_list), invoice_index_path, :class => 'icon icon-invoice-list') 
    menu_items << link_to(l(:label_new_invoice), new_invoice_path, :class => 'icon icon-invoice-new') 
    menu_items << link_to(l(:label_new_autofilled_invoice), autocreate_invoice_path, :class => 'icon icon-invoice-new') 

    if invoice.nil?
      menu_items << link_to(l(:label_new_payment),  new_payment_path, :class => 'icon icon-payment-new') 
    else 
      menu_items << link_to(l(:label_new_payment), new_invoice_payment_path(invoice), :class => 'icon icon-payment-new') 
    end

    yield menu_items if block_given?

    return content_tag(:div, menu_items.join(' '), :class => "contextual nonprinting", :id => "invoice-menu") +
      content_tag(:div, '', :style => 'clear: both')

  end

  def header_tags
    return stylesheet_link_tag("invoice.css", :plugin => "invoice_plugin", :media => 'all') +
      stylesheet_link_tag("invoice_print.css", :plugin => "invoice_plugin", :media => 'print')
  end
end
