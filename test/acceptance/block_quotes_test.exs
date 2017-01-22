defmodule Acceptance.BlockQuotesTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1]

  setup do
    {:ok, messages: []}
  end

  describe "Block Quotes" do
    test "quote my block", %{messages: messages} do
      markdown = "> Foo"
      html     = "<blockquote><p>Foo</p>\n</blockquote>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "and block my quotes", %{messages: messages} do
      markdown = "> # Foo\n> bar\n> baz\n"
      html     = "<blockquote><h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "linient we are", %{messages: messages} do
      markdown = "> bar\nbaz\n> foo\n"
      html     = "<blockquote><p>bar\nbaz\nfoo</p>\n</blockquote>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "lists in blockquotes? Coming up Sir", %{messages: messages} do
      markdown = "> - foo\n- bar\n"
      html     = "<blockquote><ul>\n<li>foo\n</li>\n</ul>\n</blockquote>\n<ul>\n<li>bar\n</li>\n</ul>\n"

      assert as_html(markdown) == {html, messages}
    end

  end
end
