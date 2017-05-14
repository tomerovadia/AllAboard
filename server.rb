require 'rack'
# require './all_aboard/router'
require_relative './all_aboard/static'
require_relative './all_aboard/show_exceptions'
require './config/routes'

include AppRouter

# Defines an object that responds to .call, per Rack requirements
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new

  router = AppRouter.draw_router
  router.run(req, res)

  res.finish
end

# Adds middleware for handling expcetions and static assets
app = Rack::Builder.new do
  use ShowExceptions
  use Static
  run app
end.to_app


Rack::Server.start(
  app: app,
  Port: 3000
)
