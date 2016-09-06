#!/usr/bin/perl



use warnings;
use utf8;
binmode STDOUT, ":utf8";


my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";


my $found = 0;
while (my $row = <$fh>) {
    chomp $row;
	if ( $found == 1 )
	{
		#this is the row
		#extract max number of pages and print it on stdout

		if ( $row =~ m/\?pagina=(\d*)/ )
		{
			print $1;
			exit 0;
		}
	}
    if ($row =~ m/\?pagina=5/)  # detected a new record
    {
		$found = 1;
		next;
	}
	else
	{
		next;
	}
}



close $fh;
