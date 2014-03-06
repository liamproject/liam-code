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
SELECT ?p ?o
WHERE { &lt;http://infomotions.com/sandbox/liam/id/mum432&gt; ?p ?o }
ORDER BY ?p
</textarea><br />
<input type='submit' value='Search' />
</form>
<p>Sample queries:</p>
<ul>
	<li>All the classes in the triple store - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+DISTINCT+%3Fo+WHERE+%7B+%3Fs+a+%3Fo+%7D+ORDER+BY+%3Fo" target="_blank">SELECT DISTINCT ?o WHERE { ?s a ?o } ORDER BY ?o</a></code></li>
	<li>All the properties in the triple store - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+DISTINCT+%3Fp+WHERE+%7B+%3Fs+%3Fp+%3Fo+%7D+ORDER+BY+%3Fp" target="_blank">SELECT DISTINCT ?p WHERE { ?s ?p ?o } ORDER BY ?p</a></code></li>
	<li>All the things things that are archival finding aids - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+%3Fs+WHERE+%7B+%3Fs+a+%3Chttp%3A%2F%2Fdata.archiveshub.ac.uk%2Fdef%2FFindingAid%3E+%7D" target="_blank">SELECT ?s WHERE { ?s a &lt;http://data.archiveshub.ac.uk/def/FindingAid&gt; }</a></code></li>
	<li>Everything about a specific actionable URI (finding aid) - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+%3Fp+%3Fo+WHERE+%7B+%3Chttp%3A%2F%2Finfomotions.com%2Fsandbox%2Fliam%2Fid%2Fmum432%3E+%3Fp+%3Fo+%7D+ORDER+BY+%3Fp" target="_blank">SELECT ?p ?o WHERE { &lt;http://infomotions.com/sandbox/liam/id/mum432&gt; ?p ?o } ORDER BY ?p</a></code></li>
	<li>Ten things that are MARC records - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+%3Fs+WHERE+%7B+%3Fs+a+%3Chttp%3A%2F%2Fsimile.mit.edu%2F2006%2F01%2Fontologies%2Fmods3%23Record%3E+%7D+LIMIT+10" target="_blank">SELECT ?s WHERE { ?s a &lt;http://simile.mit.edu/2006/01/ontologies/mods3#Record&gt; } LIMIT 10</a></code></li>
	<li>Everything about a specific actionable URI - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+%3Fp+%3Fo+WHERE+%7B+%3Chttp%3A%2F%2Finfomotions.com%2Fsandbox%2Fliam%2Fid%2Fshumarc681792%3E+%3Fp+%3Fo+%7D+ORDER+BY+%3Fp" target="_blank">SELECT ?p ?o WHERE { &lt;http://infomotions.com/sandbox/liam/id/shumarc681792&gt; ?p ?o } ORDER BY ?p</a></code></li>
	<li>One hundred things with titles - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+%3Fs+%3Fo+WHERE+%7B+%3Fs+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2Ftitle%3E+%3Fo+%7D+ORDER+BY+%3Fo+LIMIT+100" target="_blank">SELECT ?s ?o WHERE { ?s &lt;http://purl.org/dc/terms/title&gt; ?o } ORDER BY ?o LIMIT 100</a></code></li>
	<li>One hundred things with creators - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+%3Fs+%3Fo+WHERE+%7B+%3Fs+%3Chttp%3A%2F%2Fsimile.mit.edu%2F2006%2F01%2Froles%23creator%3E+%3Fo+%7D+ORDER+BY+%3Fo+LIMIT+100" target="_blank">SELECT ?s ?o WHERE { ?s &lt;http://simile.mit.edu/2006/01/roles#creator&gt; ?o } ORDER BY ?o LIMIT 100</a></code></li>
	<li>One hundred things with names - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+%3Fs+%3Fo+WHERE+%7B+%3Fs+%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2Fname%3E+%3Fo+%7D+ORDER+BY+%3Fo+LIMIT+100" target="_blank">SELECT ?s ?o WHERE { ?s &lt;http://xmlns.com/foaf/0.1/name&gt; ?o } ORDER BY ?o LIMIT 100</a></code></li>
	<li>One hundred things with notes - <code><a href="http://infomotions.com/sandbox/liam/sparql/?query=SELECT+%3Fs+%3Fo+WHERE+%7B+%3Fs+%3Chttp%3A%2F%2Fdata.archiveshub.ac.uk%2Fdef%2Fnote%3E+%3Fo+%7D+ORDER+BY+%3Fo+LIMIT+100" target="_blank">SELECT ?s ?o WHERE { ?s &lt;http://data.archiveshub.ac.uk/def/note&gt; ?o } ORDER BY ?o LIMIT 100</a></code></li>
</ul>
<p>For more information about SPARQL, see:</p>
<ol>
	<li><a href="http://www.w3.org/TR/rdf-sparql-query/" target="_blank">SPARQL Query Language for RDF</a> from the W3C</li>
	<li><a href="http://en.wikipedia.org/wiki/SPARQL" target="_blank">SPARQL</a> from Wikipedia</li>
</ol>
<p>Source code -- <a href="http://infomotions.com/sandbox/liam/bin/sparql.pl">sparql.pl</a> -- is available online.</p>
<hr />
<p>
<a href="mailto:eric_morgan\@infomotions.com">Eric Lease Morgan &lt;eric_morgan\@infomotions.com&gt;</a><br />
March 5, 2014
</p>
</body>
</html>
EOF

}
