require 'json'

class Session
  def initialize(req)
    if req.cookies['_rails_lite_app']
      @cookie = JSON.parse(req.cookies['_rails_lite_app'])
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    cookie_attrs = { path: "/", value: @cookie.to_json }

    res.set_cookie('_rails_lite_app', cookie_attrs)
  end
end
