#!/usr/bin/perl 


#use strict;
use warnings;
use utf8;
use Data::Dumper;
use DBI;
binmode STDOUT, ":utf8";

#local $/= undef;
my $filename = $ARGV[0];
my $DIR = $ARGV[1];
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
my $start_section=0;
my $jump_first_3=100;
my $in_record =0;
my @arrayoOfTitles;

foreach my $row (@file_content) {
    chomp $row;
	if ( $row =~ m/^   Afiseaza \[100\] rezultate pe pagina Sortare dupa \[Data modificarii\]/ )
	{
		$start_section = 1;
		$jump_first_3 = 3;
		next;
	}
	if ( $start_section == 1 )
	{
		if ( $row =~ m/\s*Nu sunt permise link-uri in comentariu.*/ )
		{
			#found the end of the entire section
			#break the loop
			last;
		}
		if ($jump_first_3 > 0)
		{
			$jump_first_3--;
		}
		if ( $jump_first_3 == 0 )
		{
			# we jumped the first lines - start of the real sections records
			if ( $in_record == 0 )
			{
				# we are not in record so we can look for the begining of a record
				if ( $row =~ m/\s*\[(\d*)\].*/ )
				{
					#found the first line of a record
					#print $row."\n";
					push (@arrayoOfTitles, $1);
					$in_record = 1;
					next;
				}
			}
			if ( $in_record == 1 )
			{
				# we are in record we need to look for the end of the record
				if ( $row =~ m/\s*Categoria/ )
				{
					# found the end of the record
					$in_record = 0;
				}
			}
		}
		else
		{
			next;
		}
	}

	
    #if ($row =~ m/^\[(\d*)\]/)  # detected a new record
    #{
		#my $title_id=$1;
        #$count ++;

        #if ( $record_str ne "" )
        #{
            #if (exists $ArrayofHashes[$count-1]{$akeys[4]} )
            #{
            #}
            #else
            #{
                #$ArrayofHashes[$count-1]{$akeys[4]} = $record_str;
            #}
            #if ((exists $ArrayofHashes[$count-1]{$akeys[0]}) and  (exists $ArrayofHashes[$count-1]{$akeys[1]}))
            #{
                #$ArrayofHashes[$count-1]{$akeys[3]} = ($ArrayofHashes[$count-1]{$akeys[0]} * 1000 ) / $ArrayofHashes[$count-1]{$akeys[1]};
            #}
        #}
        #$record_str = "";
        #$record_str .= $row."\n";
        #if (exists $ArrayofHashes[$count]{$akeys[5]} )
        #{
        #}
        #else
        #{
            #$ArrayofHashes[$count]{$akeys[5]} = $row;
			#my $url="";
			#foreach my $second_iter (@file_content)
			#{
				##print "TITLE IS $title_id\n";
				#if ($second_iter =~ m/^\s*$title_id\.\s*(.*)/)
				#{
					#$url = $1;
					##print "AM GASIT ".$second_iter."\n";
					##print "AM GASIT $url\n";
					#$ArrayofHashes[$count]{$akeys[7]} = $url;
					#last;
				#}
			#}

        #}
        #if ( $start == 0 )
        #{
            #$start = 1;
            ##print "START===\n";
        #}
        #next;
    #}

    #if ($row =~ m/^Agenţii imobiliare/)
    #{
        #$stop = 1;
        ##print "STOP===\n";
        #if ( $record_str ne "" )
        #{
            #if (exists $ArrayofHashes[$count]{$akeys[4]} )
            #{
            #}
            #else
            #{
                #$ArrayofHashes[$count]{$akeys[4]} = $record_str;
            #}

            #if ((exists $ArrayofHashes[$count]{$akeys[0]}) and  (exists $ArrayofHashes[$count]{$akeys[1]}))
            #{
                #$ArrayofHashes[$count]{$akeys[3]} = ( $ArrayofHashes[$count]{$akeys[0]} * 1000 ) / $ArrayofHashes[$count]{$akeys[1]};
            #}
            
        #}
        #last;
    #}
    #if ($start == 1)
    #{
        ##print "$row\n";
        #$record_str .= $row."\n";
        #if ( $row =~ m/.*zona.*/ ) # Timisoara, zona I.I. de la Brad
        #{
            #if (exists $ArrayofHashes[$count]{$akeys[6]} )
            #{
            #}
            #else
            #{
                #$ArrayofHashes[$count]{$akeys[6]} = $row;
            #}
            #next;
        #}
        #if ( $row =~ m/\s*(\S*)\s*camere.*/ ) # 3 camere
        #{
            #if (exists $ArrayofHashes[$count]{$akeys[2]} )
            #{
            #}
            #else
            #{
                #$ArrayofHashes[$count]{$akeys[2]} = $1;
            #}
            #next;
        #}
        #if ( $row =~ m/\s*(\S*)\s*mp\s*utili.*/ ) # 80 mp utili
        #{
            #if (exists $ArrayofHashes[$count]{$akeys[1]} )
            #{
            #}
            #else
            #{
                #$ArrayofHashes[$count]{$akeys[1]} = $1;
            #}
            #next;
        #}
        #if ( $row =~ m/\s*(\S*)\s*EUR.*/ ) # 56.000 EUR
        #{
            #if (exists $ArrayofHashes[$count]{$akeys[0]} )
            #{
            #}
            #else
            #{
                #$ArrayofHashes[$count]{$akeys[0]} = $1;
            #}
            #next;
        #}
    #}

    #if ($stop == 1)    # detected the end of the usefull stuff
    #{
        #$start = 0;
    #}
} # end of big loop

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
#chop ($scols);

