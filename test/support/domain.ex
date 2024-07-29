defmodule AshTrans.Test.Domain do
  use Ash.Domain

  resources do
    resource AshTrans.Test.Post
  end
end
