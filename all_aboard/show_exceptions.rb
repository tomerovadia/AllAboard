require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      app.call(env)
    rescue Exception => e
      return ['500', {'Content-type' => 'text/html'}, [render_exception(e)]]
    end
  end

  private

  def render_exception(e)
    path = File.dirname(__FILE__) + "/templates/rescue.html.erb"
    raw_contents = File.read(path)
    erb_contents = ERB.new(raw_contents)
    html_content = erb_contents.result(binding)
    html_content
  end

end
