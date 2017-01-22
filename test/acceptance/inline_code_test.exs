defmodule Acceptance.InlineCodeTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1]

  setup do
    {:ok, messages: []}
  end


  describe "Inline Code" do

    test "plain simple", %{messages: messages} do
      markdown = "`foo`\n"
      html     = "<p><code class=\"inline\">foo</code></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "this time you got it right", %{messages: messages} do
      markdown = "`a\nb`c\n"
      html     = "<p><code class=\"inline\">a\nb</code>c</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "and again!!!", %{messages: messages} do
      markdown = "+ ``a `\n`\n b``c"
      html = "<ul>\n<li><code class=\"inline\">a `\n`\n b</code>c\n</li>\n</ul>\n"
      assert as_html(markdown) == {html, messages}
    end

    test "plain simple, right?" do
      markdown = "`hi`lo`\n"
      html     = "<p><code class=\"inline\">hi</code>lo`</p>\n"
      messages = [{:warning, 1, "Closing unclosed backquotes ` at end of input"}]

      assert as_html(markdown) == {html, messages}
    end
  end
end
