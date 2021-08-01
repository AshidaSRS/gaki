defmodule GakiBot.Utils do
  import ExGram.Dsl.Keyboard

  require Logger

  def generate_step_buttons(uuid, show_avoid) do
    case show_avoid do
      true ->
        generate_optional_step_buttons(uuid)

      _ ->
        generate_step_buttons(uuid)
    end
  end

  def generate_start_buttons do
    keyboard :inline do
      row do
        button("Cancel", callback_data: "cancel")
        button("Start", callback_data: "start")
      end
    end
  end

  # Private
  defp generate_optional_step_buttons(uuid) do
    keyboard :inline do
      row do
        button("Avoid", callback_data: "avoid|#{uuid}")
        button("Continue", callback_data: "send|#{uuid}")
      end
    end
  end

  defp generate_step_buttons(uuid) do
    keyboard :inline do
      row do
        button("Continue", callback_data: "send|#{uuid}")
      end
    end
  end

  def to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end
end
