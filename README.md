# IkiWiki::Plugin::wikilink

Plugin for outputting the path of IkiWiki `[[WikiLinks]]` as pure text.

## Synopsis

```
Directive                    Example output
---------------------------  -----------------
[[!wikiurl RecentChanges]]   ../recentchanges/
[[!wikiurl some_page]]       ../some_page/
[[!wikiurl url="Some page"]] ../some_page/
```

Note that the output is sensitive to the location of the page where the
directive is placed. In most cases, paths are relative. This may, however,
depend on the IkiWiki configuration and other factors.

## Installation

1. Copy `wikiurl.pm` to your local IkiWiki plugin directory - normally
`~/.ikwiki/IkiWiki/Plugin/`.
2. Add it to the `add_plugins` setting of the `*.setup` file for your wiki.

## Motivation

This plugin can for instance be used in conjunction with markup processors such
as [ikiwiki-pandoc](https://github.com/sciunto-org/ikiwiki-pandoc), where
accessing IkiWiki's path resolution is essential for using internal
reference-style links effectively.

## License

This software is copyright (c) 2016 by Baldur Kristinsson.

This is free software with a dual Artistic/GPL license. The terms for using,
copying, distributing and modifying it are the same as for Perl 5.
