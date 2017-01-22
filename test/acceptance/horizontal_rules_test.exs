defmodule Acceptance.HorizontalRulesTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1]

  setup do
    {:ok, messages: []}
  end
  
  describe "Horizontal rules" do

    test "thick, thin & medium", %{messages: messages} do
      markdown = "***\n---\n___\n"
      html     = "<hr class=\"thick\"/>\n<hr class=\"thin\"/>\n<hr class=\"medium\"/>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "not a rule", %{messages: messages} do
      markdown = "+++\n"
      html     = "<p>+++</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "not in code", %{messages: messages} do
      markdown = "    ***\n    \n     a"
      html     = "<pre><code>***\n\n a</code></pre>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "not in code, second line", %{messages: messages} do
      markdown = "Foo\n    ***\n"
      html     = "<p>Foo</p>\n<pre><code>***</code></pre>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "medium, long", %{messages: messages} do
      markdown = "_____________________________________\n"
      html     = "<hr class=\"medium\"/>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "emmed, so to speak", %{messages: messages} do
      markdown = " *-*\n"
      html     = "<p> <em>-</em></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "in lists", %{messages: messages} do
      markdown = "- foo\n***\n- bar\n"
      html     = "<ul>\n<li>foo\n</li>\n</ul>\n<hr class=\"thick\"/>\n<ul>\n<li>bar\n</li>\n</ul>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "setext rules over rules (why am I soo witty?)", %{messages: messages} do
      markdown = "Foo\n---\nbar\n"
      html     = "<h2>Foo</h2>\n<p>bar</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "in lists, thick this time (why am I soo good to you?)", %{messages: messages} do
      markdown = "* Foo\n* * *\n* Bar\n"
      html = "<ul>\n<li>Foo\n</li>\n</ul>\n<hr class=\"thick\"/>\n<ul>\n<li>Bar\n</li>\n</ul>\n"
      assert as_html(markdown) == {html, messages}
    end
  end
end
