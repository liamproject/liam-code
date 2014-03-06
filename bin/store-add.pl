#!/usr/bin/perl

# store-add.pl - add items to an RDF triple store
# Eric Lease Morgan <eric_morgan@infomotions.com>
#
# December 14, 2013 - after wrestling with wilson for most of the day


# configure
use constant ETC => '/disk01/www/html/main/sandbox/liam/etc/';

# require
use strict;
use RDF::Redland;

# sanity check #1 - command line arguments
my $db   = $ARGV[ 0 ];
my $file = $ARGV[ 1 ];
if ( ! $db or ! $file ) {

	print "Usage: $0 <db> <file>\n";
	exit;
	
}

# echo
warn "$file\n";

# sanity check #2 - store exists
die "Error: po2s file not found. Make a store?\n" if ( ! -e ETC . $db . '-po2s.db' );
die "Error: so2p file not found. Make a store?\n" if ( ! -e ETC . $db . '-so2p.db' );
die "Error: sp2o file not found. Make a store?\n" if ( ! -e ETC . $db . '-sp2o.db' );

# open the store
my $etc = ETC;
my $store = RDF::Redland::Storage->new( 'hashes', $db, "new='no', hash-type='bdb', dir='$etc'" );
die "Error: Unable to open store ($!)" unless $store;
my $model = RDF::Redland::Model->new( $store, '' );
die "Error: Unable to create model ($!)" unless $model;

# sanity check #3 - file exists
die "Error: $file not found.\n" if ( ! -e $file );

# parse a file and add it to the store
my $uri    = RDF::Redland::URI->new( "file:$file" );
my $parser = RDF::Redland::Parser->new( 'rdfxml', 'application/rdf+xml' );
die "Error: Failed to find parser ($!)\n" if ( ! $parser );
my $stream = $parser->parse_as_stream( $uri, $uri );
my $count  = 0;
while ( ! $stream->end ) {

	$model->add_statement( $stream->current );
	$count++;
	$stream->next;

}

# echo the result
#warn "Namespaces:\n";
#my %namespaces = $parser->namespaces_seen;
#while ( my ( $prefix, $uri ) = each %namespaces ) {
#
#	warn " prefix: $prefix\n";
#	warn '    uri: ' . $uri->as_string . "\n";
#	warn "\n";
#
#}
warn "Added $count statements\n";
warn "\n";

# "save"
$store = undef;
$model = undef;

# done
exit;

