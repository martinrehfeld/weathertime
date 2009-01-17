# WeatherTime/Strings.pm
# $Id$
#
#	Author: kdf
#
#	Copyright (c) 2005-2007
#	This file is part of the WeatherTime software. The same license applies.
#	See main file Plugin.pm for details
#

package Plugins::WeatherTime::Settings;

use strict;
use base qw(Slim::Web::Settings);

use Slim::Utils::Log;
use Slim::Utils::Misc;
use Slim::Utils::Strings qw(string);
use Slim::Utils::Prefs;

my $alarmID = 'A';

my $log = Slim::Utils::Log->addLogCategory({
	'category'     => 'plugin.weathertime',
	'defaultLevel' => 'WARN',
	'description'  => 'SETUP_GROUP_PLUGIN_WEATHERTIME',
});

my $prefs = preferences('plugin.weathertime');

$prefs->migrate(1, sub {
	$prefs->set('units',          Slim::Utils::Prefs::OldPrefs->get('plugin_Weathertime_units'));
	$prefs->set('city',           Slim::Utils::Prefs::OldPrefs->get('plugin_Weathertime_city'));
	$prefs->set('citycode',       Slim::Utils::Prefs::OldPrefs->get('plugin_Weathertime_citycode'));
	$prefs->set('interval',       Slim::Utils::Prefs::OldPrefs->get('plugin_Weathertime_interval'));
	$prefs->set('partner',        Slim::Utils::Prefs::OldPrefs->get('plugin_Weathertime_partner'));
	$prefs->set('license',        Slim::Utils::Prefs::OldPrefs->get('plugin_Weathertime_license'));
	$prefs->set('dateformat',     Slim::Utils::Prefs::OldPrefs->get('plugin_Weathertime_dateformat'));
	$prefs->set('linethree',      Slim::Utils::Prefs::OldPrefs->get('plugin_Weathertime_linethree'));
	$prefs->set('linethreeunit',  Slim::Utils::Prefs::OldPrefs->get('plugin_Weathertime_linethreeunit'));
	1;
});

sub prefs {
	return ($prefs, qw(units city citycode interval partner license timedateformat dateformat linethree linethreeunit));
}

sub name {
	return 'PLUGIN_SCREENSAVER_WEATHERTIME';
}

sub page {
	return 'plugins/WeatherTime/settings/basic.html';
}

1;

__END__
