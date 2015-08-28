require 'base64'

class Decoder
  ENCODING_NAME = 'US-ASCII'

  def initialize app
    @app = app
  end

  def call env
    decode(env)
    @app.call(env)
  end

  private

  def decode env
    request = Rack::Request.new(env)
    (request.params & @app.config.encoded_parameters).each do |param_name|
      if base64_encoded? request.params[param_name]
        request.update_param(param_name, Base64.decode64(request.params[param_name]))
      end
    end
  end

  def base64_encoded?(obj)
    obj.encoding.try(:name) == ENCODING_NAME
  end
end
