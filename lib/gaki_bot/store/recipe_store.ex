defmodule GakiBot.Store.RecipeStore do
  import GakiBot.Store
  alias GakiBot.Repo
  alias GakiBot.Model.Recipe

  def find_recipe(opts \\ []) do
    Recipe
    |> maybe_where_telegram_id(opts[:telegram_id])
    |> maybe_preload(opts[:preload])
    |> Repo.one()
  end

  def find_recipes(opts \\ []) do
    Recipe
    |> maybe_limit(opts[:limit])
    |> maybe_preload(opts[:preload])
    |> maybe_order_by(opts[:order_by])
    |> Repo.all()
  end

  def insert_recipe(recipe_params) do
    recipe_params
    |> Map.new()
    |> Recipe.insert_changeset()
    |> Repo.insert()
  end

  def count_recipes() do
    Repo.aggregate(Recipe, :count, :id)
  end
end
