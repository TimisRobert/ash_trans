import Config

config :ex_cldr,
  default_locale: "en",
  default_backend: AshTrans.Test.Cldr,
  json_library: Jason

config :ash_trans, ash_domains: [AshTrans.Test.Domain]

config :logger, level: :warning
