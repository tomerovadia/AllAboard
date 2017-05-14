Dir[File.dirname(__FILE__) + "/../app/controllers/*.rb"].each {|file| require_relative file }

class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    # given by user
    @pattern = pattern
    @http_method = http_method

    # used if match
    @controller_class = controller_class
    @action_name = action_name
  end


  # checks if route pattern matches request path and route method matches request method
  def matches?(req)
    req.request_method.downcase == http_method.to_s && req.path =~ pattern
  end



  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    match_data = req.path.match(@pattern) # get wildcard params from url path
    params = {}
    match_data.names.each {|key| params[key] = match_data[key]} # convert match data object to params object

    controller_class.new(req, res, params).invoke_action(action_name)
  end
end






class Router
  attr_reader :routes

  def initialize
    @routes = []
  end


  def add_route(pattern, method, controller_class, action_name)
    @routes.push(Route.new(pattern, method, controller_class, action_name))
  end


  def draw(&proc)
    self.instance_eval(&proc)
  end



  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end




  def match(req)
    routes.each do |route|
      return route if route.matches?(req)
    end

    nil
  end




  # either throw 404 or call run on a matched route
  def run(req, res)
    matched_route = match(req)

    if !matched_route
      res.status = 404
      res.write("No route matched #{req.path}")
    else
      matched_route.run(req, res)
    end

  end


end
