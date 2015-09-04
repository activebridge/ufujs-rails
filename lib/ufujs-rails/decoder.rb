require 'base64'
require 'securerandom'

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
      filename = SecureRandom.hex(32)
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

    def modify_values(obj, &decode)
      result = obj.class.new
      if obj.kind_of?(Hash)
        obj.map do |k, v|
          result[k] = if v.kind_of?(Hash) || v.kind_of?(Array)
                        modify_values(v, &decode)
                      else
                        decode.call(v)
                      end
        end
      else
        obj.map do |v|
          result << if v.kind_of?(Hash) || v.kind_of?(Array)
                      modify_values(v, &decode)
                    else
                      decode.call(v)
                    end
        end
      end
      result
    end

    def decoded_parameters(env)
      request = Rack::Request.new(env)
      decode = Proc.new { |v| base64_encoded?(v) ? parse_image_data(v) : v }
      modify_values(request.params, &decode)
    end
  end
end
