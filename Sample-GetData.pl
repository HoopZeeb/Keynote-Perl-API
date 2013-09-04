#!/usr/bin/env perl

=head1 [Keynote-API-Simple]

 Simple use of the Keynote API:

=cut

use LWP::Simple;			# HTTP support
use XML::Simple;			# XML::Simple
use Data::Dumper;			# Dumping XML, debug
use Text::CSV;				#	CSV parsing support
use DateTime;					# DT for output filename
#
use feature ':5.10';
use strict;						# XML -- recommended setting
#use warnings;
use Getopt::Long;

my $prog = $0;
my $usage = <<EOQ;
Usage for $0:

  >$prog [-test -help -verbose]

EOQ

#	check if i/p file passed on cmd-line
if ( @ARGV > 0 )
{
  print "Number of arguments: " . scalar @ARGV . "\n";
}
else
{
  print "No arguments! Need input filename! \n";
  exit 99;
}

#	check if filename passed actually exists
my $filename = $ARGV[0];				# get filename passed
	if (-e $filename) {
 		print "IP File Exists!";
 	} else { 
 		print "IP File Doesn't Exist!";
 		exit 98;
 	}
 
#	instantiate DateTime
my $dt = DateTime->now; 
 
#	Open filename passed
open IPFILE, "$filename" or die $!; 

#	initialize Text::CSV support
my $csv = Text::CSV->new({ sep_char => ',' });

my (@fields, $ip_slot, $ip_alias);
my ($line, $opfile);

$opfile = $dt.'-file.csv';
#	open O/P file, use DateTime from previous in Filename
open OPFILE, ">$opfile" or die $!;

# instantiate XML services
my $xml = new XML::Simple;

#	read slotid from input record. Save measurement alias name
while ($line = <IPFILE>) {			#	loop as long as input exists
  chomp $line;
  if ($csv->parse($line)) {
  	@fields = $csv->fields();
  	$ip_slot = $fields[0];
  	$ip_alias = $fields[1];
  } else {
  		warn "Line could not be parsed: $line \n";
  	}
#  	  print $_;

# Make API call
my $url = 'http://api.keynote.com/keynote/api/getgraphdata?api_key=df92d879-c26c-34b5-ba0e-d730db69f24d&graphtype=scatter&basepageonly=true&averagemethod=GM&timezone=GMT&format=xml&slotidlist=';
my $content = get $url.$ip_slot;
  die "Couldn't get $url.$ip_slot" unless defined $content;

# Load data into XML area
# my $xml_data = $xml->XMLin("api-scatter-output-03.xml");
my $xml_data = $xml->XMLin($content);
my ($keyn_EC, $keyn_agent, $keyn_DT, $keyn_slot, $keyn_BWs, $keyn_TxnMeasurement, $keyn_target);

# print XML area
# print Dumper($xml_data);

# Loop through pages, get error__code, datetime, agent__id, slot__id, bandwidth__kbsec

foreach $keyn_TxnMeasurement (@{$xml_data->{list}->{'com.keynote.mykeynote.service.api.response.txn.TxnMeasurement'}}) {
	if ($keyn_TxnMeasurement->{txn__error}->{code} gt " ") {
		$keyn_EC = $keyn_TxnMeasurement->{txn__error}->{code};
	}
	if ($keyn_TxnMeasurement->{txn__summary}->{bandwidth__kbsec} gt " ") {
		$keyn_BWs = $keyn_TxnMeasurement->{txn__summary}->{bandwidth__kbsec};
	}
	$keyn_agent = $keyn_TxnMeasurement->{agent__id};
	$keyn_DT = $keyn_TxnMeasurement->{datetime};
	$keyn_slot = $keyn_TxnMeasurement->{slot__id};	
	$keyn_target = $keyn_TxnMeasurement->{target__id};
	$keyn_BWs = $keyn_TxnMeasurement->{txn__summary}->{bandwidth__kbsec};	
	
	print OPFILE $keyn_DT.','.$keyn_target.','.$keyn_EC.','.$ip_alias.','.$keyn_agent.','.$keyn_slot.','.$keyn_BWs."\n";
	
#	print ' Date ', $keyn_DT, ' Target ', $keyn_target, ' Err Code ', $keyn_EC, ' Agent ', $keyn_agent, ' SlotID ', $keyn_slot, ' Bandwidth ', $keyn_BWs, "\n";

	$keyn_DT = ' ';
	$keyn_target = ' '; 
	$keyn_EC = ' ';
	$keyn_agent = ' '; 
	$keyn_slot = ' ';
	$keyn_BWs = ' ';

    }  # end foreach
  } #end while loop  
  
close IPFILE;
close OPFILE;
  
