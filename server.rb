require 'rack'
require './all_aboard/router'
require_relative './all_aboard/static'
require_relative './all_aboard/show_exceptions'

router = Router.new

router.draw do
  get Regexp.new("^/vending_machines$"), VendingMachinesController, :show
  delete Regexp.new("^/vending_machines$"), VendingMachinesController, :destroy
  post Regexp.new("^/items$"), ItemsController, :create
  delete Regexp.new("^/items/(?<id>.+)$"), ItemsController, :destroy
end

# Define an object that responds to .call, per Rack requirements
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'

  path = req.get_header('REQUEST_PATH')

  router.run(req, res)

  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  use Static
  run app
end.to_app


Rack::Server.start(
  app: app,
  Port: 3000
)
