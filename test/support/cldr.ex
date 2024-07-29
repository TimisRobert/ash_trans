defmodule AshTrans.Test.Cldr do
  use Cldr,
    providers: [AshTrans],
    locales: ["it", "en", "de"]
end
