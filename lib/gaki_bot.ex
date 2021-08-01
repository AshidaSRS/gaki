defmodule GakiBot do
  alias GakiBot.Store.RecipeStore
  alias GakiBot.Utils
  alias GakiBot.Steps

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

  def process_message(msg, user_id) do
    apply_next_step(nil, msg, true, user_id)
  end

  def apply_next_step(uuid, msg, show_msg_buttons, user_id) do
    IO.inspect(uuid)
    IO.inspect(msg)
    IO.inspect(show_msg_buttons)
    IO.inspect(user_id)

    case GakiBot.Steps.get_step(uuid) do
      {:ok, _list, _description, _tips, _tags, step} ->
        IO.inspect(step)
        apply_step(step, uuid, msg)

      {:error, :not_found} ->
        case Steps.get_step_by_user_id(user_id) do
          {:ok, key} ->
            IO.inspect("ok")
            apply_next_step(key, msg, user_id, show_msg_buttons)

          {:error, :not_found} ->
            IO.inspect("ko")
            {"Not able to find a started step", parse_mode: "Markdown"}
        end
    end
  end

  def help_message do
    text = "Please add the list of ingredients followed by a dot"
    {text, parse_mode: "Markdown"}
  end

  def show_buttons(uuid, msg, show_msg_buttons) do
    case show_msg_buttons do
      true ->
        keyboard = Utils.generate_step_buttons(uuid, false)
        {msg, [reply_markup: keyboard]}

      false ->
        help_message()
    end
  end

  def apply_step(:start, user_id) do
    case Steps.get_step_by_user_id(user_id) do
      {:ok, _key} ->
        help_message()

      {:error, :not_found} ->
        GakiBot.Steps.add_step(:add_list, user_id, nil, nil)
    end

    help_message()
  end

  def apply_step(:add_list, uuid, text, show_msg_buttons) do
    IO.inspect(uuid)
    IO.inspect(:add_list)
    GakiBot.Steps.add_step(:add_list, nil, uuid, text)
    show_buttons(uuid, text, show_msg_buttons)
  end

  def apply_step(:add_description, uuid, text, show_msg_buttons) do
    uuid = GakiBot.Steps.add_step(:add_description, nil, uuid, text)
    show_buttons(uuid, text, show_msg_buttons)
  end

  def apply_step(:add_tips, uuid, text, show_msg_buttons) do
    uuid = GakiBot.Steps.add_step(:add_tips, nil, uuid, text)
    show_buttons(uuid, text, show_msg_buttons)
  end

  def apply_step(:add_tags, uuid, text) do
    GakiBot.Steps.add_step(:add_tags, nil, uuid, text)
    GakiBot.Steps.add_step(:end, nil, uuid, nil)
    {"Finished", parse_mode: "Markdown"}
  end

  def add_recipe_steps do
    text = """
    ▪ *Add a list of ingredients separated by points.*
      _Ex. 500 gr. greek yogurt. 290 gr. condensed milk. 3 lemons (big)._

    ▪ *Add a description explaining how to cook it. Small please.*
      _Ex. For 6 ppl. Squeeze the lemons to get the juice. Mix together the yogurt and the milk. One you have done that, mix with the juice. Put in the fridge and enjoy._

    ▪ *(Optional) Add sentence hints separated by commas.*
      _Mix the milk and the yogurt slowly to avoid air. Same with thee juice, slowly._

    ▪ *Add tags to be able to find the recipe.*
      _Mousee. Lemon. Yogurt. Dessert. Summer._
    """

    keyboard = Utils.generate_start_buttons()
    {text, [reply_markup: keyboard]}
  end
end
