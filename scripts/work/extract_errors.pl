#!/usr/bin/perl 
#

use strict;
use warnings;
 
#my $filename = 'duplicates.txt';
#open(my $fh, '<:encoding(UTF-8)', $filename)
  #or die "Could not open file '$filename' $!";

while (my $row = <STDIN>) {
  chomp $row;
  if ( $row =~ m/(.*?):.*In\s*function\s*\`(.*)\':(.*?):(.*?):.*multiple\s*definition\s*of\s*\`(.*?)\'(.*?):(.*?):(.*?):.*/ )
  #if ( $row =~ m/(.*?):/ )
	  {
		  my $var1 = $1;
		  my $var2 = $2;
		  my $var3 = `basename $3`;
		  chop $var3;
		  my $var4 = $4;
		  my $var5 = $5;
		  my $var6 = $6;
		  my $var7 = `basename $7`;
		  chop $var7;
		  my $var8 = $8;

		  #print "1->".$var1."\n";
		  #print "2->".$var2."\n";
		  #print "3->".$var3."\n";
		  #print "4->".$var4."\n";
		  #print "5->".$var5."\n";
		  #print "6->".$var6."\n";
		  #print "7->".$var7."\n";
		  #print "8->".$var8."\n";
		  print $var1."#".$var2."#".$var3."#".$var4."#".$var5."#".$var6."#".$var7."\n";
		  next;
	  }
# ColorMaintenance.o:(.data.rel.local+0x400): multiple definition of `outputBinNames'ControlUnitConfig.o:(.data.rel.local+0x3c0): first defined here`
  if ( $row =~ m/(.*?):\((.*?)\):\s*multiple\s*definition\s*of\s*\`(.*?)\'(.*?):(.*?):\s*first\s*defined\s*here/ )
  #if ( $row =~ m/(.*?):/ )
	  {
		  my $var1 = $1;
		  my $var2 = $2;
		  my $var3 = " ";
		  my $var4 = " ";
		  my $var5 = $3;
		  my $var6 = $4;
		  my $var7 = $5;
		  my $var8 = " ";

		  #print "1->".$var1."\n";
		  #print "2->".$var2."\n";
		  #print "3->".$var3."\n";
		  #print "4->".$var4."\n";
		  #print "5->".$var5."\n";
		  #print "6->".$var6."\n";
		  #print "7->".$var7."\n";
		  #print "8->".$var8."\n";
	  print $var1."#".$var2."#".$var3."#".$var4."#".$var5."#".$var6."#".$var7."\n";
	  }
	  #print "NEXT LINE\n";
}

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s  };
