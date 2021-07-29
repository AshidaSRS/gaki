defmodule GakiBot do
  alias GakiBot.Store.RecipeStore

  def about_command do
    text = """
    __Cosas publicas__
    Cosas publicas
    """

    {text, parse_mode: "Markdown"}
  end

  def create_recipe(recipe) do
    Map.new()
    |> Map.put(:recipe, recipe)
    |> RecipeStore.insert_recipe()

    {"Recipe in", parse_mode: "Markdown"}
  end
end
