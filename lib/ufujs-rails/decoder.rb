require 'base64'

class Hash
  def decode_base64_values
    result = {}
    self.map do |k, v|
      result[k] = v.kind_of?(Hash) ? v.decode_base64_values : v
      result[k] = v.map { |obj| obj.decode_base64_values if obj.kind_of?(Hash) } if v.kind_of?(Array)
      result[k] = parse_image_data(result[k]) if base64_encoded?(result[k])
    end
    result
  end

  private

  def base64_encoded?(base64_image)
    base64_image.present? && base64_image.is_a?(String) && base64_image.strip.include?("base64,")
  end

  def parse_image_data(base64_image)
    filename = "upload-image" # FIXME we want the original name
    in_content_type, encoding, string = base64_image.split(/[:;,]/)[1..3]

    tempfile = Tempfile.new(filename)
    tempfile.binmode
    tempfile.write Base64.decode64(string)
    tempfile.rewind

    content_type = `file --mime -b #{tempfile.path}`.split(";")[0]

    extension = content_type.match(/gif|jpeg|png/).to_s
    filename += ".#{extension}" if extension

    ActionDispatch::Http::UploadedFile.new({
      tempfile: tempfile,
      content_type: content_type,
      filename: filename
    })
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

    def decoded_parameters(env)
      request = Rack::Request.new(env)
      request.params.decode_base64_values
    end
  end
end
