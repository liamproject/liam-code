package Apache2::LiAM::Dereference;

# Dereference.pm - Redirect user-agents based on value of URI.

# Eric Lease Morgan <eric_morgan@infomotions.com>
# December 7, 2013 - first investigations; based on Apache2::Alex::Dereference


# configure
use constant PAGES => 'http://infomotions.com/sandbox/liam/pages/';
use constant DATA  => 'http://infomotions.com/sandbox/liam/data/';

# require
use Apache2::Const -compile => qw( OK );
use CGI;
use strict;

# main
sub handler {

	# initialize
	my $r   = shift;
	my $cgi = CGI->new;
	my $id  = substr( $r->uri, length $r->location );
	
	# wants RDF
	if ( $cgi->Accept( 'text/html' )) {
	
		print $cgi->header( -status => '303 See Other', 
		-Location => PAGES . $id . '.html', 
		-Vary     => 'Accept' )
		
	}

	# give them RDF
	else {
	
		print $cgi->header( -status => '303 See Other', 
		-Location      => DATA . $id . '.rdf', 
		-Vary          => 'Accept', 
		"Content-Type" => 'application/rdf+xml' )
		
	}
	
	# done
	return Apache2::Const::OK;

}

1; # return true or die
