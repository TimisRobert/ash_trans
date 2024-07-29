defmodule AshTrans.Test do
  use ExUnit.Case

  test "default locale" do
    post =
      Ash.Changeset.for_create(AshTrans.Test.Post, :create, %{
        title: "Title",
        body: "Body",
        translations: %{
          it: %{
            title: "Titolo",
            body: "Corpo"
          }
        }
      })
      |> Ash.create!()

    assert %{title: "Title", body: "Body"} = AshTrans.Test.Cldr.AshTrans.translate(post)
  end

  test "handle missing translations by falling back to default locale" do
    {:ok, _} = Cldr.put_locale(:it)

    post =
      Ash.Changeset.for_create(AshTrans.Test.Post, :create, %{
        title: "Title",
        body: "Body"
      })
      |> Ash.create!()

    assert %{title: "Title", body: "Body"} = AshTrans.Test.Cldr.AshTrans.translate(post)
  end

  test "handle missing locale translations by falling back to default locale" do
    {:ok, _} = Cldr.put_locale(:de)

    post =
      Ash.Changeset.for_create(AshTrans.Test.Post, :create, %{
        title: "Title",
        body: "Body",
        translations: %{
          it: %{
            title: "Titolo",
            body: "Corpo"
          }
        }
      })
      |> Ash.create!()

    assert %{title: "Title", body: "Body"} = AshTrans.Test.Cldr.AshTrans.translate(post)
  end

  test "handle missing field translations by falling back to default locale" do
    {:ok, _} = Cldr.put_locale(:it)

    post =
      Ash.Changeset.for_create(AshTrans.Test.Post, :create, %{
        title: "Title",
        body: "Body",
        translations: %{
          it: %{
            body: "Corpo"
          }
        }
      })
      |> Ash.create!()

    assert %{title: "Title", body: "Corpo"} = AshTrans.Test.Cldr.AshTrans.translate(post)
  end
end
