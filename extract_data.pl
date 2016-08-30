#!/usr/bin/perl


#use strict;
use warnings;
use utf8;
use Data::Dumper;
binmode STDOUT, ":utf8";

my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";

my $start=0;
my $stop=0;
my $count=-1;
my $first_found =0;
my @ArrayofHashes =0;
my $record_str="";
while (my $row = <$fh>) {
    chomp $row;
    if ($row =~ m/^\[\d*\]/)  # detected a new record
    {
        $count ++;

        if ( $record_str ne "" )
        {
            if (exists $ArrayofHashes[$count-1]{'raw'} )
            {
            }
            else
            {
                $ArrayofHashes[$count-1]{'raw'} = $record_str;
            }
            if ((exists $ArrayofHashes[$count-1]{'eur'}) and  (exists $ArrayofHashes[$count-1]{'mp'}))
            {
                $ArrayofHashes[$count-1]{'rap'} = ($ArrayofHashes[$count-1]{'eur'} * 1000 ) / $ArrayofHashes[$count-1]{'mp'};
            }
        }
        $record_str = "";
        $record_str .= $row."\n";
        if (exists $ArrayofHashes[$count]{'title'} )
        {
        }
        else
        {
            $ArrayofHashes[$count]{'title'} = $row;
        }
        if ( $start == 0 )
        {
            $start = 1;
            #print "START===\n";
        }
        next;
    }

    if ($row =~ m/^Agenţii imobiliare/)
    {
        $stop = 1;
        #print "STOP===\n";
        if ( $record_str ne "" )
        {
            if (exists $ArrayofHashes[$count]{'raw'} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{'raw'} = $record_str;
            }

            if ((exists $ArrayofHashes[$count]{'eur'}) and  (exists $ArrayofHashes[$count]{'mp'}))
            {
                $ArrayofHashes[$count]{'rap'} = ( $ArrayofHashes[$count]{'eur'} * 1000 ) / $ArrayofHashes[$count]{'mp'};
            }
            
        }
        last;
    }
    if ($start == 1)
    {
        #print "$row\n";
        $record_str .= $row."\n";
        if ( $row =~ m/.*zona.*/ ) # Timisoara, zona I.I. de la Brad
        {
            if (exists $ArrayofHashes[$count]{'zona'} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{'zona'} = $row;
            }
            next;
        }
        if ( $row =~ m/\s*(\S*)\s*camere.*/ ) # 3 camere
        {
            if (exists $ArrayofHashes[$count]{'nrcamere'} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{'nrcamere'} = $1;
            }
            next;
        }
        if ( $row =~ m/\s*(\S*)\s*mp\s*utili.*/ ) # 80 mp utili
        {
            if (exists $ArrayofHashes[$count]{'mp'} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{'mp'} = $1;
            }
            next;
        }
        if ( $row =~ m/\s*(\S*)\s*EUR.*/ ) # 56.000 EUR
        {
            if (exists $ArrayofHashes[$count]{'eur'} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{'eur'} = $1;
            }
            next;
        }
    }

    if ($stop == 1)    # detected the end of the usefull stuff
    {
        $start = 0;
    }
}

close $fh;

#$d = Data::Dumper->Dump(\@ArrayofHashes,[\@ArrayofHashes]);
#print $d->Dump;
print "\n\nDump\n\n";
my $indx = 0;
foreach my $hash (@ArrayofHashes)
{
    #print  $hash. "\n";
    foreach my $key  ( sort ( keys %$hash  ) )  
    {
        print "[ ".$indx." ]"."  ". $key . "--->  "; 
        print $hash->{$key}."   \n";

        #print Dumper($hash);
        #print $_. "=> $hash{$_}" . "\n";
    }
    print "\n";
    $indx ++;
}

#for my $hash (@ArrayofHashes)
#{
#print $hash;
#for my $key ( keys %$hash )
#{
#print "$key=$hash->{$key} "
#}
#}


