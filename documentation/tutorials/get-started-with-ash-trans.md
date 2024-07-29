# Get Started with AshTrans

## Installation

First, add the dependency to your `mix.exs` file

```elixir
{:ash_trans, "~> 0.1.0"}
```

and add `:ash_trans` to your `.formatter.exs`

```elixir
import_deps: [..., :ash_trans]
```

## Adding to a resource

To add translations to a resource, add the extension to the resource:

```elixir
use Ash.Resource,
  extensions: [..., AshTrans.Resource]

translations do
  # Add public or add :translations to action accept list
  public? true
  # Add the fields you want to translate
  fields [:name, :description]
  # Add the locales, except the default locale
  locales [:it]
end
```

If you are using Cldr, add the provider to your Cldr module:

```elixir
use Cldr,
  providers: [AshTrans],
  locales: ["it", "en"]
```

Then use the provider function for a locale list with the default excluded:

```elixir
translations do
  locales MyApp.Cldr.AshTrans.locale_names()
end
```

To translate a resource, just do this:

```elixir
# If you have Cldr
MyApp.Cldr.AshTrans.translate(resource)
# If you don't have Cldr
AshTrans.translate(resource, locale)
```

You can also translate just a field:

```elixir
# If you have Cldr
MyApp.Cldr.AshTrans.translate_field(resource, field)
# If you don't have Cldr
AshTrans.translate_field(resource, field, locale)
```

## Using with AshPhoenix

To use with AshPhoenix, there is a helper provided to add the required forms:

```elixir
# Or Form.for_create
Form.for_update(activity_price_category, :update,
  # This is necessary, alternatively you can define them manually
  forms: [auto?: true],
  prepare_source: fn changeset ->
    # For the language selection later
    Ash.Changeset.set_argument(changeset, :locale, MyApp.Cldr.get_locale().cldr_locale_name)
  end
)
|> AshTrans.add_forms(locales)
# If you are using Cldr
# |> AshTrans.add_forms(Cldr.AshTrans.locale_names())
```

### Example

```heex
<.input
  type="select"
  label={gettext("Language")}
  field={@form[:locale]}
  options={
    Enum.map(MyApp.Cldr.known_locale_names(), &{MyApp.Cldr.LocaleDisplay.display_name!(&1), &1})
  }
/>

<.input
  class={hide_input?(@form[:locale]) && "hidden"}
  label={gettext("Name")}
  field={@form[:name]}
/>

<.inputs_for :let={translations} field={@form[:translations]}>
  <.inputs_for
    :let={field}
    :for={locale <- MyApp.Cldr.AshTrans.locale_names()}
    field={translations[locale]}
  >
    <.input
      class={hide_translation_input?(@form[:locale], locale) && "hidden"}
      label={gettext("Name")}
      field={field[:name]}
    />
  </.inputs_for>
</.inputs_for>
```

```elixir
defp hide_input?(field) do
  field.value &&
    to_string(field.value) != to_string(MyApp.Cldr.default_locale().cldr_locale_name)
end

defp hide_translation_input?(field, locale) do
  !field.value || to_string(field.value) != to_string(locale)
end
```
