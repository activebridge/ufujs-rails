require 'base64'

module Ufujs
  module Rails
    class Decoder
      def initialize(app)
        @app = app
      end

      def call(env)
        decode(env)
        @app.call(env)
      end

      private

      def decode(env)
        request = Rack::Request.new(env)
        request.params.select { |_, v| base64_encoded?(v) }.each do |k, encoded_file|
          description, encoded_bytes = encoded_file.split(",")
          #using description we could get original_filename of encoded file
          break unless encoded_bytes
          break if encoded_bytes.eql?("(null)")
          request.update_param(k, Base64.decode64(encoded_bytes))
        end
      end

      def base64_encoded?(encoded_file)
        encoded_file.present? && encoded_file.is_a?(String) && encoded_file.strip.start_with?("data")
      end
    end
  end
end
