require 'base64'
require 'securerandom'

class Array
  def modify_values!(&decode)
    result = []
    self.map do |obj|
      result << if obj.kind_of?(Hash) || obj.kind_of?(Array)
                  obj.modify_values!(&decode)
                else
                  decode.call(obj)
                end
    end
    result
  end
end

class Hash
  def modify_values!(&decode)
    result = {}
    self.map do |k, v|
      result[k] = if v.kind_of?(Hash) || v.kind_of?(Array)
                    v.modify_values!(&decode)
                  else
                    decode.call(v)
                  end
    end
    result
  end
end

module Ufujs
  class Decoder
    def initialize(app)
      @app = app
    end

    def call(env)
      if params = decoded_parameters(env)
        env["action_dispatch.request.request_parameters"] = params
      end
      @app.call(env)
    end

    private

    def base64_encoded?(base64_image)
      base64_image.present? && base64_image.is_a?(String) && base64_image.strip.include?("base64,")
    end

    def parse_image_data(base64_image)
      filename = SecureRandom.hex(32) # FIXME we want the original name
      in_content_type, encoding, string = base64_image.split(/[:;,]/)[1..3]

      tempfile = Tempfile.new(filename)
      tempfile.binmode
      tempfile.write Base64.decode64(string)
      tempfile.rewind
      filename += ".#{in_content_type.split('/').last}"

      ActionDispatch::Http::UploadedFile.new({
        tempfile: tempfile,
        filename: filename
      })
    end

    def decoded_parameters(env)
      request = Rack::Request.new(env)
      decode = Proc.new { |v| base64_encoded?(v) ? parse_image_data(v) : v }
      request.params.modify_values!(&decode)
    end
  end
end
