package view;

use base 'ASF::View'; # see https://svn.apache.org/repos/infra/websites/cms/build/lib/ASF/View.pm

use strict;
use warnings;
use ASF::Util qw/read_text_file sort_tables parse_filename/;
use Dotiac::DTL qw/Template *TEMPLATE_DIRS/;
use Dotiac::DTL::Addon::markup;
use File::Basename;
use Data::Dumper;
use Date::Format;
use Date::Parse;
use LWP::Simple;
use File::Temp qw/tempfile/;
use HTML::Entities;
    
# set to 1 for some debug output
my $DEBUG = 1;
$Data::Dumper::Indent = 0;

sub debug { print STDERR "[debug] " . shift . "\n" if $DEBUG; }

# postprocessing tags   
sub recent_news { return `xsltproc stylesheets/recent_news.xsl content/news.xml`; }
sub project_news { return `xsltproc stylesheets/project_news.xsl content/news.xml`; }
sub format_date { return time2str("%A, %e %B %Y", str2time(shift)); } ## xsltproc doesn't know XSLT 2.0 
sub format_date_short { return time2str("%a, %e %b %Y", str2time(shift)); } ## xsltproc doesn't know XSLT 2.0 format-date function
sub changes_report
{
    my ($project, $tag) = split '/', shift;
    my $url = "https://gitbox.apache.org/repos/asf?p=velocity-$project.git;a=blob_plain;f=src/changes/changes.xml;hb=$tag";
    print("Generating changes report from " . $url . "\n");
    my $xml = get $url;

    # hack to fix an error in the XML up to 1.7
    $xml =~ s/<scope>/&lt;scope&gt;/;

    my ($fh, $filename) = tempfile("XXXXXX");
    print $fh $xml;
    close $fh;
    my $summary = `xsltproc stylesheets/releases_history.xsl $filename`;
    my $changes = `xsltproc stylesheets/changes.xsl $filename`;
    unlink $filename;
    return $summary . $changes;
}
sub source_file
{
    # Note: those contributions didn't make their way from svn to git
    # TODO - do something...
    my $url = "http://svn.apache.org/repos/asf/velocity/" . shift;
    my $content = get $url;

    $content = "" if not $content;

    # extension gives lexer used for code highlighting
    if ($url =~ /\.([a-z]+)$/i)
    {
        my $accepted = "java properties xml vm vtl vhtml";
        my $ext = lc $1;
        if (index($accepted, $ext) != -1)
        {
            $ext =~ s/vm|vtl|vhtml/velocity/;
            $content = ":::$ext\n$content";
        }
    }

    # indent as block of code
    $content =~ s/^/    /smg;

    # filename gives block title
    if ($url =~ /(\w+\.[a-z]+)$/)
    {
        my $filename = $1;
        $content = "\n\n#### [$filename]($url)\n\n$content";
    }

    return $content;
}
sub team()
{
    my $xml = get 'https://gitbox.apache.org/repos/asf?p=velocity-master.git;a=blob_plain;f=pom/pom.xml;hb=HEAD';
    my ($fh, $filename) = tempfile("XXXXXX");

    print $fh $xml;
    close $fh;
    my $pmc = `xsltproc stylesheets/pmc.xsl $filename`;
    my $commiters = `xsltproc stylesheets/commiters.xsl $filename`;
    my $emeriti = `xsltproc stylesheets/emeriti.xsl $filename`;
    unlink $filename;
    return $pmc . $commiters . $emeriti;
}

