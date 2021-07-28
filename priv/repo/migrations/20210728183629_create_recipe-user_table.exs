defmodule :"Elixir.GakiBot.Repo.Migrations.CreateRecipe-userTable" do
  use Ecto.Migration

  def change do
    create table(:recipes_users_relation, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, :bigint, null: false)
      add(:recipe_id, :bigint, null: false)

      timestamps()
    end
    create(unique_index(:recipes_users_relation, [:user_id, :recipe_id]))
  end
end
