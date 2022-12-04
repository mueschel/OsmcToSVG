#!/usr/bin/perl 
use CGI ':standard';
use CGI::Carp qw(warningsToBrowser fatalsToBrowser); 
use warnings;
use strict;
use utf8;
binmode(STDIN, ":encoding(UTF-8)");
binmode STDOUT, ':utf8';
use List::Util qw(min max);

my $svg = '<?xml version="1.0" encoding="UTF-8"?>'."\n".
'<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="%WIDTH%px" height="%HEIGHT%px" viewBox="0 0 %WIDTH% %HEIGHT%" version="1.1">';          

my @colornames = qw(grey gray red yellow orange white purple black green blue brown pink);
my @colors     = qw(aaa  aaa  f00 ff0    f80    fff   a0a    000   080   00b  862   f88);  

my @bgshapes   = qw(circle round frame);

my @fgshapes   = qw(corner cross bar pointer stripe dot triangle diamond_line lower slash backslash triangle_turned  
                    rectangle  diamond  rectangle_line right x hiker circle triangle_line turned_T fork hexagon 
                    hiker wheel shell shell_modern arch bowl crest drop drop_line diamond_right L);
my @fgaddshapes = qw(left upper corner_left left_pointer right_pointer arrow right_arrow left_arrow upper_bowl house diamond_left bicycle);

#Not yet supported:
# diamond_corner horse tower

my $svg_wheel = <<HE;
<svg  width="&width&px" height="&height&px" viewBox="0 0 15 15"><g>
<path style="fill:none;stroke-width:1.30268;stroke-linecap:butt;stroke-linejoin:miter;stroke:&color&;stroke-opacity:1;stroke-miterlimit:4;" d="M 15.00625 1044.359985 C 15.00625 1048.203735 11.8875 1051.322485 8.0375 1051.322485 C 4.19375 1051.322485 1.075 1048.203735 1.075 1044.359985 C 1.075 1040.516235 4.19375 1037.397485 8.0375 1037.397485 C 11.8875 1037.397485 15.00625 1040.516235 15.00625 1044.359985 Z M 15.00625 1044.359985 " transform="matrix(0.625,0,0,0.625,2.5,-645.224991)"/>
<path style="fill:none;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke:&color&;stroke-opacity:1;stroke-miterlimit:4;" d="M 9.2125 1044.359985 C 9.2125 1045.028735 8.66875 1045.572485 8 1045.572485 C 7.33125 1045.572485 6.7875 1045.028735 6.7875 1044.359985 C 6.7875 1043.691235 7.33125 1043.147485 8 1043.147485 C 8.66875 1043.147485 9.2125 1043.691235 9.2125 1044.359985 Z M 9.2125 1044.359985 " transform="matrix(0.625,0,0,0.625,2.5,-645.224991)"/>
<path style=" stroke:none;fill-rule:evenodd;fill:&color&;fill-opacity:1;" d="M 3.542969 7.132812 L 6.625 7.132812 L 6.625 7.890625 L 3.542969 7.890625 Z M 3.542969 7.132812 "/>
<path style=" stroke:none;fill-rule:evenodd;fill:&color&;fill-opacity:1;" d="M 8.449219 7.117188 L 11.53125 7.117188 L 11.53125 7.878906 L 8.449219 7.878906 Z M 8.449219 7.117188 "/>
<path style=" stroke:none;fill-rule:evenodd;fill:&color&;fill-opacity:1;" d="M 5.832031 3.851562 L 7.371094 6.523438 L 6.714844 6.90625 L 5.171875 4.234375 Z M 5.832031 3.851562 "/>
<path style=" stroke:none;fill-rule:evenodd;fill:&color&;fill-opacity:1;" d="M 8.292969 8.097656 L 9.835938 10.769531 L 9.175781 11.148438 L 7.636719 8.476562 Z M 8.292969 8.097656 "/>
<path style=" stroke:none;fill-rule:evenodd;fill:&color&;fill-opacity:1;" d="M 9.820312 4.226562 L 8.28125 6.898438 L 7.621094 6.519531 L 9.164062 3.847656 Z M 9.820312 4.226562 "/>
<path style=" stroke:none;fill-rule:evenodd;fill:&color&;fill-opacity:1;" d="M 7.382812 8.484375 L 5.839844 11.15625 L 5.179688 10.777344 L 6.722656 8.105469 Z M 7.382812 8.484375 "/>
</g></svg>
HE

