class Static#Router
  def initialize(app)
    @root_dir = :public
    @app = app
    @file_server = StaticFileServer.new(@root_dir)
  end

  def call(env)
    p "Calling Static App"
    req = Rack::Request.new(env)

    debugger
    if root_path?(req.path)
      res = @file_server.call(env)
    else
      res = @app.call(env)
    end

    res
  end

  def root_path?(path)
    path.split("/")[1] == @root_dir.to_s
  end
end

class StaticFileServer
  CONTENT_TYPES = {
    '.txt' => 'text/plain',
    '.jpg' => 'image/jpeg',
    '.zip' => 'application/zip'
  }

  def initialize(root)
    @root = root
  end

  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new
    dir_path = File.dirname(__FILE__)
    full_path = "#{dir_path}#{req.path}"

    if is_file?(full_path)
      serve_file(full_path, res)
    else
      res.status = "404"
      res.finish
    end
  end

  def is_file?(path)
    File.exist?(path)
  end

  def serve_file(file_path, res)
    content_type = CONTENT_TYPES[File.extname(file_path)]

    file = File.read(file_path)
    res['Content-type'] = content_type
    res.write(file)
    res.finish
  end
end
