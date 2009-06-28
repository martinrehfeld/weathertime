# Weather/Wunderground.pm
# $Id$
#
#	Author: Martin Rehfeld <martin.rehfeld(at)glnetworks(dot)de>
#
#	Copyright (c) 2008
#	This file is part of the WeatherTime software. The same license applies.
#	See main file Plugin.pm for details

package Weather::Wunderground;

# = Purpose
# Plug-In Replacement for Weather::Com to provide TWC formatted Data from Wunderground
#
# == Weather.Com XML structure (only parts used in WeatherTime)
# 
# %weather
#   head              Header
#     ut              unit of temperature
# 
#   cc                Current Conditions
#     tmp             temperature
#   
#   dayf              Day forcasts
#     day[0..]        Arrays of forecasts, starting with current day (=0), tomorrow (=1)
#       hi            max temperature
#       low           min temperature
#       t             name of weekday
#       part[0..1]    data for first (=0) or second (=1) half of the day
#         t           Conditions text
#         icon        Conditions icon index
#         ppcp        Precipitation chance
#         wind
#           s         wind speed
#           t         wind direction (N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW, ALL)
#         
# == Mapping of Weather.Com XML structure to Wunderground format
# 
# %weather
#   head              Header
#     ut              parameters->{UNITS} =m -> C, =s -> F
# 
#   cc                Current Conditions
#     tmp             current->(temp_f|temp_c)
#   
#   dayf              Day forcasts
#     day[0..]        day = simpleforecast->forecastday[0..]
#       hi            day->high->(celsius|fahrenheit)
#       low           day->low->(celsius|fahrenheit)
#       t             day->date->weekday
#       part[0..1]    we only have one part per day!, let's fill [0] and leave [1] undefined
#         t           day->conditions
#         icon        we use day->icon (i.e. chancerain), also available: day->skyicon (i.e. partlycloudy) and map to TWC-Icon-No
#         ppcp        day->pop
#         wind        only in current
#           s         current->wind_mph
#           t         current->wind_dir

use 5.006;
use strict;
use warnings;
use URI::Escape;
use LWP::UserAgent;
use XML::Simple;
use Data::Dumper;

my $FORECAST_QUERY_URI = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=";
my $CURRENT_QUERY_URI = "http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml?query=";

# translate Wunderground icon string into TWC icon number
my $TwcIcons = {
# observed
	'chancerain'     => 11,
	'chancesnow'     => 13,
	'chancetstorms'  => 37,
	'clear'          => 32,
	'cloudy'         => 26,
	'hazy'           => 21,
	'mostlycloudy'   => 28,
	'mostlysunny'    => 34,
	'partlycloudy'   => 30,
	'rain'           => 12,
	'sleat'          => 5,
	'snow'           => 14,
	'sunny'          => 32,
	'tstorms'        => 35,
# additional conditions from http://saratoga-weather.org/WU-forecast.php?sce=view
	'sleet'          => 5,
	'chanceflurries' => 23,
	'chancesleet'    => 5,
	'chancesleat'    => 5,
	'flurries'       => 23,
	'fog'            => 20,
	'partlysunny'    => 28,
	'unknown'        => 29,
# nighttime conditions (do not seem to be used in the XML data feed)
	'nt_chanceflurries' => 23,
	'nt_chancerain' => 45,
	'nt_chancesleet' => 5,
	'nt_chancesnow' => 46,
	'nt_chancetstorms' => 47,
	'nt_clear' => 31,
	'nt_cloudy' => 26,
	'nt_flurries' => 46,
	'nt_fog' => 20,
	'nt_hazy' => 33,
	'nt_mostlycloudy' => 27,
	'nt_mostlysunny' => 29,
	'nt_partlycloudy' => 29,
	'nt_partlysunny' => 29,
	'nt_rain' => 12,
	'nt_sleet' => 5,
	'nt_snow' => 15,
	'nt_sunny' => 31,
	'nt_tstorms' => 47,
	'nt_unknown' => 29
};

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

	# API specific attributes
	$self->{UNITS}    = 'm';    # could be 'm' for metric or 's' for us standard

	# parameters provided by new method
	my %parameters = ();
	if ( ref( $_[0] ) eq "HASH" ) {
		%parameters = %{ $_[0] };
	} else {
		%parameters = @_;
	}

	# set attributes as in %parameters
	$self->{PROXY}       = $parameters{proxy}   if ( $parameters{proxy} );
	$self->{TIMEOUT}     = $parameters{timeout} if ( $parameters{timeout} );
	$self->{DEBUG}       = $parameters{debug}   if ( $parameters{debug} );
	$self->{UNITS}       = $parameters{units}   if ( $parameters{units} );

	bless( $self, $class );

	$self->_debug( Dumper($self) );

	return $self;
}

