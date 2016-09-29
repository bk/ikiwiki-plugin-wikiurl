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
	hook(type => "preprocess", id => "wikiurl", call => \&wikiurl);
}

sub wikiurl {
    my ($link, $ignore, %params) = @_;
    # support [[!wikiurl url="MyUrl"]] syntax variation
    if ($link eq 'url' && length($ignore)) {
        $link = $ignore;
    }
    $link =~ s/ /_/g;
    my $pagename = $params{page};
    my $destpage = $params{destpage};
    my $is_previw = $params{preview};

    my $bestlink = bestlink($pagename, $link);

	if (! $destsources{$bestlink}) {
		$bestlink = htmlpage($bestlink);
		if (!$destsources{$bestlink} && $config{cgiurl}) {
            # Name could not be resolved: return a path to the URL to create the
            # corresponding page.
            $bestlink = IkiWiki::cgiurl(do=>'create', page=>$link, from=>$pagename);
        }
    }
	$bestlink = IkiWiki::abs2rel(
        $bestlink, IkiWiki::dirname(htmlpage($destpage)));
	$bestlink = IkiWiki::beautify_urlpath($bestlink);

    return $bestlink;
}

1;
