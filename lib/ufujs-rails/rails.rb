module Ufujs
  class Railtie < Rails::Railtie
    initializer "ufujs.railtie.configure_rails_initialization" do
      insert_middleware
    end

    def insert_middleware
      if defined? ActionDispatch::ParamsParser
        app.middleware.insert_after ActionDispatch::ParamsParser, Ufujs::Decoder
      else
        app.middleware.use Ufujs::Decoder
      end
    end

    def app
      Rails.application
    end
  end
end
