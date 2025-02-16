defmodule AshTrans do
  @moduledoc false

  def cldr_backend_provider(config) do
    module = __MODULE__
    backend = config.backend
    info = AshTrans.Resource.Info

    quote location: :keep, bind_quoted: [module: module, backend: backend, info: info] do
      defmodule AshTrans do
        def translate(resource) do
          locale = unquote(backend).get_locale().cldr_locale_name
          unquote(module).translate(resource, locale)
        end

        def translate_field(resource, field) do
          locale = unquote(backend).get_locale().cldr_locale_name
          unquote(module).translate_field(resource, field, locale)
        end

        def locale_names() do
          known_locales = unquote(backend).known_locale_names()
          default_locale = unquote(backend).default_locale().cldr_locale_name
          Enum.reject(known_locales, &(&1 == default_locale))
        end
      end
    end
  end

  def add_forms(%{action: :create} = form, locales) do
    do_add_forms(form, locales)
  end

  def add_forms(form, locales) do
    if form.original_data.translations do
      form
    else
      do_add_forms(form, locales)
    end
  end

  defp do_add_forms(form, locales) do
    form = AshPhoenix.Form.add_form(form, :translations)

    Enum.reduce(locales, form, fn locale, form ->
      AshPhoenix.Form.add_form(form, [:translations, locale])
    end)
  end

  def translate(resource, locale) do
    translations = Map.get(resource.translations || %{}, locale) || %{}

    AshTrans.Resource.Info.translations_fields!(resource)
    |> Enum.reduce(resource, fn field, resource ->
      Map.update!(resource, field, fn original ->
        Map.get(translations, field) || original
      end)
    end)
  end

  def translate_field(resource, field, locale) do
    translations = Map.get(resource.translations || %{}, locale) || %{}
    Map.get(translations, field) || Map.get(resource, field)
  end
end
