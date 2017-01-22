defmodule Acceptance.EscapeTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1, as_html: 2]

  setup do
    {:ok, messages: []}
  end


  describe "Escapes" do

    test "dizzy?", %{messages: messages} do
      markdown = "\\\\!\\\\\""
      html     = "<p>\\!\\“</p>\n"

      assert as_html(markdown, smartypants: true) == {html, messages}

      html     = "<p>\\!\\&quot;</p>\n"
      assert as_html(markdown, smartypants: false) == {html, messages}
    end

    test "obviously", %{messages: messages} do
      markdown = "\\`no code"
      html     = "<p>`no code</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "less obviously - escpe the escapes", %{messages: messages} do
      markdown = "\\\\` code`"
      html     = "<p>\\<code class=\"inline\">code</code></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "don't ask me", %{messages: messages} do
      markdown = "\\\\ \\"
      html     = "<p>\\ \\</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "let us escape (again)", %{messages: messages} do
      markdown = "\\\\*emphasis*\n"
      html = "<p>\\<em>emphasis</em></p>\n"
      assert as_html(markdown) == {html, messages}
    end

    test "a plenty of nots" do
      markdown = "\\*not emphasized\\*\n\\[not a link](/foo)\n\\`not code`\n1\\. not a list\n\\* not a list\n\\# not a header\n\\[foo]: /url \"not a reference\"\n"
      html     = "<p>*not emphasized*\n[not a link](/foo)\n`not code`\n1. not a list\n* not a list\n# not a header\n[foo]: /url &quot;not a reference&quot;</p>\n"
      messages = [{:warning, 3, "Closing unclosed backquotes ` at end of input" }]

      assert as_html(markdown, smartypants: false) == {html, messages}
    end

  end
end