sub get_weather {
	my $self  = shift;
	my $locid = shift;
	my $weatherXML;

	unless ($locid) {
		die ref($self), ": ERROR Please provide a location id!\n";
	}

	# prepare HTTP Requests
	my $currentlocation = $CURRENT_QUERY_URI . $locid;
	my $forecastlocation = $FORECAST_QUERY_URI . $locid;

	# get current weather data
	$self->_debug($currentlocation);
	eval { $weatherXML = $self->_getWebPage($currentlocation); };
	if ($@) {
		die ref($self),
		  ": ERROR No response from weather server while loading data: $@\n";
	}

	# parse weather data
	my $currentHash = XMLin($weatherXML);

	# do some error handling if wunderground.com returns no data
	if ( ref($currentHash->{station_id}) eq "HASH") {
		$self->_debug( 'EMPTY CURRENT' );
		die ref($self),
		  ": ERROR no current data received, location is probably unknown!\n";
	}

	# get weather forecast data
	$self->_debug($forecastlocation);
	eval { $weatherXML = $self->_getWebPage($forecastlocation); };
	if ($@) {
		die ref($self),
		  ": ERROR No response from weather server while loading data: $@\n";
	}

	# parse weather data
	my $forecastHash = XMLin($weatherXML);

	# do some error handling if wunderground.com returns no data
	unless ( $forecastHash->{simpleforecast}->{forecastday} ) {
		$self->_debug( 'EMPTY FORECAST' );
		die ref($self),
		  ": ERROR no forecast data received, location is probably unknown!\n";
	}
	
	return $self->_twcFormattedHash($currentHash, $forecastHash);
}

#--------------------------------------------------------------------
# Reformat Wunderground data to resemble structure used by TWC
#--------------------------------------------------------------------
sub _twcFormattedHash {
	my $self  = shift;
	my $currentHash = shift;
	my $forecastHash = shift;

	my $dailyForecasts = ();
	
	my $windDir = $currentHash->{wind_dir};
	if ($windDir eq "Variable") {
		$windDir = "ALL";
	}
	my $index = 0;
	foreach (@{$forecastHash->{simpleforecast}->{forecastday}}) {
		push(@{$dailyForecasts}, {
				'hi'  => $_->{high}->{$self->{UNITS} eq "m" ? "celsius" : "fahrenheit"},
				'low' => $_->{low}->{$self->{UNITS} eq "m" ? "celsius" : "fahrenheit"},
				't'   => $_->{date}->{weekday},
				'part' => [{
					't' => $_->{conditions},
					'icon' => $self->_twcIconNumber($_->{skyicon},$_->{icon}),
					'wind' => {
						's' => $index == 0 ? $currentHash->{wind_mph} : "N/A",
						't' => $index == 0 ? $windDir : "N/A"
					},
					'ppcp' => ref($_->{pop}) eq "HASH" ? "N/A" : $_->{pop}
				}]
		});
		$index++;
	}

	my $twcHash = {
		'head' => {
			'ut' => $self->{UNITS} eq "m" ? "C" : "F"
		},
		'cc' => {
			'tmp' => $currentHash->{$self->{UNITS} eq "m" ? "temp_c" : "temp_f"}
		},
		'dayf' => {
			'day' => $dailyForecasts
		}
	};
	
	return $twcHash;
}

sub _twcIconNumber {
	my $self  = shift;
	my $wundergroundSkyIcon = shift;
	my $wundergroundIcon = shift;
	
	my $lookupString = $wundergroundIcon;
	
	return ($TwcIcons->{$wundergroundIcon} || "na");
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

# # SAMPLE usage
# my %comargs = (
# 	'debug'      => 0,
# 	'units'      => 'm'
# );
# my $wc = Weather::Wunderground->new(%comargs);
# 
# my $weather = $wc->get_weather("TXL"); # best to use IATA airport code as location
# print Dumper($weather);

1;
__END__
