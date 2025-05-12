defmodule AshTrans.Test.Domain do
  use Ash.Domain

  resources do
    resource AshTrans.Test.Author
    resource AshTrans.Test.Post
  end
end
