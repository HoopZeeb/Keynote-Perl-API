#!/usr/bin/env perl

=head1 [Keynote-API-Simple]

 Simple use of the Keynote API:

=cut

use LWP::Simple;			# HTTP support
use XML::Simple;			# XML::Simple
# use XML::Simple   qw(XMLin);
use Data::Dumper;			# Dumping XML, debug
#
use Carp;							# enhanced debugging info
use Text::CSV;				#	CSV parsing support
use DateTime;					# DT for output filename
use Scalar::Util qw(looks_like_number);		# numeric validation
#
use feature ':5.10';
use strict;						# XML -- recommended setting
use warnings;
use Getopt::Long;

use English qw( -no_match_vars );

my $prog = $0;
my $usage = <<EOQ;
Usage for $0:

  >$prog [-test -help -verbose]

EOQ

my $fn = 0;	#	initialize filename flag

if ( @ARGV > 0 )		#	check if i/p file passed on cmd-line
{
  print "Number of arguments: " . scalar @ARGV . "\n";
  print "Using filename passed. \n";
  $fn = 1;
}
else
{
  print "No arguments! Getting all measurements! \n";
}

# instantiate XML services
my $xml = new XML::Simple;

my ($urlslots, $urldata, $content, $xml_data, $while_slots, %slots, $keys_slotid, @slot_values); 
my (@ipf_slots, $ipf_slots_idx, $line, $ipfilename);

&getallslots;		# Get list of allslots data from Keynote

#	check if filename passed actually exists
if ($fn == 1) {
	$ipfilename = $ARGV[0];				# get filename passed
	if (-e $ipfilename) {
 		print "IP File ($ipfilename) Exists! \n";
 	} else { 
 		print "IP File ($ipfilename) Doesn't Exist! \n";
 		exit 98;
 	}
 	&ReadSlots;
}	# if ($fn == 1)
 
#	instantiate DateTime
my $dt = DateTime->now; 
my $opfile;

$opfile = $dt.'-file.csv';
#	open O/P file, use DateTime from previous in Filename
open OPFILE, ">$opfile" or die $!;

print "o/p file, $opfile, should be created \n";

my ($keyn_EC, @keyn_PS, $keyn_agent_name, $keyn_DT, $keyn_BW_kbs, $keyn_TxnMeasurement, $keyn_TxnPage, $keyn_target, @keyn_pages, $eval_res);
my ($keyn_alias, $keyn_agent_id, $keyn_url, $keyn_slot, $slot_href, @keyn_TxnMeasurement, $get_err, $keyn_UT_msec);	
my ($slotlist, $slotx, $slot0, $slot1, $slot2, $slot3, $slot4, $slot5, $slot6, $slot7, $slot8, $slot9, $slot_cnt, $slot_loop, $slot_idx);

# create hashref for slots from Keynote
# $slot_href = \%slots;		
			
if ($fn == 0) {	#	if no input file, key list of slotid's from Keynote hash table
		@ipf_slots = keys(%slots);
		}		
		
# print Dumper(@ipf_slots);
# print " dumped slotIDs \n";					

# sleep 2;

$while_slots = 1; $slot_cnt = $slot_loop = 0; 	#	Set Ctls
			
