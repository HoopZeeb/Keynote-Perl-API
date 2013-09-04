#!/usr/bin/env perl

=head1 [Keynote-API-Simple]

 Simple use of the Keynote API:

=cut

use LWP::Simple;			# HTTP support
use XML::Simple;			# XML::Simple
use Data::Dumper;			# Dumping XML, debug
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
# my $xml = XML::Simple->new(ForceArray => 1);

my ($urlslots, $urldata, $content, $xml_data, $ip_slot, %slots, $keys_slotid, @slot_values); 
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
my ($slotlist, $slot0, $slot1, $slot2, $slot3, $slot4, $slot5, $slot6, $slot7, $slot8, $slot9, $slot_cnt, $slot_idx);

# create hashref for slots from Keynote
# $slot_href = \%slots;		
			
if ($fn == 0) {	#	if no input file, key list of slotid's from Keynote hash table
		@ipf_slots = keys(%slots);
		}		
		
print Dumper(@ipf_slots);
print " dumped slotIDs \n";					

# sleep 2;

$ip_slot = 1; $slot_cnt = 0;	#	Set Ctls
			
# foreach (@ipf_slots) {		# Start loop, 

while ( $ip_slot ) {
	#	print " \$ip_slot = $ip_slot, at start of while loop\n";
	
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
                                	
	print $slot0.','.$slot1.','.$slot2.','.$slot3.','.$slot4.','.$slot5.','.$slot6.','.$slot7.','.$slot8.','.$slot9."\n";  
	print "$slot0,$slot1 \n";  
	
	if ( eval($slot0) ) {
			$slotlist = "$slot0,";
			$slot_cnt++;
		}	else {
			$slotlist = 0;		#out of slots
			$ip_slot = 0;			# terminate WHILE
		}   
	if ( eval($slot1) ) {                        
			$slotlist .= "$slot1,";
			$slot_cnt++;                               
			print "Slot1 = $slotlist \n";                                                                         
			} else {                                              
			$ip_slot = 0;                                         
		}                                                       
	if ( eval($slot2) ) {                        
			$slotlist .= "$slot2,";  
			$slot_cnt++;                             
			print "Slot2 = $slotlist \n";                                                                         
			} else {                         		                  
			$slotlist = $slotlist.',';	                          
			$ip_slot = 0;                                         
			}                                                     
	if ( eval($slot3) ) {                        
			$slotlist .= "$slot3,";   
			$slot_cnt++;                            
			print "Slot3 = $slotlist \n";                                                                         
			} else {                                              
			$ip_slot = 0;                                         
		}						                                            
	if ( eval($slot4) ) {                        
			$slotlist .= "$slot4,"; 
			$slot_cnt++;                              
			print "Slot4 = $slotlist \n";                                                                          
			} else {		                                          
			$ip_slot = 0;                                         
		}                                                       
	if ( eval($slot5) ) {                        
			$slotlist .= "$slot5,";   
			$slot_cnt++;                            
			print "Slot5 = $slotlist \n";                                                                         
			} else {		                                          
			$ip_slot = 0;                                         
		}				                                                
	if ( eval($slot6) ) {                        
			$slotlist .= "$slot6,";   
			$slot_cnt++;                            
			print "Slot6 = $slotlist \n";                                                                        
			} else {		                                          
			$ip_slot = 0;                                         
		}                                                       
	if ( eval($slot7) ) {                        
			$slotlist .= "$slot7,";   
			$slot_cnt++;                            
			print "Slot7 = $slotlist \n";                                                                         
			} else {		                                          
			$ip_slot = 0;                                         
		}                                                       
	if ( eval($slot8) ) {                        
			$slotlist .= "$slot8,";   
			$slot_cnt++;                            
			print "Slot8 = $slotlist \n";                                                                         
			} else {		                                          
			$ip_slot = 0;                                         
		}                                                       
	if ( eval
	($slot9) ) {                        
			$slotlist .= "$slot9 ";   
			$slot_cnt++;                            
			print "Slot9 = $slotlist \n";                                                                          
			} else {		                                          
			$ip_slot = 0;                                         
		}			                                                  
                                                                           

 	#	 Make API call                                                                                                                                                                                                                                                                                                                                                                                  
	$urldata = 'http://api.keynote.com/keynote/api/getgraphdata?api_key=df92d879-c26c-34b5-ba0e-d730db69f24d&graphtype=scatter&basepageonly=true&averagemethod=GM&timezone=GMT&format=xml&slotidlist=';       	                                                                                                                                                                                        
	print "slotlist = $slotlist \n";                                                                                                                                                                                                                                                                                                                                              
     
#	$content = get $urldata.."$slot0".','."$slot1".','."$slot2".','."$slot3".','."$slot4".','."$slot5".','."$slot6".','."$slot7".','."$slot8".','."$slot9";	
# die "Couldn't get $urldata"."$slot0".','."$slot1".','."$slot2".','."$slot3".','."$slot4".','."$slot5".','."$slot6".','."$slot7".','."$slot8".','."$slot9" unless defined $content;
$eval_res = eval { $content = get $urldata.$slotlist };   

#		$content = get "$urldata.$slotlist";                              
#	  	die "Couldn't get $urldata.$slotlist" unless defined $content;       
	  	
# If there's a problem eval'ing the
# code, eval() returns undef and
# the error is found in $@.
	unless($eval_res) {
		print $@;
	}	# end unless


	# Load data into XML area
#	$xml_data = $xml->XMLin($content, forcearray=>1);
	$xml_data = $xml->XMLin($content);
	
#	print Dumper($xml_data);	
	
	print " before for: slot_idx = $slot_idx, slot_cnt = $slot_cnt -- \n";
			 
#				foreach $keyn_TxnMeasurement (@{$xml_data->{list}->{'com.keynote.mykeynote.service.api.response.txn.TxnMeasurement'}[$slot_idx]->{txnPages}}) {
#				foreach $keyn_TxnMeasurement (@{$xml_data->{list][0]{'com.keynote.mykeynote.service.api.response.txn.TxnMeasurement'}[$slot_idx]->{txnPages}->{'com.keynote.mykeynote.service.api.response.txn.TxnPage'}}) {
		foreach $keyn_TxnMeasurement (@{$xml_data->{list}[0]{'com.keynote.mykeynote.service.api.response.txn.TxnMeasurement'}}) {
	
				for ( $slot_idx = ($slot_cnt - 1), $slot_cnt > $slot_idx, $slot_cnt-- ) {	
		
						print " after for: slot_idx = $slot_idx, slot_cnt = $slot_cnt -- \n";
						# print ' foreach-parsing XML', Dumper($keyn_TxnMeasurement), "\n";
							
#							@keyn_PS = $keyn_TxnMeasurement->{txnPages}->{'com.keynote.mykeynote.service.api.response.txn.TxnPage'}->{txnPageStatus};
							@keyn_PS = $keyn_TxnMeasurement[$slot_idx]{txnPages}->{'com.keynote.mykeynote.service.api.response.txn.TxnPage'}->{txnPageStatus};
							
							if ( exists $keyn_PS[0] ) {		# Error code after content count, 2nd element
#									$keyn_EC = $keyn_TxnMeasurement->{txnPages}->{'com.keynote.mykeynote.service.api.response.txn.TxnPage'}->{txnPageStatus}->{error__code};
									$keyn_EC = $keyn_TxnMeasurement[$slot_idx]{txnPages}->{'com.keynote.mykeynote.service.api.response.txn.TxnPage'}->{txnPageStatus}->{error__code};
								} else {
									$keyn_EC = ' ';
							}	#end if
							
							print " Error Status obtained= $keyn_EC \n";
							
#							@keyn_PS = $keyn_TxnMeasurement[$slot_idx]{txnPages}->{txn__summary};
							@keyn_PS = $keyn_TxnMeasurement[$slot_idx]{txnPages}->{txn__summary};
		
			
							if ( exists $keyn_PS[0] ) {
									$keyn_BW_kbs = $keyn_TxnMeasurement[$slot_idx]{txnPages}->{txn__summary}->{bandwidth__kbsec};
									$keyn_UT_msec = $keyn_TxnMeasurement[$slot_idx]{txnPages}->{txn__summary}->{delta__user__msec};
								} else {
									$keyn_BW_kbs = $keyn_UT_msec = ' ';	# shouldn't happen	
							}	#end if
							
							print " Summary Status obtained, Bandwidth = $keyn_BW_kbs \n";
							print " Summary Status obtained, UT-msec = $keyn_UT_msec \n";							
							
#						$keyn_DT = $keyn_TxnMeasurement->{datetime};	
						$keyn_DT = $keyn_TxnMeasurement[$slot_idx]{datetime};	
						$ipf_slots_idx = $keyn_slot = $keyn_TxnMeasurement[$slot_idx]{slot__id};
						
						print " slot table for $keyn_slot \n";
						
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
					
						print 'Printed:, Date ', $keyn_DT, ' Target ', $keyn_target, ' Err Code ', $keyn_EC, ' Agent ', $keyn_agent_name, ' SlotID ', $keyn_slot, ' Usr Time(ms) ', $keyn_UT_msec, ' Bandwidth ', $keyn_BW_kbs, "\n";
				
						#	Reset var(s) for next entry
						$keyn_DT = $keyn_EC = $keyn_BW_kbs = $keyn_alias = $keyn_agent_name = $keyn_agent_id = $keyn_url = ' ';
						$keyn_EC = $keyn_target = $keyn_slot = $keyn_UT_msec = ' ';
				
						#	Clear array(s) for next entry
						@keyn_pages = @slot_values = ();	
						
						if ($slot_idx > 0) {
							$slot_idx = ($slot_cnt - 1);
						}	#	end  if 
						
					} 	#end for loop
					print "after for loop txn \n";
			
			} 	#end foreach loop
			    print "after foreach txn \n";
    			$slot0 = $slot1 = $slot2 = $slot3 = $slot4 = $slot5 = $slot6 = $slot7 = $slot8 = $slot9 = $slot_cnt = 0;		#	clear slotids for GET
    
  } #end While (slot table)  
		
	print "end While, closing... \n";

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
	$slot_urlslots = 'http://api.keynote.com/keynote/api/getslotmetadata?api_key=df92d879-c26c-34b5-ba0e-d730db69f24d&scope=agreement&agreementid=226613&format=xml';
	
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
