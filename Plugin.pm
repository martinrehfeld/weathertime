# WeatherTime/Plugin.pm
# $Id$
#
#	Author: Martin Rehfeld <martin.rehfeld(at)glnetworks(dot)de>
#
#	Copyright (c) 2005-2007
#	All rights reserved.
#
#	Based on: several plugins and screensavers,
#	          especially the Weather.com Forecaster by Kevin Deane-Freeman
#	          and Justin Birch,
#	          Felix Mueller's TinyLittlePacMan and LineX screensavers,
#	          and the standard Date/Time screensaver from SlimDevices.
#
#	----------------------------------------------------------------------
#	Function: Screensaver Plugin
#
#	Show weather forecasts along with the current date and time
#
#	----------------------------------------------------------------------
#	Installation:
#
#	- Extract the weathertime_<version>.tar.gz archive into the 'Plugins'
#	  directory
#	- Restart the server
#	- Register with Weather.Com(R) to aquire a partnerID/key (see below)
#	- Set up the WeatherTime options in the server's plugin settings
#
#	----------------------------------------------------------------------
#	Restrictions & Know Bugs:
#
#	- Needs a Squeezebox2 or SoftSqueeze to show weather condition icons
#	  and detailed info, other devices will show text only information
#	- Not explictly tested on SqueezeboxG (only SLIMP3 and Squeezebox2)
#	- Needs registration (partnerID/key) with Weather.Com(R);
#	  sign up at http://registration.weather.com/registration/xmloap/step1
#	- Application does not comply with Weather.Com(R)'s implementation
#	  guidelines for applications using their XML weather data:
#	   o does not display merely on either a desktop PC or in a web browser
#	     (but on a embedded device)
#	   o does not make sure a valid location ID has been entered
#	     (it is the responsibility of the user to set this up correctly)
#	   o does not show official The Weather Channel(R) logo
#	     (official logos are only available in color and not suitable for
#	     Squeezebox2)
#	   o does not link to the Weather.Com site (not applicable to SB2)
#	   o does not include commercial links (not applicable to SB2)
#	   o does (try to) translate information into different language(s)
#	     (this is neccessary for increased usability)
#	   o does not use the official weather conditions icons (as those are
#	     only available in color and not suitable for Squeezebox2)
#	- Could not make sure, the translations for weather conditions
#	  are complete (does anyone have a official complete list?)
#
#	----------------------------------------------------------------------
#	Changelog:
#
#	2005/31/08 v1.0 - Initial version
#	2005/26/10 v1.1 - Proposed version for plugins@slimdevices.com
#	                  (Tested against SlimServer 6.2)
#	2006/11/03 v1.2 - additional translations and fixed use-line for
#	                  SlimServer 6.5 compatibility (NOT tested against)
#	2006/12/03 v1.3 - fixed include path problem for SlimServer 6.2.1
#	2006/17/03 v1.4 - added Dutch translations contributed by Willem
#	                  Oepkes <oepkes(at)klq(dot)nl>, improved error handling
#	2006/02/04 v1.5 - updated WeatherChannel(R) logo to current version
#	2006/05/01 v1.6 - added french translations contributed by Daniel Born
#	                  <born_daniel@yahoo.com>,
#	                  improved dutch translations contributed by Mark
#	                  Ruys <mark(at)paracas.nl>,
#	                  additonal date formats, always display NOW temp.,
#	                  show tonight's forecast in the afternoon
#	2006/05/02 v1.6.1 bugfix for Slimserver 6.5 beta
#	2006/05/03 v1.6.2 another bugfix for Slimserver 6.5 beta
#	2006/05/03 v1.6.3 fix to the fix (1.6.2)
#	2006/06/17 v1.7 - add more date formats,
#	                  compatibility with latest 6.5 beta builds (perl
#	                  include path once again),
#	                  improvements for alarm bell overlay by Ludovico
#	                  <garden(at)acheronte(dot)it>,
#	                  prefixed translation strings to avoid clashes with
#	                  existing SlimServer translations,
#	                  enabled scrolling through forecasts in OFF mode
#	2006/09/23 v1.8 - compatibility with 6.5.0 release of Slimserver
#	                  (thanks to kdf and cparker)
#	                  NOT backwards compatible with previous releases
#	                  added more translated strings
#	                  replaced menu-based enable/disable with direct start
#	2007/11/11 v1.9   fix for Slimserver 7.x series
#	                  added additional icons by Yannzola
#	                  added Swedish translations contributed by Daniel
#	                  Cervera <dc11ab(at)gmail.com>
#	                  implemented some cleanups by Michael Herger
#
#	----------------------------------------------------------------------
#	To do:
#
#	- Add more translations
#	- Optional: Support SqueezeboxG's graphic features (lowres icons?)
#	- Support the second display of the Transporter
#	- support multiple locations for weather forecasts
#	- add information on windspeed and directions
#	- add information on sunset and sundown
#	- add information on moonphases
#	- use AsyncHTTP calls to retrieve the weather data
#	- enable icon animation
#
#
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 2 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program; if not, write to the Free Software
#	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
#	02111-1307 USA
#
# This code is derived from code with the following copyright message:
#
# SliMP3 Server Copyright (C) 2001 Sean Adams, Slim Devices Inc.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License,
# version 2.


use strict;

###########################################
### Section 1. Change these as required ###
###########################################

package Plugins::WeatherTime::Plugin;

#use Slim::Control::Command;
#use Slim::Buttons::Common;
use Slim::Utils::Misc;
#use Slim::Utils::Validate;
#use Slim::Display::Display;
use Plugins::WeatherTime::Strings;
use Plugins::WeatherTime::Weather::Cached;

use vars qw($VERSION);
$VERSION = substr(q$Revision: 1.9 $,10);

use Slim::Utils::Strings qw (string);
use Socket;

my $timeout = 30;

#### Sign up at http://registration.weather.com/registration/xmloap/step1
#### and enter ID and Key in server settings -> plugins.
my $Partner = "";
my $License = "";

