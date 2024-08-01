defmodule LiveViewResponsive.OptsParserTest do
  @moduledoc false

  use LiveViewResponsive.Case

  alias LiveViewResponsive.OptsParser

  describe "parse/1" do
    test "accepts keyword lists and maps" do
      assert [
               [orientation: "portrait"],
               %{orientation: "portrait"},
               %{"orientation" => "portrait"}
             ]
             |> Enum.map(&OptsParser.parse/1) == [
               [{"orientation", "portrait"}],
               [{"orientation", "portrait"}],
               [{"orientation", "portrait"}]
             ]
    end

    test "converts atoms to strings" do
      assert [orientation: "portrait", orientation: :portrait]
             |> OptsParser.parse() == [{"orientation", "portrait"}, {"orientation", "portrait"}]
    end

    test "does not convert booleans and nils to strings" do
      assert [screen: true, initial: nil] |> OptsParser.parse() == [
               {"screen", true},
               {"initial", nil}
             ]
    end

    test "replaces underscores with hyphens" do
      assert [{:"_this_is-test_key_", 500}] |> OptsParser.parse() == [
               {"-this-is-test-key-", 500}
             ]
    end
  end

  describe "pop/3" do
    test "returns value of the key and remaining opts" do
      opts = [{"initial", true}, {"min-width", 500}]
      assert OptsParser.pop(opts, "initial") == {true, [{"min-width", 500}]}
    end

    test "returns nil if the key is not found" do
      opts = [{"min-width", 500}]

      assert OptsParser.pop(opts, "initial") == {nil, [{"min-width", 500}]}
    end

    test "returns the default value if the key is not found" do
      opts = [{"min-width", 500}]

      assert OptsParser.pop(opts, "initial", :custom_value) ==
               {:custom_value, [{"min-width", 500}]}
    end
  end
end
