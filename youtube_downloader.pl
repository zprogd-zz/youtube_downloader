#!/usr/bin/perl

use utf8;
use open ':std', ':encoding(utf8)';

if ($#ARGV < 0) {
  print "Usage: youtube_download.pl URL_to_youtube\n";
  exit;
}

my $html=`wget -q -O - $ARGV[0]`;

my ($mpg_stream_settings) = $html =~ m/url_encoded_fmt_stream_map(.+)/i;
$mpg_stream_settings =~ s/\%([a-fA-F0-9]{2})/pack('C', hex($1))/eg;

my ($url) = $mpg_stream_settings =~ m/(http.+?)\\u0026/i;
my ($video_format) = $mpg_stream_settings =~ m/video\/(.+?);/i;

my ($filename) = $html =~ m/<title>(.+)<\/title>/si;
$filename =~ s/[^\w\d]+/_/g;
$filename =~ s/_youtube//ig;
$filename .= ".$video_format";

`wget -O $filename "$url"`;
