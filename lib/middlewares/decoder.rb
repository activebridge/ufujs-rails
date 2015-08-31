require 'base64'

class Decoder
  ENCODING_NAME = 'US-ASCII'

  def initialize(app, encoded_parameters = [])
    @app = app
    @encoded_parameters = encoded_parameters
  end

  def call(env)
    decode(env)
    @app.call(env)
  end

  private

  def decode(env)
    request = Rack::Request.new(env)
    # query_hash = env['rack.request.query_hash']
    request.params.select { |k, _| @encoded_parameters.include?(k) }.each do |k, v|
      request.update_param(k, Base64.decode64(v)) if base64_encoded?(v)
    end
  end

  def base64_encoded?(obj)
    obj.encoding.try(:name) == ENCODING_NAME
  end
end
