#!/usr/bin/perl 
use CGI '-utf8';
use CGI::Carp qw(warningsToBrowser fatalsToBrowser); 
use warnings;
use strict;
use utf8;
binmode(STDIN, ":utf8");
binmode STDOUT, ':utf8';

use Encode qw(encode from_to);
use URI::Escape qw(uri_unescape uri_escape);
use JSON::XS;
use lib '.';
use osmc qw(OsmcSymbol);

my $q = CGI->new;
my $str  = $q->param('osmc') || '';
   $str  = uri_unescape($str);
my $size = $q->param('size') || '40';
my $opt  = $q->param('opt')  || 'opt';
my $out  = $q->param('out')  || 'svg'; 


if($out eq 'svg' || $out eq 'svgerr'){ 

  print "Content-Type: image/svg+xml; charset=utf-8\r\n".
        "Access-Control-Allow-Origin: *\r\n\r\n";

  my ($svg,$err) = OsmcSymbol($str,$size,$opt);

  print $svg;
  
  if($out eq 'svgerr'){ 
    print "\n\n<!--\n".encode('utf-8',$err)."-->";
    }
  }

if($out eq 'json'){  

  print "Content-Type: application/json; charset=utf-8\r\n";
  print "Access-Control-Allow-Origin: *\r\n\r\n";

  my ($svg,$err) = OsmcSymbol($str,$size,$opt);
  my $o;
  $o->{svg}   = $svg;
  $o->{error} = $err;
  print  encode_json($o);
  }
  

if($out eq 'err'){ 
  print "Content-Type: text/text; charset=utf-8\r\n".
        "Access-Control-Allow-Origin: *\r\n\r\n";
  my ($svg,$err) = OsmcSymbol($str,$size,$opt);
  print "\n\n<!--\n$err-->";
  }

  
1;
