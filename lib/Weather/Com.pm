#line 1 "Weather/Com.pm"
package Weather::Com;

# $Revision: 1.5 $

use 5.006;
use strict;
use warnings;
use URI::Escape;
use LWP::UserAgent;
use XML::Simple;
use Data::Dumper;
use Time::Local;

require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw ( celsius2fahrenheit fahrenheit2celsius convert_winddirection);
our $VERSION   = "0.1";

my $CITY_SEARCH_URI    = "http://xoap.weather.com/search/search?where=";
my $WEATHER_SEARCH_URI = "http://xoap.weather.com/weather/local/";

my %winddir = (
				"VAR"             => "Variable",
				"N"               => "North",
				"NNW"             => "North Northwest",
				"NW"              => "Northwest",
				"WNW"             => "West Northwest",
				"W"               => "West",
				"WSW"             => "West Southwest",
				"SW"              => "Southwest",
				"SSW"             => "South Southwest",
				"S"               => "South",
				"SSE"             => "South Southeast",
				"SE"              => "Southeast",
				"ESE"             => "East Southeast",
				"E"               => "East",
				"ENE"             => "East Northeast",
				"NE"              => "Northeast",
				"NNE"             => "North Northeast",
				"North"           => "N",
				"North Northwest" => "NNW",
				"Northwest"       => "NW",
				"West Northwest"  => "WNW",
				"West"            => "W",
				"West Southwest"  => "WSW",
				"Southwest"       => "SW",
				"South Southwest" => "SSW",
				"South"           => "S",
				"South Southeast" => "SSE",
				"Southeast"       => "SE",
				"East Southeast"  => "ESE",
				"East"            => "E",
				"East Northeast"  => "ENE",
				"Northeast"       => "NE",
				"North Northeast" => "NNE",
				"Variable"        => "VAR",
);

#------------------------------------------------------------------------
# Constructor
#------------------------------------------------------------------------
sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self  = {};

	# some general attributes
	$self->{PROXY}   = "none";
	$self->{TIMEOUT} = 180;
	$self->{DEBUG}   = 0;

	# license information
	$self->{PARTNER_ID}  = undef;
	$self->{LICENSE_KEY} = undef;

	# API specific attributes
	$self->{UNITS}    = 'm';    # could be 'm' for metric or 's' for us standard
	$self->{CC}       = 0;      # show current conditions true/false
	$self->{FORECAST} = 0;      # multi day forecast 0 = no, 1..10 days
	$self->{LINKS}    = 0;

	# parameters provided by new method
	my %parameters = ();
	if ( ref( $_[0] ) eq "HASH" ) {
		%parameters = %{ $_[0] };
	} else {
		%parameters = @_;
	}

	# set attributes as in %parameters
	$self->{PARTNER_ID} = $parameters{partner_id}
	  if ( $parameters{partner_id} );
	$self->{LICENSE_KEY} = $parameters{license} if ( $parameters{license} );
	$self->{PROXY}       = $parameters{proxy}   if ( $parameters{proxy} );
	$self->{TIMEOUT}     = $parameters{timeout} if ( $parameters{timeout} );
	$self->{DEBUG}       = $parameters{debug}   if ( $parameters{debug} );
	$self->{UNITS}       = $parameters{units}   if ( $parameters{units} );
	$self->{CC}          = $parameters{current} if ( $parameters{current} );
	$self->{LINKS}       = $parameters{links}   if ( $parameters{links} );

	# do some validity checking on the forecast value
	# has to be between 0 and 10. we will ignore any other value
	if ( $parameters{forecast} && ( $parameters{forecast} =~ /^[1]?\d$/ ) ) {
		$self->{FORECAST} = $parameters{forecast};
	}

	bless( $self, $class );

	$self->_debug( Dumper($self) );

	return $self;
}

#------------------------------------------------------------------------
# getting data from weather.com
#------------------------------------------------------------------------
sub search {
	my $self  = shift;
	my $place = shift;

	# set error and die if no place provided
	unless ($place) {
		die ref($self), ": ERROR Please provide a location to search for!\n";
	}

	# build up HTTP GET request
	$place = uri_escape($place);
	my $searchlocation = $CITY_SEARCH_URI . $place;
	$searchlocation .= '&prod=xoap';
	if ( $self->{PARTNER_ID} && $self->{LICENSE_KEY} ) {
		$searchlocation .= '&par=' . $self->{PARTNER_ID};
		$searchlocation .= '&key=' . $self->{LICENSE_KEY};
	}

	$self->_debug($searchlocation);

	# get information
	my $locationXML;
	my $i = 0;
	while ( !$locationXML || ( $locationXML !~ /^\<\?xml/ ) && ( $i < 3 ) ) {
		eval { $locationXML = $self->_getWebPage($searchlocation); };
		if ($@) {
			die ref($self),
": ERROR No response from weather server while searching place: $@\n";
		}

		# check if at least one location has been returned
		# if not return 0
		if ( $locationXML =~ /^\s*$/g ) {
			$self->_debug(
				"No location found using $place (url escaped) as search string." );
			return 0;
		}

		$i++;
	}

	return 0 unless ( $locationXML =~ /^\<\?xml/ );

	# parse answer
	my $simpleHash = XMLin($locationXML);

	# XML::Simple behaves differently when one location is return than
	# when more locations are returned ...
	my $locations = {};
	if ( $simpleHash->{loc}->{content} ) {
		$locations->{ $simpleHash->{loc}->{id} } =
		  $simpleHash->{loc}->{content};
	} else {
		foreach ( keys %{ $simpleHash->{loc} } ) {
			$locations->{$_} = $simpleHash->{loc}->{$_}->{content};
		}
	}

	$self->_debug( Dumper($locations) );

	return $locations;
}    # end search()

