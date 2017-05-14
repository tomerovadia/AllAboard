class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  MIME_TYPES = {
    '.txt' => 'text/plain',
    '.jpg' => 'image/jpeg',
    '.zip' => 'application/zip',
    '.css' => 'text/css'
  }

  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new
    path = req.path

    # Check if the path includes /assets/ and thus if a static asset is being accessed
    if path.include?('/assets/')
      dir = File.dirname(__FILE__) # get the current file's path
      file_name = path.match(/assets\/(.*)/)[1] # get the file name fromt he path

      path_of_requested_file = [dir, '..', 'app/assets', file_name].join('/') # find the absolute path using the current file's path

      # Check if the file exists at the path provided
      if File.exist?(path_of_requested_file)
        res["Content-type"] = MIME_TYPES[File.extname(file_name)] # set the header to the appropriate file type
        file = File.read(path_of_requested_file) # obtain the file contents
        res.write(file) # write the file contents into the body
      else
        res.status = 404
        res.write("File not found")
      end

    else # If 'assets' is not in the path, move on
      res = app.call(env)
    end

    res # Return the response

  end

end
