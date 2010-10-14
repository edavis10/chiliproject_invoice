# Mock class to help build forms
class Autofill
  # "Properties"
  attr_accessor :project_id
  attr_accessor :date_from
  attr_accessor :date_to
  attr_accessor :activities
  attr_accessor :rate
  attr_accessor :project
  attr_accessor :customer
  attr_accessor :issues
  attr_accessor :total_time
  attr_accessor :time_entries
  attr_accessor :all_time_entries
  attr_accessor :generate_invoice
  attr_accessor :total

  # Fake out an AR object
  def errors
    return { }
  end

  def self.new_from_params(params)
    autofill = Autofill.new
    return autofill if params.blank?
    
    # Get project
    autofill.project = Project.find_by_id(params[:project_id])
    
    # Get customer
    autofill.customer = Customer.find_by_id(autofill.project.customer_id) # Customer plugin only has a 1-way relationship
    
    # Build date range
    autofill.date_from = params[:date_from]
    autofill.date_to = params[:date_to]
    
    # Build activities
    if params[:activities]
      autofill.activities =  params[:activities].collect {|p| p.to_i }
    end
    
    autofill.activities ||= []
    
    # Fetch issues
#    autofill.issues = autofill.project.issues.find(:all,
#                                  :conditions => ['time_entries.spent_on >= :from AND time_entries.spent_on <= :to AND time_entries.activity_id IN (:activities)',
#                                                  {
#                                                    :from => autofill.date_from,
#                                                    :to => autofill.date_to,
#                                                    :activities => autofill.activities
#                                                  }],
#                                  :include => [:time_entries])
    
#    autofill.total_time = autofill.issues.collect(&:time_entries).flatten.collect(&:hours).sum
    
    # Time logged without an issue
#    autofill.time_entries = autofill.project.time_entries.find(:all,
#                                         :conditions => ['issue_id IS NULL AND spent_on >= :from AND spent_on <= :to AND activity_id IN (:activities)',
#                                                  {
#                                                    :from => autofill.date_from,
#                                                    :to => autofill.date_to,
#                                                    :activities => autofill.activities
#                                                  }])
    # Time enteries
    autofill.all_time_entries = autofill.project.time_entries.find(:all,
                                         :conditions => ['spent_on >= :from AND spent_on <= :to AND activity_id IN (:activities)',
                                                  {
                                                    :from => autofill.date_from,
                                                    :to => autofill.date_to,
                                                    :activities => autofill.activities
                                                  }])


    autofill.total_time = 0
    if params[:generate_invoice]
      autofill.generate_invoice = 1
      autofill.time_entries = autofill.project.time_entries.find(params[:time_entries].collect {|p| p.to_i })
      autofill.total_time += autofill.time_entries.collect(&:hours).sum
    end
    
    autofill.total = autofill.total_time.to_f * params[:rate].to_f

    autofill
  end
end
