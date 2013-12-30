#!/usr/bin/perl

# store-make.pl - simply initialize an RDF triple store
# Eric Lease Morgan <eric_morgan@infomotions.com>
#
# December 14, 2013 - after wrestling with wilson for most of the day


# configure
use constant ETC => '/disk01/www/html/main/sandbox/liam/etc/';

# require
use strict;
use RDF::Redland;

# sanity check
my $db = $ARGV[ 0 ];
if ( ! $db ) {

	print "Usage: $0 <db>\n";
	exit;
	
}

# do the work; brain-dead
my $etc = ETC;
my $store = RDF::Redland::Storage->new( 'hashes', $db, "new='yes', hash-type='bdb', dir='$etc'" );
die "Unable to create store ($!)" unless $store;
my $model = RDF::Redland::Model->new( $store, '' );
die "Unable to create model ($!)" unless $model;

# "save"
$store = undef;
$model = undef;

# done
exit;

