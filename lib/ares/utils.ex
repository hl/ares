defmodule Ares.Utils do
  @moduledoc """
  General helper functions
  """

  @spec validate_required(Enum.t(), atom() | [atom()]) :: :ok | {:errors, [{atom(), String.t()}]}
  def validate_required(data, key_or_keys) do
    keys = List.wrap(key_or_keys)

    errors =
      Enum.reduce(keys, [], fn key, errors ->
        case Map.get(data, key) do
          nil -> [{key, "is required"} | errors]
          _value -> errors
        end
      end)

    validate(Enum.empty?(errors), errors)
  end

  @spec validate(boolean(), error_reason) :: :ok | {:error, error_reason}
        when error_reason: term()
  def validate(true, _error_reason), do: :ok
  def validate(false, error_reason), do: {:error, error_reason}
end
