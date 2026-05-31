require "active_support/core_ext/integer/time"

# Render varsayilan build'i env'siz assets:precompile calistirir; dummy key gerekir.
BUILD_TIME_SECRET_KEY_BASE = "0000000000000000000000000000000000000000000000000000000000000000"

compiling_assets = ARGV.any? { |arg| arg.start_with?("assets:") }

Rails.application.configure do
  if ENV["SECRET_KEY_BASE"].present?
    config.secret_key_base = ENV["SECRET_KEY_BASE"]
  elsif ENV["SECRET_KEY_BASE_DUMMY"].present? || compiling_assets
    config.secret_key_base = BUILD_TIME_SECRET_KEY_BASE
  end

  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.cache_store = :memory_store
  config.action_controller.default_url_options = { host: ENV.fetch("APP_HOST", "example.com"), protocol: "https" }
  config.active_storage.default_url_options = { host: ENV.fetch("APP_HOST", "example.com"), protocol: "https" }
  config.hosts << ENV["APP_HOST"] if ENV["APP_HOST"].present?
  config.hosts << ENV["RENDER_EXTERNAL_HOSTNAME"] if ENV["RENDER_EXTERNAL_HOSTNAME"].present?
  config.hosts << /.*\.onrender\.com\z/
  config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
  config.force_ssl = true
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }
  config.active_storage.service = :local
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.log_tags = [ :request_id ]
  config.action_mailer.default_url_options = { host: ENV.fetch("APP_HOST", "example.com"), protocol: "https" }
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  # Test deploy: tek web servisi, ayrı worker yok. Canlıda solid_queue + worker ekle.
  config.active_job.queue_adapter = ENV.fetch("ACTIVE_JOB_ADAPTER", "async").to_sym
end
