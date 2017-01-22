defmodule Acceptance.InlineAttributeListTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1]

  setup do
    {:ok, messages: []}
  end


  describe "IAL" do

    test "Not associated", %{messages: messages} do
      markdown = "{:hello=world}"
      html     = "<p>{:hello=world}</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "Associated", %{messages: messages} do
      markdown = "Before\n{:hello=world}"
      html     = "<p hello=\"world\">Before</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "Associated in between", %{messages: messages} do
      markdown = "Before\n{:hello=world}\nAfter"
      html     = "<p hello=\"world\">Before</p>\n<p>After</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "Not associated and incorrect" do
      markdown = "{:hello}"
      html     = "<p>{:hello}</p>\n"
      messages = [{:warning, 1, "Illegal attributes [\"hello\"] ignored in IAL" }]

      assert as_html(markdown) == {html, messages}
    end

    test "Associated and incorrect" do
      markdown = "Before\n{:hello}"
      html     = "<p>Before</p>\n"
      messages = [{:warning, 2, "Illegal attributes [\"hello\"] ignored in IAL" }]

      assert as_html(markdown) == {html, messages}
    end

    test "Associated and partly incorrect" do
      markdown = "Before\n{:hello title=world}"
      html     = "<p title=\"world\">Before</p>\n"
      messages = [{:warning, 2, "Illegal attributes [\"hello\"] ignored in IAL" }]

      assert as_html(markdown) == {html, messages}
    end

    test "Associated and partly incorrect and shortcuts" do
      markdown = "Before\n{:#hello .alpha hello title=world .beta class=\"gamma\" title='class'}"
      html     = "<p class=\"gamma beta alpha\" id=\"hello\" title=\"class world\">Before</p>\n"
      messages = [{:warning, 2, "Illegal attributes [\"hello\"] ignored in IAL" }]

      assert as_html(markdown) == {html, messages}
    end

  end
end
