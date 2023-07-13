defmodule Ares.CatalogTest do
  @moduledoc """
  Tests for the Catalog context
  """

  use ExUnit.Case, async: true

  alias Ares.Catalog

  import Ares.CatalogFixtures

  describe "list_products/0" do
    test "returns a list of products" do
      product = product_fixture()
      products = Catalog.list_products()

      assert product in products
    end
  end

  describe "get_product/1" do
    test "returns nil for unknown product" do
      product = Catalog.get_product(-1)

      refute product
    end

    test "returns a product" do
      product = product_fixture()
      queried_product = Catalog.get_product(product.id)

      assert product == queried_product
    end
  end

  describe "create_product/1" do
    test "requires sku to be set" do
      attrs = valid_product_attributes() |> Map.delete(:sku)

      assert {:error, errors} = Catalog.create_product(attrs)
      assert {:sku, "is required"} in errors
    end

    test "requires price to be set" do
      attrs = valid_product_attributes() |> Map.delete(:price)

      assert {:error, errors} = Catalog.create_product(attrs)
      assert {:price, "is required"} in errors
    end

    test "creates a product" do
      attrs = valid_product_attributes()
      {:ok, product} = Catalog.create_product(attrs)

      assert is_integer(product.id)
      assert product.sku == attrs.sku
      assert product.price == attrs.price
      assert product.title == attrs.title
    end
  end

  describe "update_product/2" do
    test "updates a product" do
      product = product_fixture()
      attrs = valid_product_attributes()

      {:ok, updated_product} = Catalog.update_product(product, attrs)

      refute updated_product.sku == product.sku
      refute updated_product.price == product.price
      refute updated_product.title == product.title

      assert updated_product.id == product.id
      assert updated_product.sku == attrs.sku
      assert updated_product.price == attrs.price
      assert updated_product.title == attrs.title
    end
  end

  describe "delete_product/1" do
    test "returns nil for a deleted product" do
      product = product_fixture()
      {:ok, ^product} = Catalog.delete_product(product)
      queried_product = Catalog.get_product(product.id)

      refute queried_product
    end
  end
end
