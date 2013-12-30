#!/usr/bin/perl

# marc2rdf.pl - make MARC records accessible via linked data

# Eric Lease Morgan <eric_morgan@infomotions.com>
# December 5, 2013 - first cut;


# configure
use constant ROOT      => '/disk01/www/html/main/sandbox/liam';
use constant MARC      => ROOT . '/src/marc/';
use constant DATA      => ROOT . '/data/';
use constant PAGES     => ROOT . '/pages/';
use constant MARC2HTML => ROOT . '/etc/MARC21slim2HTML.xsl';
use constant MARC2MODS => ROOT . '/etc/MARC21slim2MODS3.xsl';
use constant MODS2RDF  => ROOT . '/etc/mods2rdf.xsl';
use constant MAXINDEX  => 100;

# require
use IO::File;
use MARC::Batch;
use MARC::File::XML;
use strict;
use XML::LibXML;
use XML::LibXSLT;

# initialize
my $parser = XML::LibXML->new;
my $xslt   = XML::LibXSLT->new;

# process each record in the MARC directory
my @files = glob MARC . "*.marc";
for ( 0 .. $#files ) {

	# re-initialize
	my $marc = $files[ $_ ];
	my $handle = IO::File->new( $marc );
	binmode( STDOUT, ':utf8' );
	binmode( $handle, ':bytes' );
	my $batch  = MARC::Batch->new( 'USMARC', $handle );
	$batch->warnings_off;
	$batch->strict_off;
	my $index = 0;

	# process each record in the batch
	while ( my $record = $batch->next ) {

		# get marcxml
		my $marcxml =  $record->as_xml_record;
		my $_001    =  $record->field( '001' )->as_string;
		$_001       =~ s/_//;
		$_001       =~ s/ +//;
		$_001       =~ s/-+//;
		print "        marc: $marc\n";
		print "  identifier: $_001\n";
		print "         URI: http://infomotions.com/sandbox/liam/id/$_001\n";

		# re-initialize and sanity check
		my $output = PAGES . "$_001.html";
		if ( ! -e $output or -s $output == 0 ) {
	
			# transform marcxml into html
			print "        HTML: $output\n";
			my $source     = $parser->parse_string( $marcxml )  or warn $!;
			my $style      = $parser->parse_file( MARC2HTML )   or warn $!;
			my $stylesheet = $xslt->parse_stylesheet( $style )  or warn $!;
			my $results    = $stylesheet->transform( $source )  or warn $!;
			my $html       = $stylesheet->output_string( $results );
	
			&save( $output, $html );

		}
		else { print "        HTML: skipping\n" }

		# re-initialize and sanity check
		my $output = DATA . "$_001.rdf";
		if ( ! -e $output or -s $output == 0 ) {

			# transform marcxml into mods
			my $source     = $parser->parse_string( $marcxml )  or warn $!;
			my $style      = $parser->parse_file( MARC2MODS )   or warn $!;
			my $stylesheet = $xslt->parse_stylesheet( $style )  or warn $!;
			my $results    = $stylesheet->transform( $source )  or warn $!;
			my $mods       = $stylesheet->output_string( $results );
	
			# transform mods into rdf
			print "         RDF: $output\n";
			$source        = $parser->parse_string( $mods )     or warn $!;
			my $style      = $parser->parse_file( MODS2RDF )    or warn $!;
			my $stylesheet = $xslt->parse_stylesheet( $style )  or warn $!;
			my $results    = $stylesheet->transform( $source )  or warn $!;
			my $rdf        = $stylesheet->output_string( $results );
	
			&save( $output, $rdf );
			
		}
		else { print "         RDF: skipping\n" }
	
		# prettify
		print "\n";
		
		# increment and check
		$index++;
		last if ( $index > MAXINDEX )
		
	}

}

# done
exit;


sub save {

	open F, ' > ' . shift or die $!;
	binmode( F, ':utf8' );
	print F shift;
	close F;
	return;

}


