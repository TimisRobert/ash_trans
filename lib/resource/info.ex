defmodule AshTrans.Resource.Info do
  use Spark.InfoGenerator, extension: AshTrans.Resource, sections: [:translations]
end
