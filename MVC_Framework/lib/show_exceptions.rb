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
    res['Content-type'] = 'text/html'
    res.write(body)
    res.status = "500"
    res.finish
  end

  def find_relevant_code(e)
    trace_last = e.backtrace.first

    error_line = trace_last.split(":")[1].to_i
    file = trace_last.split(":").first

    extract_and_format_relevant_code(file, error_line)
  end

  def extract_and_format_relevant_code(file, error_line)
    line_nos = (error_line - 5..error_line + 5).to_a
    file_code = File.readlines(file)

    relevant_lines = file_code.select.with_index do |ent, idx|
      line_nos.include?(idx)
    end

    relevant_lines = relevant_lines.map.with_index do |line, i|
      if line.lstrip[0..2] == "def"
        relevant_lines[i + 1].insert(0, "&nbsp;")
      end

      if line_nos[i] == error_line
        "#{line_nos[i] + 1}:  #{line} <<-- ERROR "
      else
        "#{line_nos[i] + 1}:  #{line}"
      end
    end

    relevant_lines
  end

  def format_stack_trace(e)
    trace = e.backtrace
  end
end
