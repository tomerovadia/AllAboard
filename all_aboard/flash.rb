require 'json'

class Flash

  attr_accessor :now

  def initialize(req)
    # stores three different flashes with three different persistences
    # now: never sent back to the user (not really a cookie)
    # old_flash: read-only flash data sent with request from user browser
    # new_flash: ready/write flash data added this session and to be sent back to user

    @now = {}
    @new_flash = {}

    @old_flash = {}
    if req.cookies['_all_aboard_flash']
      @old_flash = JSON.parse(req.cookies['_all_aboard_flash'])
    end
  end


  def [](key)
    @now[key.to_s] || @old_flash[key.to_s] || @new_flash[key.to_s]
  end


  def []=(key, val)
    @new_flash[key] = val
  end

  # store the flash as cookie in preparation for shipping back to user
  def store_flash(res)
    # res.delete_cookie(:_all_aboard_flash)
    res.set_cookie(:_all_aboard_flash, {path: '/', value: @new_flash.to_json})
  end

end
