require 'json'

# _all_aboard => {key1: value2, key2: value2}

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_all_aboard']
      @my_cookie_value = JSON.parse(req.cookies['_all_aboard'])
    else
      @my_cookie_value = {}
    end
  end

  def [](key)
    @my_cookie_value[key]
  end

  def []=(key, val)
    @my_cookie_value[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(:_all_aboard, {path: '/', value: @my_cookie_value.to_json})
  end
end