while ( $while_slots ) {
	#	print " \$while_slots = $while_slots, at start of while loop\n";
	
	$slot_cnt = $slot_loop = 0;					#	set ctls for next pass
	
	$slot0 = pop(@ipf_slots); 	# pop off slots
	$slot1 = pop(@ipf_slots); 
	$slot2 = pop(@ipf_slots);
	$slot3 = pop(@ipf_slots); 
	$slot4 = pop(@ipf_slots); 
	$slot5 = pop(@ipf_slots);
	$slot6 = pop(@ipf_slots); 
	$slot7 = pop(@ipf_slots); 
	$slot8 = pop(@ipf_slots);
	$slot9 = pop(@ipf_slots);
                                	
#	print $slot0.','.$slot1.','.$slot2.','.$slot3.','.$slot4.','.$slot5.','.$slot6.','.$slot7.','.$slot8.','.$slot9."\n";  

	if ( eval($slot0) ) {	
			$slotlist = "$slot0,";
			$slot_cnt++;
		}	else {
			$slotlist = ',';		#out of slots
			$while_slots = 0;			# terminate WHILE
		}   
	if ( eval($slot1) ) {                       
			$slotlist .= "$slot1,";
			$slot_cnt++;                                                                                                        
		} else {      
				$slotlist .= ',';		#out of slots
				$while_slots = 0;			# terminate WHILE	                                                                                
		}                                                       
	if ( eval($slot2) ) {                       
			$slotlist .= "$slot2,";  
			$slot_cnt++;                                                                                                      
		} else {                         		                  
				$slotlist .= ',';	 
				$while_slots = 0;			# terminate WHILE                                                                  
			}                                                     
	if ( eval($slot3) ) {                       
			$slotlist .= "$slot3,";   
			$slot_cnt++;                                                                                                    
		} else {                                              
				$slotlist .= ',';	   
				$while_slots = 0;			# terminate WHILE                                     
		}						                                            
	if ( eval($slot4) ) {                       
			$slotlist .= "$slot4,"; 
			$slot_cnt++;                                                                                                        
		} else {		                                          
				$slotlist .= ',';	                 
				$while_slots = 0;			# terminate WHILE                     
		}                                                       
	if ( eval($slot5) ) {                       
			$slotlist .= "$slot5,";   
			$slot_cnt++;                                                                                                     
			} else {		                                          
				$slotlist .= ',';	                 
				$while_slots = 0;			# terminate WHILE                       
		}				                                                
	if ( eval($slot6) ) {
#	if ( eval($slot6) && ($slot6 ne '1197505') ) {                        
			$slotlist .= "$slot6,";   
			$slot_cnt++;                                                                                                   
			} else {		                                          
				$slotlist .= ',';	                 
				$while_slots = 0;			# terminate WHILE                        
		}                                                       
	if ( eval($slot7) ) {                       
			$slotlist .= "$slot7,";   
			$slot_cnt++;                                                                                                    
		} else {		                                          
				$slotlist .= ',';	                 
				$while_slots = 0;			# terminate WHILE                       
		}                                                       
	if ( eval($slot8) ) {                        
			$slotlist .= "$slot8,";   
			$slot_cnt++;                                                                                                     
		} else {		                                          
				$slotlist .= ',';	                 
				$while_slots = 0;			# terminate WHILE                       
		}                                                       
	if ( eval($slot9) ) {                        
			$slotlist .= "$slot9 ";   
			$slot_cnt++;                                                                                                     
		} else {		                                          
				$slotlist .= ',';	                 
				$while_slots = 0;			# terminate WHILE                      
		}			                                                  
                     
	if ( $slot_cnt > 1 ) {			     # set loop control for later ForEach
			$slot_loop = 1;
		}                     
  
#  $slotlist =~ s/,,/,/g;	     # clean up slot list
                                                                                              	#	 Make API call                                                                                                                                                                                                                                                                                                                                                                                  
	$urldata = 'http://api.keynote.com/keynote/api/getgraphdata?api_key=c96aeb0b-f575-363e-9338-af54129014ed&graphtype=scatter&basepageonly=true&averagemethod=GM&timezone=GMT&format=xml&slotidlist=';
#	$urldata = 'http://api2.keynote.com/keynote/api/getgraphdata?api_key=c96aeb0b-f575-363e-9338-af54129014ed&graphtype=scatter&basepageonly=true&averagemethod=GM&timezone=GMT&format=xml&slotidlist=';       	                                                                                                                                                                                        

# 	print "slot_cnt = $slot_cnt; slot_loop = $slot_loop; slotlist = $slotlist \n";                                                                                                                                                                                                                                                                                                                                              
     
#	$content = get $urldata.."$slot0".','."$slot1".','."$slot2".','."$slot3".','."$slot4".','."$slot5".','."$slot6".','."$slot7".','."$slot8".','."$slot9";	
# die "Couldn't get $urldata"."$slot0".','."$slot1".','."$slot2".','."$slot3".','."$slot4".','."$slot5".','."$slot6".','."$slot7".','."$slot8".','."$slot9" unless defined $content;
$eval_res = eval { $content = get $urldata.$slotlist };          
	  	
# If there's a problem eval'ing the
# code, eval() returns undef and
# the error is found in $@.
	unless($eval_res) {
		print $@;
	}	# end unless


	# Load data into XML area  
  $xml_data = $xml->XMLin($content, ForceArray => 1);
    	
 	# print "$_\n" for sort grep /XML/, keys %INC;             # what's loaded in Perl?
	
  #  print Dumper($xml_data);	
	
# 	print " before for: slot_idx = $slot_idx, slot_cnt = $slot_cnt -- \n";

		for ( $slot_idx = ($slot_cnt - 1); $slot_cnt > 0; $slot_cnt-- ) {
			 
			# 	print " after for: slot_idx = $slot_idx, slot_cnt = $slot_cnt -- \n";
       
       if ( $slot_loop ) {    
       	    
#      	    print " after for: slot_idx = $slot_idx, slot_cnt = $slot_cnt -- \n";                                                              
			 			foreach $keyn_TxnMeasurement (@{$xml_data->{list}[$slot_idx]{'com.keynote.mykeynote.service.api.response.txn.TxnMeasurement'}}) {   
						  	$keyn_EC = $keyn_TxnMeasurement->{txnPages}[0]->{'com.keynote.mykeynote.service.api.response.txn.TxnPage'}[0]->{txnPageStatus}[0]->{error__code}[0];                                                                          
						 		$keyn_BW_kbs = $keyn_TxnMeasurement->{txn__summary}[0]->{bandwidth__kbsec}[0];
						  # clean up above
						  	if ( $keyn_EC =~ /HASH/ ) {
						  			$keyn_EC = "0";
						  		}
						  	if ( $keyn_BW_kbs =~ /HASH/ ) {
						  			$keyn_BW_kbs = "0";
						  		}
						  	$keyn_UT_msec = $keyn_TxnMeasurement->{txn__summary}[0]->{delta__msec}[0];
						  	$keyn_DT = $keyn_TxnMeasurement->{datetime}[0];
		 						$ipf_slots_idx = $keyn_slot = $keyn_TxnMeasurement->{slot__id}[0];	
								
#								print " slot table for $keyn_slot \n";
								
						#		Get data saved from Keynote DB, reuse slotvalues array space
								$keyn_alias = $slots{$ipf_slots_idx}[0];
								$keyn_agent_name = $slots{$ipf_slots_idx}[1];
								$keyn_agent_id = $slots{$ipf_slots_idx}[2];
								$keyn_url = $slots{$ipf_slots_idx}[3];
								$keyn_target = $slots{$ipf_slots_idx}[4];
								@keyn_pages = $slots{$ipf_slots_idx}[5];
							  
								print OPFILE $keyn_DT.','
									.$keyn_target.','
									.$keyn_EC.','
									.$keyn_alias.','
									.$keyn_agent_name.','
									.$keyn_agent_id.','
									.$keyn_slot.','
									.$keyn_UT_msec.','
									.$keyn_BW_kbs."\n";
							
#								print 'Printed:, Date= ', $keyn_DT, ' Target= ', $keyn_target, ' ErrCode= ', $keyn_EC, ' Agent= ', $keyn_agent_name, ' SlotID= ', $keyn_slot, ' UsrTime(ms)= ', $keyn_UT_msec, ' Bandwidth= ', $keyn_BW_kbs, "\n";
						
								#	Reset var(s) for next entry
								$keyn_DT = $keyn_EC = $keyn_BW_kbs = $keyn_alias = $keyn_agent_name = $keyn_agent_id = $keyn_url = ' ';
								$keyn_EC = $keyn_target = $keyn_slot = $keyn_UT_msec = ' ';
						
								#	Clear array(s) for next entry
#								@keyn_pages = @slot_values = ();	
								@keyn_pages = ();
								
							} 	#end forEach loop
        
        		}       # end (if $slot_loop )
        	
#						}	# end if...ref
					
				#	$slot_idx = ($slot_cnt - 1);
					$slot_idx--;
						
#					print "after foreach loop txn \n";
#					print "more loop?: slot_idx = $slot_idx, slot_cnt = $slot_cnt \n";
					
			} 	#end for loop
#			    print "after foreach txn \n";
    			$slot0 = $slot1 = $slot2 = $slot3 = $slot4 = $slot5 = $slot6 = $slot7 = $slot8 = $slot9 = $slot_cnt = 0;		#	clear slotids for GET
    
  } #end While (slot table)  
		
