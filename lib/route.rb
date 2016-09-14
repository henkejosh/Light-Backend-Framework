
class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    @pattern =~ req.path && @http_method == req.request_method.downcase.to_sym
  end

  def run(req, res)
    regex = Regexp.new @pattern
    match_data = regex.match(req.path)

    route_params = {}
    match_data.names.each do |param|
      route_params[param] = match_data[param]
    end

    controller = @controller_class.new(req, res, route_params)
    controller.invoke_action(@action_name)
    # regex = Regexp.new "/#{@controller_class}/(?<id>\d+)"
  end
end
