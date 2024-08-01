defmodule LiveViewResponsive.QueryBuilderTest do
  @moduledoc false

  use LiveViewResponsive.Case

  alias LiveViewResponsive.QueryBuilder

  describe "build/1" do
    test "builds a query with valid options" do
      opts = [
        {"screen", true},
        {"orientation", "portrait"},
        {"width", 1000},
        {"height", "1000px"},
        {"min-monochrome", 0}
      ]

      assert QueryBuilder.build(opts) ==
               "screen and (orientation: portrait) and (width: 1000px) and (height: 1000px) and (min-monochrome: 0)"
    end

    test "adds px to string_or_number values" do
      opts = [{"width", 1000}]
      assert QueryBuilder.build(opts) == "(width: 1000px)"
    end

    test "does not add px to numeric values" do
      opts = [{"min-monochrome", 8}]
      assert QueryBuilder.build(opts) == "(min-monochrome: 8)"
    end

    test "builds a query with numeric values" do
      opts = [{"min-width", 500}, {"max-width", 1200}]
      assert QueryBuilder.build(opts) == "(min-width: 500px) and (max-width: 1200px)"
    end

    test "builds a query with string values" do
      opts = [{"resolution", "300dpi"}]
      assert QueryBuilder.build(opts) == "(resolution: 300dpi)"
    end

    test "raises an error for invalid key" do
      opts = [{"invalid_key", true}]
      assert_raise ArgumentError, fn -> QueryBuilder.build(opts) end
    end

    test "gives suggestion on typo" do
      opts = [{"embosse", true}]
      assert_raise ArgumentError, ~r/Did you mean "embossed"?/, fn -> QueryBuilder.build(opts) end
    end

    test "raises an error for invalid boolean value" do
      opts = [{"monochrome", "yes"}]
      assert_raise ArgumentError, fn -> QueryBuilder.build(opts) end
    end

    test "raises an error for invalid number value" do
      opts = [{"min-monochrome", "0"}]
      assert_raise ArgumentError, fn -> QueryBuilder.build(opts) end
    end

    test "raises an error for invalid string_or_number value" do
      opts = [{"resolution", true}]
      assert_raise ArgumentError, fn -> QueryBuilder.build(opts) end
    end

    test "raises an error for invalid option in available values" do
      opts = [{"orientation", "diagonal"}]
      assert_raise ArgumentError, fn -> QueryBuilder.build(opts) end
    end

    test "returns the custom query if query key is present" do
      opts = [{"query", "screen and (orientation: landscape)"}, {"width", 1000}, {"height", 1000}]
      assert QueryBuilder.build(opts) == "screen and (orientation: landscape)"
    end
  end
end
