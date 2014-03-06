#!/usr/bin/perl

# store-dump.pl - output the content of store as RDF/XML
# Eric Lease Morgan <eric_morgan@infomotions.com>
#
# December 14, 2013 - after wrestling with wilson for most of the day


# configure
use constant ETC => '/disk01/www/html/main/sandbox/liam/etc/';

# require
use strict;
use RDF::Redland;

# sanity check #1 - command line arguments
my $db  = $ARGV[ 0 ];
if ( ! $db ) {

	print "Usage: $0 <db>\n";
	exit;
	
}

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

# do the work
my $serializer = RDF::Redland::Serializer->new;
print $serializer->serialize_model_to_string( RDF::Redland::URI->new, $model );

# done
exit;

