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
                         content_tag(:p, "Invoice Paid"),
                         :class => "invoice-message fully-paid nonprinting")
    when invoice.late?
      return content_tag(:div,
                         content_tag(:p, "Invoice Late"),
                         :class => "invoice-message late nonprinting")
      
    else
      return content_tag(:div,
                         content_tag(:p, "Pending"),
                         :class => "invoice-message pending nonprinting")
      
    end
  end
end
