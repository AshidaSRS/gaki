defmodule :"Elixir.GakiBot.Repo.Migrations.CreateRecipe-tagTable" do
  use Ecto.Migration

  def change do
    create table(:recipes_tags_relation, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:recipe_id, :bigint, null: false)
      add(:tag_id, :bigint, null: false)

      timestamps()
    end
    create(unique_index(:recipes_tags_relation, [:recipe_id, :tag_id]))
  end
end
