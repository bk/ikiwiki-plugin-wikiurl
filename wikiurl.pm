#!/usr/bin/perl
#
# Take a [[WikiLink]] and output the url/path in-place
# E.g.: '[[!wikiurl RecentChanges]]' => '/recentchanges/'
#
package IkiWiki::Plugin::wikiurl;

use warnings;
use strict;
use IkiWiki 3.00;

sub import {
    hook(type => "scan", id => "wikiurl", call => \&scan);
	hook(type => "preprocess", id => "wikiurl", call => \&wikiurl);
}

sub wikiurl {
    my ($link, $ignore, %params) = @_;
    # support [[!wikiurl url="MyUrl"]] syntax variation
    if ($link eq 'url' && length($ignore)) {
        $link = $ignore;
    }
    $link =~ s/ /_/g;
    my $backlink = $params{backlink} || 0;
    my $pagename = $params{page};
    my $destpage = $params{destpage};
    my $is_preview = $params{preview};

    my $bestlink = bestlink($pagename, $link);

    if (! $destsources{$bestlink}) {
        $bestlink = htmlpage($bestlink);
        if (!$destsources{$bestlink} && $config{cgiurl}) {
            # Name could not be resolved: return a path to the URL to create the
            # corresponding page.
            $bestlink = IkiWiki::cgiurl(do=>'create', page=>$link, from=>$pagename);
            if ($bestlink =~ /<a /i && $bestlink =~ / href="(.*?)"/i) {
                $bestlink = $1;
            }
        }
    }
    $bestlink = IkiWiki::abs2rel(
        $bestlink, IkiWiki::dirname(htmlpage($destpage)));
    $bestlink = IkiWiki::beautify_urlpath($bestlink);

    return $bestlink;
}

sub scan {
    my %params = @_;
    my $pagename = $params{page};
    my $content = $params{content};
    my @wikiurls = ($content =~ /\[\[\!wikiurl\s+(.*?)\s*\]\]/sg);
    foreach my $link (@wikiurls) {
        # We don't have to worry about other parameters than url and backlink,
        # so there is no need for any real parameter parsing
        next if $link =~ /\bbacklink=.?(?:0|no|off|false)\b/i;
        next unless $link =~ s/\s*backlink=\S+\s*//i;
        $link =~ s/^\s*(?:url=)?["']?(.+?)["']?\s*$/$1/i;
        next unless $link;
        add_link($pagename, linkpage($link));
    }
}

1;
