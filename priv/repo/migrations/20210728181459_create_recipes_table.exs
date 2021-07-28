defmodule GakiBot.Repo.Migrations.CreateRecipesTable do
  use Ecto.Migration

  def change do
    create table(:recipes, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:uuid, :uuid,  default: fragment("uuid_generate_v4()"), null: false)
      add(:recipe, :string)

      timestamps()
    end
    create(unique_index(:recipes, :uuid))
  end
end
