#!/usr/bin/perl

# sparql.pl - a brain-dead, half-baked SPARQL endpoint

# Eric Lease Morgan <eric_morgan@infomotions.com>
# December 15, 2013 - first investigations


# require
use CGI;
use CGI::Carp qw( fatalsToBrowser );
use RDF::Redland;
use strict;

# initialize
my $cgi   = CGI->new;
my $query = $cgi->param( 'query' );

if ( ! $query ) {

	print $cgi->header;
	print &home;

}

else {

	# open the store for business
	my $store = RDF::Redland::Storage->new( 'hashes', 'store', "new='no', hash-type='bdb', dir='/disk01/www/html/main/sandbox/liam/etc'" );
	my $model = RDF::Redland::Model->new( $store, '' );

	# search
	my $results = $model->query_execute( RDF::Redland::Query->new( $query, undef, undef, 'sparql' ) );

	# return the results
	print $cgi->header( -type => 'application/xml' );
	print $results->to_string;

}

# done
exit;


sub home {

	# create a list namespaces
	my $namespaces = &namespaces;
	my $list       = '';
	foreach my $prefix ( sort keys $namespaces ) {
	
		my $uri = $$namespaces{ $prefix };
		$list .= $cgi->li( "$prefix - " . $cgi->a( { href=> $uri, target => '_blank' }, $uri ) );
		
	}
	$list = $cgi->ol( $list );
	
	# return a home page
	return <<EOF
<html>
<head>
<title>LiAM SPARQL Endpoint</title>
</head>
<body style='margin: 7%'>
<h1>LiAM SPARQL Endpoint</h1>
<p>This is a brain-dead and half-baked SPARQL endpoint to a subset of LiAM linked data. Enter a query, but there is the disclaimer. Errors will probably happen because of SPARQL syntax errors. Remember, the interface is brain-dead. Your milage <em>will</em> vary.</p>
<form method='GET' action='./'>
<textarea style='font-size: large' rows='5' cols='65' name='query' />
PREFIX hub:<http://data.archiveshub.ac.uk/def/>
SELECT ?uri
WHERE { ?uri ?o hub:FindingAid }
</textarea><br />
<input type='submit' value='Search' />
</form>
<p>Here are a few sample queries:</p>
<ul>
	<li>Find all triples with RDF Schema labels - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=PREFIX+rdf%3A%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0ASELECT+*+WHERE+%7B+%3Fs+rdf%3Alabel+%3Fo+%7D%0D%0A">PREFIX rdf:&lt;http://www.w3.org/2000/01/rdf-schema#&gt; SELECT * WHERE { ?s rdf:label ?o }</a></code></li>
	<li>Find all items with MODS subjects - <code><a href='http://infomotions.com/sandbox/liam/sparql/?query=PREFIX+mods%3A%3Chttp%3A%2F%2Fsimile.mit.edu%2F2006%2F01%2Fontologies%2Fmods3%23%3E%0D%0ASELECT+*+WHERE+%7B+%3Fs+mods%3Asubject+%3Fo+%7D'>PREFIX mods:&lt;http://simile.mit.edu/2006/01/ontologies/mods3#&gt; SELECT * WHERE { ?s mods:subject ?o }</a></code></li>
	<li>Find every unique predicate - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+DISTINCT+%3Fp+WHERE+%7B+%3Fs+%3Fp+%3Fo+%7D">SELECT DISTINCT ?p WHERE { ?s ?p ?o }</a></code></li>
	<li>Find everything - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+*+WHERE+%7B+%3Fs+%3Fp+%3Fo+%7D">SELECT * WHERE { ?s ?p ?o }</a></code></li>
	<li>Find all classes - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+DISTINCT+%3Fclass+WHERE+%7B+%5B%5D+a+%3Fclass+%7D+ORDER+BY+%3Fclass">SELECT DISTINCT ?class WHERE { [] a ?class } ORDER BY ?class</a></code></li>
	<li>Find all properties - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+DISTINCT+%3Fproperty%0D%0AWHERE+%7B+%5B%5D+%3Fproperty+%5B%5D+%7D%0D%0AORDER+BY+%3Fproperty">SELECT DISTINCT ?property WHERE { [] ?property [] } ORDER BY ?property</a></code></li>
	<li>Find URIs of all finding aids - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=PREFIX+hub%3A%3Chttp%3A%2F%2Fdata.archiveshub.ac.uk%2Fdef%2F%3E+SELECT+%3Furi+WHERE+%7B+%3Furi+%3Fo+hub%3AFindingAid+%7D">PREFIX hub:&lt;http://data.archiveshub.ac.uk/def/&gt; SELECT ?uri WHERE { ?uri ?o hub:FindingAid }</a></code></li>
	<li>Find URIs of all MARC records - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=PREFIX+mods%3A%3Chttp%3A%2F%2Fsimile.mit.edu%2F2006%2F01%2Fontologies%2Fmods3%23%3E+SELECT+%3Furi+WHERE+%7B+%3Furi+%3Fo+mods%3ARecord+%7D%0D%0A%0D%0A%0D%0A">PREFIX mods:&lt;http://simile.mit.edu/2006/01/ontologies/mods3#&gt; SELECT ?uri WHERE { ?uri ?o mods:Record }</a></code></li>
	<li>Find all URIs of all collections - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=PREFIX+mods%3A%3Chttp%3A%2F%2Fsimile.mit.edu%2F2006%2F01%2Fontologies%2Fmods3%23%3E%0D%0APREFIX+hub%3A%3Chttp%3A%2F%2Fdata.archiveshub.ac.uk%2Fdef%2F%3E%0D%0ASELECT+%3Furi+WHERE+%7B+%7B+%3Furi+%3Fo+hub%3AFindingAid+%7D+UNION+%7B+%3Furi+%3Fo+mods%3ARecord+%7D+%7D%0D%0AORDER+BY+%3Furi%0D%0A">PREFIX mods:&lt;http://simile.mit.edu/2006/01/ontologies/mods3#&gt; PREFIX hub:&lt;http://data.archiveshub.ac.uk/def/&gt; SELECT ?uri WHERE { { ?uri ?o hub:FindingAid } UNION { ?uri ?o mods:Record } } ORDER BY ?uri</a></code></li>
</ul>
<p>This is a list of ontologies (namespaces) used in the triple store as predicates:</p>
$list
<p>For more information about SPARQL, see:</p>
<ol>
	<li><a href="http://www.w3.org/TR/rdf-sparql-query/" target="_blank">SPARQL Query Language for RDF</a> from the W3C</li>
	<li><a href="http://en.wikipedia.org/wiki/SPARQL" target="_blank">SPARQL</a> from Wikipedia</li>
</ol>
<p>Source code -- <a href="http://infomotions.com/sandbox/liam/bin/sparql.pl">sparql.pl</a> -- is available online.</p>
<hr />
<p>
<a href="mailto:eric_morgan\@infomotions.com">Eric Lease Morgan &lt;eric_morgan\@infomotions.com&gt;</a><br />
January 6, 2014
</p>
</body>
</html>
EOF

}


sub namespaces {

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
	
	return \%namespaces;

}


