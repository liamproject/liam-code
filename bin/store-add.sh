# brain-dead way of adding bunches of RDF to a triple store
for f in /disk01/www/html/main/sandbox/liam/data/mum*.rdf
do
	/disk01/www/html/main/sandbox/liam/bin/store-add.pl store $f
done