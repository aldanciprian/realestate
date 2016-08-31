#!/usr/bin/perl


#use strict;
use warnings;
use utf8;
use Data::Dumper;
use DBI;
binmode STDOUT, ":utf8";

my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";
    #                      0        1      2        3      4        5           6
my @akeys = ( "raw" ,"rap","eur","mp","title","zona","nrcamere" );
my @akeys = ("eur", "mp" , "nrcamere", "rap", "raw", "title", "zona" );
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
            if (exists $ArrayofHashes[$count-1]{$akeys[4]} )
            {
            }
            else
            {
                $ArrayofHashes[$count-1]{$akeys[4]} = $record_str;
            }
            if ((exists $ArrayofHashes[$count-1]{$akeys[0]}) and  (exists $ArrayofHashes[$count-1]{$akeys[1]}))
            {
                $ArrayofHashes[$count-1]{$akeys[3]} = ($ArrayofHashes[$count-1]{$akeys[0]} * 1000 ) / $ArrayofHashes[$count-1]{$akeys[1]};
            }
        }
        $record_str = "";
        $record_str .= $row."\n";
        if (exists $ArrayofHashes[$count]{$akeys[5]} )
        {
        }
        else
        {
            $ArrayofHashes[$count]{$akeys[5]} = $row;
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
            if (exists $ArrayofHashes[$count]{$akeys[4]} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{$akeys[4]} = $record_str;
            }

            if ((exists $ArrayofHashes[$count]{$akeys[0]}) and  (exists $ArrayofHashes[$count]{$akeys[1]}))
            {
                $ArrayofHashes[$count]{$akeys[3]} = ( $ArrayofHashes[$count]{$akeys[0]} * 1000 ) / $ArrayofHashes[$count]{$akeys[1]};
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
            if (exists $ArrayofHashes[$count]{$akeys[6]} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{$akeys[6]} = $row;
            }
            next;
        }
        if ( $row =~ m/\s*(\S*)\s*camere.*/ ) # 3 camere
        {
            if (exists $ArrayofHashes[$count]{$akeys[2]} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{$akeys[2]} = $1;
            }
            next;
        }
        if ( $row =~ m/\s*(\S*)\s*mp\s*utili.*/ ) # 80 mp utili
        {
            if (exists $ArrayofHashes[$count]{$akeys[1]} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{$akeys[1]} = $1;
            }
            next;
        }
        if ( $row =~ m/\s*(\S*)\s*EUR.*/ ) # 56.000 EUR
        {
            if (exists $ArrayofHashes[$count]{$akeys[0]} )
            {
            }
            else
            {
                $ArrayofHashes[$count]{$akeys[0]} = $1;
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
my  $once = 0;
my $scols = "";
foreach my $akey (sort @akeys)
{
            $scols = $akey."  VARCHAR(700)," .$scols;
}
  print "SCOLS   ".$scols."\n";


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
    $once = 1;
    $indx ++;
}

#my @col =  keys \%$ArrayofHashes[0] ;

#my $scol = join ( ",", @col );



#for my $hash (@ArrayofHashes)
#{
#print $hash;
#for my $key ( keys %$hash )
#{
#print "$key=$hash->{$key} "
#}
#}


 # Connect to the database.
  my $dbh = DBI->connect("DBI:mysql:database=realestate;host=localhost",
                         "ciprian", "",
                         {'RaiseError' => 1});

  # Drop table 'foo'. This may fail, if 'foo' doesn't exist
  # Thus we put an eval around it.
  eval { $dbh->do("DROP TABLE content") };
  print "Dropping content failed: $@\n" if $@;

  # Create a new table 'foo'. This must not fail, thus we don't
  # catch errors.
  #$dbh->do("CREATE TABLE content (id INTEGER, name VARCHAR(20))");
  chop ($scols);
  
  

  $dbh->do("CREATE TABLE content (".$scols.")");
my $indexare= 0;
foreach my $hash (@ArrayofHashes)
{
print $indexare."     \n";
    my $row = "INSERT INTO content VALUES ( ";  
    foreach my $akey (@akeys)
    {
           if ( undef $hash->{$akey} )
           {
           print $akey. "\n";
           }
           else
           {
           print $akey ."-> ".$hash->{$akey}  ."\n";
           }

        if (not defined $hash->{$akey} ) 
        {
        $row = " '' ,";
        }
        else
        {
        $row = $row.$dbh->quote($hash->{$akey}).",";        
#        print "keya ".$akey." ".$hash->{$akey}."\n";
        }
    }
#    foreach my $key  ( sort ( keys %$hash  ) )  
   
 #       print "{  ".$key."  }\n";
  #      $row = $row.$dbh->quote($hash->{$key}).",";
        #print "[ ".$indx." ]"."  ". $key . "--->  "; 
        #print $hash->{$key}."   \n";
        #print "keya ".$key." ".$hash->{$key}."\n";
    
    print "\n";
    chop ($row);
    $row  = $row.")";
    print "[ ".$row." ]\n";
    $dbh->do($row);
    
$indexare ++;
}

  # INSERT some data into 'foo'. We are using $dbh->quote() for
  # quoting the name.
  #$dbh->do("INSERT INTO content VALUES (1, " . $dbh->quote("Tim") . ")");

  # same thing, but using placeholders (recommended!)
  #$dbh->do("INSERT INTO content VALUES (?, ?)", undef, 2, "Jochen");

  # now retrieve data from the table.
  my $sth = $dbh->prepare("SELECT * FROM content");
  $sth->execute();
  while (my $ref = $sth->fetchrow_hashref()) {
            for my $ky ( sort (keys %$ref))
            {
                print "$ky -> $ref->{$ky} ";
            }
            print "\n";
  #  print "Found a row: id = $ref->{'id'}, name = $ref->{'name'}\n";
  }
  $sth->finish();

  # Disconnect from the database.
  $dbh->disconnect();

