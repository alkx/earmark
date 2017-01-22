defmodule Acceptance.FencedCodeBlocksTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1, as_html: 2]

  setup do
    {:ok, messages: []}
  end

  describe "Fenced code blocks" do
    test "no lang", %{messages: messages} do
      markdown = "```\n<\n >\n```\n"
      html     = "<pre><code class=\"\">&lt;\n &gt;</code></pre>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "still no lang", %{messages: messages} do
      markdown = "~~~\n<\n >\n~~~\n"
      html     = "<pre><code class=\"\">&lt;\n &gt;</code></pre>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "elixir 's the name", %{messages: messages} do
      markdown = "```elixir\naaa\n~~~\n```\n"
      html     = "<pre><code class=\"elixir\">aaa\n~~~</code></pre>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "with a code_class_prefix", %{messages: messages} do
      markdown = "```elixir\naaa\n~~~\n```\n"
      html     = "<pre><code class=\"elixir lang-elixir\">aaa\n~~~</code></pre>\n"

      assert as_html(markdown, code_class_prefix: "lang-") == {html, messages}
    end

    test "look mam, more lines", %{messages: messages} do
      markdown = "   ```\naaa\nb\n  ```\n"
      html     = "<pre><code class=\"\">aaa\nb</code></pre>\n"

      assert as_html(markdown) == {html, messages}
    end

  end
end
