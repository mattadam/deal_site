require 'test_helper'
require 'rails/performance_test_help'

class BrowsingTest < ActionController::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory, :objects, :gc_runs, :gc_time],
                           :output => 'tmp/performance', :formats => [:flat] }

  def test_homepage
    get '/'
  end

  def test_deals_index
    get '/deals'
  end
end
