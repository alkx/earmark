defmodule Acceptance.AtxHeadersTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1]

  setup do
    {:ok, messages: []}
  end

  describe "ATX headers" do

    test "from one to six", %{messages: messages} do
      markdown = "# foo\n## foo\n### foo\n#### foo\n##### foo\n###### foo\n"
      html     = "<h1>foo</h1>\n<h2>foo</h2>\n<h3>foo</h3>\n<h4>foo</h4>\n<h5>foo</h5>\n<h6>foo</h6>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "seven? kidding, right?", %{messages: messages} do
      markdown = "####### foo\n"
      html     = "<p>####### foo</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "sticky (better than to have no glue)", %{messages: messages} do
      markdown = "#5 bolt\n\n#foobar\n"
      html     = "<p>#5 bolt</p>\n<p>#foobar</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "close escape", %{messages: messages} do
      markdown = "\\## foo\n"
      html     = "<p>## foo</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "position is so important", %{messages: messages} do
      markdown = "# foo *bar* \\*baz\\*\n"
      html     = "<h1>foo <em>bar</em> *baz*</h1>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "spacy", %{messages: messages} do
      markdown = "#                  foo                     \n"
      html     = "<h1>foo</h1>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "code comes first", %{messages: messages} do
      markdown = "    # foo\nnext"
      html     = "<pre><code># foo</code></pre>\n<p>next</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "some prefer to close their headers", %{messages: messages} do
      markdown = "# foo#\n"
      html     = "<h1>foo</h1>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "yes, they do (prefer closing their header)", %{messages: messages} do
      markdown = "### foo ### "
      html     = "<h3>foo ###</h3>\n"

      assert as_html(markdown) == {html, messages}
    end

  end
end
