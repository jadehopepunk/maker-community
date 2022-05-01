Sentry.init do |config|
  config.dsn = 'https://b437a430994f41efbbf311dc1228632e@o1227082.ingest.sentry.io/6372738'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 0.5
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
end
