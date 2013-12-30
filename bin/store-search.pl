#!/usr/bin/perl

# store-search.pl - query a triple store
# Eric Lease Morgan <eric_morgan@infomotions.com>

# December 14, 2013 - after wrestling with wilson for most of the day


# configure
use constant ETC => '/disk01/www/html/main/sandbox/liam/etc/';
my %namespaces = (

  "crm"       => "http://erlangen-crm.org/current/",
  "dc"        => "http://purl.org/dc/elements/1.1/",
  "dcterms"   => "http://purl.org/dc/terms/",
  "event"     => "http://purl.org/NET/c4dm/event.owl#",
  "foaf"      => "http://xmlns.com/foaf/0.1/",
  "lode"      => "http://linkedevents.org/ontology/",
  "lvont"     => "http://lexvo.org/ontology#",
  "modsrdf"   => "http://simile.mit.edu/2006/01/ontologies/mods3#",
  "ore"       => "http://www.openarchives.org/ore/terms/",
  "owl"       => "http://www.w3.org/2002/07/owl#",
  "rdf"       => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  "rdfs"      => "http://www.w3.org/2000/01/rdf-schema#",
  "role"      => "http://simile.mit.edu/2006/01/roles#",
  "skos"      => "http://www.w3.org/2004/02/skos/core#",
  "time"      => "http://www.w3.org/2006/time#",
  "timeline"  => "http://purl.org/NET/c4dm/timeline.owl#",
  "wgs84_pos" => "http://www.w3.org/2003/01/geo/wgs84_pos#"
  
);

# require
use strict;
use RDF::Redland;

# sanity check #1 - command line arguments
my $db    = $ARGV[ 0 ];
my $query = $ARGV[ 1 ];
if ( ! $db or ! $query ) {

	print "Usage: $0 <db> <query>\n";
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

# search
#my $sparql  = RDF::Redland::Query->new( "CONSTRUCT { ?a ?b ?c } WHERE { ?a ?b ?c }", undef, undef, "sparql" );
my $sparql = RDF::Redland::Query->new( "PREFIX modsrdf: <http://simile.mit.edu/2006/01/ontologies/mods3#>\nSELECT ?a ?b ?c WHERE {  ?a  modsrdf:$query ?c }", undef, undef, 'sparql' );
my $results = $model->query_execute( $sparql );
print $results->to_string;

# done
exit;

