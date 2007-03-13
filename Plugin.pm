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
#	2006/11/02 v1.8.1 fix for Slimserver 7.x series
#	                  added additional icons by Yannzola
#	                  added Swedish translations contributed by Daniel
#	                  Cervera <dc11ab(at)gmail.com>
#
#	----------------------------------------------------------------------
#	To do:
#
#	- Add missing icons for special weather conditions
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

use Slim::Control::Command;
use Slim::Buttons::Common;
use Slim::Utils::Misc;
use Slim::Utils::Validate;
use Slim::Utils::DateTime;
use Slim::Display::Display;

use File::Spec::Functions qw(:ALL);
use FileHandle;
use FindBin qw($Bin);
use XML::Simple;
use Plugins::WeatherTime::Weather::Cached;
use IO::Socket::INET;
use IO::Socket qw(:DEFAULT :crlf);
use POSIX qw(strftime);

use vars qw($VERSION);
$VERSION = substr(q$Revision: 1.8 $,10);

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

sub strings { return '
PLUGIN_SCREENSAVER_WEATHERTIME
	DE	Wetter/Zeit Bildschirmschoner
	EN	Weather, Date and Time
	FR	Température, Date et Heure
	NL	Weer, datum en tijd
	SE	Väder, datum och tid
  
PLUGIN_SCREENSAVER_WEATHERTIME_START
	DE	PLAY drÃ¼cken zum Starten des Bildschirmschoners
	EN	Press PLAY to start this screensaver
	FR	Appuyez sur PLAY pour activer cet écran de veille
	NL	Druk op PLAY om deze screensaver aan te zetten
	SE	Tryck på PLAY för att starta skärmsläckaren
  
PLUGIN_SCREENSAVER_WEATHERTIME_ENABLE
	DE	PLAY drÃ¼cken zum Aktivieren des Bildschirmschoners
	EN	Press PLAY to enable this screensaver
	FR	Appuyez sur PLAY pour activer cet écran de veille
	NL	Druk op PLAY om deze schermbeveiliger aan te zetten
	SE	Tryck på PLAY för att aktivera skärmsläckaren
  
PLUGIN_SCREENSAVER_WEATHERTIME_DISABLE
	DE	PLAY drÃ¼cken zum Deaktivieren dieses Bildschirmschoners
	EN	Press PLAY to disable this screensaver
	FR	Appuyer sur PLAY pour dï¿½sactiver cet ï¿½cran de veille
	NL	Druk op PLAY om deze schermbeveiliger uit te zetten
	SE	Tryck på PLAY för att avaktivera skärmsläckaren
  
PLUGIN_SCREENSAVER_WEATHERTIME_ENABLING
	DE	Wetter/Zeit Bildschirmschoner aktivieren
	EN	Enabling WeatherTime as current screensaver
	FR	Activation de WeatherTime comme écran de veille actuel
	NL	Aanzetten van Weer, datum en tijd als huidige schermbeveiliger
	SE	Aktiverar WeatherTime som skärmsläckare
  
PLUGIN_SCREENSAVER_WEATHERTIME_DISABLING
	DE	Standard-Bildschirmschoner deaktivieren
	EN	Resetting to default screensaver
	FR	Retour à l\'écran de veille par défaut
	NL	Herstellen standaard schermbeveiliger
	SE	Återställer till standardskärmsläckaren

PLUGIN_SCREENSAVER_WEATHERTIME_UPDATING
	DE	Aktualisiere aktuelle Wetterdaten...
	EN	Updating Weather Forecast...
	FR	Mise à jour des prévisions météo...
	NL	Bijwerken weersvoorspelling
	SE	Uppdaterar väderdata...

PLUGIN_SCREENSAVER_NOSETUP_LINE1
	DE	Registrierung und/oder Setup erforderlich
	EN	Registration and/or Setup Required
	FR	Enregistrement et/ou configuration requis
	NL	Registratie en/of instellen noodzakelijk
	SE	Registrering och/eller konfiguration saknas

PLUGIN_SCREENSAVER_NOSETUP_LINE2
	DE	Bei auf http://registration.weather.com/registration/xmloap/step1 registrieren und ID und Key in server settings eintragen.
	EN	Sign up at http://registration.weather.com/registration/xmloap/step1 and enter ID and Key in server settings.
	FR	Enregistrez-vous à http://registration.weather.com/registration/xmloap/step1 et entrez votre identification et clé dans les paramètres de serveur.
	NL	Registeren bij http://registration.weather.com/registration/xmloap/step1 en enter ID en key in server instellingen
	SE	Registrera dig på http://registration.weather.com/registration/xmloap/step1 - skriv in erhållen KEY ochh ID i serverinställningarna 

SETUP_GROUP_PLUGIN_WEATHERTIME
	DE	Wetter/Zeit Bildschirmschoner
	EN	Weather, Date and Time Screensaver
	FR	Ecran de veille Température, Date et Heure
	NL	Weer, datum en tijd schermbeveiliger
	SE	Väder, datum och tid-skärmsläckare

SETUP_GROUP_PLUGIN_WEATHERTIME_DESC
	EN	The weather data is retrieved from <i>The Weather Channel&reg;</i>. You need to sign up at http://registration.weather.com/registration/xmloap/step1 and enter ID and Key in server settings. To localize your forecast you also need to find out the weather.com citycode, e.g. GMXX0007 for Berlin, Germany. You can see the citycode in the URL of your local forecast on <i>weather.com&reg;</i>.
	FR	L\'information météo est extraite de <i>The Weather Channel&reg;</i>. Vous devez vous inscrire à http://registration.weather.com/registration/xmloap/step1 et entrer identification et clé dans les paramètres de serveur. Pour localiser vos prévisions vous devez aussi déterminer le code de ville de weather.com, par exemple CAXX0301 pour Montréal, Canada. Vous pouvez voir le code de ville dans le URL de vos prévisions locales sur <i>weather.com&reg;</i>.
	DE	Die Wetterdaten werden von <i>The Weather Channel&reg;</i> bezogen. Eine Registrierung unter http://registration.weather.com/registration/xmloap/step1 ist erforderlich, um die Partner ID und den LizenzschlÃ¼ssel zu erhalten. Der Citycode stammt ebenfalls von weather.com, zum Beispiel GMXX0007 fÃ¼r Berlin, und kann der URL des entsprechenden Wetterberichts auf <i>weather.com&reg;</i> entnommen werden.
	NL	Het weerbericht is opgehaald van  <i>The Weather Channel&reg;</i>. Je moet registreren bij http://registration.weather.com/registration/xmloap/step1 en vul je ID en Key in bij de Server instellingen. Om het weerbericht te localiseren heb je de citycode van weather.com nodig. Bijvoorbeeld NLXX0002 voor Amsterdam. Je kunt de citycode uit de URL halen als je het weerbericht voor de plaats opzoekt.
	SE	Väderdata kommer från <i>The Weather Channel&reg;</i>. För att se din lokala väderdata måste du registrera dig på http://registration.weather.com/registration/xmloap/step1 och fylla i ID och Key i serverinställningarna. Du hittar den kod som Weather.com använder i adressfältet i browsern när du söker på din ort, till exempel SWXX0020 för Malmö.
  
SETUP_PLUGIN_WEATHERTIME_UNITS
	EN	Weather Units
	FR	Unités Météo
	DE	Einheiten
	NL	Eenheden
	SE	Enheter

SETUP_PLUGIN_WEATHERTIME_1
	EN	Metric Units
	FR	Unités Métriques
	DE	metrisch
	NL	Metrisch
	SE	Metriska SI-enheter

SETUP_PLUGIN_WEATHERTIME_0
	EN	Imperial Units
	FR	Unités Impériales
	DE	englisch
	NL	Engels
	SE	US/Imperial-enheter

SETUP_PLUGIN_WEATHERTIME_CITY
	EN	City
	FR	Ville
	DE	Name der Stadt
	NL	Plaatsnaam
	SE	Ort/stad

SETUP_PLUGIN_WEATHERTIME_CITYCODE
	EN	Weather.com Citycode
	FR	Code de ville weather.com
	DE	Weather.com Citycode
	NL	Weather.com Citycode
	SE	Citycode från Weather.com

SETUP_PLUGIN_WEATHERTIME_INTERVAL
	EN	Fetch Interval (seconds)
	FR	Intervalle de mise-à-jour (secondes)
	DE	Aktualisierungsintervall (sekunden)
	NL	Interval voor bijwerken in seconden
	SE	Hämtningsintervall

SETUP_PLUGIN_WEATHERTIME_PARTNER
	EN	Partner ID
	FR	Partner ID
	DE	Partner ID
	NL	Partner ID
	SE	Partner ID

SETUP_PLUGIN_WEATHERTIME_LICENSE
	EN	License Key
	FR	Clé de License
	DE	LizenzschlÃ¼ssel
	NL	Licentiesleutel
	SE	License Key

SETUP_PLUGIN_WEATHERTIME_DATEFORMAT
	EN	Date format
	FR	Format des dates
	DE	Datumsformat
	NL	Datumformaat
	SE	Datumformat

SETUP_PLUGIN_WEATHERTIME_STDDATE
	EN	standard
	FR	standard
	DE	Standardformat
	NL	standaardformat
	SE	Standardformat

SETUP_PLUGIN_WEATHERTIME_NODATE
	EN	no date (time only)
	FR	sans date (heure seulement)
	DE	kein Datum (nur Zeit)
	NL	geen datum (alleen de tijd)
	SE	Inget datum (endast tid)

PLUGIN_SCREENSAVER_WEATHERTIME_NOINFO
	DE	Wetterdaten werden geladen
	EN	Weather Forecast loading
	FR	Chargement des prévisions météo
	NL	Laden weerbericht
	SE	Laddar väderdata

PLUGIN_WEATHERTIME_NO_FORECAST_AVAILABLE
	DE	keine Vorhersage vorhanden
	EN	no forecast available
	FR	Prévisions non disponibles
	NL	geen weerbericht beschikbaar
	SE	Prognos ej tillgänglig

PLUGIN_WEATHERTIME_CURRENTTEMP
	DE	Jetzt
	EN	Now
	FR	Maintenant
	NL	Nu
	SE	Nu

PLUGIN_WEATHERTIME_TODAY
	DE	Heute
	EN	Today
	FR	Aujourd\'hui
	NL	Vandaag
	SE	Idag

PLUGIN_WEATHERTIME_TONIGHT
	DE	Nachts
	EN	Tonight
	FR	Ce soir
	NL	Vannacht
	SE	Ikväll

PLUGIN_WEATHERTIME_TOMORROW
	DE	Morgen
	EN	Tomorrow
	FR	Demain
	NL	Morgen
	SE	Imorgon

PLUGIN_WEATHERTIME_SUNDAY
	DE	Sonntag
	EN	Sunday
	FR	Dimanche
	NL	Zondag
	SE	Söndag

PLUGIN_WEATHERTIME_MONDAY
	DE	Montag
	EN	Monday
	FR	Lundi
	NL	Maandag
	SE	Måndag

PLUGIN_WEATHERTIME_TUESDAY
	DE	Dienstag
	EN	Tuesday
	FR	Mardi
	NL	Dinsdag
	SE	Tisdag

PLUGIN_WEATHERTIME_WEDNESDAY
	DE	Mittwoch
	EN	Wednesday
	FR	Mercredi
	NL	Woensdag
	SE	Onsdag

PLUGIN_WEATHERTIME_THURSDAY
	DE	Donnerstag
	EN	Thursday
	FR	Jeudi
	NL	Donderdag
	SE	Torsdag

PLUGIN_WEATHERTIME_FRIDAY
	DE	Freitag
	EN	Friday
	FR	Vendredi
	NL	Vrijdag
	SE	Fredag

PLUGIN_WEATHERTIME_SATURDAY
	DE	Samstag
	EN	Saturday
	FR	Samedi
	NL	Zaterdag
	SE	Lördag

PLUGIN_WEATHERTIME_NIGHT
	DE	Nachts
	EN	Night
	FR	Nuit
	NL	\'s Nachts
	SE	Natt

PLUGIN_WEATHERTIME_DAY
	DE	Tagsüber
	EN	Day
	FR	Jour
	NL	Overdag
	SE	Dagtid

PLUGIN_WEATHERTIME_HIGH
	DE	Max
	EN	High
	FR	Maximum
	NL	Max
	SE	Max

PLUGIN_WEATHERTIME_LOW
	DE	Min
	EN	Low
	FR	Minimum
	NL	Min
	SE	Min

PLUGIN_WEATHERTIME_PRECIP
	DE	Regen
	EN	Precip
	FR	Précip
	NL	Regen
	SE	Regn

PLUGIN_WEATHERTIME_CLOUDY
	EN	Cloudy
	FR	Nuageux
	DE	bewÃ¶lkt
	NL	zwaarbewolkt
	SE	Molnigt

PLUGIN_WEATHERTIME_MOSTLY_CLOUDY
	EN	Mostly Cloudy
	FR	Plutôt nuageux
	DE	meist bewÃ¶lkt
	NL	bewolkt
	SE	Mestadels molnigt

PLUGIN_WEATHERTIME_PARTLY_CLOUDY
	EN	Partly Cloudy
	FR	Partiellement nuageux
	DE	teilw. bewÃ¶lkt
	NL	halfbewolkt
	SE	Delvis molnigt

PLUGIN_WEATHERTIME_LIGHT_RAIN
	EN	Light Rain
	FR	Pluie légère
	DE	etwas Regen
	NL	enige regen
	SE	Lätt regn

PLUGIN_WEATHERTIME_LIGHT_RAIN_WIND
	EN	Light Rain / Wind
	FR	Pluie légère / Vent
	DE	etwas Regen, Wind
	NL	enige regen / winderig
	SE	Lätt regn/blåsigt

PLUGIN_WEATHERTIME_SHOWERS
	EN	Showers
	FR	Averses
	DE	Schauer
	NL	buien
	SE	Regnskurar

PLUGIN_WEATHERTIME_RAIN
	EN	Rain
	FR	Pluie
	DE	Regen
	NL	regen
	SE	Regn

PLUGIN_WEATHERTIME_AM_SHOWERS
	EN	AM Showers
	FR	Averses AM
	DE	Vorm. Schauer
	NL	ocht. buien
	SE	Regn på förmiddagen

PLUGIN_WEATHERTIME_SHOWERS_EARLY
	EN	Showers early
	FR	Averses Tôt
	DE	anfangs Schauer
	NL	vroeg buien
	SE	Tidiga regnskurar

PLUGIN_WEATHERTIME_SHOWERS_LATE
	EN	Showers late
	FR	Averses Tard
	DE	abends Schauer
	NL	avond buien
	SE	Regnskurar mot kvällen

PLUGIN_WEATHERTIME_FOG
	EN	Fog
	FR	Brouillard
	DE	Nebel
	NL	mist
	SE	Dimma

PLUGIN_WEATHERTIME_FEW_SHOWERS
	EN	Few Showers
	FR	Quelques Averses
	DE	vereinzelte Schauer
	NL	enkele buien
	SE	Enstaka skurar

PLUGIN_WEATHERTIME_MOSTLY_SUNNY
	EN	Mostly Sunny
	FR	Plutôt Ensoleillé
	DE	meist sonnig
	NL	vooral zonnig
	SE	Mestadels soligt

PLUGIN_WEATHERTIME_SUNNY
	EN	Sunny
	FR	Ensoleillé
	DE	sonnig
	NL	zonnig
	SE	Soligt

PLUGIN_WEATHERTIME_SCATTERED_FLURRIES
	EN	Scattered Flurries
	FR	Neige Passagère
	DE	BÃ¶en aus wechselnder Richtung
	NL	lokaal buien
	SE	Byiga vindar

PLUGIN_WEATHERTIME_AM_CLOUDS_PM_SUN
	EN	AM Clouds/PM Sun
	FR	Nuageux AM / Soleil PM
	DE	Vorm. Wolken, nachm. Sonne
	NL	bewolkt later zonnig
	SE	Moln på fm, sol på em

PLUGIN_WEATHERTIME_CLOUDS_EARLY_CLEARING_LATE
	EN	Clouds Early / Clearing Late
	FR	Nuages Tôt / Eclaircissements
	DE	anfangs Wolken / abends klar
	NL	bewolkt later opklaringen
	SE	Uppsprickande molntäcke

PLUGIN_WEATHERTIME_ISOLATED_T-STORMS
	EN	Isolated T-Storms
	FR	Orages Isolées
	DE	vereinzelte Gewitter
	NL	een enkele onweersbui
	SE	Enstaka åskväder

PLUGIN_WEATHERTIME_SCATTERED_THUNDERSTORMS
	EN	Scattered Thunderstorms
	FR	Orages Dispersées
	DE	verteilte Gewitter
	NL	lokaal onweersbuien
	SE	Lokala åskväder

PLUGIN_WEATHERTIME_SCATTERED_T-STORMS
	EN	Scattered Thunderstorms
	FR	Orages Dispersées
	DE	verteilte Gewitter
	NL	lokaal onweersbuien
	SE	Lokala åskväder

PLUGIN_WEATHERTIME_SCATTERED_SHOWERS
	EN	Scattered Showers
	FR	Averses Dispersées
	DE	verteilte Schauer
	NL	lokaal buien
	SE	Lokala regnskurar

PLUGIN_WEATHERTIME_PM_SHOWERS
	EN	PM Showers
	FR	Averses PM
	DE	Nachm. Schauer
	NL	middag buien
	SE	Eftermiddagsregn

PLUGIN_WEATHERTIME_PM_SHOWERS_WIND
	EN	PM Showers/Wind
	FR	Averses/Vent PM
	DE	Nachm. Schauer/Wind
	NL	midd. buien/winderig
	SE	Regnskurar/blåst mot em

PLUGIN_WEATHERTIME_RAIN_SNOW_SHOWERS
	EN	Rain/Snow Showers
	FR	Averses Pluie/Neige
	DE	Regen/Schneeschauer
	NL	regen/sneeuwbuien
	SE	Regn-, snöfall

PLUGIN_WEATHERTIME_FEW_SNOW_SHOWERS
	EN	Few Snow Showers
	FR	Quelques Averses de Neige
	DE	vereinzelte Schneeschauer
	NL	enkele sneeuwbuien
	SE	Enstaka snöfall

PLUGIN_WEATHERTIME_CLOUDY_WIND
	EN	Cloudy/Wind
	FR	Nuageux/Venteux
	DE	bewÃ¶lkt/windig
	NL	zwaarbewolkt/winderig
	SE	Molnigt/blåsigt

PLUGIN_WEATHERTIME_FLURRIES_WIND
	EN	Flurries/Wind
	FR	Neige/Vent
	DE	bÃ¶eig/windig
	NL	windvlagen
	SE	Flingor/blåsigt

PLUGIN_WEATHERTIME_MOSTLY_CLOUDY_WINDY
	EN	Mostly Cloudy/Windy
	FR	Plutôt Nuageux/Venteux
	DE	meist bewÃ¶lkt/windig
	NL	bewolkt/winderig
	SE	Mestadels molnigt/blåsigt

PLUGIN_WEATHERTIME_RAIN_THUNDER
	EN	Rain/Thunder
	FR	Pluie/Orages
	DE	Regen/Gewitter
	NL	regen/onweer
	SE	Regn och åska

PLUGIN_WEATHERTIME_PARTLY_CLOUDY_WIND
	EN	Partly Cloudy/Wind
	FR	Partiellement Nuageux/Venteux
	DE	teilw. bewÃ¶lkt/Wind
	NL	halfbewolkt/winderig
	SE	Delvis molnigt/blåsigt

PLUGIN_WEATHERTIME_AM_RAIN_SNOW_SHOWERS
	EN	AM Rain/Snow Showers
	FR	Pluie/Averses de neige AM
	DE	Vorm. Regen/Schneeschauer
	NL	ocht. regen/sneeuwbui
	SE	Förmiddagsregn/snöfall

PLUGIN_WEATHERTIME_LIGHT_RAIN_WIND
	EN	Light Rain/Wind
	FR	Pluie/Vents Légers
	DE	leichter Regen/Wind
	NL	enige regen/winderig
	SE	Lätt regn/blåst

PLUGIN_WEATHERTIME_SHOWERS_WIND
	EN	Showers/Wind
	FR	Averses/Vent
	DE	Schauer/Wind
	NL	buien/winderig
	SE	Regnskurar/blåst

PLUGIN_WEATHERTIME_MOSTLY_SUNNY_WIND
	EN	Mostly Sunny/Wind
	FR	Plutôt Ensoleillé/Vent
	DE	meist sonnig/Wind
	NL	vooral zonnig/winderig
	SE	Mestadels soligt/blåsigt

PLUGIN_WEATHERTIME_FLURRIES
	EN	Flurries
	FR	Neige
	DE	BÃ¶en
	NL	buien
	SE	Snöflingor

PLUGIN_WEATHERTIME_RAIN_WIND
	EN	Rain/Wind
	FR	Pluie/Vent
	DE	Regen/Wind
	NL	regen/winderig
	SE	Regn/blåst

PLUGIN_WEATHERTIME_SCT_FLURRIES_WIND
	EN	Sct Flurries/Wind
	FR	Averses de Neige/Vent
	DE	verteilte, bÃ¶eige Winde
	NL	lokaal buien/winderig
	SE	Lokalt snöflingor/blåsigt

PLUGIN_WEATHERTIME_SCT_STRONG_STORMS
	EN	Sct Strong Storms
	FR	Fortes Tempêtes Dispersées
	DE	verteilte, heftige StÃ¼rme
	NL	lokaal zware stormen
	SE	Lokala stormbyar

PLUGIN_WEATHERTIME_PM_T-STORMS
	EN	PM T-Storms
	FR	Orages PM
	DE	Nachm. Gewitter
	NL	midd. onweersbuien
	SE	Åskväder under fm

PLUGIN_WEATHERTIME_T-STORMS
	EN	T-Storms
	FR	Orages
	DE	Gewitter
	NL	onweersbuien
	SE	Åskväder

PLUGIN_WEATHERTIME_THUNDERSTORMS
	EN	Thunderstorms
	FR	Orages
	DE	Gewitter
	NL	onweer
	SE	Åskväder

PLUGIN_WEATHERTIME_SUNNY_WINDY
	EN	Sunny/Windy
	FR	Ensoleillé/Venteux
	DE	sonnig/windig
	NL	zonnig/winderig
	SE	Soligt/blåsigt

PLUGIN_WEATHERTIME_AM_THUNDERSTORMS
	EN	AM Thunderstorms
	FR	Orages AM
	DE	Vorm. Gewitter
	NL	ocht. onweersbuien
	SE	Åskväder under fm

PLUGIN_WEATHERTIME_AM_RAIN
	EN	AM Rain
	FR	Pluie AM
	DE	Vorm. Regen
	NL	ochtend regen
	SE	Regn under fm

PLUGIN_WEATHERTIME_ISO_T-Storms_WIND
	EN	Iso T-Storms/Wind
	FR	Orages/Vent Dispersés
	DE	vereinzelte Gewitter/Wind
	NL	enkele onweersbui/winderig
	SE	Enstaka åskväder/blåsigt

PLUGIN_WEATHERTIME_RAIN_SNOW
	EN	Rain/Snow
	FR	Pluie/Neige
	DE	Regen/Schnee
	NL	regen/sneeuw
	SE	Regn/snö

PLUGIN_WEATHERTIME_RAIN_SNOW_WIND
	EN	Rain/Snow/Wind
	FR	Pluie/Neige/Vent
	DE	Regen/Schnee/Wind
	NL	regen/sneeuw/winderig
	SE	Regn/snö och blåsigt

PLUGIN_WEATHERTIME_SCT_T-STORMS_WIND
	EN	Sct T-Storms/Wind
	FR	Orages Dispersées/Vent
	DE	verteilte Gewitter/Wind
	NL	lokaal onweersbui/winderig
	SE	Lokala åskväder/blåsigt

PLUGIN_WEATHERTIME_AM_SHOWERS_WIND
	EN	AM Showers/Wind
	FR	Averses/Vent AM
	DE	Vorm. Schauer/Wind
	NL	ocht. buien/winderig
	SE	Regnskurar under fm

PLUGIN_WEATHERTIME_SCT_SNOW_SHOWERS
	EN	Sct Snow Showers
	FR	Averses de Neige Dispersées
	DE	verteilte Schneeschauer
	NL	lokaal sneeuwbuien
	SE	Lokala snöbyar

PLUGIN_WEATHERTIME_SCATTERED_SNOW_SHOWERS
	EN	Scattered Snow Showers
	FR	Averses de Neige Dispersées
	DE	verteilte Schneeschauer
	NL	lokaal sneeuwbuien
	SE	Lokala snöbyar

PLUGIN_WEATHERTIME_SNOW_TO_ICE_WIND
	EN	Snow to Ice/Wind
	FR	Neige à Glace/Vent
	DE	Schnee in Hagel Ã¼berg./Wind
	NL	sneeuw tot hagel/winderig
	SE	Snöblandad hagelvind

PLUGIN_WEATHERTIME_SNOW_TO_RAIN
	EN	Snow to Rain
	FR	Neige à Pluie
	DE	Schnee in Regen Ã¼berg.
	NL	sneeuw tot regen
	SE	Snö till regn

PLUGIN_WEATHERTIME_AM_LIGHT_RAIN
	EN	AM Light Rain
	FR	Pluie Légère AM
	DE	Vorm. etwas Regen
	NL	ocht. enige regen
	SE	Lätt regn under fm

PLUGIN_WEATHERTIME_PM_LIGHT_RAIN
	EN	PM Light Rain
	FR	Pluie Légère PM
	DE	Nachm. etwas Regen
	NL	midd. enige regen
	SE	Lätt regn till em
PLUGIN_WEATHERTIME_LIGHT_RAIN_LATE
	EN	Light Rain Late
	FR	Pluie Légère Tard
	DE	Abends etwas Regen
	NL	avond enige regen
	SE	Lätt regn mot kvällen
  
PLUGIN_WEATHERTIME_RAIN_LATE
	EN	Rain Late
	FR	Pluie Tard
	DE	Abends Regen
	NL	avond regen
	SE	Regn mot kvällen

PLUGIN_WEATHERTIME_PM_RAIN
	EN	PM Rain
	FR	Pluie PM
	DE	Nachm. Regen
	NL	midd. regen
	SE	Regn mot em

PLUGIN_WEATHERTIME_SNOW_SHOWERS
	EN	Snow Showers
	FR	Averses de Neige
	DE	Schneeschauer
	NL	sneeuwbuien
	SE	Snöfall

PLUGIN_WEATHERTIME_SNOW_SHOWER
	EN	Snow Shower
	FR	Averse de Neige
	DE	Schneeschauer
	NL	sneeuwbui
	SE	Snöfall

PLUGIN_WEATHERTIME_RAIN_TO_SNOW
	EN	Rain to Snow
	FR	Pluie à Neige
	DE	Regen in Schnee Ã¼berg.
	NL	regen tot sneeuw
	SE	Regn till snö

PLUGIN_WEATHERTIME_PM_RAIN_SNOW
	EN	PM Rain/Snow
	FR	Pluie/Neige PM
	DE	Nachm. Regen/Schnee
	NL	midd. regen/sneeuw
	SE	Regn/snö mot em

PLUGIN_WEATHERTIME_FEW_SHOWERS_WIND
	EN	Few Showers/Wind
	FR	Quelques Averses/Vent
	DE	wenige Schauer/Wind
	NL	enkele buien/winderig
	SE	Enstaka regnskurar/blåst

PLUGIN_WEATHERTIME_SNOW_WIND
	EN	Snow/Wind
	FR	Neige/Vent
	DE	Schnee/Wind
	NL	sneeuw/winderig
	SE	Snö/blåst

PLUGIN_WEATHERTIME_PM_RAIN_SNOW_SHOWERS
	EN	PM Rain/Snow Showers
	FR	Averses de Pluie/Neige PM
	DE	Nachm. Regen/Schneeschauer
	NL	midd. regen/sneeuwbuien
	SE	Snöblandat regn mot em

PLUGIN_WEATHERTIME_PM_RAIN_SNOW_WIND
	EN	PM Rain/Snow/Wind
	FR	Pluie/Neige/Vent PM
	DE	Nachm. Regen/Schnee/Wind
	NL	midd. regen/sneeuw/winderig
	SE	Snöblandat regn/blåst mot em

PLUGIN_WEATHERTIME_RAIN_SNOW_SHOWERS_WIND
	EN	Rain/Snow Showers/Wind
	FR	Pluie/Averses de Neige/Vent
	DE	Regen/Schneeschauer/Wind
	NL	regen/sneeubuien/winderig
	SE	Regn/Snöfall och blåsigt

PLUGIN_WEATHERTIME_RAIN_SNOW_WIND
	EN	Rain/Snow/Wind
	FR	Pluie/Neige/Vent
	DE	Regen/Schnee/Wind
	NL	regen/sneeuw/winderig
	SE	Regn/snö/blåst

PLUGIN_WEATHERTIME_LIGHT_SNOW
	EN	Light Snow
	FR	Neige Légère
	DE	etwas Schnee
	NL	lichte sneeuw
	SE	Lätt snöfall

PLUGIN_WEATHERTIME_PM_SNOW
	EN	PM Snow
	FR	Neige PM
	DE	Nachm. Schnee
	NL	midd. sneeuw
	SE	Snö mot em

PLUGIN_WEATHERTIME_FEW_SNOW_SHOWERS_WIND
	EN	Few Snow Showers/Wind
	FR	Quelques Averses de Neige/Vent
	DE	wenige Schneeschauer/Wind
	NL	enkele sneeuwbuien/winderig
	SE	Enstaka snöbyar/blåsigt

PLUGIN_WEATHERTIME_LIGHT_SNOW_WIND
	EN	Light Snow/Wind
	FR	Neige/Vent Léger
	DE	etwas Schnee/Wind
	NL	lichte sneeuw/winderig
	SE	Lätt snö/blåsigt

PLUGIN_WEATHERTIME_WINTRY_MIX
	EN	Wintry Mix
	FR	Mélange Hivernal
	DE	Winter-Mix
	NL	winters
	SE	Vinterväder kring nollgradigt

PLUGIN_WEATHERTIME_AM_WINTRY_MIX
	EN	AM Wintry Mix
	FR	Mélange Hivernal AM
	DE	Vorm. Winter-Mix
	NL	ocht. winters
	SE	Kring nollgradigt under fm

PLUGIN_WEATHERTIME_HVY_RAIN_FREEZING_RAIN
	EN	Hvy Rain/Freezing Rain
	FR	Pluie Forte/Verglaçante
	DE	heftiger/gefr. Regen
	NL	sterke (ijs)regen
	SE	Kraftigt underkylt regn

PLUGIN_WEATHERTIME_AM_LIGHT_SNOW
	EN	AM Light Snow
	FR	Neige Légère AM
	DE	Vorm. etwas Schnee
	NL	ocht. enige sneeuw
	SE	Lätt snö under fm

PLUGIN_WEATHERTIME_RAIN_FREEZING_RAIN
	EN	Rain/Freezing Rain
	FR	Pluie/Pluie Verglaçante
	DE	Regen/gefr. Regen
	NL	regen/ijsregen
	SE	Regn/underkylt regn

PLUGIN_WEATHERTIME_T-STORMS_WIND
	EN	T-Storms/Wind
	FR	Orages/Vent
	DE	Gewitter/Wind
	NL	onweer/winderig
	SE	Åskväder/blåsigt

PLUGIN_WEATHERTIME_SPRINKLES
	EN	Sprinkles
	FR	Quelques Gouttes
	DE	Graupel
	NL	motregen
	SE	Strilande regn

PLUGIN_WEATHERTIME_AM_SNOW_SHOWERS
	EN	AM Snow Showers
	FR	Averses de Neige AM
	DE	Vorm. Schneeschauer
	NL	ocht. sneeuwbuien
	SE	Snöfall under fm

PLUGIN_WEATHERTIME_SNOW_SHOWERS_EARLY
	EN	Snow Showers Early
	FR	Averses de Neige Tôt
	DE	anfangs Schneeschauer
	NL	vroeg sneeuwbuien
	SE	Tidiga snöfall

PLUGIN_WEATHERTIME_AM_CLOUDS_PM_SUN_WIND
	EN	AM Clouds/PM Sun/Wind
	FR	Nuages AM / Soleil/Vent PM
	DE	Vorm. Wolken/Nachm. Sonne/Wind
	NL	bewolkt later zon/winderig
	SE	Molnigt under fm/Sol under em

PLUGIN_WEATHERTIME_AM_RAIN_SNOW_WIND
	EN	AM Rain/Snow/Wind
	FR	Pluie/Neige/Vent AM
	DE	Vorm. Regen/Schnee/Wind
	NL	ocht. regen/sneeuw/winderig
	SE	Snöblandat regn/blåst under fm

PLUGIN_WEATHERTIME_RAIN_TO_SNOW_WIND
	EN	Rain to Snow/Wind
	FR	Pluie à Neige/Vent
	DE	Regen in Schnee Ã¼berg./Wind
	NL	regen tot sneeuw/winderig
	SE	Snöblandat regn/blåst

PLUGIN_WEATHERTIME_SNOW_TO_WINTRY_MIX
	EN	Snow to Wintry Mix
	FR	Neige à Mélange Hivernal
	DE	Schnee in Winter-Mix Ã¼berg.
	NL	sneeuw tot winters
	SE	Vinterväder kring nollgradigt

PLUGIN_WEATHERTIME_PM_SNOW_SHOWERS_WIND
	EN	PM Snow Showers/Wind
	FR	Averses de Neige/Vent PM
	DE	Nachm. Schneeschauer/Wind
	NL	midd. sneeuwbuien/winderig
	SE	Snöfall/blåsigt under fm

PLUGIN_WEATHERTIME_SNOW_AND_ICE_TO_RAIN
	EN	Snow and Ice to Rain
	FR	Neige et Glace à Pluie
	DE	Schnee und Hagel in Regen Ã¼berg.
	NL	sneeuw/hagel tot regen
	SE	Snö/hagel till regn

PLUGIN_WEATHERTIME_HEAVY_RAIN
	EN	Heavy Rain
	FR	Pluie Forte
	DE	heftiger Regen
	NL	zware buien
	SE	Kraftiga regnskurar

PLUGIN_WEATHERTIME_AM_RAIN_ICE
	EN	AM Rain/Ice
	FR	Pluie/Glace AM
	DE	Vorm. Regen/Hagel
	NL	ocht. regen/hagel
	SE	Regn och is under fm

PLUGIN_WEATHERTIME_AM_SNOW_SHOWERS_WIND
	EN	AM Snow Showers/Wind
	FR	Averses de Neige/Vent AM
	DE	Vorm. Schneeschauer/Wind
	NL	ocht. sneeuwbuien/winderig
	SE	Snöfall/blåsigt under fm

PLUGIN_WEATHERTIME_AM_LIGH_SNOW_WIND
	EN	AM Light Snow/Wind
	FR	Neige Légère/Vent AM
	DE	Vorm. etwas Schnee/Wind
	NL	ocht. lichte sneeuw/winderig
	SE	Lätt snö/blåst under fm

PLUGIN_WEATHERTIME_PM_LIGHT_RAIN_WIND
	EN	PM Light Rain/Wind
	FR	Pluie Légère/Vent PM
	DE	Nachm. etwas Regen/Wind
	NL	midd. lichte regen/winderig
	SE	Lätt regn/vind mot em

PLUGIN_WEATHERTIME_AM_LIGHT_WINTRY_MIX
	EN	AM Light Wintry Mix
	FR	Mélange Hivernal Léger AM
	DE	Vorm. leichter Winter-Mix
	NL	ocht. lichte winters
	SE	Kring nollgradigt under fm

PLUGIN_WEATHERTIME_PM_LIGHT_SNOW_WIND
	EN	PM Light Snow/Wind
	FR	Neige Légère/Vent PM
	DE	Nachm. etwas Schnee/Wind
	NL	midd. lichte sneeuw/winderig
	SE	Lätt snö/vind under fm

PLUGIN_WEATHERTIME_HEAVY_RAIN_WIND
	EN	Heavy Rain/Wind
	FR	Pluie/Vent Forts
	DE	heftiger Regen/Wind
	NL	zware regen/winderig
	SE	Kraftigt regn/blåsigt

PLUGIN_WEATHERTIME_PM_SNOW_SHOWER
	EN	PM Snow Shower
	FR	Averse de Neige PM
	DE	Nachm. Schneeschauer
	NL	midd. sneeuwbui
	SE	Snöfall under fm

PLUGIN_WEATHERTIME_PM_SNOW_SHOWERS
	EN	PM Snow Showers
	FR	Averses de Neige PM
	DE	Nachm. Schneeschauer
	NL	midd. sneeuwbuien
	SE	Snöfall under em

PLUGIN_WEATHERTIME_SNOW_SHOWERS_LATE
	EN	Snow Showers Late
	FR	Averses de Neige Tard
	DE	Abends Schneeschauer
	NL	avond sneeuwbui
	SE	Snöfall under kvällen

PLUGIN_WEATHERTIME_RAIN_SNOW_SHOWERS_LATE
	EN	Rain / Snow Showers Late
	FR	Pluie / Averses de Neige Tard
	DE	Regen / Abends Schneeschauer
	NL	Regen later sneeuwbuien
	SE	Regn, senare snöfall

PLUGIN_WEATHERTIME_SNOW_TO_RAIN_WIND
	EN	Snow to Rain/Wind
	FR	Neige à Pluie/Vent
	DE	Schnee in Regen Ã¼berg./Wind
	NL	sneeuw tot regen/winderig
	SE	Snö mot regn/blåsigt

PLUGIN_WEATHERTIME_PM_LIGHT_RAIN_ICE
	EN	PM Light Rain/Ice
	FR	Pluie/Glace Léger PM
	DE	Nachm. leichter Regen/Hagel
	NL	midd. lichte regen/hagel
	SE	Lätt regn/hagel under em

PLUGIN_WEATHERTIME_SNOW
	EN	Snow
	FR	Neige
	DE	Schnee
	NL	sneeuw
	SE	Snö

PLUGIN_WEATHERTIME_AM_SNOW
	EN	AM Snow
	FR	Neige AM
	DE	Vorm. Schnee
	NL	ocht. sneeuw
	SE	Snö under fm

PLUGIN_WEATHERTIME_SNOW_TO_ICE
	EN	Snow to Ice
	FR	Neige à Glace
	DE	Schnee in Hagel Ã¼berg.
	NL	sneeuw tot hagel
	SE	Snö mot hagel

PLUGIN_WEATHERTIME_WINTRY_MIX_WIND
	EN	Wintry Mix/Wind
	FR	Mélange Hivernal/Vent
	DE	Winter-Mix/Wind
	NL	winters/winderig
	SE	Nollgradigt/blåsigt

PLUGIN_WEATHERTIME_PM_LIGHT_SNOW
	EN	PM Light Snow
	FR	Neige Légère PM
	DE	Nachm. etwas Schnee
	NL	midd. enige sneeuw
	SE	Lätt snö under fm

PLUGIN_WEATHERTIME_AM_DRIZZLE
	EN	AM Drizzle
	FR	Bruine AM
	DE	Vorm. Nieselregen
	NL	ocht. motregen
	SE	Strilande regn under fm

PLUGIN_WEATHERTIME_STRONG_STORMS_WIND
	EN	Strong Storms/Wind
	FR	Fortes Tempêtes/Vent
	DE	starke StÃ¼rme/Wind
	NL	zware storm/winderig
	SE	Stark vind

PLUGIN_WEATHERTIME_PM_DRIZZLE
	EN	PM Drizzle
	FR	Bruine PM
	DE	Nachm. Nieselregen
	NL	middag motregen
	SE	Strilande regn under em

PLUGIN_WEATHERTIME_DRIZZLE
	EN	Drizzle
	FR	Bruine
	DE	Nieselregen
	NL	motregen
	SE	Strilande regn

PLUGIN_WEATHERTIME_AM_LIGHT_RAIN_WIND
	EN	AM Light Rain/Wind
	FR	Pluie/Vent Légers AM
	DE	Vorm. etwas Regen/Wind
	NL	ocht. lichte regen/winderig
	SE	Lätt regn/blåst under fm

PLUGIN_WEATHERTIME_AM_RAIN_WIND
	EN	AM Rain/Wind
	FR	Pluie/vent AM
	DE	Vorm. Regen/Wind
	NL	ocht. regen/winderig
	SE	Regn/blåst under fm

PLUGIN_WEATHERTIME_WINTRY_MIX_TO_SNOW
	EN	Wintry Mix to Snow
	FR	Mélange Hivernal à Neige
	DE	Winter-Mix in Schnee Ã¼berg.
	NL	winters tot sneeuw
	SE	Snö, kring nollgradigt

PLUGIN_WEATHERTIME_SNOW_SHOWERS_WINDY
	EN	Snow Showers/Windy
	FR	Averses de Neige/Venteux
	DE	Schneeschauer/Wind
	NL	sneeuwbuien/winderig
	SE	Snöbyar/blåsigt

PLUGIN_WEATHERTIME_LIGHT_RAIN_SHOWER
	EN	Light Rain Shower
	FR	Averse de Pluie Légère
	DE	leichte Regenschauer
	NL	lichte regenbui
	SE	Lätta regnskurar

PLUGIN_WEATHERTIME_LIGHT_RAIN_WITH_THUNDER
	EN	Light Rain with Thunder
	FR	Pluie Légère avec Tonerre
	DE	etwas Regen mit Donner
	NL	lichte regen met donder
	SE	Lätt regn- och åskväder

PLUGIN_WEATHERTIME_LIGHT_DRIZZLE
	EN	Light Drizzle
	FR	Bruine Légère
	DE	leichter Nieselregen
	NL	lichte motregen
	SE	Lätt strilregn

PLUGIN_WEATHERTIME_MIST
	EN	Mist
	FR	Brume
	DE	Nebel
	NL	mist
	SE	Dimma

PLUGIN_WEATHERTIME_SMOKE
	EN	Smoke
	FR	Fumée
	DE	Rauch
	NL	smoke
	SE	Rök

PLUGIN_WEATHERTIME_HAZE
	EN	Haze
	FR	Brume
	DE	Dunst
	NL	heiig
	SE	Soldis

PLUGIN_WEATHERTIME_LIGHT_SNOW_SHOWER
	EN	Light Snow Shower
	FR	Averse de Neige Légère
	DE	leichte Schneeschauer
	NL	lichte sneeuwbui
	SE	Lätta snöbyar

PLUGIN_WEATHERTIME_LIGHT_SNOW_SHOWER_WINDY
	EN	Light Snow Shower/ Windy
	FR	Averse de Neige Légère/ Venteux
	DE	leichte Schneeschauer/Wind
	NL	lichte sneeuwbui/winderig
	SE	Lätt snöfall/blåsigt

PLUGIN_WEATHERTIME_CLEAR
	EN	Clear
	FR	Dégagé
	DE	Klar
	NL	helder
	SE	Klart

PLUGIN_WEATHERTIME_MOSTLY_CLEAR
	EN	Mostly Clear
	FR	Plutôt Dégagé
	DE	Meist klar
	NL	meestal helder
	SE	Mestadels klart

PLUGIN_WEATHERTIME_A_FEW_CLOUDS
	EN	A Few Clouds
	FR	Quelques Nuages
	DE	wenige Wolken
	NL	enkele wolken
	SE	Enstaka moln

PLUGIN_WEATHERTIME_FAIR
	EN	Fair
	FR	Agréable
	DE	Freundlich
	NL	redelijk
	SE	Behagligt

PLUGIN_WEATHERTIME_PM_T-SHOWERS
	EN	PM T-Showers
	FR	Orages PM
	DE	Nachm. gewittrige Schauer
	NL	midd. onweersbui
	SE	Åskväder under fm

PLUGIN_WEATHERTIME_T-SHOWERS
	EN	T-Showers
	FR	Orages
	DE	gewittrige Schauer
	NL	onweersbui
	SE	Åskväder

PLUGIN_WEATHERTIME_T-SHOWERS_WIND
	EN	T-Showers / Wind
	FR	Orages / Vent
	DE	gewittrige Schauer/Wind
	NL	onweersbui/winderig
	SE	Åskväder/blåsigt

PLUGIN_WEATHERTIME_T-STORMS_EARLY
	EN	T-Storms early
	FR	Orages en matinée
	DE	anfangs Gewitter
	NL	vroeg onweer
	SE	Tidig åska

PLUGIN_WEATHERTIME_LIGHT_RAIN_EARLY
	EN	Light Rain Early
	FR	Pluie légère en matinée
	DE	anfangs leichter Regen
	NL	vroeg lichte buien
	SE	Tidigt lätt regn

PLUGIN_WEATHERTIME_SUNNY_WIND
	EN	Sunny/Wind
	FR	Ensoleillé/Venteux
	DE	sonnig/Wind
	NL	zonnig/winderig
	SE	Soligt/blåsigt
';}

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

#
# What the heck are these functions good for??? (copied from standard date/time
# screensaver)
#
sub handleIndex {
	my ($client, $params) = @_;
	my $body;

	$params->{'enable'} =
		(Slim::Utils::Prefs::clientGet($client,'screensaver') eq 'SCREENSAVER.weathertime') ? 0 : 1;

	return Slim::Web::HTTP::filltemplatefile(
			'plugins/WeatherTime/index.html',
			$params,
		);
}

sub handleEnable {
	my ($client, $params) = @_;
	my $body;

	if ($params->{'enable'}) {
		Slim::Utils::Prefs::clientSet(
			$client,
			'screensaver',
			'SCREENSAVER.weathertime');
	} else {
		Slim::Utils::Prefs::clientSet(
			$client,
			'screensaver',
			'screensaver');
	}
	return Slim::Web::HTTP::filltemplatefile(
			'plugins/WeatherTime/enable.html',
			$params,
		);
}

sub webPages_disabled {
	my %pages = (
		"index\.(?:htm|xml)" => \&handleIndex,
		"enable\.(?:htm|xml)" => \&handleEnable,
	);

	return (\%pages, "index.html");
}
#
# end of clueless mode
#

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
	if ($alarmOn)
	{
		$overlay2 = $client->symbols('bell');
	}
	else
	{
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
