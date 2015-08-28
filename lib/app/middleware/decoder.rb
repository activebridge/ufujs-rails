require "base64"

class Decoder
  def initialize app
    @app = app
  end

  def call env
    decode(env)
    @app.call(env, 'image')
  end

  private

  def decode env
    request = Rack::Request.new(env, input_name)
    (request.params & @app.config.encoded_parameters).each do |param_name|
      if dd?
        request.update_param(param_name, Base64.decode64(request.params[param_name]))
      end
    end
  end

  def dd?()
    true
  end
end