#### You can set these in the server settings -> plugins, example values follow
my $Metric = 0;
my $City = "Mountain View, CA";
my $City_Code = "USCA0746";
my $Interval = 3600;


my (%numdays, %forecast, %forecastGX, %highTemp, %lowTemp, %currentTemperature);
my %scrollIndex = ();
my %scrollDefault = ();
my %scrollTimeout = ();
my %Countdown = ();
my %xmax = ();
my %ymax = ();
my %hashDisp;
my %weatherinfoLast = ();
my %timeinfoLast = ();
my %linecache = ();
my $gxwidth = 125;
my $refreshTime = 1.0;  # should usually be 1.0 seconds
                        # ... controls how often the scroll timeout and 
                        #     the necessity of weather updates are checked

#
# Map ASCII characters to custom @Charset elements
#
my %Codepage = ( ' ' =>  0, '1' =>  1, '2' =>  2, '3' =>  3, '4' =>  4,
                 '5' =>  5, '6' =>  6, '7' =>  7, '8' =>  8, '9' =>  9,
                 '0' => 10, '-' => 11, 'g' => 12, '.' => 13, '%' => 14,
                 'A' => 15, 'B' => 16, 'C' => 17, 'D' => 18, 'E' => 19,
                 'F' => 20, 'G' => 21, 'H' => 22, 'I' => 23, 'J' => 24,
                 'K' => 25, 'L' => 26, 'M' => 27, 'N' => 28, 'O' => 29,
                 'P' => 30, 'Q' => 31, 'R' => 32, 'S' => 33, 'T' => 34,
                 'U' => 35, 'V' => 36, 'W' => 37, 'X' => 38, 'Y' => 39,
                 'Z' => 40, '/' => 41 );

