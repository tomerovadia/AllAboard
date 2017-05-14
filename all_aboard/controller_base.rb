require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'
require 'active_support/inflector'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params, :already_built_response, :session, :flash

  # Set up the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = req.params.merge(params) # merge path params with other params coming from the request
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise 'Double render error' if @already_built_response
    @already_built_response = true
    @res.status = 303
    @res.set_header('Location', url)

    session.store_session(@res)
    flash.store_flash(@res)
  end

  # Populates the response with content.
  # Sets the response's content type to the given type.
  # Raises an error if the developer tries to double render.
  def render_content(content, content_type)
    raise 'Double render error' if @already_built_response
    @already_built_response = true
    @res.write(content)
    @res.set_header('Content-Type', content_type)
    session.store_session(@res) # could also be in #render
    flash.store_flash(@res) # could also be in #render
  end


  # Uses ERB and binding to evaluate templates
  # Passes the rendered html to render_content
  def render(template_name)
    controller_name = self.class.to_s.underscore
    path = File.dirname(__FILE__) + "/../app/views/#{controller_name}/#{template_name}.html.erb"
    raw_contents = File.read(path)
    erb_contents = ERB.new(raw_contents)
    html_content = erb_contents.result(binding)
    render_content(html_content, 'text/html')
  end


  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end


  def flash
    @flash ||= Flash.new(@req)
  end

  # Used with router to call name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name) if self.class.method_defined?(name)

    unless(@already_built_response)
      render(name.to_s)
    end
  end
end
