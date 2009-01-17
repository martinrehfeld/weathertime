package Weather::Cached;

# $Revision: 1.5 $

use 5.006;
use strict;
use warnings;
use Storable qw(lock_store lock_retrieve);
use Data::Dumper;
use Weather::Com;
use base "Weather::Com";

#------------------------------------------------------------------------
# Constructor
#------------------------------------------------------------------------
sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	# getting the parameters from @_
	my %parameters = ();
	if ( ref( $_[0] ) eq "HASH" ) {
		%parameters = %{ $_[0] };
	} else {
		%parameters = @_;
	}

	# creating the SUPER instance
	my $self = $class->SUPER::new( \%parameters );

	# some caching attributes
	if ( $parameters{cache} ) {
		$self->{PATH} = $parameters{cache};
	} else {
		$self->{PATH} = ".";
	}

	# parameter cache
	$self->{PARAMS} = undef;

	return $self;
}

#------------------------------------------------------------------------
# getting data from weather.com
#------------------------------------------------------------------------
sub get_weather {
	my $self  = shift;
	my $locid = shift;

	$self->_debug("Trying to get data for $locid");

	unless ($locid) {
		die ref($self), "Please provide a location id!\n";
	}

	# try to load an existing cache file
	my $weathercache = {};
	eval { $weathercache = lock_retrieve( $self->{PATH} . "/$locid.dat" ); };
	if ( $@ or !$weathercache ) {
		$self->_debug("No cache file found.");
		$weathercache = {};
	}

	# find out which data is wanted by the modules user and
	# which parts of that are in the cache or must be
	# loaded from the web
	if ($weathercache) {

		$self->_debug("Cache file found.");

		# save parameters to be able to reset them at the end of
		# this method...
		$self->_store_params();

		# load uncached or old requested data
		if ( $self->{PARAMS}->{CC} ) {
			if ( $weathercache->{cc}
				 && !$self->_older_than( 30, $weathercache->{cc}->{cached} ) )
			{
				$self->{CC} = 0;
				$self->_debug("Turning off 'cc' update. Cache is good enough.");
			}
		}

		if ( $self->{PARAMS}->{FORECAST} ) {
			if ( $weathercache->{dayf} ) {
				my $no_forecastdays;    # number of days to be forecasted
				if ( ref( $weathercache->{dayf}->{day} ) eq "HASH" ) {
					$no_forecastdays = 1;
				} else {
					$no_forecastdays = $#{ $weathercache->{dayf}->{day} } + 1;
				}

				if ( ( $self->{PARAMS}->{FORECAST} == $no_forecastdays )
					 && !$self->_older_than( 120,
											 $weathercache->{dayf}->{cached} ) )
				{
					$self->{FORECAST} = 0;
					$self->_debug(
						"Turning off 'forecast' update. Cache is good enough.");
				}
			}
		}
	}

	# only update weathercache if a current conditions update or a
	# forecast update is necessary or the location data is older than
	# 15 minutes.
	if (    $self->{CC}
		 or $self->{FORECAST}
		 or !$weathercache
		 or $self->_older_than( 15, $weathercache->{loc}->{cached} ) )
	{
		$self->_debug("All conditions met. Fetching weather from web.");

		my $weather = $self->SUPER::get_weather($locid);
		foreach ( keys %{$weather} ) {
			if ( ref( $weather->{$_} ) ) {
				$weathercache->{$_} = $weather->{$_};
				$weathercache->{$_}->{cached} = time();
			}
		}

		# save data to cache file
		unless ( lock_store( $weathercache, $self->{PATH} . "/$locid.dat" ) ) {
			die ref($self), ": ERROR I/O problem while storing cachefile!";
		}
	}

	$self->_reset_params();
	$self->_debug( Dumper($weathercache) );

	return $weathercache;
}

#------------------------------------------------------------------------
# store and reset search parameters
#------------------------------------------------------------------------
sub _store_params {
	my $self = shift;
	my %params = (
				   'PROXY'       => $self->{PROXY},
				   'TIMEOUT'     => $self->{TIMEOUT},
				   'DEBUG'       => $self->{DEBUG},
				   'PARTNER_ID'  => $self->{PARTNER_ID},
				   'LICENSE_KEY' => $self->{LICENSE_KEY},
				   'UNITS'       => $self->{UNITS},
				   'CC'          => $self->{CC},
				   'FORECAST'    => $self->{FORECAST},
				   'LINKS'       => $self->{LINKS},
	);

	$self->{PARAMS} = \%params;

	return 1;
}

