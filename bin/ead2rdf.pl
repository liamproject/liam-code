#!/usr/bin/perl

# ead2rdf.pl - make EAD files accessible via linked data

# Eric Lease Morgan <eric_morgan@infomotions.com>
# December 6, 2013 - based on marc2linkedata.pl


# configure
use constant ROOT     => '/disk01/www/html/main/sandbox/liam';
use constant EAD      => ROOT . '/src/ead/';
use constant DATA     => ROOT . '/data/';
use constant PAGES    => ROOT . '/pages/';
use constant EAD2HTML => ROOT . '/etc/ead2html.xsl';
use constant EAD2RDF  => ROOT . '/etc/ead2rdf.xsl';
use constant SAXON    => 'java -jar /disk01/www/html/main/sandbox/liam/bin/saxon.jar -s:##SOURCE## -xsl:##XSL## -o:##OUTPUT##';

# require
use strict;
use XML::XPath;
use XML::LibXML;
use XML::LibXSLT;

# initialize
my $saxon  = '';
my $xsl    = '';
my $parser = XML::LibXML->new;
my $xslt   = XML::LibXSLT->new;

# process each record in the EAD directory
my @files = glob EAD . "*.xml";
for ( 0 .. $#files ) {

	# re-initialize
	my $ead = $files[ $_ ];
	print "         EAD: $ead\n";

	# get the identifier
	my $xpath      = XML::XPath->new( filename => $ead );
	my $identifier = $xpath->findvalue( '/ead/eadheader/eadid' );
	$identifier    =~ s/[^\w ]//g;
	print "  identifier: $identifier\n";
	print "         URI: http://infomotions.com/sandbox/liam/id/$identifier\n";
		
	# re-initialize and sanity check
	my $output = PAGES . "$identifier.html";
	if ( ! -e $output or -s $output == 0 ) {
	
		# transform marcxml into html
		print "        HTML: $output\n";
		my $source     = $parser->parse_file( $ead )  or warn $!;
		my $style      = $parser->parse_file( EAD2HTML )   or warn $!;
		my $stylesheet = $xslt->parse_stylesheet( $style )  or warn $!;
		my $results    = $stylesheet->transform( $source )  or warn $!;
		my $html       = $stylesheet->output_string( $results );
	
		&save( $output, $html );

	}
	else { print "        HTML: skipping\n" }
	
	# re-initialize and sanity check
	my $output = DATA . "$identifier.rdf";
	if ( ! -e $output or -s $output == 0 ) {
	
		# create saxon command, and save rdf
		print "         RDF: $output\n";
		$saxon  =  SAXON;
		$xsl    =  EAD2RDF;
		$saxon  =~ s/##SOURCE##/$ead/e;
		$saxon  =~ s/##XSL##/$xsl/e;
		$saxon  =~ s/##OUTPUT##/$output/e;
		system $saxon;
	
	}
	else { print "         RDF: skipping\n" }
	
	# prettify
	print "\n";
	
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



