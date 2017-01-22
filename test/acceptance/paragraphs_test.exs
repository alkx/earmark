defmodule Acceptance.ParagraphsTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1]

  setup do
    {:ok, messages: []}
  end

  describe "Paragraphs" do
    test "a para", %{messages: messages} do
      markdown = "aaa\n\nbbb\n"
      html     = "<p>aaa</p>\n<p>bbb</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "and another one", %{messages: messages} do
      markdown = "aaa\n\n\nbbb\n"
      html     = "<p>aaa</p>\n<p>bbb</p>\n"

      assert as_html(markdown) == {html, messages}
    end

  end
end
