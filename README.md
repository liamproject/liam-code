liam-code
=========

This is a small set of Perl scripts used to publish MARC and EAD files as linked data. And what is here is as follows:

  * bin/ead2rdf.pl - reads EAD files and outputs RDF/XML
  * bin/marc2rdf.pl - reads MARC and outputs RDF/XML
  * bin/store-make.pl - initializes a triple store
  * bin/store-add.pl - takes RDF/XML as input and updates the triple store
  * bin/store-add.sh - an easy way to feed content to store-add.pl
  * bin/store-search.pl - queries the triple store
  * bin/store-dump.pl - outputs the whole store
  * bin/sparql.pl - a (brain-dead and half-baked) SPARQL endpoint for the store
  * etc/*.xsl - various XSL stylesheets used to create the RDF/XML
  * etc/*.txt - lists of URLs to feed to wget and cache EAD and/or MARC locally
  * lib/LiAM/Dereference.pm - mod_perl code to implement content-negotiation

-- 
Eric Lease Morgan (March 5, 2014)