#	print "end While, closing... \n";

close OPFILE;
#		end main program, sub-routines follow

sub ReadSlots
{
	
 	my (@fields, $csv);
	
	#	Open filename passed
	open IPFILE, "$ipfilename" or die $!; 

#	initialize Text::CSV support
	$csv = Text::CSV->new({ sep_char => ',' });

	#	read slotid from input record. Save measurement alias name
	while ($line = <IPFILE>) {			#	loop as long as input exists
  	chomp $line;
  	if ($csv->parse($line)) {
  		@fields = $csv->fields();
  		push @ipf_slots, $fields[0];
  	} else {
  		warn "Line could not be parsed: $line \n";
  	} # if (while)
#  	  print $_;
	}	# end while	
	close IPFILE;
}	#	end ReadSlots

sub getallslots
{
	print "getallslots called \n";
	
	
#	Hash %slots, array of values per @slot_values
	my ($slot_urlslots, $slot_content, $slot_xml, $slot_xml_data, $slot_keys_slotid, $slot_keyn);
	
	# Make API call
	$slot_urlslots = 'http://api.keynote.com/keynote/api/getslotmetadata?api_key=c96aeb0b-f575-363e-9338-af54129014ed&scope=agreement&agreementid=226613&format=xml';
#	$slot_urlslots = 'http://api2.keynote.com/keynote/api/getslotmetadata?api_key=c96aeb0b-f575-363e-9338-af54129014ed&scope=agreement&agreementid=226613&format=xml';

	
	$slot_content = get $slot_urlslots;
  die "Couldn't get $slot_urlslots" unless defined $slot_content;
 
  $slot_xml = XML::Simple->new();

# Load data into XML area
	$slot_xml_data = $slot_xml->XMLin($slot_content);


# print XML area
# print Dumper($xml_data);

# Loop through pages, get error__code, datetime, agent__id, slot__id, bandwidth__kbsec

#	Get ApP slots
	foreach $slot_keyn (@{$slot_xml_data->{product}->{ApP}->{slot}}) {
#	set hash key for slot hash table
		$slot_keys_slotid = $slot_keyn->{slot_id};

#		if ($slot_keys_slotid == undef) {		# need to fix 1st entry in table (going to pop 1X)
# 			break;
#			}	#end if

# set array values for hash array
		push @slot_values, $slot_keyn->{pages};					# elements pushed in reverse of pop()
		push @slot_values, $slot_keyn->{target_id};
		push @slot_values, $slot_keyn->{url};
		push @slot_values, $slot_keyn->{agent_id};
		push @slot_values, $slot_keyn->{agent_name};
		push @slot_values, $slot_keyn->{slot_alias};
#	load values into array
#	$slot_values = [ $sv_alias, $sv_agent_name, $sv_agent_id, $sv_url, $sv_target_id, $sv_pages ];	
# load hash
		push(@{$slots{$slot_keys_slotid}}, @slot_values);
		@slot_values = ();	#clear array for next entry
	} # foreach ApP
	
#	Get TxP slots	
	foreach $slot_keyn (@{$slot_xml_data->{product}->{TxP}->{slot}}) {
#	set hash key for slot hash table
		$slot_keys_slotid = $slot_keyn->{slot_id};
# set array values for hash array
		push @slot_values, $slot_keyn->{pages};
		push @slot_values, $slot_keyn->{target_id};
		push @slot_values, $slot_keyn->{url};
		push @slot_values, $slot_keyn->{agent_id};
		push @slot_values, $slot_keyn->{agent_name};
		push @slot_values, $slot_keyn->{slot_alias};
#	load values into array
#	$slot_values = [ $sv_alias, $sv_agent_name, $sv_agent_id, $sv_url, $sv_target_id, $sv_pages ];	
# load hash
		push(@{$slots{$slot_keys_slotid}}, @slot_values);
		@slot_values = ();	#clear array for next entry
	} # foreach TxP
	print "getallslots ended! \n";
}	# end getallslots