my $svg_hiker = <<HE;
<svg width="&width&px" height="&height&px" viewBox="0 0 15 15"><g>
<path style=" stroke:none;fill-rule:evenodd;fill:&color&;fill-opacity:1;" d="M 8.832031 3.367188 C 8.832031 3.824219 8.382812 4.191406 7.828125 4.191406 C 7.273438 4.191406 6.824219 3.824219 6.824219 3.367188 C 6.824219 2.914062 7.273438 2.546875 7.828125 2.546875 C 8.382812 2.546875 8.832031 2.914062 8.832031 3.367188 Z M 8.832031 3.367188 "/>
<path style="fill-rule:evenodd;fill:&color&;fill-opacity:1;stroke-width:1.10218;stroke-linecap:butt;stroke-linejoin:round;stroke:&color&;stroke-opacity:1;stroke-miterlimit:4;" d="M 266.893377 1022.327224 L 268.83388 1022.328588 L 268.836176 1026.359609 L 266.895672 1026.358244 Z M 266.893377 1022.327224 " transform="matrix(0.614079,0.116329,-0.158304,0.604619,2.5,-645.224991)"/>
<path style="fill:none;stroke-width:0.611824;stroke-linecap:round;stroke-linejoin:miter;stroke:&color&;stroke-opacity:1;stroke-miterlimit:4;" d="M 13.76875 1041.128735 L 11.30625 1051.903735 " transform="matrix(0.625,0,0,0.625,2.5,-645.224991)"/>
<path style="fill:none;stroke-width:1.22365;stroke-linecap:round;stroke-linejoin:round;stroke:&color&;stroke-opacity:1;stroke-miterlimit:4;" d="M 12.225 1043.678735 L 9.63125 1043.078735 L 8.81875 1040.672485 " transform="matrix(0.625,0,0,0.625,2.5,-645.224991)"/>
<path style="fill:none;stroke-width:1.83547;stroke-linecap:round;stroke-linejoin:miter;stroke:&color&;stroke-opacity:1;stroke-miterlimit:4;" d="M 3.99375 1051.341235 L 6.50625 1043.334985 " transform="matrix(0.625,0,0,0.625,2.5,-645.224991)"/>
<path style="fill:none;stroke-width:1.83547;stroke-linecap:round;stroke-linejoin:miter;stroke:&color&;stroke-opacity:1;stroke-miterlimit:4;" d="M 9.33125 1051.322485 L 7.05 1043.309985 " transform="matrix(0.625,0,0,0.625,2.5,-645.224991)"/>
<path style="fill:none;stroke-width:3.05912;stroke-linecap:round;stroke-linejoin:miter;stroke:&color&;stroke-opacity:1;stroke-miterlimit:4;" d="M 7.84375 1040.872485 L 6.85 1044.328735 " transform="matrix(0.625,0,0,0.625,2.5,-645.224991)"/>
</g></svg>
HE

my $svg_shell = <<HE;
<svg width="&width&px" height="&height&px" viewBox="0 0 15 15"><g>
<path style="fill:none;stroke-width:0.06;stroke-linecap:butt;stroke-linejoin:miter;stroke:&color&;stroke-opacity:1;stroke-miterlimit:10;" d="M 0.5 0.1 L 0 0.3 M 0.5 0.1 L 0.1 0.5 M 0.5 0.1 L 0.2 0.65 M 0.5 0.1 L 0.35 0.8 M 0.5 0.1 L 0.5 0.85 M 0.5 0.1 L 0.65 0.8 M 0.5 0.1 L 0.8 0.65 M 0.5 0.1 L 0.9 0.5 M 0.5 0.1 L 1 0.3 " transform="matrix(15,0,0,15,0,0)"/>
</g></svg>
HE

