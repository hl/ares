defmodule Ares.Catalog.Product do
  @moduledoc """
  This module hold the structure of the Product
  """

  defstruct [:id, :sku, :price, :title, :inserted_at, :updated_at]

  @type id :: non_neg_integer()

  @type t :: %__MODULE__{
          id: id() | nil,
          sku: String.t() | nil,
          price: non_neg_integer() | nil,
          title: String.t() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }
end
