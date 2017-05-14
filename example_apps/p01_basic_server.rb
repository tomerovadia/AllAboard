require 'rack'

# Define an object that response to .call, per Rack requirements
app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'

  path = req.get_header('REQUEST_PATH')
  res.write(path)

  # or without going through the req.get_header method:
  # res.write(env['REQUEST_PATH'])

  res.finish
end

# Start a server that uses our app
Rack::Server.start(
  app: app,
  Port: 3000
)