my $svg_shell_modern = <<HE;
<svg width="&width&px" height="&height&px" viewBox="0 0 15 15"><g>
<path style="fill:none;stroke-width:0.06;stroke-linecap:butt;stroke-linejoin:miter;stroke:&color&;stroke-opacity:1;stroke-miterlimit:10;" d="M 0.1 0.5 L 0.3 0 M 0.1 0.5 L 0.5 0.1 M 0.1 0.5 L 0.65 0.2 M 0.1 0.5 L 0.8 0.35 M 0.1 0.5 L 0.85 0.5 M 0.1 0.5 L 0.8 0.65 M 0.1 0.5 L 0.65 0.8 M 0.1 0.5 L 0.5 0.9 M 0.1 0.5 L 0.3 1 " transform="matrix(15,0,0,15,0,0)"/>
</g></svg>
HE

my $svg_bicycle = <<HE;
<svg width="&width&px" height="&height&px" viewBox="0 0 15 15"><g>
 <circle cx="215" cy="409" r="161" style="fill:none; stroke:black; stroke-width:40px" transform="matrix(0.020,0,0,0.020,-2.3,2)"/>
 <circle cx="790" cy="406" r="161" style="fill:none; stroke:black; stroke-width:40px" transform="matrix(0.020,0,0,0.020,-2.3,2)"/>
 <path style="fill:black; fill-rule:evenodd; stroke:none"
       d="M 429.48437,15.467118 C 296.91790,16.759190 319.39993,1.7711686 248.07762,230.98455 C 189.97511,414.12586 196.30387,394.15363 196.00000,407.00000 C 195.78704,416.98022 203.84333,424.89312 213.96694,425.57043 C 235.02054,423.44166 226.16492,427.84741 299.15748,201.18078 C 565.86963,482.53640 465.80592,436.91194 609.34064,442.62576 C 797.98299,440.81686 813.31557,452.44550 815.55516,424.79518 C 815.29674,415.40613 810.90371,409.80716 681.43820,121.67535 L 693.84208,87.564675 L 736.48042,86.789433 L 734.92994,51.128275 L 576.00521,51.128275 C 561.96471,70.337063 581.69033,70.250925 652.75423,86.014190 L 640.35035,120.90010 L 323.27614,121.67535 C 344.63838,47.079788 332.57905,51.731243 428.70913,51.903518 L 429.48437,15.467118 z     M 314.11415,159.91012 L 624.37752,159.36001 L 534.70921,400.30922 L 314.11415,159.91012 z     M 661.78516,174.21304 L 573.76718,405.26023 L 766.30650,405.81034 L 661.78516,174.21304 z" 
       transform="matrix(0.020,0,0,0.020,-2.3,2)" />
</g></svg>
HE


