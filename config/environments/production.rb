Moneko::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  # config.action_dispatch.rack_cache = true
  config.serve_static_assets = false
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx
  # config.force_ssl = true
  config.log_level = :info
  # config.log_tags = [ :subdomain, :uuid ]
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
  # config.cache_store = :mem_cache_store
  # config.action_controller.asset_host = "http://assets.example.com"
  # config.assets.precompile += %w( search.js )
  # config.action_mailer.raise_delivery_errors = false
  
  config.action_mailer.default_url_options = { :host => "176.9.169.237" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_meiler.default :charset => "utf-8"
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  # config.autoflush_log = false
  config.log_formatter = ::Logger::Formatter.new
end