sub _reset_params {
	my $self = shift;

	$self->{PROXY}       = $self->{PARAMS}->{PROXY};
	$self->{TIMEOUT}     = $self->{PARAMS}->{TIMEOUT};
	$self->{DEBUG}       = $self->{PARAMS}->{DEBUG};
	$self->{PARTNER_ID}  = $self->{PARAMS}->{PARTNER_ID};
	$self->{LICENSE_KEY} = $self->{PARAMS}->{LICENSE_KEY};
	$self->{UNITS}       = $self->{PARAMS}->{UNITS};
	$self->{CC}          = $self->{PARAMS}->{CC};
	$self->{FORECAST}    = $self->{PARAMS}->{FORECAST};
	$self->{LINKS}       = $self->{PARAMS}->{LINKS};

	return 1;
}

sub _older_than {
	my $self              = shift;
	my $caching_timeframe = shift;
	my $cached            = shift;
	my $now               = time();

	if ( $cached < ( $now - $caching_timeframe * 60 ) ) {
		return 1;
	} else {
		return 0;
	}
}

1;

__END__

=pod

=head1 NAME

Weather::Cached - Perl extension for getting weather information from I<weather.com>

=head1 SYNOPSIS

  use Data::Dumper;
  use Weather::Cached;
  
  # define parameters for weather search
  my %params = (
		'cache'      => '/tmp/weathercache',
		'current'    => 1,
		'forecast'   => 3,
		'links'      => 1,
		'units'      => 's',
		'proxy'      => 'http://proxy.sonstwo.de',
		'timeout'    => 250,
		'debug'      => 1,
		'partner_id' => 'somepartnerid',
		'license'    => '12345678',
  );
  
  # instantiate a new weather.com object
  my $cached_weather = Weather::Cache->new(%params);
  
  # search for locations called 'Heidelberg'
  my $locations = $cached_weather->search('Heidelberg')
  	or die "No location found!\n";
  
  # and then get the weather for each location found
  foreach (keys %{$locations}) {
	my $weather = $cached_weather->get_weather($_);
	print Dumper($weather);
  }

=head1 DESCRIPTION

I<Weather::Cache> is a Perl module that provides low level OO interface
to gather all weather information that is provided by I<weather.com>. 

This module implements the caching business rules that apply to all
applications programmed against the I<xoap> API of I<weather.com>.
Except from the I<cache> parameter to be used while instantiating a new
object instance, this module has the same API than I<Weather::Com>. It's
only a simple caching wrapper around it.

Although it's really simple, the module uses I<Storable> methods 
I<lock_store> and I<lock_retrieve> to implement shared locking for 
reading cache files and exclusive locking for writing to chache files. 
By this way the same cache files should be able to be used by several
application instances using I<Weather::Cache>.

For a more high level interface please have a look at I<Weather::Simple>
that provides the same simple API than I<Weather::Underground> does.

You'll need to register at I<weather.com> to to get a free partner id
and a license key to be used within all applications that you want to
write against I<weather.com>'s I<xoap> interface. 

L<http://www.weather.com/services/xmloap.html>

=head1 CONSTRUCTOR

=head2 new(hash or hashref)

This constructor takes the same hash or hashref as I<Weather::Com> does.
Please refer to that documentation for further details.

Except from the I<Weather::Com>'s parameters this constructor takes a
parameter I<cache> which defines the path to a directory into which 
all cache files will be put. The cache directory defaults to '.'.

=head1 METHODS

That's all the same as for I<Weather::Com>.

=head1 SEE ALSO

See also documentation of L<Weather::Com> and L<Weather::Simple>.

=head1 AUTHOR

Thomas Schnuecker, E<lt>thomas@schnuecker.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Thomas Schnuecker

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The data provided by I<weather.com> and made accessible by this OO
interface can be used for free under special terms. 
Please have a look at the application programming guide of
I<weather.com>!

L<http://www.weather.com/services/xmloap.html>

=cut
