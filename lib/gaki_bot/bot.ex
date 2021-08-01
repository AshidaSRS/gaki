defmodule GakiBot.Bot do
  @bot :gaki_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Print the bot's help")
  command("add")
  command("recipe_test")

  middleware(ExGram.Middleware.IgnoreUsername)
  middleware(GakiBot.Middlewares.RegisterUser)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    {message, opts} = GakiBot.about_command()
    answer(context, message, opts)
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Here is your help: ")
  end

  def handle({:command, :add, _msg}, context) do
    {message, opts} = GakiBot.add_recipe_steps()
    answer(context, message, opts)
  end

  def handle({:command, :recipe_test, %{text: message}}, context) do
    GakiBot.create_recipe(message)
    answer(context, message)
  end

  def handle({:text, text, %{from: %{id: user_id}}}, context) do
    {message, opts} = GakiBot.process_message(text, user_id)
    answer(context, message, opts)
  end

  def handle({:callback_query, %{data: "start", from: %{id: user_id}}}, context) do
    {message, opts} = GakiBot.apply_step(:start, user_id)
    answer(context, message, opts)
  end

  def handle({:callback_query, %{data: "cancel"}}, context) do
    answer(context, "Recipt creation cancelled")
  end

  def handle({:callback_query, %{data: "avoid"}}, context) do
    answer(context, "Test avoid")
  end

  def handle({:callback_query, %{data: "send|" <> uuid}}, context) do
    {message, opts} = GakiBot.apply_next_step(uuid, nil, false, nil)
    answer(context, message, opts)
  end

  def handle({:callback_query, _msg}, context) do
    answer(context, "Not controlled")
  end
end
