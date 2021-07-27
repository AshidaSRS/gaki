defmodule GakiBot.Model.User do
  use Ecto.Schema

  alias GakiBot.Model.{User}
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:telegram_id, :integer, null: false)
    field(:first_name, :string)
    field(:username, :string)

    timestamps()
  end

  @fields [:telegram_id, :first_name, :username]
  @required_fields [:telegram_id]
  def insert_changeset(%{} = user_map) do
    %User{}
    |> Changeset.cast(user_map, @fields)
    |> Changeset.validate_required(@required_fields)
  end
end
