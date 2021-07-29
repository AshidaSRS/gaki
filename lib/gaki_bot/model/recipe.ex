defmodule GakiBot.Model.Recipe do
  use Ecto.Schema

  alias GakiBot.Model.{Recipe}
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "recipes" do
    field(:recipe, :string)

    timestamps()
  end

  @fields [:recipe]
  @required_fields [:recipe]
  def insert_changeset(%{} = recipe_map) do
    IO.inspect(recipe_map)

    %Recipe{}
    |> Changeset.cast(recipe_map, @fields)
    |> Changeset.validate_required(@required_fields)
  end
end
