defmodule Acceptance.EmphasisTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1, as_html: 2]

  setup do
    {:ok, messages: []}
  end

  describe "Emphasis" do
    test "important", %{messages: messages} do
      markdown = "*foo bar*\n"
      html     = "<p><em>foo bar</em></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "imporatant quotes", %{messages: messages} do
      markdown = "a*\"foo\"*\n"
      html     = "<p>a<em>&quot;foo&quot;</em></p>\n"

      assert as_html(markdown, smartypants: false) == {html, messages}
    end

    test "important _", %{messages: messages} do
      markdown = "_foo bar_\n"
      html     = "<p><em>foo bar</em></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "dont get confused", %{messages: messages} do
      markdown = "_foo*\n"
      html     = "<p>_foo*</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "that should make you smile", %{messages: messages} do
      markdown = "_foo_bar_baz_\n"
      html     = "<p><em>foo_bar_baz</em></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "stronger", %{messages: messages} do
      markdown = "**foo bar**\n"
      html     = "<p><strong>foo bar</strong></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "stronger insisde", %{messages: messages} do
      markdown = "foo**bar**\n"
      html     = "<p>foo<strong>bar</strong></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "stronger together", %{messages: messages} do
      markdown = "__foo bar__\n"
      html     = "<p><strong>foo bar</strong></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "let no evil underscores divide us", %{messages: messages} do
      markdown = "**foo__bar**\n"
      html     = "<p><strong>foo__bar</strong></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "strong **and** stronger", %{messages: messages} do
      markdown = "*(**foo**)*\n"
      html     = "<p><em>(<strong>foo</strong>)</em></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "stronger **and** strong", %{messages: messages} do
      markdown = "**(*foo*)**\n"
      html     = "<p><strong>(<em>foo</em>)</strong></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "one is not strong enough", %{messages: messages} do
      markdown = "foo*\n"
      html     = "<p>foo*</p>\n"

      assert as_html(markdown) == {html, messages}
    end

  end
end
