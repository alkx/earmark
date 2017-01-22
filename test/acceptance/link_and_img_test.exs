defmodule Acceptance.LinkAndImgTest do
  use ExUnit.Case

  import Support.Helpers, only: [as_html: 1, as_html: 2]

  setup do
    {:ok, messages: []}
  end

  describe "Link reference definitions" do

    test "link with title", %{messages: messages} do
      markdown = "[foo]: /url \"title\"\n\n[foo]\n"
      html     = "<p><a href=\"/url\" title=\"title\">foo</a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "this ain't no link", %{messages: messages} do
      markdown = "[foo]: /url \"title\"\n\n[bar]\n"
      html     = "<p>[bar]</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "img with title", %{messages: messages} do
      markdown = "[foo]: /url \"title\"\n\n![foo]\n"
      html     = "<p><img src=\"/url\" alt=\"foo\" title=\"title\"/></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "this ain't no img (and no link)", %{messages: messages} do
      markdown = "[foo]: /url \"title\"\n\n![bar]\n"
      html     = "<p>![bar]</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "strange syntaxes exist in Markdown", %{messages: messages} do
      markdown = "[foo]\n\n[foo]: url\n"
      html = "<p><a href=\"url\" title=\"\">foo</a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "sometimes strange text is just strange text", %{messages: messages} do
      markdown = "[foo]: /url \"title\" ok\n"
      html     = "<p>[foo]: /url &quot;title&quot; ok</p>\n"

      assert as_html(markdown, smartypants: false) == {html, messages}

      html     = "<p>[foo]: /url “title” ok</p>\n"
      assert as_html(markdown, smartypants: true) == {html, messages}
    end

    test "guess how this one is rendered?", %{messages: messages} do
      markdown = "[foo]: /url \"title\"\n"
      html     = ""

      assert as_html(markdown) == {html, messages}
    end

    test "or this one, but you might be wrong", %{messages: messages} do
      markdown = "# [Foo]\n[foo]: /url\n> bar\n"
      html     = "<h1><a href=\"/url\" title=\"\">Foo</a></h1>\n<blockquote><p>bar</p>\n</blockquote>\n"

      assert as_html(markdown) == {html, messages}
    end

  end

  describe "Link and Image imbrication" do

    test "empty (remains such)", %{messages: messages} do
      markdown = ""
      html     = ""

      assert as_html(markdown) == {html, messages}
    end

    test "inner is a link, not outer", %{messages: messages} do
      markdown = "[[text](inner)]outer"
      html     = "<p>[<a href=\"inner\">text</a>]outer</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "unless your outer is syntactically a link of course", %{messages: messages} do
      markdown = "[[text](inner)](outer)"
      html = "<p><a href=\"outer\">[text](inner)</a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "as with this img", %{messages: messages} do
      markdown = "![[text](inner)](outer)"
      html     = "<p><img src=\"outer\" alt=\"[text](inner)\"/></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "headaches ahead (and behind us)", %{messages: messages} do
      markdown = "[![moon](moon.jpg)](/uri)\n"
      html     = "<p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\"/></a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "lost in space", %{messages: messages} do
      markdown = "![![moon](moon.jpg)](sun.jpg)\n"
      html = "<p><img src=\"sun.jpg\" alt=\"![moon](moon.jpg)\"/></p>\n"
      assert as_html(markdown) == {html, messages}
    end
  end

  describe "Links" do
    test "titled link", %{messages: messages} do
      markdown = "[link](/uri \"title\")\n"
      html     = "<p><a href=\"/uri\" title=\"title\">link</a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "no title", %{messages: messages} do
      markdown = "[link](/uri))\n"
      html     = "<p><a href=\"/uri\">link</a>)</p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "let's go nowhere", %{messages: messages} do
      markdown = "[link]()\n"
      html = "<p><a href=\"\">link</a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "nowhere in a bottle", %{messages: messages} do
      markdown = "[link](())\n"
      html = "<p><a href=\"()\">link</a></p>\n"
      assert as_html(markdown) == {html, messages}
    end
  end

  describe "Images" do
    test "title", %{messages: messages} do
      markdown = "![foo](/url \"title\")\n"
      html     = "<p><img src=\"/url\" alt=\"foo\" title=\"title\"/></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "ti tle (why not)", %{messages: messages} do
      markdown = "![foo](/url \"ti tle\")\n"
      html     = "<p><img src=\"/url\" alt=\"foo\" title=\"ti tle\"/></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "titles become strange", %{messages: messages} do
      markdown = "![foo](/url \"ti() tle\")\n"
      html     = "<p><img src=\"/url\" alt=\"foo\" title=\"ti() tle\"/></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "as does everything else", %{messages: messages} do
      markdown = "![f[]oo](/url \"ti() tle\")\n"
      html     = "<p><img src=\"/url\" alt=\"f[]oo\" title=\"ti() tle\"/></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "alt goes crazy", %{messages: messages} do
      markdown = "![foo[([])]](/url 'title')\n"
      html     = "<p><img src=\"/url\" alt=\"foo[([])]\" title=\"title\"/></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "url escapes of coure", %{messages: messages} do
      markdown = "![foo](/url no title)\n"
      html     = "<p><img src=\"/url%20no%20title\" alt=\"foo\"/></p>\n"

      assert as_html(markdown) == {html, messages}
    end

  end

  describe "Autolinks" do
    test "that was easy", %{messages: messages} do
      markdown = "<http://foo.bar.baz>\n"
      html     = "<p><a href=\"http://foo.bar.baz\">http://foo.bar.baz</a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "as was this", %{messages: messages} do
      markdown = "<irc://foo.bar:2233/baz>\n"
      html     = "<p><a href=\"irc://foo.bar:2233/baz\">irc://foo.bar:2233/baz</a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "good ol' mail", %{messages: messages} do
      markdown = "<mailto:foo@bar.baz>\n"
      html     = "<p><a href=\"mailto:foo@bar.baz\">foo@bar.baz</a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "we know what mail is", %{messages: messages} do
      markdown = "<foo@bar.example.com>\n"
      html     = "<p><a href=\"mailto:foo@bar.example.com\">foo@bar.example.com</a></p>\n"

      assert as_html(markdown) == {html, messages}
    end

    test "not really a link", %{messages: messages} do
      markdown = "<>\n"
      html = "<p>&lt;&gt;</p>\n"
      assert as_html(markdown) == {html, messages}
    end
  end
end