# pre-processing sub
sub preprocess {
    my $text = shift;
    my @params = shift;
    while($text =~ /\{\{\w+(?:\([^(){}]*\))?\}\}/)
    {
        my ($before, $tag, $after) = ($`, $&, $');
        $tag =~ s/^\{\{|\}\}$//g;
        $tag =~ m/(\w+)(?:\(([^()]*)\))?/;
        my ($method, $args) = ($1, $2);
        my $replacement = &{\&{$method}}($args) or debug "could not find tag sub $tag";
        $text = $before . $replacement . $after;
    }
    return $text;
}

# post-processing sub
sub postprocess {
    my $text = shift;
    my $escape_html = shift;
    my @params = shift;
    while($text =~ /\{\{\w+(?:\([^(){}]*\))?\}\}/)
    {
        my ($before, $tag, $after) = ($`, $&, $');
        $tag =~ s/^\{\{|\}\}$//g;
        $tag =~ m/(\w+)(?:\(([^()]*)\))?/;
        my ($method, $args) = ($1, $2);
        my $replacement = &{\&{$method}}($args) or debug "could not find tag sub $tag";
        $replacement = encode_entities($replacement) if ($escape_html);
        $text = $before . $replacement . $after;
    }
    # hack for {{{href}}link} syntax handling
    while ($text =~ /\{\{\{([^{}]+)\}([^{}]+)\}\}/)
    {
        my ($before, $url, $link, $after) = ($`, $1, $2, $');
        my $a = '<a href="' . $url . '">' . $link . '</a>';
        $a = encode_entities($a) if ($escape_html);
        $text = $before . $a . $after;
    }
    return $text;
}

# standard page
sub standard {
    my %args = @_;
    my $file = "content$args{path}";
    my $template = $args{template};

#debug "rendering file $file using template $template and args " .Dumper(\%args);
    read_text_file $file, \%args unless exists $args{content} and exists $args{headers};

    # find deeper left.nav
    $args{leftnav} = dirname("content/$args{path}");
    while ($args{leftnav} ne '/' and  ! -e "$args{leftnav}/left.nav") {
        $args{leftnav} = dirname($args{leftnav});
    }
    $args{leftnav} .= '/left.nav';
    
    $args{path} =~ s/\.\w+$/\.html/;
    $args{breadcrumbs} = view->can("breadcrumbs")->($args{path});

    my $page_path = $file;
    $page_path =~ s!\.[^./]+$!.page!;
    if (-d $page_path) {
        for my $f (grep -f, glob "$page_path/*.{mdtext,md}") {
            $f =~ m!/([^/]+)\.md(?:text)?$! or die "Bad filename: $f\n";
            $args{$1} = {};
            read_text_file $f, $args{$1};
        }
    }
    $args{content} = sort_tables($args{preprocess}
                                     ? Template($args{content})->render(\%args)
                                     : $args{content});

    $args{content} = preprocess($args{content}) if $args{preprocessing};
    my $processed = Template($template)->render(\%args);
    $processed = postprocess($processed, 0) if $args{postprocessing};
    return $processed, html => \%args;
}

# rss page
sub rss {
    my %args = @_;

    my $content = `xsltproc stylesheets/rss_news.xsl content/news.xml`;

    return (postprocess $content, 1), rss => \%args;
}

sub breadcrumbs {
    my @path = split m!/!, shift;
    pop @path if $path[-1] eq 'index.html';
    my $final = scalar @path ? pop @path : 'velocity';
    $final ||= "velocity";
    $final =~ s/\.html$//;
    $final =~ s/-/ /g;
    my @rv = ();
    my $relpath = "";
    for (@path) {
        $_ = lc;
        $relpath .= "$_/";
        $_ ||= "velocity";
        push @rv, qq(<a href="$relpath">$_</a>);
    }
    my $header = '<ul><li><a href="http://www.apache.org">apache</a></li><li>';
    my $path = scalar @path ? ( join "</li><li>", @rv ) . '</li><li>' : '';
    return $header . $path . '<a href="#">' . $final . '</a></li></ul>';        
}

# overridable internal sub for computing deps
# pass quick setting in 3rd argument to speed things up: 1 is faster than 2 or 3, but 3
# is guaranteed to work in 99.9% of all project builds.

sub fetch_deps {
    my ($path, $data, $quick) = @_;
    $quick //= 0;
    for (@{$path::dependencies{$path}}) {
        my $file = $_;
        my ($filename, $dirname) = parse_filename;
        for my $p (@path::patterns) {
            my ($re, $method, $args) = @$p;
            next unless $file =~ $re;
            if ($args->{headers}) {
                my $d = Data::Dumper->new([$args->{headers}], ['$args->{headers}']);
                $d->Deepcopy(1)->Purity(1);
                eval $d->Dump;
            }
            if ($quick == 1 or $quick == 2) {
                $file = "$filename" eq "index" ? $dirname : "$dirname$filename"; # no extension
                $data->{$file} = { path => $file, %$args };
                read_text_file "content/$_", $data->{$file}, $quick == 1;
            }
            else {
                local $ASF::Value::Offline = 1 if $quick == 3;
                my $s = view->can($method) or die "Can't locate method: $method\n";
                my (undef, $ext, $vars) = $s->(path => $file, %$args);
                $file = "$filename.$ext" eq "index.html" ? $dirname : "$dirname$filename.$ext";
                $data->{$file} = $vars;
            }
            last;
        }
        $data->{$file}->{headers}->{title} //= ucfirst $filename;
    }
}

1;

=head1 LICENSE

           Licensed to the Apache Software Foundation (ASF) under one
           or more contributor license agreements.  See the NOTICE file
           distributed with this work for additional information
           regarding copyright ownership.  The ASF licenses this file
           to you under the Apache License, Version 2.0 (the
           "License"); you may not use this file except in compliance
           with the License.  You may obtain a copy of the License at

             http://www.apache.org/licenses/LICENSE-2.0

           Unless required by applicable law or agreed to in writing,
           software distributed under the License is distributed on an
           "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
           KIND, either express or implied.  See the License for the
           specific language governing permissions and limitations
           under the License.
