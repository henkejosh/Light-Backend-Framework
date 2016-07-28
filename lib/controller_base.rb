require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Double render!" if already_built_response?
    @res['location'] = url
    @res.status = 302
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Double render!" if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    # TODO uncomment line 44 so that the view path actually works!!
    # view_folder = self.class.name.underscore.chomp("_controller")
    view_folder = self.class.name.underscore
    dir_path = File.dirname(__FILE__)
    rest_path = "../views/#{view_folder}/#{template_name}.html.erb"
    full_path = [dir_path, rest_path].join("/")
    contents = File.read(full_path)

  #  debugger
    # template_code = File.read(template_fname)
    template = ERB.new(contents).result(binding)
    render_content(template, "text/html")
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
