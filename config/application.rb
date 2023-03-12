# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Attn8
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = 'Asia/Tokyo'
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # factory_botファイルを自動生成する際のファイル生成先の指定
    # "rails g factory_bot:model xxxxx"
    config.generators do |g|
      # Railsジェネレータがfactory_bot用のファイルを生成するのを無効化
      g.factory_bot false
      # factory_botファイルの生成先をspec/factoriesに変更
      g.factory_bot dir: 'spec/factories'
    end
  end
end
