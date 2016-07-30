require 'json'

class Flash
  attr_writer :cycle, :now_cycle

  attr_reader :now

  def initialize(req)
    cookie = req.cookies['_rails_lite_app_flash']
    message = cookie ? JSON.parse(cookie) : {}

    @data = FlashStore.new
    @now = FlashStore.new(message)
    @cycle = 0
    @now_cycle = 0
  end

  def store_flash(res)
    cookie_attrs = { path: "/", value: @data.to_json }
    res.set_cookie('_rails_lite_app_flash', cookie_attrs)
  end

  # def track_cycle
  #   debugger
  #   check_and_reset_flash!
  #
  #   @cycle += 1 unless @data.empty?
  #   @now_cycle += 1 if now?
  # end
  #
  # def check_and_reset_flash!
  #   if @cycle >= 2
  #     @data = {}
  #     @cycle = 0
  #   end
  #
  #   if @now_cycle >= 1
  #     @now_cycle = 0
  #     @now = {}
  #   end
  # end
  #
  # def now?
  #   @now && !@now.empty?
  # end

  def [](key)
    @data[key] || @now[key]
  end

  def []=(key, value)
    @data[key] = value
  end
end

class FlashStore
  def initialize(options = {})
    @store = options
  end

  def [](key)
    val = @store[key.to_s]

    if val.is_a?(String) && val.start_with?("---symbol---")
      return val.slice(7, val.length).to_sym
    end

    val
  end

  def empty?
    @store.empty?
  end

  def []=(key, val)
   val = "---symbol---" + val.to_s if val.is_a?(Symbol)
   @store[key.to_s] = val
 end

  def to_json
    @store.to_json
  end
end
