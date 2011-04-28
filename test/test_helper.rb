# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

class Test::Unit::TestCase
  def self.should_be_denied_access_to(route_name, &block)
    should "be deined access to #{route_name}" do
      instance_eval &block
      assert_response :forbidden
      assert_template 'common/error'
    end
  end

  def self.should_be_allowed_access_to(route_name, &block)
    should "be allowed access to #{route_name}" do
      instance_eval &block
      
      assert_response :success
    end
  end
  
end
