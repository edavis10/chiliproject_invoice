# Mock class to help build forms
class Autofill
  # "Properties"
  attr_accessor :project_id, :date_from, :date_to, :activities, :rate

  # Fake out an AR object
  def errors
    return { }
  end
end
