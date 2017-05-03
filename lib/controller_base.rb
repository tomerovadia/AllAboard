require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params, :already_built_response, :session

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = req.params.merge(params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise 'Double render error' if @already_built_response
    @already_built_response = true
    @res.status = 302
    @res.set_header('Location', url)

    session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise 'Double render error' if @already_built_response
    @already_built_response = true
    @res.write(content)
    @res.set_header('Content-Type', content_type)
    session.store_session(@res) # could also be in #render
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.underscore
    path = "views/#{controller_name}/#{template_name}.html.erb"
    raw_contents = File.read(path)
    erb_contents = ERB.new(raw_contents)
    html_content = erb_contents.result(binding)
    render_content(html_content, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)

    unless(@already_built_response)
      render(name.to_s)
    end
  end
end
