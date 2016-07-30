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

    error_line = trace_last.split(":")[1].to_i
    file = trace_last.split(":").first
    debugger

    format_code_lines(file, error_line)
  end

  def format_code_lines(file, error_line)
    lines = (error_line - 5..error_line + 5).to_a
    file_code = File.readlines(file)

    relevant_lines = file_code.select.with_index do
      |ent, idx| lines.include?(idx)
    end
  end

end
