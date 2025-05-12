defmodule AshTrans.Test.Author do
  @moduledoc false

  use Ash.Resource,
    domain: AshTrans.Test.Domain,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshTrans.Resource]

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :string, public?: true
  end

  actions do
    defaults [:read, :destroy, update: :*, create: :*]
  end

  translations do
    public? true
    fields [:name]
    locales AshTrans.Test.Cldr.AshTrans.locale_names()
  end
end