sub OsmcSymbol  {
  my ($str,$size,$opt) = @_;
  
  my $error = "";
  my @out;
  my $height = $size;
  my $width = $size;
     $width *= 1.6 if $opt =~ /rect/;

  my $hu = $height/20;
  my $wu = $width/20;
  my $minsize = min($height,$width);
     
  my @osmc = split(':',$str);
  

  $svg =~ s/%HEIGHT%/$height/g;
  $svg =~ s/%WIDTH%/$width/g;
  push (@out,$svg);
  
  my (@fgshape,@fgcolor,@fg2color,@errfg);
  my ($waycolor) = isValidColor($osmc[0]);
  my ($bgshape,$bgcolor,$bg2color,$errbg) = isValidBackground($osmc[1]);
  shift @osmc;
  ($fgshape[0],$fgcolor[0],$fg2color[0],$errfg[0]) = isValidForeground($osmc[1]);
  shift @osmc if $fgshape[0] ne 'error';
  ($fgshape[1],$fgcolor[1],$fg2color[1],$errfg[1]) = isValidForeground($osmc[1]);
  shift @osmc if $fgshape[1] ne 'error';

  $errfg[1] = '' unless $fgshape[1];

  my $text        = substr($osmc[1],0,4) || '';
  my ($textcolor) = isValidColor($osmc[2]);    
  
  if($bgshape eq '') {
    push (@out, '<rect x="0" y="0" width="'.$width.'" height="'.$height.'" style="fill:'.$bgcolor.';fill-opacity:1;stroke:none;"/>');
    push (@out, ' <clipPath id="outside"> <rect  x="0" y="0" width="'.$width.'" height="'.$height.'"  /></clipPath>');
    }
  elsif($bgshape eq 'circle') {
    push (@out, '<circle cx="'.($width/2).'" cy="'.($height/2).'" r="'.($hu*9).'" stroke="'.$bgcolor.'" stroke-width="'.($hu*2).'" fill="'.$bg2color.'" />');
    push (@out, ' <clipPath id="outside"> <circle cx="'.($width/2).'" cy="'.($height/2).'" r="'.($hu*8).'" /></clipPath>');
    }
  elsif($bgshape eq 'round') {
    push (@out, '<circle cx="'.($width/2).'" cy="'.($height/2).'" r="'.($hu*9).'" stroke="'.$bgcolor.'" stroke-width="'.($hu*2).'" fill="'.$bgcolor.'" />');
    push (@out, ' <clipPath id="outside"> <circle cx="'.($width/2).'" cy="'.($height/2).'" r="'.($height/2).'" /></clipPath>');
    }
  elsif($bgshape eq 'frame') {
    push (@out, '<rect x="'.($hu).'" y="'.($hu).'" width="'.($width-$hu*2).'" height="'.($height-$hu*2).'" fill="'.$bg2color.'" stroke="'.$bgcolor.'" stroke-width="'.($hu*2).'"/>');
    push (@out, ' <clipPath id="outside"> <rect x="'.($hu*2).'" y="'.($hu*2).'" width="'.($width-$hu*4).'" height="'.($height-$hu*4).'" /></clipPath>');
    }
  
  push(@out, '<g clip-path="url(#outside)">');
  for my $i (0..1) {
    next if $fgshape[$i] eq '' && $fgcolor[$i] eq '';
    if($fgshape[$i] eq '') {
      push (@out, '<rect x="0" y="0" width="'.($width).'" height="'.($height).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      }      
    if($fgshape[$i] eq 'corner') {
      push (@out, "<path fill=\"$fgcolor[$i]\" d=\"M 0 0 L $width $height L $width 0 Z M 0 0 \"/>");
      if($fg2color[$i] ne $fgcolor[$i]) {
        push (@out, "<path fill=\"$fg2color[$i]\" d=\"M 0 0 L $width $height L 0 $height Z M 0 0 \"/>");
        }
      }
    if($fgshape[$i] eq 'corner_left') {
      push (@out, "<path fill=\"$fgcolor[$i]\" d=\"M 0 0 L 0 $height L $width 0 Z M 0 0 \"/>");
      if($fg2color[$i] ne $fgcolor[$i]) {
        push (@out, "<path fill=\"$fg2color[$i]\" d=\"M $width 0 L $width $height L 0 $height Z M 0 0 \"/>");
        }
      }
    if($fgshape[$i] eq 'bar' || $fgshape[$i] eq 'cross') {
      push (@out, '<rect x="'.(0).'" y="'.($hu*7).'" width="'.($width).'" height="'.($hu*6).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      }
    if($fgshape[$i] eq 'stripe' || $fgshape[$i] eq 'cross') {
      push (@out, '<rect x="'.($wu*7).'" y="'.(0).'" width="'.($wu*6).'" height="'.($height).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      }    
    if($fgshape[$i] eq 'slash' || $fgshape[$i] eq 'x') {
      push (@out, '<path  d="M '.$width.' 0 L 0 '.$height.'" fill="none" stroke="'.$fgcolor[$i].'" stroke-width="'.($hu*3).'"/>');
      }
    if($fgshape[$i] eq 'backslash' || $fgshape[$i] eq 'x') {
      push (@out, '<path  d="M 0 0 L '.$width.' '.$height.'" fill="none" stroke="'.$fgcolor[$i].'" stroke-width="'.($hu*3).'"/>');
      } 
    if($fgshape[$i] eq 'dot') {
      push (@out, '<circle cx="'.($width/2).'" cy="'.($height/2).'" r="'.($hu*6.5).'" stroke="none" fill="'.$fgcolor[$i].'" />');
      }
    if($fgshape[$i] eq 'circle') {
      push (@out, '<circle cx="'.($width/2).'" cy="'.($height/2).'" r="'.($hu*6.5).'" stroke="'.$fgcolor[$i].'" stroke-width="'.($hu*2).'" fill="none" />');
      }    
    if($fgshape[$i] eq 'pointer' || $fgshape[$i] eq 'right_pointer') {
      push (@out, '<path  d="M '.($wu*3).' '.($hu*3).' L '.($wu*3).' '.($hu*17).' L '.($wu*17).' '.($hu*10).' Z" fill="'.$fgcolor[$i].'" stroke="none"/>');
      } 
    if($fgshape[$i] eq 'left_pointer') {
      push (@out, '<path  d="M '.($wu*17).' '.($hu*3).' L '.($wu*17).' '.($hu*17).' L '.($wu*3).' '.($hu*10).' Z" fill="'.$fgcolor[$i].'" stroke="none"/>');
      } 
    if($fgshape[$i] eq 'triangle') {
      push (@out, '<path  d="M '.($wu*3).' '.($hu*17).' L '.($wu*17).' '.($hu*17).' L '.($wu*10).' '.($hu*3).' Z" '.
                        'fill="'.$fgcolor[$i].'" stroke="none"/>');
      } 
    if($fgshape[$i] eq 'triangle_line') {
      push (@out, '<path d="M '.($wu*3).' '.($hu*17).' L '.($wu*17).' '.($hu*17).' L '.($wu*10).' '.($hu*3).' L '.($wu*3).' '.($hu*17).' Z" '.
                        'transform="scale(0.7)" style="transform-origin:50%" fill="none" stroke="'.$fgcolor[$i].'" stroke-width="'.($hu*3).'"/>');
      } 
    if($fgshape[$i] eq 'triangle_turned') {
      push (@out, '<path  d="M '.($wu*3).' '.($hu*3).' L '.($wu*17).' '.($hu*3).' L '.($wu*10).' '.($hu*17).
                        '" fill="'.$fgcolor[$i].'" stroke="none"/>');
      }   
    if($fgshape[$i] eq 'lower') {
      push (@out, '<rect x="0" y="'.($height/2).'" width="'.($width).'" height="'.($height/2).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      }      
    if($fgshape[$i] eq 'upper') {
      push (@out, '<rect x="'.(0).'" y="'.(0).'" width="'.($width).'" height="'.($height/2).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      }      
    if($fgshape[$i] eq 'right') {
      push (@out, '<rect x="'.($width/2).'" y="'.(0).'" width="'.($width/2).'" height="'.($height).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      }    
    if($fgshape[$i] eq 'left') {
      push (@out, '<rect x="'.(0).'" y="'.(0).'" width="'.($width/2).'" height="'.($height).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      }    
    if($fgshape[$i] eq 'rectangle') {
      push (@out, '<rect x="'.($wu*5).'" y="'.($hu*5).'" width="'.($wu*10).'" height="'.($hu*10).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      }        
    if($fgshape[$i] eq 'rectangle_line') {
      push (@out, '<rect transform="scale(0.8)" style="transform-origin:50%" x="'.($wu*5).'" y="'.($hu*5).'" width="'.($wu*10).'" height="'.($hu*10).
                        '" fill="none" stroke="'.$fgcolor[$i].'" stroke-width="'.($hu*3).'"/>');
      }        
    if($fgshape[$i] eq 'diamond') {
     push (@out, '<path d="M '.($width/2).' '.($hu*4).' L '.($width/2).' '.($hu*16).' L '.($wu*1).' '.($height/2).' Z'.
                        '" fill="'.$fgcolor[$i].'" stroke="none" />');
     push (@out, '<path d="M '.($width/2).' '.($hu*4).' L '.($width/2).' '.($hu*16).' L '.($wu*19).' '.($height/2).' Z'.
                        '" fill="'.$fg2color[$i].'" stroke="none" />');                        
      } 
    if($fgshape[$i] eq 'diamond_line') {
      push (@out, '<rect transform="scale(0.8 0.5) rotate(45) " style="transform-origin:50%" x="'.($wu*5).'" y="'.($hu*5).'" width="'.($wu*10).'" height="'.($hu*10).
                        '" fill="none" stroke="'.$fgcolor[$i].'" stroke-width="'.($hu*3).'"/>');
      } 
    if($fgshape[$i] eq 'turned_T') {
      push (@out, '<rect x="'.($wu*3).'" y="'.($hu*14).'" width="'.($wu*14).'" height="'.($hu*2).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      push (@out, '<rect x="'.($wu*9).'" y="'.($hu*4).'" width="'.($wu*2).'" height="'.($hu*12).'" fill="'.$fg2color[$i].'" stroke="none"/>');
      }      
    if($fgshape[$i] eq 'fork') {  
      push (@out, '<rect x="'.($wu*9).'" y="'.($hu*9).'" width="'.($wu*11).'" height="'.($hu*2).'" fill="'.$fgcolor[$i].'" stroke="none"/>');
      push (@out, '<path d="M '.(-$wu*1).' '.($hu*1).' L '.($wu*9).' '.($height/2).' L '.(-$wu*1).' '.($hu*19).
                        '" stroke="'.$fg2color[$i].'" stroke-width="'.($hu*2).'" fill="none" />');
      }
    if($fgshape[$i] eq 'hexagon') {  
      push (@out, '<path d="M '.(0).' '.($hu*10).' L '.($hu*3).' '.($hu*5.5).' L '.($hu*8).' '.($hu*5.5).' L '.($hu*11).' '.($hu*10).' L '.($hu*8).' '.($hu*14.5).' L '.($hu*3).' '.($hu*14.5).' L '.(0).' '.($hu*10).' Z'.
                        '" fill="'.$fgcolor[$i].'" stroke="none" transform=" scale(1.5) translate('.($width/2-$hu*5.5).')"  style="transform-origin:50%"/>');
      }
    if($fgshape[$i] eq 'arch') {
      push (@out, '<path style="fill:none;stroke-width:0.22;stroke-linecap:butt;stroke-linejoin:miter;stroke:'.$fgcolor[$i].';stroke-opacity:1;stroke-miterlimit:10;" d="M 0.25 0.9 L 0.25 0.5 C 0.25 0.166667 0.75 0.166667 0.75 0.5 L 0.75 0.9 " transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }
    if($fgshape[$i] eq 'arrow' || $fgshape[$i] eq 'right_arrow') {
      push (@out, '<path style="fill:'.$fgcolor[$i].';stroke-width:0;stroke-linecap:butt;stroke-linejoin:miter;stroke:'.$fgcolor[$i].';stroke-opacity:1;stroke-miterlimit:10;" d="M 0.1 0.7 L 0.6 0.7 L 0.6 0.95 L 1 0.5 L 0.6 0.05 L 0.6 0.3 L 0.1 0.3 L 0.1 0.7" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }      
    if($fgshape[$i] eq 'left_arrow') {
      push (@out, '<path style="fill:'.$fgcolor[$i].';stroke-width:0;stroke-linecap:butt;stroke-linejoin:miter;stroke:'.$fgcolor[$i].';stroke-opacity:1;stroke-miterlimit:10;" d="M 0.9 0.7 L 0.4 0.7 L 0.4 0.95 L 0 0.5 L 0.4 0.05 L 0.4 0.3 L 0.9 0.3 L 0.9 0.7" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }         
    if($fgshape[$i] eq 'hiker') { 
      push (@out, finalize($svg_hiker,$fgcolor[$i],$height,$width));
      }
    if($fgshape[$i] eq 'bicycle') { 
      push (@out, finalize($svg_bicycle,$fgcolor[$i],$height,$width));
      }
    if($fgshape[$i] eq 'wheel') { 
       push (@out, finalize($svg_wheel,$fgcolor[$i],$height,$width));
      }
    if($fgshape[$i] eq 'shell') { 
      push (@out, finalize($svg_shell,$fgcolor[$i],$height,$width));
      }
    if($fgshape[$i] eq 'shell_modern') { 
      push (@out, finalize($svg_shell_modern,$fgcolor[$i],$height,$width));
      }
    if($fgshape[$i] eq 'bowl') {
      push (@out, '<path style="fill:'.$fgcolor[$i].';stroke-width:0.05;stroke:none;" d="M 0.05 0.5 L 0.95 0.5 A 0.45 0.45 180 0 1 0.05 0.5" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }
    if($fgshape[$i] eq 'upper_bowl') {
      push (@out, '<path style="fill:'.$fgcolor[$i].';stroke-width:0.05;stroke:none;" d="M 0.05 0.5 L 0.95 0.5 A 0.45 0.45 180 0 0 0.05 0.5" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }
    if($fgshape[$i] eq 'crest') {
      push (@out, '<path style="fill:'.$fgcolor[$i].';stroke-width:0.05;stroke:none;" d="M 0.15 0.5 L 0.15 0.05 L 0.85 0.05 L 0.85 0.5 A 0.4 0.45 180 0 1 0.5 0.95 A 0.4 0.45 180 0 1 0.15 0.5" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }
    if($fgshape[$i] eq 'house') {
      push (@out, '<path style="fill:'.$fgcolor[$i].';stroke-width:0.05;stroke:none;" d="M 0.2 0.9 L 0.2 0.4 L 0.5 0.1 L 0.8 0.4 L 0.8 0.9 L 0.2 0.9" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }      
    if($fgshape[$i] eq 'drop') {
      push (@out, '<path style="fill:'.$fgcolor[$i].';stroke-width:0.05;stroke:none;" d="M 0.5 0.2 L 0.95 0.5 L 0.5 0.8 A 0.335 0.335 0 1 1 0.5 0.2" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      } 
    if($fgshape[$i] eq 'drop_line') {
      if($fg2color[$i] ne $fgcolor[$i]) {
        push (@out, '<path style="fill:'.$fg2color[$i].';stroke-width:0.08;stroke-linecap:butt;stroke-linejoin:miter;stroke:'.$fgcolor[$i].';" d="M 0.5 0.2 L 0.95 0.5 L 0.5 0.8 A 0.335 0.335 0 1 1 0.5 0.2 Z" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
        }
      else {
        push (@out, '<path style="fill:none;stroke-width:0.08;stroke-linecap:butt;stroke-linejoin:miter;stroke:'.$fgcolor[$i].';" d="M 0.5 0.2 L 0.95 0.5 L 0.5 0.8 A 0.335 0.335 0 1 1 0.5 0.2 Z" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
        }
      }
    if($fgshape[$i] eq 'diamond_right') {
      push (@out, '<path style="fill:'.$fgcolor[$i].';stroke-width:0.05;stroke:none;" d="M 1 0.5 L 0.5 0 L 0.5 1 Z" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }       
    if($fgshape[$i] eq 'diamond_left') {
      push (@out, '<path style="fill:'.$fgcolor[$i].';stroke-width:0.05;stroke:none;" d="M 0 0.5 L 0.5 0 L 0.5 1 Z" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }       
    if($fgshape[$i] eq 'L') {
      push (@out, '<path style="fill:none;stroke-width:0.3;stroke:'.$fgcolor[$i].';" d="M 0.2 0.05 L 0.2 0.8 L 0.95 0.8" transform="matrix('.$minsize.',0,0,'.$minsize.','.(($width-$minsize)/2).','.(($height-$minsize)/2).')"/>');
      }    
    }
  if ($text) {
    my $fontsize = ($width/2.5);
    $fontsize = ($height/2.5) if $bgshape eq 'circle' or $bgshape eq 'round';
    push (@out,'<text x="'.($width/2).'" y="'.($hu*11).'"  style="font-family:sans-serif" text-anchor="middle" alignment-baseline="middle" dominant-baseline="middle" font-size="'.$fontsize.'" fill="'.($textcolor).'">'.$text.'</text>');
    }
    
  push (@out, "</g>");
  
  if ($opt =~ /border/) {
    push (@out, '<rect  x="0" y="0" width="'.($width).'" height="'.($height).'" fill="none" stroke-width="'.($hu/5).'" stroke="black"/>');
    }

  push (@out, "</svg>");
  
  $error .= ($errbg//'').($errfg[0]//'').($errfg[1]//'');
  return (join("\n",@out),$error);
  }

#Finish prepared images, add size and color  
sub finalize {
  my $img = $_[0];
  my $col = $_[1];
  my $height = $_[2];
  my $width = $_[3];
  $img =~ s/&color&/$col/g;
  $img =~ s/&height&/$height/g;
  $img =~ s/&width&/$width/g;
  return $img;    
  }

  
#Check color names, return hex code  
sub isValidColor {
  my $str = $_[0];
  my $color = '';
  my $error = '';
  return ('','') if $str eq '';
  
  for (my $i = 0; $i < scalar @colornames;$i++) {
    if ($str eq $colornames[$i]) { 
      $color = '#'.$colors[$i];
      last;
      }
    }
  if($color eq '') {
    $error .= "no valid color";
    }
  
  return ($color,$error);
  }

#Dissect background, return shape and color  
sub isValidBackground {
  my @str = split('_',$_[0]);
  
  my ($shape,$color,$color2,$error) = ('','','#fff','');
  for (my $i = 0; $i < scalar @colornames;$i++) {
    if ($str[0] eq $colornames[$i]) { 
      $color = '#'.$colors[$i];
      shift(@str);
      last;
      }
    }
  if (!$color) {
    $color = 'transparent';
    $error .= "Invalid color name $str[0]\n";
    }
  
  if(scalar @str) {
    for (my $i = 0; $i < scalar @colornames;$i++) {
      if ($str[0] eq $colornames[$i]) { 
        $color2 = '#'.$colors[$i];
        shift(@str);
        last;
        }
      }
    }
    
  if(scalar @str) {
    if(grep($str[0],@bgshapes)) {
      $shape = $str[0];
      }
    elsif($str[0] && $str[0] ne '') {
      $error .= "Invalid background shape name $str[0]\n";
      }
    }  
  return ($shape,$color,$color2,$error);
  }
  
#Dissect foreground, return shape and color  
sub isValidForeground {
  my $str = $_[0].'_';
  my ($shape,$color,$color2,$error) = ('','','','');
  $str =~ s/\s//g;
  for (my $i = 0; $i < scalar @colornames;$i++) {
    if ($str =~ /^$colornames[$i]_/) { 
      $color = '#'.$colors[$i];
      $str =~ s/^$colornames[$i]_//;
      last;
      }
    }
    
  for (my $i = 0; $i < scalar @colornames;$i++) {
    if ($str =~ /^$colornames[$i]_/) { 
      $color2 = '#'.$colors[$i];
      $str =~ s/^$colornames[$i]_//;
      last;
      }
    }
    
  chop($str);
  if(grep(/^$str$/,@fgshapes)) {
    $shape = $str;
    }
  elsif(grep(/^$str$/,@fgaddshapes)) {
    $shape = $str;
    $error .= "non-standard shape $str\n";
    }
  elsif($str && $str ne '') {
    $shape = 'error';
    $error .= "Invalid foreground shape name $str\n";
    }
  elsif($str eq '') {
    $error .= "Missing foreground shape is non-standard\n";
    }
  if ($color eq '' && $shape) {
    $color = '#000';
    }
  
  if($color2 ne '' && ($color2 ne 'red' || $shape ne 'diamond')) {
    $error .= "Second color name is non-standard\n";
    }
    
  if($color2 eq '') {
    $color2 = $color;
    }
  return ($shape,$color,$color2,$error);
  }
  
1;
