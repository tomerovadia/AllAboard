require 'rack'
require_relative '../../all_aboard/controller_base'
Dir[File.dirname(__FILE__) + "/../models/*.rb"].each { |file| require_relative file }

class MyController < ControllerBase

end