#
# Custom 7x5 mono charset for 3-line forecast display on Squeezebox2
#
my @Charset = ('







','
  *
 **
* *
  *
  *
  *
*****
','
 ***
*   *
    *
   *
  *
 *
*****
','
 ***
*   *
    *
  **
    *
*   *
 ***
','
   *
  **
 * *
*****
   *
   *
   *
','
*****
*
*
****
    *
*   *
 ***
','
 ***
*
*
****
*   *
*   *
 ***
','
*****
    *
    *
   *
  *
 *
*
','
 ***
*   *
*   *
 ***
*   *
*   *
 ***
','
 ***
*   *
*   *
 ****
    *
    *
 ***
','
 ***
*   *
*   *
*   *
*   *
*   *
 ***
','



 ****



','
 **
*  *
*  *
 **



','





  **
  **
','
**   
**  *
   *
  *
 *
*  **
   **
','
 ***
*   *
*   *
*****
*   *
*   *
*   *
','
****
*   *
*   *
****
*   *
*   *
****
','
 ***
*   *
*
*
*
*   *
 ***
','
****
*   *
*   *
*   *
*   *
*   *
****
','
*****
*
*
****
*
*
*****
','
*****
*
*
****
*
*
*
','
 ***
*   *
*
* ***
*   *
*   *
 ***
','
*   *
*   *
*   *
*****
*   *
*   *
*   *
','
 ***
  *
  *
  *
  *
  *
 ***
','
    *
    *
    *
    *
    *
*   *
 ***
','
*   *
*  *
* *
**
* *
*  *
*   *
','
*
*
*
*
*
*
*****
','
*   *
** **
* * *
*   *
*   *
*   *
*   *
','
*   *
*   *
**  *
* * *
*  **
*   *
*   *
','
 ***
*   *
*   *
*   *
*   *
*   *
 ***
','
****
*   *
*   *
****
*
*
*
','
 ***
*   *
*   *
*   *
*   *
* * *
*  **
 ** *
','
****
*   *
*   *
****
* *
*  *
*   *
','
 ****
*
*
 ***
    *
    *
****
','
*****
  *
  *
  *
  *
  *
  *
','
*   *
*   *
*   *
*   *
*   *
*   *
 *** 
','
*   *
*   *
*   *
*   *
*   *
 * *
  *
','
*   *
*   *
*   *
*   *
* * *
** **
*   *
','
*   *
*   * 
 * * 
  *  
 * * 
*   * 
*   *
','
*   *
*   *
 * *
  *
  *
  *
  *
','
*****
    *
   *
  *
 *
*
*****
','

    *
   *
  *
 *
*

');

#
# map standard weather.com icons to custom icons
# -> we use only 16 different icons but weather.com has 49
# missing: #22: "smoke" (substituted with "fog")
#
my %Iconmap = ( '1'  => 2,  '2'  => 1,  '3'  => 2,  '4'  => 2,  '5'  => 3, 
                '6'  => 1,  '7'  => 3,  '8'  => 3,  '9'  => 1,  '10' => 3, 
                '11' => 1,  '12' => 1,  '13' => 3,  '14' => 3,  '15' => 3, 
                '16' => 3,  '17' => 2,  '18' => 1,  '19' => 10, '20' => 11, 
                '21' => 12, '22' => 11, '23' => 13, '24' => 13, '25' => 14, 
                '26' => 0,  '27' => 0,  '28' => 6,  '29' => 5,  '30' => 5, 
                '31' => 4,  '32' => 4,  '33' => 5,  '34' => 5,  '35' => 2, 
                '36' => 15, '37' => 8,  '38' => 8,  '39' => 7,  '40' => 1, 
                '41' => 3,  '42' => 3,  '43' => 3,  '44' => 5,  '45' => 1, 
                '46' => 3,  '47' => 2,  '48' => 7,  '0'  => 2,  'na' => 9,
                'NA' => 9,  'N/A' => 9 );

#
# Custom weather condition icons (40x32 pixel)
#
#234567890123456789012345678901234567890 - icon 0
my @Icons = ('





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
',
#234567890123456789012345678901234567890 - icon 1
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************


     *         *        *
     *         *   *    *
    *    *    *    *   *
    *    *    *   *    *    *
   *    *    *    *    *    *
   *         *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 2
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **     **         ** ***
     *      **          *** **
  ****     **            *   **
 **        **                 *
**        **                  **
*         **                   ***
*        ** **                   **
*        ******                   *
**       *** **                  **
 ***        **                  **
   ******************************
           **
          **
     *    **   *        *
     * * **    *   *    *
    *  ****   *    *   *
    *  *****  *   *    *    *
   *    **   *    *    *    *
   *    *    *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 3
'





              ****
           ****  ****
        ****        **
       **            **
      **              **
     **                ** ***
     *                  *** **
  ****                   *   **
 **                           *
**                            **
*                              ***
*                                **
*                                 *
**                               **
 ***                            **
   ******************************

                           * *
      * *                *  *  *
    *  *  *               * * *
     * * *      * *      * *** *
    * *** *   *  *  *     * * *
     * * *     * * *     *  *  *
    *  *  *   * *** *      * *
      * *      * * *
              *  *  *
                * *
',
#234567890123456789012345678901234567890 - icon 4
'
                     *
        *            *
         *          *
          *         *
          *         *
           *       *          *
            *      *         *
                           **
                          *
 *            *****      *
  **        *********
    **     ***********
      *   *************
          *************
         ***************
         ***************
         ***************  *******
         ***************
         ***************
    ***   *************
****      *************
           ***********
            *********
              *****      *
                          *
           *               **
          *       *          *
         *        *           *
         *        *
        *          *
       *           *
                   *
',
#234567890123456789012345678901234567890 - icon 5
'
                     *
        *            *
         *          *
          *         *
          *         *
           *       *          *
            *      *         *
                           **
                          *
 *            *****      *
  **        *********
    **     *********** ****
      *   **********  **   *
          *********         **
         *********           * **
         *******              *  *
         ******                  **
         *****                    **
         *****                     *
    ***   *****                    *
****      *************************
           ***********
            *********
              *****      *
                          *
           *               **
          *       *          *
         *        *           *
         *        *
        *          *
       *           *
                   *
',
#234567890123456789012345678901234567890 - icon 6
'
                  *       *        *
                   *      *       *
                   *      *       *
                    *     *      *
                                *
              ****     *******
           ****  **** *********
        ****        ************     **
       **            ************  **
      **              ***********
     **                **********
     *                  *** *****
  ****                   *   ****
 **                           *** *
**                            ***  **
*                              ***   **
*                                **
*                                 *
**                               **
 ***                            **
   ******************************
',
#234567890123456789012345678901234567890 - icon 7
'
                  *       *        *
                   *      *       *
                   *      *       *
                    *     *      *
                                *
              ****     *******
           ****  **** *********
        ****        ************     **
       **            ************  **
      **              ***********
     **                **********
     *                  *** *****
  ****                   *   ****
 **                           *** *
**                            ***  **
*                              ***   **
*                                **
*                                 *
**                               **
 ***                            **
   ******************************


     *         *        *
     *         *   *    *
    *    *    *    *   *
    *    *    *   *    *    *
   *    *    *    *    *    *
   *         *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 8
'
                  *       *        *
                   *      *       *
                   *      *       *
                    *     *      *
                                *
              ****     *******
           ****  **** *********
        ****        ************     **
       **            ************  **
      **              ***********
     **     **         **********
     *      **          *** *****
  ****     **            *   ****
 **        **                 *** *
**        **                  ***  **
*         **                   ***   **
*        ** **                   **
*        ******                   *
**       *** **                  **
 ***        **                  **
   ******************************
           **
          **
     *    **   *        *
     * * **    *   *    *
    *  ****   *    *   *
    *  *****  *   *    *    *
   *    **   *    *    *    *
   *    *    *        *    *
  *         *         *    *
',
#234567890123456789012345678901234567890 - icon 9
'






                *****
              *********
             ***    ***
             *       ***
                     ***
                     ***
                    ****
                   ****
                  ****
                 ****
                 ***
                ***
                ***
                ***
                ***


                ***
                ***
                ***
',
#234567890123456789012345678901234567890 - icon 10: dust by yannzola
'


                 *******
                **     **
               **  *    *
               *        **
          ****** *  *    *
         **            * *
        **         *     *****
        *    *   *   *       **
        *  *             *    **
    *****                   *  *
   **        *   ******  *     *
  **   *  *     **    **       *
  *            **      **      *
  *       *  * *   *    *  *****
  *  *  *      *        ****   **
  *         ****    *           **
  **   *   **     *    *  *   *  *
   ***    **  *             *    *
     ******           *   *      ****
          *     * *           *     **
          **            *            **
           ***      *     *       *   *
             ******          *        *
                  *    *        *    **
                  *  *     ****    ***
                  **   *  **  ******
                   **    **
                    ******
',
#234567890123456789012345678901234567890 - icon 11: fog by yannzola
'

   ***********************************



   ***********************************



   ***********************************
                *********
               ***********

   ***********************************
             ***************
             ***************

   ***********************************
             ***************
   ***********************************

   ***********************************
                *********
   ***********************************

   ***********************************

   ***********************************

   ***********************************

   ***********************************
',
#234567890123456789012345678901234567890 - icon 12: haze by yannzola
'

           *******
        ***       ***
       **           **
     **               **
    **      *****      **
    *    ***********    *
   *    ****     ****    *
  **   ***         ***   **
  *   ***   *****   ***   *
  *   **   *******   **   *
 *   ***  *********  ***   *
 *   **  ***********  **   *
 *   **  ***********  **   *
 *   **  ***********  **   *
 *   **  ***********  **   *
 *   **  ***********  **   *
 *   ***  *********  ***   *
  *   **   *******   **   *
  *   ***   *****   ***   *****
  **   ***         ***   **   **
   *    ****     ****    *     **
    *    ***********  ****      *
    **      *****    **  *      *
     **              *          ****
       **         ****             **
        ***      **                 **
           *******                   *
                 *                   *
                 **                 **
                  *******************
',
#234567890123456789012345678901234567890 - icon 13: wind by yannzola
'


       *****
      **   **
     **     *
     *      ****
     *         **
  ****          *
 **           *****************
**
*
*          **************************
**
 ***
   **********  *******
              **     **
              *       **
             **        *
             *         ******
             *              **
         *****               *
        **                 *********
       **
       *
       *
       *             ******************
       *
       **
        ***
          **************************
',
#234567890123456789012345678901234567890 - icon 14: frigid by yannzola
'


    *****                 *
   **   **                *
   *     *            *   *   *
   * *** *            *** * ***
   * *   *         *    *****    *
   * **  *         *     ***     *
   * *   *         *      *      *
   * *** *    ***  *      *      *  ***
   * *   *      ****      *      ****
   * **  *        ***     *      **
   * *   *      *** ***   *   *** ***
   * *** *    ***     *** * ***     ***
   * *   *              *****
   * **  *               ***
   * *   *              *****
   * *** *    ***     *** * ***     ***
   * *   *      *** ***   *   *** ***
   * **  *        ***     *     ***
   * *   *      ****      *      ****
   * *** *    ***  *      *      *  ***
  ** *** **        *      *      *
  * ***** *        *     ***     *
  * ***** *        *    *****    *
  * ***** *           *** * ***
  ** *** **           *   *   *
   **   **                *
    *****                 *
',
#234567890123456789012345678901234567890 - icon 15: hot by yannzola
'

                         *
    *****                *
   **   **               *
   *     *    *          *          *
   * *** *     *         *         *
   * *   *      *        *        *
   * *** *       *               *
   * *** *        *    *****    *
   * *** *           *********
   * *** *          ***********
   * *** *         *************
   * *** *         *************
   * *** *        ***************
   * *** *        ***************
   * *** * ****** *************** ******
   * *** *        ***************
   * *** *        ***************
   * *** *         *************
   * *** *         *************
   * *** *          ***********
   * *** *           *********
  ** *** **       *    *****    *
  * ***** *      *               *
  * ***** *     *        *        *
  * ***** *    *         *         *
  ** *** **   *          *          *
   **   **               *
    *****                *
                         *
');

my $TWClogo = '
       ************************
       ************************
       ************************
       ************************
       ************************
       ************************
       *    *******************
       ** *  *** **************
       ** * * *   *************
       ** * * * ***************
       ** * * **  *************
       ************************
       * * * ****** ** ********
       * * * * *  *  *  ** *  *
       * * *    **  ** *     **
       ** * * **    ** *  ** **
       ** * **       * * *   **
       ************************
       **   **************** **
       * **  *  *   *   * ** **
       * ** * **  * * *    * **
       * ** *     * * *  *** **
       **   *     * * * *  ** *
       ************************



            * *
* * * * ** *****   *  **   **  * ** *
* * ****  * * * * *** *   *   * ** * *
** ***  *** * * * *   *   *   * ** * *
 * *  ***** *** *  ** * ** **  * * * *
';

sub getDisplayName {
	return 'PLUGIN_SCREENSAVER_WEATHERTIME';
}

sub strings { 
	return Plugins::WeatherTime::Strings::strings();
}


##################################################
### Section 2. Your variables and code go here ###
##################################################

sub enabled {
	return ($::VERSION ge '6.5');
}

sub setMode {
	my $client = shift;
	$client->lines(\&lines);

	# setting this param will call client->update() frequently
	$client->param('modeUpdateInterval', 1); # seconds
}

our %functions = (
	'up' => sub  {
		my $client = shift;
		my $button = shift;
		$client->bumpUp() if ($button !~ /repeat/);
	},
	'down' => sub  {
		my $client = shift;
		my $button = shift;
		$client->bumpDown() if ($button !~ /repeat/);;
	},
	'left' => sub  {
		my ($client ,$funct ,$functarg) = @_;

		Slim::Buttons::Common::popModeRight($client);
		$client->update();

		# pass along ir code to new mode if requested
		if (defined $functarg && $functarg eq 'passback') {
			Slim::Hardware::IR::resendButton($client);
		}
	},
	'right' => sub  {
		my $client = shift;
		$client->bumpRight();
	},
	'play' => sub  {
		my $client = shift;
		Slim::Buttons::Common::pushMode($client, 'SCREENSAVER.weathertime');
	},
	'stop' => sub {
		my $client = shift;
		Slim::Buttons::Common::pushMode($client, 'SCREENSAVER.weathertime');
	}
);

sub lines {
	my $client = shift;
	my ($line1, $line2);
	$line1 = $client->string('PLUGIN_SCREENSAVER_WEATHERTIME');
	$line2 = $client->string('PLUGIN_SCREENSAVER_WEATHERTIME_START');

	return ($line1, $line2);
}

sub getFunctions {
	return \%functions;
}

sub setupGroup {
	my %setupGroup = (
		PrefOrder => ['plugin_Weathertime_units','plugin_Weathertime_city','plugin_Weathertime_citycode','plugin_Weathertime_interval','plugin_Weathertime_partner','plugin_Weathertime_license','plugin_Weathertime_dateformat']
		,GroupHead => string('SETUP_GROUP_PLUGIN_WEATHERTIME')
		,GroupDesc => string('SETUP_GROUP_PLUGIN_WEATHERTIME_DESC')
		,GroupLine => 1
		,GroupSub => 1
		,Suppress_PrefHead => 1
		,Suppress_PrefDesc => 1
		,Suppress_PrefSub => 1
		,Suppress_PrefLine => 1
		,PrefsInTable => 1
	);
	my %setupPrefs = (
		'plugin_Weathertime_units' => {
			'validate' => \&Slim::Utils::Validate::trueFalse
			,'options' => {
				'0' => string('SETUP_PLUGIN_WEATHERTIME_0')
				,'1' => string('SETUP_PLUGIN_WEATHERTIME_1')
			}
			,'PrefChoose' => string('SETUP_PLUGIN_WEATHERTIME_UNITS')
		}
		,'plugin_Weathertime_city' => {
			'validate' => \&Slim::Utils::Validate::hasText
			,'PrefChoose' => string('SETUP_PLUGIN_WEATHERTIME_CITY')
			,'PrefSize' => 'medium'
		}
		,'plugin_Weathertime_citycode' => {
			'validate' => \&Slim::Utils::Validate::hasText
			,'PrefChoose' => string('SETUP_PLUGIN_WEATHERTIME_CITYCODE')
			,'PrefSize' => 'medium'
		}
		,'plugin_Weathertime_interval' => {
			'validate' => \&Slim::Utils::Validate::number
			,'PrefChoose' => string('SETUP_PLUGIN_WEATHERTIME_INTERVAL')
			,'PrefSize' => 'medium'
		}
		,'plugin_Weathertime_partner' => {
			'validate' => \&Slim::Utils::Validate::hasText
			,'PrefChoose' => string('SETUP_PLUGIN_WEATHERTIME_PARTNER')
			,'PrefSize' => 'medium'
		}
		,'plugin_Weathertime_license' => {
			'validate' => \&Slim::Utils::Validate::hasText
			,'PrefChoose' => string('SETUP_PLUGIN_WEATHERTIME_LICENSE')
			,'PrefSize' => 'medium'
		}
		,'plugin_Weathertime_dateformat' => {
			'validate' => \&Slim::Utils::Validate::acceptAll
			,'options' => {
				'std' => string('SETUP_PLUGIN_WEATHERTIME_STDDATE'),
				'none' => string('SETUP_PLUGIN_WEATHERTIME_NODATE'),
				'%m/%d' => 'MM/DD',
				'%m-%d' => 'MM-DD',
				'%m.%d.' => 'MM.DD.',
				'%d/%m' => 'DD/MM',
				'%d-%m' => 'DD-MM',
				'%d.%m.' => 'DD.MM.',
				'%b %d' => 'MMM DD',
				'%d %b' => 'DD MMM'
			}
			,'PrefChoose' => string('SETUP_PLUGIN_WEATHERTIME_DATEFORMAT')
		}
	);

	checkDefaults();
	return (\%setupGroup,\%setupPrefs);
}

sub checkDefaults {
	if (!Slim::Utils::Prefs::isDefined('plugin_Weathertime_units')) {
		Slim::Utils::Prefs::set('plugin_Weathertime_units',$Metric)
	}
	if (!Slim::Utils::Prefs::isDefined('plugin_Weathertime_interval')) {
		Slim::Utils::Prefs::set('plugin_Weathertime_interval',$Interval)
	}
	if (!Slim::Utils::Prefs::isDefined('plugin_Weathertime_dateformat')) {
		Slim::Utils::Prefs::set('plugin_Weathertime_dateformat','std')
	}
}

###################################################################
### Section 3. Screensaver mode                                 ###
###################################################################

# First, Register the screensaver mode here.
sub screenSaver {
	Slim::Buttons::Common::addSaver(
		'SCREENSAVER.weathertime',
		getScreensaverWeathertime(),
		\&setScreensaverWeatherTimeMode,
		\&leaveScreensaverWheathertimeMode,
		'PLUGIN_SCREENSAVER_WEATHERTIME',
	);
}

our %screensaverWeatherTimeFunctions = (
	'done' => sub  {
		my ($client ,$funct ,$functarg) = @_;

		Slim::Buttons::Common::popMode($client);
		$client->update();

		# pass along ir code to new mode if requested
		if (defined $functarg && $functarg eq 'passback') {
			Slim::Hardware::IR::resendButton($client);
		}
	},
	'up' => sub  {
		my $client = shift;
		my $button = shift;
		# repeat works too fast -> disabling
		if ($button !~ /repeat/) {
			$scrollIndex{$client}--;
			$scrollTimeout{$client} = 15 / $refreshTime;
			if ($scrollIndex{$client} < 0) {
				$scrollIndex{$client} = 0;
				$client->bumpUp();
			}
			else {
				$client->update();
			}
		}
	},
	'down' => sub  {
		my $client = shift;
		my $button = shift;
		# repeat works too fast -> disabling
		if ($button !~ /repeat/) {
			$scrollIndex{$client}++;
			$scrollTimeout{$client} = 15 / $refreshTime;
			if ($scrollIndex{$client} >= $numdays{$client}) {
				$scrollIndex{$client} = $numdays{$client}-1;
				$client->bumpUp();
			}
			else {
				$client->update();
			}
		}
	},
);

sub getScreensaverWeathertime {
	return \%screensaverWeatherTimeFunctions;
}

our %mapping = (	
	'arrow_down' => 'down',
	'arrow_up' => 'up',
);

sub setScreensaverWeatherTimeMode() {
	my $client = shift;
	
	$::d_plugins && Slim::Utils::Misc::msg("WeatherTime: entering screensaver mode ($client)\n");

	$client->lines(\&screensaverWeatherTimelines);
	Slim::Hardware::IR::addModeDefaultMapping('SCREENSAVER.weathertime',\%mapping);
	Slim::Hardware::IR::addModeDefaultMapping('OFF.weathertime',\%mapping);

	# get display size for player if at least Squeezebox2
	if( $client && $client->isa( "Slim::Player::Squeezebox2")) {
		$xmax{$client} = $client->display()->displayWidth();
		$ymax{$client} = $client->display()->bytesPerColumn() * 8;
		$::d_plugins && Slim::Utils::Misc::msg("WeatherTime: found graphic display $xmax{$client} x $ymax{$client} ($client)\n");
	}
	# only use text on SqueezeboxG and SLIMP3
	else {
		$xmax{$client} = 0;
		$ymax{$client} = 0;
	}

	$scrollDefault{$client} = 0;
	$scrollIndex{$client} = $scrollDefault{$client};
	$scrollTimeout{$client} = 15 / $refreshTime;
	clearCanvas($client);
	drawIcon($client,29,$ymax{$client}-1,$TWClogo);
	$forecastGX{$client}[$scrollIndex{$client}] = getFramebuf($client,$gxwidth);
	$forecast{$client}=();
	$highTemp{$client}[$scrollIndex{$client}]="";
	$lowTemp{$client}[$scrollIndex{$client}]="";
	$currentTemperature{$client} = "";
	$numdays{$client}=0;
	# wait 4 seconds before getting weather data to make sure the lines-
	# function has completed before and the display is updated -> Start-Logo
	$Countdown{$client} = 4 / $refreshTime;

	$client->param('modeUpdateInterval', 1); #seconds
	
	Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + $refreshTime, \&tictac);
}

sub leaveScreensaverWheathertimeMode {
	my $client = shift;

	$::d_plugins && Slim::Utils::Misc::msg("WeatherTime: leaving screensaver mode ($client)\n");
	Slim::Utils::Timers::killTimers( $client, \&tictac);
}

sub tictac {
	my $client = shift;

	# check if weather forecast should be updated
	$Countdown{$client}--;
	if ($Countdown{$client} < 1) {
		$Countdown{$client} = Interval()/$refreshTime;
		&retrieveWeather($client);
	}

	# check if scroll timeout is reached
	$scrollTimeout{$client}--;
	if ($scrollTimeout{$client} < 1) {
		$scrollTimeout{$client} = 15 / $refreshTime;
		$scrollIndex{$client} = $scrollDefault{$client};
	}

	Slim::Utils::Timers::setTimer($client, Time::HiRes::time() + $refreshTime, \&tictac);
}

sub screensaverWeatherTimelines {
	my $client = shift;
	my ($line1, $line2, $overlay1, $overlay2);
	my $weatherinfo;
	my $timeinfo;

	# check for correct setup first!
	if (!Partner() || !License() || !City_Code() ||
	    Partner() eq "" || License() eq "" || City_Code() eq "") {
		$line1 = string('PLUGIN_SCREENSAVER_NOSETUP_LINE1');
		$line2 = string('PLUGIN_SCREENSAVER_NOSETUP_LINE2');
		return ($line1, $line2);
	}

	# see if forecast data is available (yet)
	if (defined $forecast{$client}[$scrollIndex{$client}]) {
		# FIXME some texts for conditions are too long
		# to fit the line (scrolling for only part of line1 possible???)
		$weatherinfo = $forecast{$client}[$scrollIndex{$client}];
	}
	else {
		$weatherinfo = string('PLUGIN_SCREENSAVER_WEATHERTIME_NOINFO');
	}
	# assemble date and time info
	$timeinfo = Slim::Utils::DateTime::timeF().Dateformatted();

	# check if we can use graphics on the client
	if($xmax{$client} && $ymax{$client}) {

		$line1 = Slim::Display::Display::symbol("framebuf");

		$line1 .= $forecastGX{$client}[$scrollIndex{$client}];
		$line1 .= Slim::Display::Lib::Fonts::string("standard.1",$weatherinfo) | Slim::Display::Lib::Fonts::string("standard.2",$timeinfo);

		$line1 .= Slim::Display::Display::symbol("/framebuf");
	}
	else {
		# text only for SqueezeboxG and SLIMP3
		if ($scrollIndex{$client} == 0) {
			$line1 = sprintf('%-8.5s',$currentTemperature{$client});
			if($highTemp{$client}[$scrollIndex{$client}] ne "") {
				$line2 = sprintf('%-8.5s',$highTemp{$client}[$scrollIndex{$client}]);
			}
			else {
				$line2 = sprintf('%-8.5s',$lowTemp{$client}[$scrollIndex{$client}]);
			}
		}
		else {
			$line1 = sprintf('%-8.5s',$lowTemp{$client}[$scrollIndex{$client}]);
			$line2 = sprintf('%-8.5s',$highTemp{$client}[$scrollIndex{$client}]);
		}
		$line1 .= $weatherinfo;
		$line2 .= $timeinfo;
	}

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	my $alarmOn = $client->prefGet("alarm", 0) || $client->prefGet("alarm", $wday);

	my $nextUpdate = $client->periodicUpdateTime();
	Slim::Buttons::Common::syncPeriodicUpdates($client, int($nextUpdate)) if (($nextUpdate - int($nextUpdate)) > 0.01);

	$overlay1 = undef;
	if ($alarmOn) {
		$overlay2 = $client->symbols('bell');
	}
	else {
		$overlay2 = undef;
	}

	return ($line1, $line2, $overlay1, $overlay2);
	
}

sub retrieveWeather {
	my $client = shift;
	my $weatherConditions = "";
	my $gxline1 = "";
	my $gxline2;
	my $gxline3;

	$::d_plugins && Slim::Utils::Misc::msg("WeatherTime: retrieving weather\n");

	#
	# get weatherdata using Weather::Cached from weather.com
	#
	my $loc = City_Code();
	chomp $loc;
	my $proxy = Slim::Utils::Prefs::get('webproxy') ? 'http://'.Slim::Utils::Prefs::get('webproxy') : undef;
	my %comargs = (
		'partner_id' => &Partner,
		'license'    => &License,
		'debug'      => 0,
		'cache'      => Slim::Utils::Prefs::get('cachedir'),
		'proxy'      => $proxy,
		'current'    => 1,
		'forecast'   => 7,
		'links'      => 0,
		'units'      => metric() ? 'm' : 's',
		'timeout'    => $timeout
	);
	my $wc = Weather::Cached->new(%comargs);
	my $weather;

	eval { $weather = $wc->get_weather($loc); };
	# make "die" errors in Weather::Cached non fatal
	if ( $@ ) {
		warn $@;
		# set display to show NO_FORECAST_AVAILABLE message
		$numdays{$client}=1;
		clearCanvas($client);
		drawIcon($client,29,$ymax{$client}-1,$TWClogo);
		$forecastGX{$client}[0] = getFramebuf($client,$gxwidth);
		$currentTemperature{$client} = "";
		$highTemp{$client}[0] = "";
		$lowTemp{$client}[0] = "";
		$forecast{$client}[0] = string('PLUGIN_WEATHERTIME_NO_FORECAST_AVAILABLE');
		$scrollDefault{$client} = 0;
		$scrollIndex{$client} = $scrollDefault{$client};
		return;
	}

	if ( $::d_plugins ) {
		Slim::Utils::Misc::msg("WeatherTime: current data\n");
		use Data::Dumper;
		print Dumper($weather->{cc});

		Slim::Utils::Misc::msg("WeatherTime: units returned\n");
		use Data::Dumper;
		print Dumper($weather->{head});
	}

	#
	# create display info
	#

	$forecast{$client}=();
	# get _current_ temperature
	if (valid($weather->{cc}->{tmp})) {
		$currentTemperature{$client} = '='.$weather->{cc}->{tmp}.$weather->{head}->{ut};
		$gxline1 = sprintf('%-6.5s% 2dg%s',uc(string('PLUGIN_WEATHERTIME_CURRENTTEMP')),
		                                   $weather->{cc}->{tmp},
		                                   $weather->{head}->{ut});
	}
	else {
		$currentTemperature{$client} = "";
	}
	my $day = 0;
	foreach (@{$weather->{'dayf'}->{'day'}}) {
		clearCanvas($client);

		# format high and/or low temperature strings
		if (valid($_->{'hi'}) && valid($_->{'low'})) {
			$gxline2 = sprintf('% 2d - % 2dg%s',$_->{'low'},
			                                    $_->{'hi'},
			                                    $weather->{head}->{ut});
			$highTemp{$client}[$day] = '<'.$_->{'hi'}.$weather->{head}->{ut};
			$lowTemp{$client}[$day] = '>'.$_->{'low'}.$weather->{head}->{ut};
		}
		elsif (valid($_->{'hi'})) {
			$gxline2 = sprintf('%-6.5s% 2dg%s',uc(string('PLUGIN_WEATHERTIME_HIGH')),
			                                   $_->{'hi'},
			                                   $weather->{head}->{ut});
			$highTemp{$client}[$day] = '<'.$_->{'hi'}.$weather->{head}->{ut};
			$lowTemp{$client}[$day] = "";
		}
		elsif (valid($_->{'low'})) {
			$gxline2 = sprintf('%-6.5s% 2dg%s',uc(string('PLUGIN_WEATHERTIME_LOW')),
			                                   $_->{'low'},
			                                   $weather->{head}->{ut});
			$lowTemp{$client}[$day] = '>'.$_->{'low'}.$weather->{head}->{ut};
			$highTemp{$client}[$day] = "";
		}
		else {
			$gxline2 = "";
			$highTemp{$client}[$day] = "";
			$lowTemp{$client}[$day] = "";
		}

		# format conditions forecast
		$::d_plugins && Slim::Utils::Misc::msg("$day: part0/day $_->{part}->[0]->{t}, part1/night $_->{part}->[1]->{t}\n");
		if (valid($_->{part}->[0]->{t})) {
		# use data for first half of the day if available
			# use upper case and transliterate for string lookup
			$weatherConditions = uc $_->{part}->[0]->{t};
			$weatherConditions =~ tr/ \//__/;
			$weatherConditions =~ s/_+/_/g;
			$weatherConditions = 'PLUGIN_WEATHERTIME_'.$weatherConditions;
			Slim::Utils::Strings::stringExists($weatherConditions) || Slim::Utils::Misc::msg("Plugin WeatherTime: need to add condition <$_->{part}->[0]->{t}> to translation STRINGS\n");
			$weatherConditions = Slim::Utils::Strings::stringExists($weatherConditions) ?
			                     string($weatherConditions) :
			                     $_->{part}->[0]->{t};
			# get and draw icon
			if (valid($_->{part}->[0]->{icon})) {
				drawIcon($client,0,$ymax{$client}-1,
				         $Icons[$Iconmap{$_->{part}->[0]->{icon}}]);
			}
			else {
				# icon no 9 is the N/A icon
				drawIcon($client,0,$ymax{$client}-1,$Icons[9]);
			}
		}
		elsif (valid($_->{part}->[1]->{t})) {
			# otherwise use data for second half of the day
			# use upper case and transliterate for string lookup
			$weatherConditions = uc $_->{part}->[1]->{t};
			$weatherConditions =~ tr/ \//__/;
			$weatherConditions =~ s/_+/_/g;
			$weatherConditions = 'PLUGIN_WEATHERTIME_'.$weatherConditions;
			Slim::Utils::Strings::stringExists($weatherConditions) || Slim::Utils::Misc::msg("Plugin WeatherTime: need to add condition |$_->{part}->[1]->{t}| to translation STRINGS\n");
			$weatherConditions = Slim::Utils::Strings::stringExists($weatherConditions) ?
			                     string($weatherConditions) :
			                     $_->{part}->[1]->{t};
			# get and draw icon
			if (valid($_->{part}->[1]->{icon})) {
				drawIcon($client,0,$ymax{$client}-1,
				         $Icons[$Iconmap{$_->{part}->[1]->{icon}}]);
			}
			else {
				# icon no 9 is the N/A icon
				drawIcon($client,0,$ymax{$client}-1,$Icons[9]);
			}
		}
		else {
			$weatherConditions = string('PLUGIN_WEATHERTIME_NO_FORECAST_AVAILABLE');
			drawIcon($client,0,$ymax{$client}-1,$Icons[9]);
		}
		if ($day == 0) {
			# today's forcast
			if (valid($_->{part}->[0]->{t})) {
				$forecast{$client}[$day] = string('PLUGIN_WEATHERTIME_TODAY').' '.
				                           $weatherConditions;
				# show todays forecast per default
				$scrollDefault{$client} = 0;
				$scrollIndex{$client} = $scrollDefault{$client};
			}
			# tonight's forcast
			else {
				$forecast{$client}[$day] = string('PLUGIN_WEATHERTIME_TONIGHT').' '.
				                           $weatherConditions;
				# scroll to  tomorrow's forecast per default
				# instead of tonight's forecast
				my ($d1,$d2,$hour,$d3,$d4,$d5,$d6,$d7) = localtime(time());
				$scrollDefault{$client} = (($hour >= 20 || $hour < 10) ? 1 : 0);
				$scrollIndex{$client} = $scrollDefault{$client};
			}
		}
		elsif ($day == 1) {
			# tomorrows forecast
			$forecast{$client}[$day] = string('PLUGIN_WEATHERTIME_TOMORROW').' '.
			                           $weatherConditions;
			# keep NOW temp on display
			# $gxline1 = "";
		}
		else {
			# forecast for after tomorrow
			$forecast{$client}[$day] = string('PLUGIN_WEATHERTIME_'.$_->{'t'}).' '.
			                           $weatherConditions;
			# NOW temp makes not much sense here, does it?
			$gxline1 = "";
		}
		if ( $::d_plugins ) {
			Slim::Utils::Misc::msg("$day: $forecast{$client}[$day]\n");
		}

		# get precipitation chance
		if (valid($_->{part}->[0]->{ppcp})) {
			$gxline3 = sprintf('%-7.6s%d%%',uc(string('PLUGIN_WEATHERTIME_PRECIP')),
			                                $_->{part}->[0]->{ppcp});
		}
		elsif (valid($_->{part}->[1]->{ppcp})) {
			$gxline3 = sprintf('%-7.6s%d%%',uc(string('PLUGIN_WEATHERTIME_PRECIP')),
			                                $_->{part}->[1]->{ppcp});
		}
		else {
			$gxline3 = "";
		}

		drawText($client,42,$ymax{$client}-1, $gxline1);
		drawText($client,42,$ymax{$client}-13,$gxline2);
		drawText($client,42,$ymax{$client}-25,$gxline3);
		$forecastGX{$client}[$day] = getFramebuf($client,$gxwidth);
		$day++;
	}

	$numdays{$client}=$day;
}

sub valid {
	my $data = shift;
	return (defined($data) && ($data ne "N/A"));
}

#
# Graphic functions
#
sub clearCanvas {
	my $client = shift;

	for( my $xi = 0; $xi < $xmax{$client}; $xi++) {
		for( my $yi = 0; $yi < $ymax{$client}; $yi++) {
			$hashDisp{$client}[$xi][$yi] = 0;
		}
	}
}

sub drawIcon {
	my $client = shift;
	my $xpos = shift;
	my $ypos = shift;
	my $icon = shift;

	$::d_plugins && Slim::Utils::Misc::msg("WeatherTime-Icon ($xpos,$ypos): $icon\n");
	if ($xmax{$client} && $ymax{$client}) {
		my $firstline = 1;
		my $xs = $xpos < 0 ? 0 : $xpos;
		my $yi = $ypos > $ymax{$client} ? $ymax{$client} : $ypos;
		for my $line (split('\n',$icon)) {
			# first line must be skipped (empty)
			if ($firstline) {
				$firstline = 0;
				next;
			}
			chomp $line;
			for( my $xi = $xs; $xi < length($line)+$xs && $xi < $xmax{$client} && $yi >= 0; $xi++) {
				if (substr($line,$xi-$xs,1) eq "*") {
					$hashDisp{$client}[$xi][$yi] = 1;
				}
			}
			$yi--;
		}
	}
}

sub drawText {
	my $client = shift;
	my $xpos = shift;
	my $ypos = shift;
	my $text = shift;

	$::d_plugins && Slim::Utils::Misc::msg("WeatherTime-Text ($xpos,$ypos): $text\n");
	if ($xmax{$client} && $ymax{$client}) {
		for (my $ci = 0; $ci < length($text); $ci++) {
			my $c = substr($text,$ci,1);
			my $firstline = 1;
			my $xs = $xpos < 0 ? 0 : $xpos + $ci*6;
			my $yi = $ypos > $ymax{$client} ? $ymax{$client} : $ypos;
			for my $line (split('\n',$Charset[$Codepage{$c}])) {
				# first line must be skipped (empty)
				if ($firstline) {
					$firstline = 0;
					next;
				}
				chomp $line;
				for( my $xi = $xs; $xi < length($line)+$xs && $xi < $xmax{$client} && $yi >= 0; $xi++) {
					if (substr($line,$xi-$xs,1) eq "*") {
						$hashDisp{$client}[$xi][$yi] = 1;
					}
				}
				$yi--;
			}
		}
	}
}

# convert %hashDisp into line framebuffer format
sub getFramebuf {
	my $client = shift;
	my $width = shift;
	my $line1 = "";
	
	for( my $x = 0; $x < $width && $x < $xmax{$client}; $x++) {
		my $byte;
		for( my $y = $ymax{$client}; $y > 0; $y -= 8) {
			$byte = ($hashDisp{$client}[$x][$y-1] << 7)
			      + ($hashDisp{$client}[$x][$y-2] << 6)
			      + ($hashDisp{$client}[$x][$y-3] << 5)
			      + ($hashDisp{$client}[$x][$y-4] << 4)
			      + ($hashDisp{$client}[$x][$y-5] << 3)
			      + ($hashDisp{$client}[$x][$y-6] << 2)
			      + ($hashDisp{$client}[$x][$y-7] << 1)
			      +  $hashDisp{$client}[$x][$y-8];
			$line1 .= pack("C", $byte);
		}
	}
	return $line1;
}

#
# access server settings
#
sub metric {
	return Slim::Utils::Prefs::get('plugin_Weathertime_units');
}

sub Partner {
	return Slim::Utils::Prefs::get('plugin_Weathertime_partner') || $Partner;
}

sub License {
	return Slim::Utils::Prefs::get('plugin_Weathertime_license') || $License;
}

sub City {
	return Slim::Utils::Prefs::get('plugin_Weathertime_city') || $City;
}

sub City_Code {
	return Slim::Utils::Prefs::get('plugin_Weathertime_citycode') || $City_Code;
}

sub Interval {
	return Slim::Utils::Prefs::get('plugin_Weathertime_interval');
}

sub Dateformat {
	return Slim::Utils::Prefs::get('plugin_Weathertime_dateformat');
}

sub Dateformatted {
	my $fmt = Dateformat();
	if ($fmt eq 'std') {
		return '  -  '.Slim::Utils::DateTime::shortDateF(); 
	}
	elsif ($fmt eq 'none') {
		return '';
	}
	else {
		my $date = strftime($fmt, localtime(time()));
		$date =~ s/\|0*//;
		return '  -  '.Slim::Utils::Unicode::utf8decode_locale($date);
	}
}

1;

__END__

# Local Variables:
# tab-width:4
# indent-tabs-mode:t
# End:
