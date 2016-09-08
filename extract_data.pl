#!/usr/bin/perl


#use strict;
use warnings;
use utf8;
use Data::Dumper;
use DBI;
binmode STDOUT, ":utf8";

#local $/= undef;
my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";


my @file_content=<$fh>;
close $fh;




    #                      0        1      2        3      4        5           6	7
#my @akeys = ( "raw" ,"rap","eur","mp","title","zona","nrcamere" );
my @akeys = ("eur", "mp" , "nrcamere", "rap", "raw", "title", "zona","url" );
my $start=0;
my $stop=0;
my $count=-1;
my $first_found =0;
my @ArrayofHashes =0;
my $record_str="";
#while (my $row = <$fh>) {
foreach my $row (@file_content) {
    chomp $row;
    if ($row =~ m/^\[(\d*)\]/)  # detected a new record
    {
		my $title_id=$1;
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
			my $url="";
			foreach my $second_iter (@file_content)
			{
				#print "TITLE IS $title_id\n";
				if ($second_iter =~ m/^\s*$title_id\.\s*(.*)/)
				{
					$url = $1;
					#print "AM GASIT ".$second_iter."\n";
					#print "AM GASIT $url\n";
					$ArrayofHashes[$count]{$akeys[7]} = $url;
					last;
				}
			}

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

#close $fh;

#$d = Data::Dumper->Dump(\@ArrayofHashes,[\@ArrayofHashes]);
#print $d->Dump;
print "\n\nDump\n\n";
my $indx = 0;
my  $once = 0;
my $scols = "";
foreach my $akey (sort @akeys)
{
            $scols = $scols.$akey."  VARCHAR(2000),";
}



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
  #eval { $dbh->do("DROP TABLE content") };
  #print "Dropping content failed: $@\n" if $@;

  # Create a new table 'foo'. This must not fail, thus we don't
  # catch errors.
  #$dbh->do("CREATE TABLE content (id INTEGER, name VARCHAR(20))");
  chop ($scols);
  
  

  $dbh->do("CREATE TABLE IF NOT EXISTS content (".$scols.")");
my $indexare= 0;
foreach my $hash (@ArrayofHashes)
{
	#print "[ - ".$ArrayofHashes[$indexare]{'mp'}." -  ]\n";
	print "indexare [".$indexare."]  ".$hash."   \n";
	#print "[".$hash->{'mp'}."]\n";

    my $row = "INSERT INTO content VALUES ( ";  
    foreach my $akey (sort @akeys)
    {
    	#print "[".$hash->{$akey}."]\n";
		#if ( undef $hash->{$akey} )
		
		#	print $akey. "\n";
		
		#else
		
		#	print $akey ."-> ".$hash->{$akey}  ."\n";
		

		print "[ ".$akey." ->  ".$hash->{$akey}."   <-  ]\n";

        if (not defined $hash->{$akey} ) 
        {
        $row = $row." '0' ,";
        }
        else
        {
        $row = $row.$dbh->quote($hash->{$akey}).",";        
        #print "keya ".$akey." ".$hash->{$akey}."\n";

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
  	print "SCOLS   ".$scols."\n";    
    print "[ ".$row." ]\n";
	eval {    $dbh->do($row)  };

    
$indexare ++;
}

  # INSERT some data into 'foo'. We are using $dbh->quote() for
  # quoting the name.
  #$dbh->do("INSERT INTO content VALUES (1, " . $dbh->quote("Tim") . ")");

  # same thing, but using placeholders (recommended!)
  #$dbh->do("INSERT INTO content VALUES (?, ?)", undef, 2, "Jochen");

  $dbh->do("ALTER TABLE content MODIFY rap DOUBLE");
  $dbh->do("ALTER TABLE content MODIFY eur DOUBLE");
  $dbh->do("ALTER TABLE content MODIFY nrcamere DOUBLE");
  $dbh->do("ALTER IGNORE TABLE content ADD UNIQUE INDEX idx_uniq (`rap`)");
    
  # now retrieve data from the table.
  #my $sth = $dbh->prepare("SELECT eur,nrcamere,rap,title,zona FROM content where nrcamere !='0' order by 'rap'");
  #$sth->execute();
  #while (my $ref = $sth->fetchrow_hashref()) {
            #for my $ky ( sort (keys %$ref))
            #{
                ##print "$ky -> $ref->{$ky} ";
                #print "$ref->{$ky}\t";
            #}
            #print "\n";
  ##  print "Found a row: id = $ref->{'id'}, name = $ref->{'name'}\n";
  #}
  #$sth->finish();

  # Disconnect from the database.
  $dbh->disconnect();

