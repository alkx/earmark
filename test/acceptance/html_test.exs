defmodule Acceptance.HtmlBlocksTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1]

  setup do
    {:ok, messages: []}
  end

  describe "HTML blocks" do
    test "tables are just tables again (or was that mountains?)", %{messages: messages} do
      markdown = "<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>\n\nokay.\n"
      html     = "<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table><p>okay.</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "div (ine?)", %{messages: messages} do
      markdown = "<div>\n  *hello*\n         <foo><a>\n</div>\n"
      html     = "<div>\n  *hello*\n         <foo><a>\n</div>"

      assert as_html(markdown) == {html, messages}
    end

    test "we are leaving html alone", %{messages: messages} do
      markdown = "<div>\n*Emphasized* text.\n</div>"
      html     = "<div>\n*Emphasized* text.\n</div>"

      assert as_html(markdown) == {html, messages}
    end

  end

  describe "HTML void elements" do
    test "area", %{messages: messages} do
      markdown = "<area shape=\"rect\" coords=\"0,0,1,1\" href=\"xxx\" alt=\"yyy\">\n**emphasized** text"
      html     = "<area shape=\"rect\" coords=\"0,0,1,1\" href=\"xxx\" alt=\"yyy\"><p><strong>emphasized</strong> text</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "we are outside the void now (lucky us)", %{messages: messages} do
      markdown = "<br>\n**emphasized** text"
      html     = "<br><p><strong>emphasized</strong> text</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "high regards???", %{messages: messages} do
      markdown = "<hr>\n**emphasized** text"
      html     = "<hr><p><strong>emphasized</strong> text</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "img (a punless test)", %{messages: messages} do
      markdown = "<img src=\"hello\">\n**emphasized** text"
      html     = "<img src=\"hello\"><p><strong>emphasized</strong> text</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "not everybode knows this one (hint: take a break)", %{messages: messages} do
      markdown = "<wbr>\n**emphasized** text"
      html = "<wbr><p><strong>emphasized</strong> text</p>\n"
      assert as_html(markdown) == {html, messages}
    end
  end

  describe "HTML and paragraphs" do
    test "void elements close para", %{messages: messages} do
      markdown = "alpha\n<hr>beta"
      html     = "<p>alpha</p>\n<hr>beta"

      assert as_html(markdown) == {html, messages}
    end

    test "void elements close para but only at BOL", %{messages: messages} do
      markdown = "alpha\n <hr>beta"
      html     = "<p>alpha\n <hr>beta</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "self closing block elements close para", %{messages: messages} do
      markdown = "alpha\n<div/>beta"
      html     = "<p>alpha</p>\n<div/>beta"

      assert as_html(markdown) == {html, messages}
    end

    test "self closing block elements close para, atts do not matter", %{messages: messages} do
      markdown = "alpha\n<div class=\"first\"/>beta"
      html     = "<p>alpha</p>\n<div class=\"first\"/>beta"

      assert as_html(markdown) == {html, messages}
    end

    test "self closing block elements close para, atts and spaces do not matter", %{messages: messages} do
      markdown = "alpha\n<div class=\"first\"   />beta\ngamma"
      html     = "<p>alpha</p>\n<div class=\"first\"   />beta<p>gamma</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "self closing block elements close para but only at BOL", %{messages: messages} do
      markdown = "alpha\n <div/>beta"
      html     = "<p>alpha\n <div/>beta</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "self closing block elements close para but only at BOL, atts do not matter", %{messages: messages} do
      markdown = "alpha\ngamma<div class=\"fourty two\"/>beta"
      html     = "<p>alpha\ngamma<div class=\"fourty two\"/>beta</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "block elements close para", %{messages: messages} do
      markdown = "alpha\n<div></div>beta"
      html     = "<p>alpha</p>\n<div></div>beta"

      assert as_html(markdown) == {html, messages}
    end

    test "block elements close para, atts do not matter", %{messages: messages} do
      markdown = "alpha\n<div class=\"first\"></div>beta"
      html     = "<p>alpha</p>\n<div class=\"first\"></div>beta"

      assert as_html(markdown) == {html, messages}
    end

    test "block elements close para but only at BOL", %{messages: messages} do
      markdown = "alpha\n <div></div>beta"
      html     = "<p>alpha\n <div></div>beta</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "block elements close para but only at BOL, atts do not matter", %{messages: messages} do
      markdown = "alpha\ngamma<div class=\"fourty two\"></div>beta"
      html     = "<p>alpha\ngamma<div class=\"fourty two\"></div>beta</p>\n"

      assert as_html(markdown) == {html, messages}
    end

  end
end
