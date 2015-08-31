module Ufujs
  module Rails
    class Railtie < Rails::Railtie
      initializer "ufujs-rails.configure_rails_initialization" do
        insert_middleware
      end

      def insert_middleware
        if defined? ActionDispatch::ParamsParser
          app.middleware.insert_before ActionDispatch::ParamsParser, Ufujs::Rails::Decoder
        else
          app.middleware.use Ufujs::Rails::Decoder
        end
      end

      def app
        Rails.application
      end
    end
  end
end
