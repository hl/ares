defmodule Ares.Repo do
  @moduledoc """
  The repository to interact with CubDB
  """

  @type id :: non_neg_integer()
  @type collection :: atom()

  @spec get(collection(), id(), term()) :: struct() | nil
  def get(collection, id, default \\ nil) do
    CubDB.get(__MODULE__, {collection, id}, default)
  end

  @spec get_by(collection(), [{atom(), term()}]) :: struct() | nil
  def get_by(collection, clauses) do
    stream =
      __MODULE__
      |> CubDB.select(min_key: {collection, 0}, max_key: {collection, nil})
      |> Stream.map(&elem(&1, 1))
      |> Stream.filter(&Enum.all?(clauses, fn {k, v} -> Map.get(&1, k) == v end))
      |> Stream.take(1)

    Enum.at(stream, 0)
  end

  @spec all(collection()) :: [struct()]
  def all(collection) do
    stream =
      __MODULE__
      |> CubDB.select(min_key: {collection, 0}, max_key: {collection, nil})
      |> Stream.map(&elem(&1, 1))

    Enum.to_list(stream)
  end

  @spec insert(struct()) :: {:ok, struct()}
  def insert(%{__struct__: collection, id: nil} = struct) do
    id =
      CubDB.transaction(__MODULE__, fn tx ->
        id = CubDB.Tx.get(tx, {:index, collection}, 1)
        tx = CubDB.Tx.put(tx, {:index, collection}, id + 1)

        {:commit, tx, id}
      end)

    now = NaiveDateTime.utc_now()
    struct = %{struct | id: id, inserted_at: now, updated_at: now}

    :ok = CubDB.put(__MODULE__, {collection, id}, struct)

    {:ok, struct}
  end

  @spec update(struct()) :: {:ok, struct()}
  def update(%{__struct__: collection, id: id} = struct) when is_integer(id) do
    struct = %{struct | updated_at: NaiveDateTime.utc_now()}

    :ok = CubDB.put(__MODULE__, {collection, id}, struct)

    {:ok, struct}
  end

  @spec insert_or_update(struct()) :: {:ok, struct()}
  def insert_or_update(%{id: nil} = struct), do: insert(struct)
  def insert_or_update(struct), do: update(struct)

  @spec delete(struct()) :: {:ok, struct()}
  def delete(%{__struct__: collection, id: id} = struct) when is_integer(id) do
    :ok = CubDB.delete(__MODULE__, {collection, id})
    {:ok, struct}
  end
end