sub get_weather {
	my $self  = shift;
	my $locid = shift;

	unless ($locid) {
		die ref($self), ": ERROR Please provide a location id!\n";
	}

	# prepare HTTP Request
	my $searchlocation = $WEATHER_SEARCH_URI . $locid;
	$searchlocation .= '?unit=' . $self->{UNITS};
	$searchlocation .= '&prod=xoap';

	if ( $self->{PARTNER_ID} && $self->{LICENSE_KEY} ) {
		$searchlocation .= '&par=' . $self->{PARTNER_ID};
		$searchlocation .= '&key=' . $self->{LICENSE_KEY};
	}
	if ( $self->{CC} ) {
		$searchlocation .= '&cc=*';
	}
	if ( $self->{FORECAST} ) {
		$searchlocation .= '&dayf=' . $self->{FORECAST};
	}
	if ( $self->{LINKS} ) {
		$searchlocation .= '&link=xoap';
	}

	# get weather data
	$self->_debug($searchlocation);
	my $weatherXML;
	eval { $weatherXML = $self->_getWebPage($searchlocation); };
	if ($@) {
		die ref($self),
		  ": ERROR No response from weather server while loading data: $@\n";
	}

	# parse weather data
	my $simpleHash = XMLin($weatherXML);

	# do some error handling if weather.com returns an error message
	if ( $simpleHash->{err} ) {
		die ref($self), ": ERROR ", $simpleHash->{err}->{content}, "\n";
	}

	return $simpleHash;
}

#--------------------------------------------------------------------
# Utility function to get one web pages content or die on error
#--------------------------------------------------------------------
sub _getWebPage {
	my $self = shift;
	my $path = shift;

	# instantiate a new user agent, with proxy if necessary
	my $ua = LWP::UserAgent->new();
	$ua->proxy( 'http', $self->{PROXY} )
	  if ( $self->{PROXY} ne "none" );
	$ua->timeout( $self->{TIMEOUT} );

	# print some debugging info on the user agent object
	$self->_debug("This is the user agent we wanna use...");
	$self->_debug( Dumper($ua) );

	# get the html page
	my $response = $ua->get($path);

	# and do some error handling
	my $html = undef;
	if ( $response->is_success() ) {
		$html = $response->content();
	} else {
		die "ERROR While getting resource: $path :\n", $response->status_line(),
		  "\n";
	}

	# and print the complete HTML response for debugging purposes
	$self->_debug($html);

	return $html;
}

#------------------------------------------------------------------------
# other internals
#------------------------------------------------------------------------
sub _debug {
	my $self   = shift;
	my $notice = shift;
	if ( $self->{DEBUG} ) {
		warn ref($self) . " DEBUG NOTE: $notice\n";
		return 1;
	}
	return 0;
}

#########################################################################
#
#	STATIC methods go here
#
#------------------------------------------------------------------------
# methods for temperature conversion
#------------------------------------------------------------------------
sub celsius2fahrenheit {
	my $celsius = shift;
	my $fahrenheit = sprintf( "%d", ( $celsius * 1.8 ) + 32 );
	return $fahrenheit;
}

sub fahrenheit2celsius {
	my $fahrenheit = shift;
	my $celsius = sprintf( "%d", ( $fahrenheit - 32 ) / 1.8 );
	return $celsius;
}

#------------------------------------------------------------------------
# internal time conversion methods
#------------------------------------------------------------------------
sub _lsup2epoc {

	# this method returns epoc for gmt corresponding to
	# the provided last update value (lsup)
	my $lsup       = shift;
	my $gmt_offset = shift;

	my ( $date, $time, $ampm, $zone ) = split( / /, $lsup );
	my ( $mon, $mday, $year ) = split( "/", $date );
	my ( $hour, $min ) = split( /:/, $time );

	$year += 100;
	$hour += 12 if ( $ampm eq "PM" );

	my $gmtime = timegm( 0, $min, $hour, $mday, $mon - 1, $year );
	$gmtime -= $gmt_offset * 3600;

	return $gmtime;
}

sub _epoc2lsup {

	# this method takes epoc (gmt) and builds up the weather.com
	# internally used last update format (lsup)
	my $epoc       = shift;
	my $gmt_offset = shift;

	my ( $sec, $min, $hour, $mday, $mon, $year ) =
	  gmtime( $epoc + $gmt_offset * 3600 );

	$year -= 100;
	$year = '0' . $year if ( $year < 10 );
	$mon++;
	my $ampm = "AM";

	if ( $hour > 12 ) {
		$hour -= 12;
		$ampm = "PM";
	}

	my $time = join( ":", $hour, $min );
	my $date = join( "/", $mon,  $mday, $year );
	my $lsup = join( " ", $date, $time, $ampm, "Local Time" );

	return $lsup;
}

#------------------------------------------------------------------------
# wind direction conversion methods
#------------------------------------------------------------------------
sub convert_winddirection {
	my $indir = shift;
	return $winddir{$indir};
}


1;
__END__

#line 970
