require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
      @app.call(env)
    rescue Exception => e
      render_exception(e)
  end

  private

  def render_exception(e)
    dir_path = File.dirname(__FILE__)
    template_location = "#{dir_path}/templates/rescue.html.erb"
    content = File.read(template_location)

    body = ERB.new(content).result(binding)

    res = Rack::Response.new
    res['Content-Type'] = 'text/html'
    res.write(body)
    res.status = 500
    res.finish
  end

  def find_error_line(e)
    trace_last = e.backtrace.first
  end

end
