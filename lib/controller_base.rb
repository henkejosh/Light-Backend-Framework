require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = route_params.merge(@req.params)
    #TODO -> allow for defining routes as strings like normal Rails
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

    session.store_session(@res)
    @already_built_response = true
    nil
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Double render!" if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    session.store_session(@res)
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

    template = ERB.new(contents).result(binding)
    render_content(template, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    if !already_built_response?
      render(name)
    end
  end
end
