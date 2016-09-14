require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'
require_relative './flash'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = route_params.merge(@req.params)
    @@protected_from_forgery ||= false
    #TODO -> allow for defining routes as strings like normal Rails
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "Double render!" if already_built_response?

    @res['location'] = url
    @res.status = 302

    session.store_session(@res)
    flash.store_flash(@res)

    @already_built_response = true
    nil
  end

  def render_content(content, content_type)
    raise "Double render!" if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)

    session.store_session(@res)
    flash.store_flash(@res)

    @already_built_response = true
  end

  def render(template_name)
    view_folder = self.class.name.underscore
    dir_path = File.dirname(__FILE__)
    rest_path = "../views/#{view_folder}/#{template_name}.html.erb"
    full_path = [dir_path, rest_path].join("/")
    contents = File.read(full_path)

    template = ERB.new(contents).result(binding)
    render_content(template, "text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  def generate_form_authenticity_token
    @token ||= SecureRandom::urlsafe_base64(16)
  end

  def form_authenticity_token
    generate_form_authenticity_token
    @res.set_cookie('authenticity_token', value: @token, path: "/")
    @token
  end

  def check_authenticity_token
    token = @req.cookies['authenticity_token']
    unless token && token == params['authenticity_token']#@token
      raise "Invalid authenticity token"
    end
  end

  def self.protect_from_forgery
    @@protected_from_forgery = true
  end

  def invoke_action(name)
    if @@protected_from_forgery && @req.request_method != "GET"
      check_authenticity_token
    end

    self.send(name)
    if !already_built_response?
      render(name)
    end
  end
end
