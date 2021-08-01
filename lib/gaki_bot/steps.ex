defmodule GakiBot.Steps do
  use GenServer
  alias GakiBot.StepContent

  # 1 hour
  @timeout 60 * 60 * 1000

  # steps:
  # 1- list
  # 2- description
  # 3- tips | nothing
  # 4- tags

  require Logger

  # Child specification
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  # Client API
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_step(step, user_id, uuid, content) do
    GenServer.call(__MODULE__, {:add_step, step, content, user_id, uuid})
  end

  def get_step(uuid) do
    GenServer.call(__MODULE__, {:get_step, uuid})
  end

  def get_step_by_user_id(user_id) do
    GenServer.call(__MODULE__, {:get_step_by_user_id, user_id})
  end

  # Server callbacks
  def init(:ok) do
    Process.send_after(self(), :timeout, @timeout)
    default_step = %{}
    {:ok, %{first_gen: default_step, second_gen: default_step}}
  end

  def handle_info(:timeout, %{first_gen: first_gen}) do
    Logger.debug("Cleaning Steps genserver, next clean up in #{@timeout} ms")
    Process.send_after(self(), :timeout, @timeout)
    {:noreply, %{first_gen: %{}, second_gen: first_gen}}
  end

  def handle_call({:add_step, step, content, user_id, uuid}, _from, %{
        first_gen: first_gen,
        second_gen: second_gen
      }) do
    IO.inspect(step)
    IO.inspect(content)

    case step do
      :start ->
        new_uuid = UUID.uuid4()
        ops = %{:step => step, :user_id => user_id}
        step_content = struct(StepContent, ops)
        new_first_gen = Map.put(first_gen, new_uuid, step_content)
        IO.inspect(new_first_gen)
        {:reply, new_uuid, %{first_gen: new_first_gen, second_gen: second_gen}}

      :end ->
        ops = %{:step => step}

        new_ops =
          get_from_generations(uuid, first_gen, second_gen)
          |> Map.from_struct()
          |> Map.merge(ops)

        step_content = struct(StepContent, new_ops)
        new_first_gen = Map.put(first_gen, uuid, step_content)
        {:reply, uuid, %{first_gen: new_first_gen, second_gen: second_gen}}

      _ ->
        step_name = step |> to_string() |> String.split("_") |> List.last()

        ops = %{String.to_atom(step_name) => content, :step => step}

        new_ops =
          get_from_generations(uuid, first_gen, second_gen)
          |> Map.from_struct()
          |> Map.merge(ops)

        step_content = struct(StepContent, new_ops)
        new_first_gen = Map.put(first_gen, uuid, step_content)
        {:reply, uuid, %{first_gen: new_first_gen, second_gen: second_gen}}
    end
  end

  def handle_call(
        {:get_step, uuid},
        _from,
        %{first_gen: first_gen, second_gen: second_gen} = state
      ) do
    case get_from_generations(uuid, first_gen, second_gen) do
      %StepContent{list: list, description: description, tips: tips, tags: tags, step: step} =
          data ->
        new_first_gen = Map.put(first_gen, uuid, data)

        {:reply, {:ok, list, description, tips, tags, step},
         %{first_gen: new_first_gen, second_gen: second_gen}}

      _ ->
        {:reply, {:error, :not_found}, state}
    end
  end

  def handle_call(
        {:get_step_by_user_id, user_id},
        _from,
        %{first_gen: first_gen, second_gen: second_gen} = state
      ) do
    case get_from_generations_by_user_id(user_id, first_gen, second_gen) do
      [] ->
        {:reply, {:error, :not_found}, state}

      {key, _value} ->
        {:reply, {:ok, key}, state}
    end
  end

  # Private
  defp get_from_generations(uuid, first_gen, second_gen) do
    case Map.get(first_gen, uuid, :not_found) do
      :not_found -> Map.get(second_gen, uuid)
      found -> found
    end
  end

  defp get_from_generations_by_user_id(user_id, first_gen, second_gen) do
    found = get_by_user(user_id, first_gen)

    case found do
      [] ->
        get_by_user(user_id, second_gen)

      [head | _tail] ->
        head
    end
  end

  defp get_by_user(user_id, first_gen) do
    first_gen
    |> Enum.filter(fn {_, step_content} ->
      step_content.user_id == user_id
    end)
  end
end
