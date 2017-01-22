defmodule Acceptance.DiverseTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1]

  setup do
    {:ok, messages: []}
  end

  describe "etc" do
    test "entiy", %{messages: messages} do
      markdown = "`f&ouml;&ouml;`\n"
      html     = "<p><code class=\"inline\">f&amp;ouml;&amp;ouml;</code></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "spaec preserving", %{messages: messages} do
      markdown = "Multiple     spaces\n"
      html     = "<p>Multiple     spaces</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "syntax errors" do
      markdown ="A\nB\n="
      html     = "<p>A\nB</p>\n<p></p>\n"
      messages = [{:warning, 3, "Unexpected line =" }]

      assert as_html(markdown) == {html, messages}
    end


  end
end