#$dbh->do("CREATE TABLE IF NOT EXISTS content (".$scols.")");

my %apart = (
	"loc" => "",
	"zona" => "",
	"mp" => "",
	"nrcamere" => "",
	"p_euro" => "",
	"p_ron" => "",
	"incal" => "",
	"etaj" => "",
	"nrbai" => "",
	"nivel" => "",
	"an" => "",
	"parcare" => "",
	"dela" => "",
	"panala" => "",
	"rap" => "",
	"url" => "",
);
my $create_table_str = "CREATE TABLE IF NOT EXISTS content_romino ( ";
foreach (sort (keys (%apart)))
{
	$create_table_str .= $_." VARCHAR(200) ,";
}

chop($create_table_str);
$create_table_str .= " ) ";
print $create_table_str."\n";
$dbh->do($create_table_str);

foreach my $title (@arrayoOfTitles)
{
	#print $title."\n";
	#if ( $title =~ m/\s/ )
	foreach my $row (@file_content) 
	{
		chomp $row;
		if ($row =~ m/^\s*$title\.\s*(.*)/)
		{
			my $obj_url=$1;
			if ( $obj_url =~ /.*\/(.*\.html).*/ )
			{
				my $page_obj=$1;
				print "Check exist $DIR/$page_obj \n";
				if ( -f $DIR."/".$page_obj )
				{
					print "file exist\n";
				}
				else
				{
					print "file does not exist\n";
					print "Dumping the file $page_obj\n";
					`lynx -dump $obj_url > $DIR/$page_obj`;
				}

				#here the file exist
				my @individual_apart_content;
				my $indv_fh;
				open($indv_fh, '<:encoding(UTF-8)', $DIR."/".$page_obj)
					or die "Could not open file '$DIR/$page_obj' $!";
				@individual_apart_content=<$indv_fh>;
				close $indv_fh;

				print "Parsing file $DIR/$page_obj\n";
				my $found_section = 0;
				%apart = (
					"loc" => "",
					"zona" => "",
					"mp" => "",
					"nrcamere" => "",
					"p_euro" => "",
					"p_ron" => "",
					"incal" => "",
					"etaj" => "",
					"nrbai" => "",
					"nivel" => "",
					"an" => "",
					"parcare" => "",
					"dela" => "",
					"panala" => "",
					"rap" => "",
					"url" => "",
				);
				foreach my $indiv_row (@individual_apart_content)
				{
					chop($indiv_row);
					#print "[$indiv_row]\n";
					if ( $indiv_row =~ m/^Detalii.*/ )
					{
						#print "Found Detalii\n";
						$found_section = 1;
						next;
					}
					if ( $found_section == 1 )
					{
						if ( $indiv_row =~ m/^Descriere.*/ )
						{
							#print "Found Descriere\n";
							$found_section = 0;
							next;
						}
						if ($indiv_row =~ m/\s*Localitatea\s\[.*\]\s*(.*)$/)
						{
							print "Localitatea $1\n";
							$apart{'loc'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Zona\s*(.*)$/)
						{
							print "Zona $1\n";
							$apart{'zona'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Suprafata\s*utila\s*(\d*)m.*$/)
						{
							print "Suprafata Utila $1\n";
							$apart{'mp'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Numar\scamere\s*(\d*).*$/)
						{
							print "Nr camere $1\n";
							$apart{'nrcamere'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Pret\s*(.*)\s*EUR.*$/)
						{
							print "Pret EUR $1\n";
							$apart{'p_euro'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Pret\s*\(RON\)\s*(.*)\s*RON.*$/)
						{
							print "Pret RON $1\n";
							$apart{'p_ron'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Incalzire\s*(.*)/)
						{
							print "Incalzire $1\n";
							$apart{'incal'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Etaj\s*(\d*).*$/)
						{
							print "Etaj $1\n";
							$apart{'etaj'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Numar bai\s*(\d*).*$/)
						{
							print "Nr bai $1\n";
							$apart{'nrbai'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Numar locuri parcare\s*(\d*).*$/)
						{
							print "Numar loc parcare $1\n";
							$apart{'parcare'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Anul construirii\s*(\d*).*$/)
						{
							print "Anul construirii $1\n";
							$apart{'an'}= $1;
							next;
						}
						if ($indiv_row =~ m/\s*Numar nivele\s*(\d*).*$/)
						{
							print "Numar nivele $1\n";
							$apart{'nivel'}= $1;
							next;
						}
					}  # in section

					if ($indiv_row =~ m/\s*Valabil: de la\s*(.*)$/)
					{
						print "De la $1\n";
						$apart{'dela'}= $1;
						next;
					}
					if ($indiv_row =~ m/\s*Pana la\s*(.*)$/)
					{
						print "pana la $1\n";
						$apart{'panala'}= $1;

						$apart{'url'}=$obj_url;
						if ( ($apart{'p_euro'} != "") and ($apart{'mp'} != ""))
						{
							$apart{'rap'} = ($apart{'p_euro'} * 1000)/ $apart{'mp'};
							print "Rap is $apart{'rap'}\n";
						}
						my $insert_str = "INSERT into content_romino VALUES ( ";
						foreach (sort (keys (%apart)))
						{
							$insert_str .= $dbh->quote($apart{$_})." ,";
						}
						chop($insert_str);
						$insert_str .= " )";
						print $insert_str."\n";

						eval {  $dbh->do($insert_str) };

						last;
					}
				}

			}
			last;
		}
	}
} # end of foreach title
#eval { $dbh->do("ALTER IGNORE TABLE content_romino ADD UNIQUE INDEX idx_uniq (`rap`)")};
eval { $dbh->do("ALTER IGNORE TABLE content_romino ADD UNIQUE INDEX idx_uniq (`url`)")};
# Disconnect from the database.
$dbh->disconnect();

  ## INSERT some data into 'foo'. We are using $dbh->quote() for
  ## quoting the name.
  ##$dbh->do("INSERT INTO content VALUES (1, " . $dbh->quote("Tim") . ")");

  ## same thing, but using placeholders (recommended!)
  ##$dbh->do("INSERT INTO content VALUES (?, ?)", undef, 2, "Jochen");

  #$dbh->do("ALTER TABLE content MODIFY rap DOUBLE");
  #$dbh->do("ALTER TABLE content MODIFY eur DOUBLE");
  #$dbh->do("ALTER TABLE content MODIFY nrcamere DOUBLE");
  #$dbh->do("ALTER IGNORE TABLE content ADD UNIQUE INDEX idx_uniq (`rap`)");
    
  ## now retrieve data from the table.
  ##my $sth = $dbh->prepare("SELECT eur,nrcamere,rap,title,zona FROM content where nrcamere !='0' order by 'rap'");
  ##$sth->execute();
  ##while (my $ref = $sth->fetchrow_hashref()) {
            ##for my $ky ( sort (keys %$ref))
            ##{
                ###print "$ky -> $ref->{$ky} ";
                ##print "$ref->{$ky}\t";
            ##}
            ##print "\n";
  ###  print "Found a row: id = $ref->{'id'}, name = $ref->{'name'}\n";
  ##}
  ##$sth->finish();

  ## Disconnect from the database.
  #$dbh->disconnect();

#close $fh;

#$d = Data::Dumper->Dump(\@ArrayofHashes,[\@ArrayofHashes]);
#print $d->Dump;
#print "\n\nDump\n\n";
#my $indx = 0;
#my  $once = 0;
#my $scols = "";
#foreach my $akey (sort @akeys)
#{
            #$scols = $scols.$akey."  VARCHAR(2000),";
#}



#foreach my $hash (@ArrayofHashes)
#{
    ##print  $hash. "\n";

    #foreach my $key  ( sort ( keys %$hash  ) )  
    #{
        #print "[ ".$indx." ]"."  ". $key . "--->  "; 
        #print $hash->{$key}."   \n";

        ##print Dumper($hash);
        ##print $_. "=> $hash{$_}" . "\n";
    #}
    #print "\n";
    #$once = 1;
    #$indx ++;
#}

##my @col =  keys \%$ArrayofHashes[0] ;

##my $scol = join ( ",", @col );



##for my $hash (@ArrayofHashes)
##{
##print $hash;
##for my $key ( keys %$hash )
##{
##print "$key=$hash->{$key} "
##}
##}


 ## Connect to the database.
  #my $dbh = DBI->connect("DBI:mysql:database=realestate;host=localhost",
                         #"ciprian", "",
                         #{'RaiseError' => 1});

  ## Drop table 'foo'. This may fail, if 'foo' doesn't exist
  ## Thus we put an eval around it.
  ##eval { $dbh->do("DROP TABLE content") };
  ##print "Dropping content failed: $@\n" if $@;

  ## Create a new table 'foo'. This must not fail, thus we don't
  ## catch errors.
  ##$dbh->do("CREATE TABLE content (id INTEGER, name VARCHAR(20))");
  #chop ($scols);
  
  

  #$dbh->do("CREATE TABLE IF NOT EXISTS content (".$scols.")");
#my $indexare= 0;
#foreach my $hash (@ArrayofHashes)
#{
	##print "[ - ".$ArrayofHashes[$indexare]{'mp'}." -  ]\n";
	#print "indexare [".$indexare."]  ".$hash."   \n";
	##print "[".$hash->{'mp'}."]\n";

    #my $row = "INSERT INTO content VALUES ( ";  
    #foreach my $akey (sort @akeys)
    #{
        ##print "[".$hash->{$akey}."]\n";
		##if ( undef $hash->{$akey} )
		
		##	print $akey. "\n";
		
		##else
		
		##	print $akey ."-> ".$hash->{$akey}  ."\n";
		

		#print "[ ".$akey." ->  ".$hash->{$akey}."   <-  ]\n";

        #if (not defined $hash->{$akey} ) 
        #{
        #$row = $row." '0' ,";
        #}
        #else
        #{
        #$row = $row.$dbh->quote($hash->{$akey}).",";        
        ##print "keya ".$akey." ".$hash->{$akey}."\n";

        #}
    #}
##    foreach my $key  ( sort ( keys %$hash  ) )  
   
 ##       print "{  ".$key."  }\n";
  ##      $row = $row.$dbh->quote($hash->{$key}).",";
        ##print "[ ".$indx." ]"."  ". $key . "--->  "; 
        ##print $hash->{$key}."   \n";
        ##print "keya ".$key." ".$hash->{$key}."\n";
    
    #print "\n";
    #chop ($row);
    #$row  = $row.")";
      #print "SCOLS   ".$scols."\n";    
    #print "[ ".$row." ]\n";
	#eval {    $dbh->do($row)  };

    
#$indexare ++;
#}

  ## INSERT some data into 'foo'. We are using $dbh->quote() for
  ## quoting the name.
  ##$dbh->do("INSERT INTO content VALUES (1, " . $dbh->quote("Tim") . ")");

  ## same thing, but using placeholders (recommended!)
  ##$dbh->do("INSERT INTO content VALUES (?, ?)", undef, 2, "Jochen");

  #$dbh->do("ALTER TABLE content MODIFY rap DOUBLE");
  #$dbh->do("ALTER TABLE content MODIFY eur DOUBLE");
  #$dbh->do("ALTER TABLE content MODIFY nrcamere DOUBLE");
    
  ## now retrieve data from the table.
  ##my $sth = $dbh->prepare("SELECT eur,nrcamere,rap,title,zona FROM content where nrcamere !='0' order by 'rap'");
  ##$sth->execute();
  ##while (my $ref = $sth->fetchrow_hashref()) {
            ##for my $ky ( sort (keys %$ref))
            ##{
                ###print "$ky -> $ref->{$ky} ";
                ##print "$ref->{$ky}\t";
            ##}
            ##print "\n";
  ###  print "Found a row: id = $ref->{'id'}, name = $ref->{'name'}\n";
  ##}
  ##$sth->finish();

  ## Disconnect from the database.
  #$dbh->disconnect();

