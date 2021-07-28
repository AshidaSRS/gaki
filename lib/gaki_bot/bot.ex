defmodule GakiBot.Bot do
  @bot :gaki_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Print the bot's help")
  command("recipe")

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

  def handle({:command, :recipe, %{text: message}}, context) do
    IO.inspect(message)
    GakiBot.create_recipe(message)
    IO.puts("va")
    answer(context, message)
  end
end
