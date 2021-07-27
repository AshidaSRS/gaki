defmodule GakiBot do
  def about_command do
      text = """
      __Cosas publicas__
      Cosas publicas
      """

      {text, parse_mode: "Markdown"}
  end

  # defp about_command_private do
  #   text = """
  #   __Cosas privadas__
  #   Cosas privadas
  #   """

  #   {text, parse_mode: "Markdown"}
  # end
end
