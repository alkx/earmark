defmodule Acceptance.IndentedCodeBlocksTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1]

  setup do
    {:ok, messages: []}
  end

  describe "Indented code blocks" do
    test "simple (but easy?)", %{messages: messages} do
      markdown = "    a simple\n      indented code block\n"
      html     = "<pre><code>a simple\n  indented code block</code></pre>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "code is soo verbatim", %{messages: messages} do
      markdown = "    <a/>\n    *hi*\n\n    - one\n"
      html     = "<pre><code>&lt;a/&gt;\n*hi*\n\n- one</code></pre>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "chunky bacon (RIP: Why)", %{messages: messages} do
      markdown = "    chunk1\n\n    chunk2\n  \n \n \n    chunk3\n"
      html     = "<pre><code>chunk1\n\nchunk2\n\n\n\nchunk3</code></pre>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "foo and bar (now you are surprised!)", %{messages: messages} do
      markdown = "    foo\nbar\n"
      html     = "<pre><code>foo</code></pre>\n<p>bar</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "not the alpha, not the omega (gamma maybe?)", %{messages: messages} do
      markdown = "\n    \n    foo\n    \n\n"
      html = "<pre><code>foo</code></pre>\n"
      assert as_html(markdown) == {html, messages}
    end
  end
end
