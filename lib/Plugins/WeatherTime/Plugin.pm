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
#	- Set up the WeatherTime options in the server's plugin settings
#
#	----------------------------------------------------------------------
#	Restrictions & Know Bugs:
#
#	- Needs a Squeezebox2 or SoftSqueeze to show weather condition icons
#	  and detailed info, other devices will show text only information
#	- Not explictly tested on SqueezeboxG (only SLIMP3 and Squeezebox2)
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
#	2007/11/11 v2.0a  preliminary compatibility with 7.0a release of
#	                  SqueezeCenter
#	2007/02/07        Added options to choose windspeed/direction on 3. line
#	                  Added danish locale
#	2008/02/16        added additional icons contributed by Jeff Caulk
#	                  <jvcaulk@yahoo.com> and improved by David Morton
#	                  <davidanddebbie@the-mortons.com>
#	2008/05/03 v2.1   Changed data provider to Wunderground
#	2008/08/03 v2.1.1 Re-added precipitation information which is now
#	                  provided by Wunderground and merged translation
#	                  updates for FR and NL
#	2009/01/17 v2.2   Officially support Versions 7.2/7.3 of SqueezeCenter
#	           v2.2.1  + last minute fixes for Extension Installer
#	2009/06/28 v2.2.2 fix for display when precipitation data is missing
#
#	----------------------------------------------------------------------
#	To do:
#
#	- Add validations to preferences setup screen
#	- Add more translations
#	- Optional: Support SqueezeboxG's graphic features (lowres icons?)
#	- Support the second display of the Transporter
#	- support multiple locations for weather forecasts
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

use base qw(Slim::Plugin::Base);
use POSIX qw(strftime);

use Slim::Buttons::Common;
use Slim::Utils::Misc;
use Slim::Utils::Validate;
use Slim::Utils::DateTime;
use Slim::Display::Display;
use Slim::Utils::Prefs;
use Slim::Utils::Log;
use Weather::Wunderground;

use vars qw($VERSION);
$VERSION = substr( q$Revision: 2.2.1 $, 10 );

use Slim::Utils::Strings qw (string);
use Socket;

use Plugins::WeatherTime::Settings;

my $timeout = 30;

#### You can set these in the server settings -> plugins, example values follow
my $Metric        = 0;
my $City          = "Berlin, Germany";
my $City_Code     = "TXL";
my $Interval      = 3600;
my $TimeDateformat    = "std";
my $Dateformat    = "%b %d";
my $Linethree     = "0";
my $Linethreeunit = "0";

my ( %numdays, %dayinfos, %forecast, %forecastGX, %highTemp, %lowTemp,
	%currentTemperature, %currentBar, %currentVisibility, %currentUv, 
	%currentMoon, %currentWindDir, %currentWindSpeed, %currentWindGust );
my %scrollIndex      = ();
my %horizScrollIndex = ();
my %scrollDefault    = ();
my %scrollTimeout    = ();
my %Countdown        = ();
my %xmax             = ();
my %ymax             = ();
my %hashDisp;
my %weatherinfoLast = ();
my %timeinfoLast    = ();
my %linecache       = ();
my $gxwidth         = 125;
my $refreshTime     = 1.0;    # should usually be 1.0 seconds
                              # ... controls how often the scroll timeout and
                              #     the necessity of weather updates are checked

#
# Map ASCII characters to custom @Charset elements (Capital only)
# 'g' used for degree symbol
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
# Mapping of special local unicode symbols like ÆØÅ
#
my %UnicodeCodepage = ( 216 => 42, 198 => 43, 197 => 44 );

#
# Custom 7x5 mono charset for 3-line forecast display on Squeezebox2
#
my @Charset = ( '







',
#1
'
  *
 **
* *
  *
  *
  *
*****
',
#2
'
 ***
*   *
    *
   *
  *
 *
*****
',
#3
'
 ***
*   *
    *
  **
    *
*   *
 ***
',
#4
	'
   *
  **
 * *
*****
   *
   *
   *
',
#5
'
*****
*
*
****
    *
*   *
 ***
',
#6
'
 ***
*
*
****
*   *
*   *
 ***
',
#7
'
*****
    *
    *
   *
  *
 *
*
',
#8
'
 ***
*   *
*   *
 ***
*   *
*   *
 ***
',
#9
'
 ***
*   *
*   *
 ****
    *
    *
 ***
',
#10
'
 ***
*   *
*   *
*   *
*   *
*   *
 ***
',
#11
'



 ****



',
#12
'
 **
*  *
*  *
 **



',
#13
'





  **
  **
',
#14
'
**   
**  *
   *
  *
 *
*  **
   **
',
#15
'
 ***
*   *
*   *
*****
*   *
*   *
*   *
',
#16
'
****
*   *
*   *
****
*   *
*   *
****
',
#17
'
 ***
*   *
*
*
*
*   *
 ***
',
#18
'
****
*   *
*   *
*   *
*   *
*   *
****
',
#19
'
*****
*
*
****
*
*
*****
',
#20
'
*****
*
*
****
*
*
*
',
#21
'
 ***
*   *
*
* ***
*   *
*   *
 ***
',
#22
'
*   *
*   *
*   *
*****
*   *
*   *
*   *
',
#23
'
 ***
  *
  *
  *
  *
  *
 ***
',
#24
'
    *
    *
    *
    *
    *
*   *
 ***
',
#25
'
*   *
*  *
* *
**
* *
*  *
*   *
',
#26
'
*
*
*
*
*
*
*****
',
#27
'
*   *
** **
* * *
*   *
*   *
*   *
*   *
',
#28
'
*   *
*   *
**  *
* * *
*  **
*   *
*   *
',
#29
'
 ***
*   *
*   *
*   *
*   *
*   *
 ***
',
#30
'
****
*   *
*   *
****
*
*
*
',
#31
'
 ***
*   *
*   *
*   *
*   *
* * *
*  **
 ** *
',
#32
'
****
*   *
*   *
****
* *
*  *
*   *
',
#33
'
 ****
*
*
 ***
    *
    *
****
',
#34
'
*****
  *
  *
  *
  *
  *
  *
',
#35
'
*   *
*   *
*   *
*   *
*   *
*   *
 *** 
',
#36
'
*   *
*   *
*   *
*   *
*   *
 * *
  *
',
#37
'
*   *
*   *
*   *
*   *
* * *
** **
*   *
',
#38
'
*   *
*   * 
 * * 
  *  
 * * 
*   * 
*   *
',
#39
'
*   *
*   *
 * *
  *
  *
  *
  *
',
#40
'
*****
    *
   *
  *
 *
*
*****
',
#41
'

    *
   *
  *
 *
*

',
#42 Ø
'
    *
 ***
*  **
* * *
**  *
 ***
*
',
#43 Æ
'
 ****
*  *
*  *
*****
*  *
*  *
*  **
',
#44 Å
'
  *

 ***
*   *
*****
*   *
*   *
' );

#
# map standard weather.com icons to custom icons
# -> we use only 31 different icons but weather.com has 49
#
my %Iconmap = ( '1'  => 2, '2'  => 1, '3'  => 2, '4'  => 2, '5'  => 31, 
                '6'  => 1, '7'  => 30, '8'  => 20,'9'  => 20,'10' => 3, 
                '11' => 20,'12' => 1, '13' => 16,'14' => 3, '15' => 17, 
                '16' => 18,'17' => 2, '18' => 21,'19' => 23,'20' => 9, 
                '21' => 24,'22' => 28,'23' => 22,'24' => 22,'25' => 25, 
                '26' => 0, '27' => 12,'28' => 6, '29' => 11,'30' => 5, 
                '31' => 10,'32' => 4, '33' => 27,'34' => 5, '35' => 2, 
                '36' => 26,'37' => 8, '38' => 8, '39' => 7, '40' => 1, 
                '41' => 19,'42' => 18,'43' => 18,'44' => 29,'45' => 13, 
                '46' => 15,'47' => 14,'48' => 7, '0'  => 2, 'na' => 29,
                'NA' => 29,'N/A'=> 29 );

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
#234567890123456789012345678901234567890 - icon 10
'

        
         
          
          
           
             *******     
           *         *      
         *             *   
        *               *
       *                 *    
       *                 *
      *                   *
      *                   *
     *                     *
     *                     *
     *                     *
     *                     *
     *                     *
      *                   * 
      *                   *
       *                 *
       *                 *
        *               *
         *             *   
           *         *    
             *******   
         
         
        
       
                   
',
#234567890123456789012345678901234567890 - icon 11
'

        
         
          
          
           
             *******     
           *         *      
         *             *   
        *               *
       *                 *    
       *             * ***
      *            *  **  **
      *          **         **
     *          **           * **
     *        **              *  *
     *       **                  **
     *       *                    **
     *       **                    *
      *       **                   *
      *         *******************
       *                 *
       *                 *
        *               *
         *             *   
           *         *    
             *******   
         
         
        
       
                   
',
#234567890123456789012345678901234567890 - icon 12
'
                    
                       *******
                     *         *
                   *             * 
                  *               *  
              ****                 *    
           ****  ****              *       
        ****        **              *     
       **            **             *  
      **              **             *
     **                ** ***        *
     *                  *** **       *
  ****                   *   **      *
 **                           **     *
**                            ***   *
*                              ***  *  
*                                ***
*                                 **
**                               **
 ***                            **
   ******************************
',
#234567890123456789012345678901234567890 - icon 13
'
                    
                       *******
                     *         *
                   *             * 
                  *               *  
              ****                 *    
           ****  ****              *       
        ****        **              *     
       **            **             *  
      **              **             *
     **                ** ***        *
     *                  *** **       *
  ****                   *   **      *
 **                           **     *
**                            ***   *
*                              ***  *  
*                                ***
*                                 **
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
#234567890123456789012345678901234567890 - icon 14
'
                    
                       *******
                     *         *
                   *             * 
                  *               *  
              ****                 *    
           ****  ****              *       
        ****        **              *     
       **            **             *  
      **              **             *
     **     **         ** ***        *
     *      **          *** **       *
  ****     **            *   **      *
 **        **                 **     *
**        **                  ***   *
*         **                   ***  *  
*        ** **                   ***
*        ******                   **
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
#234567890123456789012345678901234567890 - icon 15
'
                    
                       *******
                     *         *
                   *             * 
                  *               *  
              ****                 *    
           ****  ****              *       
        ****        **              *     
       **            **             *  
      **              **             *
     **                ** ***        *
     *                  *** **       *
  ****                   *   **      *
 **                           **     *
**                            ***   *
*                              ***  *  
*                                ***
*                                 **
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
#234567890123456789012345678901234567890 - icon 16
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
                         *  *  *
                          * * *
                         * *** *
                          * * *
                         *  *  *
                           * *
      
              
                
',
#234567890123456789012345678901234567890 - icon 17
'












                    * *
                  *  *  *
                   * * *
                  * *** *
                   * * *
                  *  *  * 
                    * *    * *
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
#234567890123456789012345678901234567890 - icon 18
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
        * *** *     * * *
         * * *     *  *  * * *
      * *  *  *      * * *  *  *
    *  *  * *             * * *
     * * *      * *      * *** *
    * *** *   *  *  *     * * *
     * * *     * * *     *  *  *
    *  *  *   * *** *      * *
      * *      * * *
              *  *  *
                * *
',
#234567890123456789012345678901234567890 - icon 19
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
#234567890123456789012345678901234567890 - icon 20
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


     *     *     *     *     *         
                             
     *     *     *     *     * 
                           
   *     *     *     *     *  
                           
   *     *     *     *     *  
                           
  
',
#234567890123456789012345678901234567890 - icon 21
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


     *     *     *     *     *         
        *     *     *     *      
     *     *     *     *     * 
        *     *     *     *    
     *     *     *     *     *  
        *     *     *     *   
     *     *     *     *     *  
        *     *     *     *   
    
',
#234567890123456789012345678901234567890 - icon 22: wind by yannzola
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
#234567890123456789012345678901234567890 - icon 23
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
#234567890123456789012345678901234567890 - icon 24: haze by yannzola
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
#234567890123456789012345678901234567890 - icon 25: frigid by yannzola
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
#234567890123456789012345678901234567890 - icon 26: hot by yannzola
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
',
#234567890123456789012345678901234567890 - icon 27 
'

        
         
          
          
           
             *******     
           *         *      
         *             *   
        *               *
       *                 *    
       *                 *
      *                   *
  **  *  ***  * **  * **  * ** *
     *                     *
     *                     *
 * * * **  * ** **  ***  * * * **
     *                     *
     *                     *
   *  *  * ***  * *  * ** * * * 
      *                   *
       *                 *
       *                 *
        *               *
         *             *   
           *         *    
             *******   
         
         
        
       
                   
',
#234567890123456789012345678901234567890 - icon 27
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
#234567890123456789012345678901234567890 - icon 29
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
#234567890123456789012345678901234567890 - icon 30
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

     *               *   *  
     *                 *
    *    *           *   *
    *   *    * *       *      *
   *    *  *  *  *   *   *    *   *
   *   *    * * *      *     *   * 
  *    *   * *** *   *   *   *   *
  *         * * *           *   * 
           *  *  *          *   *
             * *           *
',
#234567890123456789012345678901234567890 - icon 31
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

                            
    *                 *    
    *  *              *  *
   *   *    * *      *   *   * *
   *  *   *  *  *    *  *  *  *  *
  *   *    * * *    *   *   * * *
  *  *    * *** *   *  *   * *** *
 *         * * *   *        * * *
          *  *  *          *  *  *
            * *              * *
');

my $WuLogo = '
****  *****  ****                              ****                            ***** ****                   ****                                                                              ****   ***
****  *****  ****                       ****   ****                            ***** ****                   ****                                                                              ****  *   *
****  *****  ****                       ****   ****                            ***** ****                   ****                                                                              ****  * * *
****  *****  ****   *****      ******  ******  **** ****    *****    **** **   ***** ****  **** ****   **** ****    *****    **** *  **** **** **** **   *****    **** ****  **** ****   *********  * * *
****  *****  ****  *******   ********* ******  *********   *******   *******   ***** ****  *********   *********   *******   ******  ********* *******  *******   **** ****  ********** **********  *   *
***** ***** ***** **** ****  **** **** ******  **** ****  *********  *******   ***** ****  ********** **********  *********  ****** ********** ******* *********  **** ****  ********** **********   ***
***** ***** ***** **** ****  **** ****  ****   **** ****  **** ****  *******   ***** ****  **** ***** ***** ****  **** ****  ****** ***** **** ******* **** ****  **** ****  ****  **** ****  ****
***** ***** ***** **** ****  **** ****  ****   **** ****  **** ****  *******   ***** ****  **** ***** ***** ****  **** ****  ****** ***** **** ******* **** ****  **** ****  ****  **** ****  ****
***************** *********      *****  ****   **** ****  *********  *****     ***** ****  **** ***** ***** ****  *********  *****  ***** **** *****   **** ****  **** ****  ****  **** ****  ****
 ***************  *********    *******  ****   **** ****  *********  ****      ***** ****  **** ***** ***** ****  *********  ****   ***** **** ****    **** ****  **** ****  ****  **** ****  ****
 ***************  ****       *********  ****   **** ****  ****       ****      ***** ****  **** ***** ***** ****  ****       ****   ***** **** ****    **** ****  **** ****  ****  **** ****  ****
  ****** ******   ****  ***  **** ****  ****   **** ****  ****  ***  ****      ***** ****  **** ***** ***** ****  ****  ***  ****   ***** **** ****    **** ****  **** ****  ****  **** ****  ****
  ****** ******   ****  ***  **** ****  ****   **** ****  ****  ***  ****      ***** ****  **** ***** ***** ****  ****  ***  ****   ********** ****    **** ****  **** ****  ****  **** ****  ****
  *****   *****   **** ****  **** ****  ****   **** ****  **** ****  ****      ***** ****  **** ***** ***** ****  **** ****  ****    ********* ****    **** ****  **** ****  ****  **** ****  ****
  *****   *****   *********  *********  *****  **** ****  *********  ****       *********  **** ***** **********  *********  ****    ********* ****    *********  *********  ****  **** **********
  *****   *****    *******   *********  *****  **** ****   *******   ****       ********   **** *****  *********   *******   ****         **** ****     *******   *********  ****  **** **********
  *****   *****     *****     *** ****   ****  **** ****    *****    ****        ******    **** *****   *** ****    *****    ****   ********** ****      *****     *** ****  ****  ****  **** ****
                                                                                                                                     ********
                                                                                                                                      ******
                          *                                             *
                          *                                             *
                          *                                             *
                          *                                             *
*   *   * *   * * **   ****   ***  * *  ****  * *  ***  *   * * **   ****      ***   ***   *** **
*   *   * *   * ** ** **  *  *   * **  **  *  **  *   * *   * ** ** **  *     *   * *   *  *  *  *
 * *** *  *   * *   * *   *  ***** *   *   *  *   *   * *   * *   * *   *     *     *   *  *  *  *
 *** ***  *   * *   * *   *  *     *   *   *  *   *   * *   * *   * *   *     *     *   *  *  *  *
  *   *   *   * *   * *   *  *   * *   *   *  *   *   * *   * *   * *   *     *   * *   *  *  *  *
  *   *    ***  *   *  ****   ***  *    ****  *    ***   ***  *   *  ****  *   ***   ***   *  *  *
                                           *
                                       *   *
                                        ***
';

sub getDisplayName {
	return 'PLUGIN_SCREENSAVER_WEATHERTIME';
}

sub strings { return ''; }




my $log = Slim::Utils::Log->addLogCategory(
	{
		'category'     => 'plugin.weathertime',
		'defaultLevel' => 'WARN',
		'description'  => 'SETUP_GROUP_PLUGIN_WEATHERTIME'
	}
);

my $prefs = preferences('plugin.weathertime');

##################################################
### Section 2. Your variables and code go here ###
##################################################

sub initPlugin {
	my $class = shift;

	Slim::Buttons::Common::addSaver(
		'SCREENSAVER.weathertime',       getScreensaverWeathertime(),
		\&setScreensaverWeatherTimeMode, \&leaveScreensaverWheathertimeMode,
		'PLUGIN_SCREENSAVER_WEATHERTIME',
	);

	Plugins::WeatherTime::Settings->new;

	$class->SUPER::initPlugin();
}

sub setMode {
	my $class  = shift;
	my $client = shift;
	$client->lines( \&lines );

	# setting this param will call client->update() frequently
	$client->modeParam( 'modeUpdateInterval', 1 );    # seconds
}

our %functions = (
	'up' => sub {
		my $client = shift;
		my $button = shift;
		$client->bumpUp() if ( $button !~ /repeat/ );
	},
	'down' => sub {
		my $client = shift;
		my $button = shift;
		$client->bumpDown() if ( $button !~ /repeat/ );
	},
	'left' => sub {
		my ( $client, $funct, $functarg ) = @_;

		Slim::Buttons::Common::popModeRight($client);
		$client->update();

		# pass along ir code to new mode if requested
		if ( defined $functarg && $functarg eq 'passback' ) {
			Slim::Hardware::IR::resendButton($client);
		}
	},
	'right' => sub {
		my $client = shift;
		$client->bumpRight();
	},
	'play' => sub {
		my $client = shift;
		Slim::Buttons::Common::pushMode( $client, 'SCREENSAVER.weathertime' );
	},
	'stop' => sub {
		my $client = shift;
		Slim::Buttons::Common::pushMode( $client, 'SCREENSAVER.weathertime' );
	}
);

sub lines {
	my $client = shift;
	my ( $line1, $line2 );
	$line1 = $client->string('PLUGIN_SCREENSAVER_WEATHERTIME');
	$line2 = $client->string('PLUGIN_SCREENSAVER_WEATHERTIME_START');

	return { 'line' => [ $line1, $line2 ] };
}

sub getFunctions {
	return \%functions;
}

###################################################################
### Section 3. Screensaver mode                                 ###
###################################################################

our %screensaverWeatherTimeFunctions = (
	'done' => sub {
		my ( $client, $funct, $functarg ) = @_;

		Slim::Buttons::Common::popMode($client);
		$client->update();

		# pass along ir code to new mode if requested
		if ( defined $functarg && $functarg eq 'passback' ) {
			Slim::Hardware::IR::resendButton($client);
		}
	},
	'up' => sub {
		my $client = shift;
		my $button = shift;

		# repeat works too fast -> disabling
		if ( $button !~ /repeat/ ) {
			$scrollIndex{$client}--;
			$scrollTimeout{$client} = 15 / $refreshTime;
			if ( $scrollIndex{$client} < 0 ) {
				$scrollIndex{$client} = 0;
				$client->bumpUp();
			}
			else {
				$client->update();
			}
		}
	},
	'down' => sub {
		my $client = shift;
		my $button = shift;

		# repeat works too fast -> disabling
		if ( $button !~ /repeat/ ) {
			$scrollIndex{$client}++;
			$scrollTimeout{$client} = 15 / $refreshTime;
			if ( $scrollIndex{$client} >= $numdays{$client} ) {
				$scrollIndex{$client} = $numdays{$client} - 1;
				$client->bumpUp();
			}
			else {
				$client->update();
			}
		}
	},
	'left' => sub {
		my $client = shift;
		my $button = shift;

		# repeat works too fast -> disabling
		if ( $button !~ /repeat/ ) {
			$horizScrollIndex{$client}--;
			$scrollTimeout{$client} = 15 / $refreshTime;
			if ( $horizScrollIndex{$client} < 0 ) {
				$horizScrollIndex{$client} = 0;
				$client->bumpLeft();
			}
			else {
				$client->update();
			}
		}
	},
	'right' => sub {
		my $client = shift;
		my $button = shift;

		# repeat works too fast -> disabling
		if ( $button !~ /repeat/ ) {
			$horizScrollIndex{$client}++;
			$scrollTimeout{$client} = 15 / $refreshTime;
			$client->update();
		}
	}
);

sub getScreensaverWeathertime {
	return \%screensaverWeatherTimeFunctions;
}

our %mapping = (
	'arrow_down'  => 'down',
	'arrow_up'    => 'up',
	'arrow_left'  => 'left',
	'arrow_right' => 'right',
);

sub setScreensaverWeatherTimeMode() {
	my $client = shift;

	$::d_plugins
	  && Slim::Utils::Misc::msg(
		"WeatherTime: entering screensaver mode ($client)\n");

	$client->lines( \&screensaverWeatherTimelines );
	Slim::Hardware::IR::addModeDefaultMapping( 'SCREENSAVER.weathertime',
		\%mapping );
	Slim::Hardware::IR::addModeDefaultMapping( 'OFF.weathertime', \%mapping );

	# get display size for player if at least Squeezebox2
	if ( $client && $client->isa("Slim::Player::Squeezebox2") ) {
		$xmax{$client} = $client->display()->displayWidth();
		$ymax{$client} = $client->display()->bytesPerColumn() * 8;
		$::d_plugins
		  && Slim::Utils::Misc::msg(
"WeatherTime: Squeezebox2 found graphic display $xmax{$client} x $ymax{$client} ($client)\n"
		  );
	}

	# only use text on SqueezeboxG and SLIMP3
	else {
		$xmax{$client} = 0;
		$ymax{$client} = 0;
	}

	$scrollDefault{$client}    = 0;
	$scrollIndex{$client}      = $scrollDefault{$client};
	$horizScrollIndex{$client} = 0;
	$scrollTimeout{$client}    = 15 / $refreshTime;
	clearCanvas($client);
	drawIcon( $client, 0, $ymax{$client} - 1, $WuLogo );
	$forecastGX{$client}[ $scrollIndex{$client} ] =
	  getFramebuf( $client, 205 );
	$forecast{$client}                          = ();
	$highTemp{$client}[ $scrollIndex{$client} ] = "";
	$lowTemp{$client}[ $scrollIndex{$client} ]  = "";
	$currentTemperature{$client}                = "";
	$numdays{$client}                           = 0;
	$dayinfos{$client}[ $scrollIndex{$client} ] = undef;

	# wait 4 seconds before getting weather data to make sure the lines-
	# function has completed before and the display is updated -> Start-Logo
	$Countdown{$client} = 4 / $refreshTime;

	$client->modeParam( 'modeUpdateInterval', 1 );    #seconds

	Slim::Utils::Timers::setTimer( $client, Time::HiRes::time() + $refreshTime,
		\&tictac );
}

sub leaveScreensaverWheathertimeMode {
	my $client = shift;

	$::d_plugins
	  && Slim::Utils::Misc::msg(
		"WeatherTime: leaving screensaver mode ($client)\n");
	Slim::Utils::Timers::killTimers( $client, \&tictac );
}

sub tictac {
	my $client = shift;

	# check if weather forecast should be updated
	$Countdown{$client}--;
	if ( $Countdown{$client} < 1 ) {
		$Countdown{$client} = Interval() / $refreshTime;
		&retrieveWeather($client);
	}

	# check if scroll timeout is reached
	$scrollTimeout{$client}--;
	if ( $scrollTimeout{$client} < 1 ) {
		$scrollTimeout{$client}    = 15 / $refreshTime;
		$scrollIndex{$client}      = $scrollDefault{$client};
		$horizScrollIndex{$client} = 0;
	}

	Slim::Utils::Timers::setTimer( $client, Time::HiRes::time() + $refreshTime,
		\&tictac );
}

sub screensaverWeatherTimelines {
	my $client = shift;
	my ( $line1, $line2, $overlay1, $overlay2, $bits );
	my $weatherinfo;
	my $timeinfo;

	# check for correct setup first!
	if (  !City_Code()
		|| City_Code() eq "" )
	{
		$line1 = string('PLUGIN_SCREENSAVER_NOSETUP_LINE1');
		$line2 = string('PLUGIN_SCREENSAVER_NOSETUP_LINE2');

		return { 'line' => [ $line1, $line2 ] };
	}

	# see if forecast data is available (yet)
	if ( defined $forecast{$client}[ $scrollIndex{$client} ] ) {
		$weatherinfo = line1Info($client);
		# assemble date and time info
		#$timeinfo = Slim::Utils::DateTime::timeF() . Dateformatted();
		$timeinfo = Timeformatted() . Dateformatted();
	}
	else {
		$weatherinfo = string('PLUGIN_SCREENSAVER_WEATHERTIME_NOINFO');
		$timeinfo = "";
	}

	# check if we can use graphics on the client
	if ( $xmax{$client} && $ymax{$client} ) {
		$bits = $forecastGX{$client}[ $scrollIndex{$client} ];
		$bits .=
		  Slim::Display::Lib::Fonts::string( "standard.1", $weatherinfo ) |
		  Slim::Display::Lib::Fonts::string( "standard.2", $timeinfo );
	}
	else {

		# text only for SqueezeboxG and SLIMP3
		if ( $scrollIndex{$client} == 0 ) {
			$line1 = sprintf( '%-8.5s', $currentTemperature{$client} );
			if ( $highTemp{$client}[ $scrollIndex{$client} ] ne "" ) {
				$line2 = sprintf( '%-8.5s',
					$highTemp{$client}[ $scrollIndex{$client} ] );
			}
			else {
				$line2 = sprintf( '%-8.5s',
					$lowTemp{$client}[ $scrollIndex{$client} ] );
			}
		}
		else {
			$line1 =
			  sprintf( '%-8.5s', $lowTemp{$client}[ $scrollIndex{$client} ] );
			$line2 =
			  sprintf( '%-8.5s', $highTemp{$client}[ $scrollIndex{$client} ] );
		}
		$line1 .= $weatherinfo;
		$line2 .= $timeinfo;
	}

	my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
	  localtime(time);
	  
	my $alarmOn = preferences('server')->client($client)->get("alarmsEnabled")
		&& %{ preferences('server')->client($client)->get("alarms") };	  

	my $nextUpdate = $client->periodicUpdateTime();
	Slim::Buttons::Common::syncPeriodicUpdates( $client, int($nextUpdate) )
	  if ( ( $nextUpdate - int($nextUpdate) ) > 0.01 );

	$overlay1 = undef;
	if ($alarmOn) {
		$overlay2 = $client->symbols('bell');
	}
	else {
		$overlay2 = undef;
	}

	return {
		'line'    => [ $line1,    $line2 ],
		'overlay' => [ $overlay1, $overlay2 ],
		'bits'    => $bits
	};
}

sub line1Info {
	my $client = shift;

	if ( $horizScrollIndex{$client} == 0 ) {
		# FIXME some texts for conditions are too long
		# to fit the line (scrolling for only part of line1 possible???)
		return $forecast{$client}[ $scrollIndex{$client} ];
	}
	else {
		my $val = $dayinfos{$client}[ $scrollIndex{$client} ][$horizScrollIndex{$client}-1];
#        $log->error("Getting line 1 info for $val");
        if (valid($val) && $val ne "") {
   		   return $val;
        }
        else {
        	$horizScrollIndex{$client} = 0;
     		return $forecast{$client}[ $scrollIndex{$client} ];
        } 
	}

}

sub retrieveWeather {
	my $client            = shift;
	my $weatherConditions = "";
	my $gxline1           = "";
	my $gxline2;
	my $gxline3;

	$::d_plugins && Slim::Utils::Misc::msg("WeatherTime: retrieving weather\n");

	#
	# get weatherdata using Weather::Wunderground from wunderground.com
	#
	my $loc = City_Code();
	chomp $loc;
	my $proxy =
	  preferences('server')->get('webproxy')
	  ? 'http://' . preferences('server')->get('webproxy')
	  : undef;
	my %comargs = (
		'debug'      => 0,
		'proxy'      => $proxy,
		'units'      => metric() ? 'm' : 's',
		'timeout'    => $timeout
	);
	my $wc = Weather::Wunderground->new(%comargs);
	my $weather;

	eval { $weather = $wc->get_weather($loc); };

	# make "die" errors in Weather::Wunderground non fatal
	if ($@) {
		warn $@;

		# set display to show NO_FORECAST_AVAILABLE message
		$numdays{$client}  = 1;
		$dayinfos{$client} = undef;
	    clearCanvas($client);
		# icon no 29 is the N/A icon
		drawIcon($client,0,$ymax{$client}-1,$Icons[29]);
		$forecastGX{$client}[0] = getFramebuf( $client, $gxwidth );
		$currentTemperature{$client} = "";
		$highTemp{$client}[0]        = "";
		$lowTemp{$client}[0]         = "";
		$forecast{$client}[0]        =
		  string('PLUGIN_WEATHERTIME_NO_FORECAST_AVAILABLE');
		$scrollDefault{$client} = 0;
		$scrollIndex{$client}   = $scrollDefault{$client};
		$horizScrollIndex{$client}   = 0;
		return;
	}

	if ($::d_plugins) {
		Slim::Utils::Misc::msg("WeatherTime: current data\n");
		use Data::Dumper;
		print Dumper( $weather->{cc} );

		Slim::Utils::Misc::msg("WeatherTime: units returned\n");
		use Data::Dumper;
		print Dumper( $weather->{head} );
	}

	#
	# create display info
	#

	$forecast{$client} = ();

	# get _current_ temperature
	if ( valid( $weather->{cc}->{tmp} ) ) {
		$currentTemperature{$client} =
		  '=' . $weather->{cc}->{tmp} . $weather->{head}->{ut};
		$gxline1 = sprintf( '%-6.5s% 2dg%s',
			uc( string('PLUGIN_WEATHERTIME_CURRENTTEMP') ),
			$weather->{cc}->{tmp},
			$weather->{head}->{ut} );
	}
	else {
		$currentTemperature{$client} = "";
	}
	

   	if ( valid( $weather->{cc}->{wind}->{s} ) ) {
   		$currentWindSpeed{$client} = $weather->{cc}->{wind}->{s}; 
	} else {
		$currentWindSpeed{$client} = "";
	}		

   	if ( valid( $weather->{cc}->{wind}->{t} ) ) {
   		$currentWindDir{$client} = $weather->{cc}->{wind}->{t};
	} else {
		$currentWindDir{$client} = "";
	}		

   	if ( valid( $weather->{cc}->{wind}->{gust} ) ) {
   		$currentWindGust{$client} = $weather->{cc}->{wind}->{gust};
	} else {
		$currentWindGust{$client} = "";
	}		

	if ( valid( $weather->{cc}->{bar}->{r} ) ) {
		my $vv = getStringString('PLUGIN_WEATHERTIME_CURRENTBAR_',$weather->{cc}->{bar}->{d}); 
        $currentBar{$client} = uc( string('PLUGIN_WEATHERTIME_CURRENTBAR') ).' '.
           $weather->{cc}->{bar}->{r}.' '.$weather->{head}->{up}.' '.$vv;
	}
	else {
		$currentBar{$client} = "";
	}	
	
	if ( valid( $weather->{cc}->{vis} ) ) {
        $currentVisibility{$client} = uc( string('PLUGIN_WEATHERTIME_VISIBILITY') ).' '.
           $weather->{cc}->{vis}.' '.$weather->{head}->{ud};
	}
	else {
		$currentVisibility{$client} = "";
	}	

	if ( valid( $weather->{cc}->{uv}->{i}) && $weather->{cc}->{uv}->{i} ne 0) {
		my $vv = getStringString('PLUGIN_WEATHERTIME_UVINDEX_',$weather->{head}->{uv}->{t});
        $currentUv{$client} = uc( string('PLUGIN_WEATHERTIME_UVINDEX') ).' '.
           $weather->{cc}->{uv}->{i}.' '.$vv;
	}
	else {
		$currentUv{$client} = "";
	}	

	if ( valid( $weather->{cc}->{moon}->{t} ) ) {
        my $vv = getStringString('PLUGIN_WEATHERTIME_MOON_',$weather->{cc}->{moon}->{t});
        $currentMoon{$client} = uc( string('PLUGIN_WEATHERTIME_MOON') ).' '.$vv;
	}
	else {
		$currentMoon{$client} = "";
	}	
	
	my $day = 0;
	foreach ( @{ $weather->{'dayf'}->{'day'} } ) {
		clearCanvas($client);

		# format high and/or low temperature strings
		if ( valid( $_->{'hi'} ) && valid( $_->{'low'} ) ) {
			$gxline2 = sprintf( '% 2d - % 2dg%s',
				$_->{'low'}, $_->{'hi'}, $weather->{head}->{ut} );
			$highTemp{$client}[$day] =
			  '<' . $_->{'hi'} . $weather->{head}->{ut};
			$lowTemp{$client}[$day] =
			  '>' . $_->{'low'} . $weather->{head}->{ut};
		}
		elsif ( valid( $_->{'hi'} ) ) {
			$gxline2 = sprintf( '%-6.5s% 2dg%s',
				uc( string('PLUGIN_WEATHERTIME_HIGH') ),
				$_->{'hi'}, $weather->{head}->{ut} );
			$highTemp{$client}[$day] =
			  '<' . $_->{'hi'} . $weather->{head}->{ut};
			$lowTemp{$client}[$day] = "";
		}
		elsif ( valid( $_->{'low'} ) ) {
			$gxline2 = sprintf( '%-6.5s% 2dg%s',
				uc( string('PLUGIN_WEATHERTIME_LOW') ),
				$_->{'low'}, $weather->{head}->{ut} );
			$lowTemp{$client}[$day] =
			  '>' . $_->{'low'} . $weather->{head}->{ut};
			$highTemp{$client}[$day] = "";
		}
		else {
			$gxline2                 = "";
			$highTemp{$client}[$day] = "";
			$lowTemp{$client}[$day]  = "";
		}

		# format conditions forecast
		$::d_plugins
		  && Slim::Utils::Misc::msg(
"$day: part0/day $_->{part}->[0]->{t}, part1/night $_->{part}->[1]->{t}\n"
		  );
		if ( valid( $_->{part}->[0]->{t} ) ) {

			# use data for first half of the day if available
			# use upper case and transliterate for string lookup
			$weatherConditions = uc $_->{part}->[0]->{t};
			$weatherConditions =~ tr/ \//__/;
			$weatherConditions =~ s/_+/_/g;
			$weatherConditions = 'PLUGIN_WEATHERTIME_' . $weatherConditions;
			Slim::Utils::Strings::stringExists($weatherConditions)
			  || Slim::Utils::Misc::msg(
"Plugin WeatherTime: need to add condition <$_->{part}->[0]->{t}> to translation STRINGS\n"
			  );
			$weatherConditions =
			    Slim::Utils::Strings::stringExists($weatherConditions)
			  ? string($weatherConditions)
			  : $_->{part}->[0]->{t};

			# get and draw icon
			if ( valid( $_->{part}->[0]->{icon} ) ) {
				drawIcon(
					$client, 0,
					$ymax{$client} - 1,
					$Icons[ $Iconmap{ $_->{part}->[0]->{icon} } ]
				);
			}
			else {

				# icon no 29 is the N/A icon
				drawIcon( $client, 0, $ymax{$client} - 1, $Icons[29] );
			}
		}
		elsif ( valid( $_->{part}->[1]->{t} ) ) {

			# otherwise use data for second half of the day
			# use upper case and transliterate for string lookup
			$weatherConditions = uc $_->{part}->[1]->{t};
			$weatherConditions =~ tr/ \//__/;
			$weatherConditions =~ s/_+/_/g;
			$weatherConditions = 'PLUGIN_WEATHERTIME_' . $weatherConditions;
			Slim::Utils::Strings::stringExists($weatherConditions)
			  || Slim::Utils::Misc::msg(
"Plugin WeatherTime: need to add condition |$_->{part}->[1]->{t}| to translation STRINGS\n"
			  );
			$weatherConditions =
			    Slim::Utils::Strings::stringExists($weatherConditions)
			  ? string($weatherConditions)
			  : $_->{part}->[1]->{t};

			# get and draw icon
			if ( valid( $_->{part}->[1]->{icon} ) ) {
				drawIcon(
					$client, 0,
					$ymax{$client} - 1,
					$Icons[ $Iconmap{ $_->{part}->[1]->{icon} } ]
				);
			}
			else {

				# icon no 29 is the N/A icon
				drawIcon( $client, 0, $ymax{$client} - 1, $Icons[29] );
			}
		}
		else {
			$weatherConditions =
			  string('PLUGIN_WEATHERTIME_NO_FORECAST_AVAILABLE');
			drawIcon( $client, 0, $ymax{$client} - 1, $Icons[29] );
		}
		if ( $day == 0 ) {

			# today's forcast
			if ( valid( $_->{part}->[0]->{t} ) ) {
				$forecast{$client}[$day] =
				  string('PLUGIN_WEATHERTIME_TODAY') . ' ' . $weatherConditions;

				# show todays forecast per default
				# scroll to  tomorrow's forecast per default
				# after 7pm
				my ( $d1, $d2, $hour, $d3, $d4, $d5, $d6, $d7 ) =
				  localtime( time() );
				$scrollDefault{$client} =
				  ( ( $hour >= 19 && $hour <= 23 ) ? 1 : 0 );
				$scrollIndex{$client} = $scrollDefault{$client};
				$horizScrollIndex{$client}   = 0;
			}

			# tonight's forcast
			else {
				$forecast{$client}[$day] =
				  string('PLUGIN_WEATHERTIME_TONIGHT') . ' '
				  . $weatherConditions;

				# scroll to  tomorrow's forecast per default
				# instead of tonight's forecast
				my ( $d1, $d2, $hour, $d3, $d4, $d5, $d6, $d7 ) =
				  localtime( time() );
				$scrollDefault{$client} =
				  ( ( $hour >= 19 && $hour <= 23 ) ? 1 : 0 );
				$scrollIndex{$client} = $scrollDefault{$client};
				$horizScrollIndex{$client}   = 0;
			}
		}
		elsif ( $day == 1 ) {

			# tomorrows forecast
			$forecast{$client}[$day] =
			  string('PLUGIN_WEATHERTIME_TOMORROW') . ' ' . $weatherConditions;

			# keep NOW temp on display
			# $gxline1 = "";
		}
		else {

			# forecast for after tomorrow
			$forecast{$client}[$day] =
			  string( 'PLUGIN_WEATHERTIME_' . $_->{'t'} ) . ' '
			  . $weatherConditions;

			# NOW temp makes not much sense here, does it?
			$gxline1 = "";
		}
		if ($::d_plugins) {
			Slim::Utils::Misc::msg("$day: $forecast{$client}[$day]\n");
		}

		if ( Linethree() == "0" ) {

			# get precipitation chance
			if ( valid( $_->{part}->[0]->{ppcp} ) ) {
				$gxline3 = sprintf( '%-7.6s%d%%',
					uc( string('PLUGIN_WEATHERTIME_PRECIP') ),
					$_->{part}->[0]->{ppcp} );
			}
			elsif ( valid( $_->{part}->[1]->{ppcp} ) ) {
				$gxline3 = sprintf( '%-7.6s%d%%',
					uc( string('PLUGIN_WEATHERTIME_PRECIP') ),
					$_->{part}->[1]->{ppcp} );
			}
			else {
				$gxline3 = "";
			}
		}
		else {

			# get wind and direction
            my $dir;
            my $speed;

			if ( $currentWindSpeed{$client} ne "" && $day == 0 ) {
                $speed = $currentWindSpeed{$client};
                $dir = $currentWindDir{$client};
			} elsif ( valid( $_->{part}->[0]->{wind}->{s} ) ) {
                $speed = $_->{part}->[0]->{wind}->{s};
                $dir = $_->{part}->[0]->{wind}->{t};
			} elsif ( valid( $_->{part}->[1]->{wind}->{s} ) ) {
                $speed = $_->{part}->[1]->{wind}->{s};
                $dir = $_->{part}->[1]->{wind}->{t};
			}

			if ( valid( $dir ) & valid( $speed ) && $dir ne "" && $speed ne "") {
				$gxline3 = sprintf('%-3.3s%3d%4s',
								uc(string('PLUGIN_WEATHERTIME_WIND_'.$dir)),
								windspeed( $speed ),
								uc(string('PLUGIN_WEATHERTIME_WIND_' . Linethreeunit())));
			}
			elsif (valid( $speed ) && $speed ne "") {
				$gxline3 = sprintf('%d %s',
							windspeed( $speed ),
							uc(string('PLUGIN_WEATHERTIME_WIND_' . Linethreeunit())));
			} else {
				$gxline3 = "";
			}
		}

		drawText( $client, 42, $ymax{$client} - 1,  $gxline1 );
		drawText( $client, 42, $ymax{$client} - 13, $gxline2 );
		drawText( $client, 42, $ymax{$client} - 25, $gxline3 );
		$forecastGX{$client}[$day] = getFramebuf( $client, $gxwidth );
		my @arr = getDayInfos( $client, $day, $_ );
		my $i;
		for $i (0 .. $#arr) {
		   $dayinfos{$client}[$day][$i] = $arr[$i];
		}
		$day++;
	}

	$numdays{$client} = $day;
}

sub getDayInfos {
	my $client = shift;
	my $day    = shift;
	my $data   = shift;

	my $num = 0;

	my @dayInfoTexts = ();
    my $windshow = 0; 

    if ($day == $scrollDefault{$client}) {
		if ( $currentBar{$client} ne "" ) {
			$dayInfoTexts[$num] = $currentBar{$client};
			$num++;
		}
	
		if ( $currentWindSpeed{$client} ne "" ) {
	    	$dayInfoTexts[$num] = uc(string('PLUGIN_WEATHERTIME_WIND_'
		    		  .$currentWindDir{$client}).' '.
			    		windspeed( $currentWindSpeed{$client} ).' '.
				    	uc(string('PLUGIN_WEATHERTIME_WIND_' . Linethreeunit())));

	      	if ( $currentWindGust{$client} ne "" ) {
       		   $dayInfoTexts[$num] = $dayInfoTexts[$num].' '.
       			   			uc(string('PLUGIN_WEATHERTIME_WINDGUST')).' '.windspeed( $currentWindGust{$client} ).' '.
		    				uc(string('PLUGIN_WEATHERTIME_WIND_' . Linethreeunit()));
	      	} elsif (Linethree() != "0") {
				$num--;
	      	}
			$windshow = 1;
			$num++;
		}

		if ( $currentVisibility{$client} ne "" ) {
			$dayInfoTexts[$num] = $currentVisibility{$client};
			$num++;
		}
	
		if ( $currentUv{$client} ne "" ) {
			$dayInfoTexts[$num] = $currentUv{$client};
			$num++;
		}
	
		if ( $currentMoon{$client} ne "" ) {
			$dayInfoTexts[$num] = $currentMoon{$client};
			$num++;
		}
    }

	if ( valid( $data->{sunr} ) ) {
		$dayInfoTexts[$num] = uc(string('PLUGIN_WEATHERTIME_SUNRISE')) .' '.FormatTime($data->{sunr});
		$num++;
	}
	if ( valid( $data->{suns} ) ) {
	    $dayInfoTexts[$num] = uc(string('PLUGIN_WEATHERTIME_SUNSET')).' '.FormatTime($data->{suns});
		$num++;
	}
	if ( $windshow == 0) {
        if ($day != $scrollDefault{$client}) {
	    	if ( valid( $data->{part}->[0]->{wind}->{s} ) ) {
		    	$dayInfoTexts[$num] = uc(string('PLUGIN_WEATHERTIME_WIND_'
			    		  .$data->{part}->[0]->{wind}->{t}).' '.
				    		windspeed( $data->{part}->[0]->{wind}->{s} ).' '.
					    	uc(string('PLUGIN_WEATHERTIME_WIND_' . Linethreeunit())));

		      	if ( valid( $data->{part}->[0]->{wind}->{gust} ) ) {
        		   $dayInfoTexts[$num] = $dayInfoTexts[$num].' '.
        			   			uc(string('PLUGIN_WEATHERTIME_WINDGUST')).' '.windspeed( $data->{part}->[0]->{wind}->{gust} ).' '.
			    				uc(string('PLUGIN_WEATHERTIME_WIND_' . Linethreeunit()));
		      	} elsif (Linethree() != "0") {
   					$num--;
		      	}
		      
				$num++;
    		} elsif ( valid( $data->{part}->[1]->{wind}->{s} ) ) {
	    		$dayInfoTexts[$num] = uc(string('PLUGIN_WEATHERTIME_WIND_'
   						  .$data->{part}->[1]->{wind}->{t}).' '.
							windspeed( $data->{part}->[1]->{wind}->{s} ).' '.
							uc(string('PLUGIN_WEATHERTIME_WIND_' . Linethreeunit())));
		      	if ( valid( $data->{part}->[1]->{wind}->{gust} ) ) {
       			   $dayInfoTexts[$num] = $dayInfoTexts[$num].' '.
        			   			uc(string('PLUGIN_WEATHERTIME_WINDGUST')).' '.windspeed( $data->{part}->[1]->{wind}->{gust} ).' '.
			    				uc(string('PLUGIN_WEATHERTIME_WIND_' . Linethreeunit()));
		      	} elsif (Linethree() != "0") {
   					$num--;
		      	}
				$num++;
    		}		
   	    }
	} 
	if ( Linethree() != "0" ) {
	    if ( valid( $data->{part}->[0]->{ppcp} ) ) {
			$dayInfoTexts[$num] = uc(string('PLUGIN_WEATHERTIME_PRECIP')).' '.$data->{part}->[0]->{ppcp}.' %';
			$num++;
		} 
		elsif ( valid( $data->{part}->[1]->{ppcp} ) ) {
			$dayInfoTexts[$num] = uc(string('PLUGIN_WEATHERTIME_PRECIP')).' '.$data->{part}->[1]->{ppcp}.' %';
			$num++;
		}   
	}
	if ( valid( $data->{part}->[0]->{hmid} ) ) {
		$dayInfoTexts[$num] = uc(string('PLUGIN_WEATHERTIME_HUMID')).' '.$data->{part}->[0]->{hmid}.' %';
		$num++;
	}
	elsif ( valid( $data->{part}->[1]->{hmid} ) ) {
			$dayInfoTexts[$num] = uc(string('PLUGIN_WEATHERTIME_HUMID')).' '.$data->{part}->[1]->{hmid}.' %';
			$num++;
	}

	return @dayInfoTexts;

}

sub valid {
	my $data = shift;
	return ( defined($data) && ( $data ne "N/A" ) );
}

#
# Graphic functions
#
sub clearCanvas {
	my $client = shift;

	for ( my $xi = 0 ; $xi < $xmax{$client} ; $xi++ ) {
		for ( my $yi = 0 ; $yi < $ymax{$client} ; $yi++ ) {
			$hashDisp{$client}[$xi][$yi] = 0;
		}
	}
}

sub drawIcon {
	my $client = shift;
	my $xpos   = shift;
	my $ypos   = shift;
	my $icon   = shift;

	$::d_plugins
	  && Slim::Utils::Misc::msg("WeatherTime-Icon ($xpos,$ypos): $icon\n");
	if ( $xmax{$client} && $ymax{$client} ) {
		my $firstline = 1;
		my $xs        = $xpos < 0 ? 0 : $xpos;
		my $yi        = $ypos > $ymax{$client} ? $ymax{$client} : $ypos;
		for my $line ( split( '\n', $icon ) ) {

			# first line must be skipped (empty)
			if ($firstline) {
				$firstline = 0;
				next;
			}
			chomp $line;
			for (
				my $xi = $xs ;
				$xi < length($line) + $xs
				&& $xi < $xmax{$client}
				&& $yi >= 0 ;
				$xi++
			  )
			{
				if ( substr( $line, $xi - $xs, 1 ) eq "*" ) {
					$hashDisp{$client}[$xi][$yi] = 1;
				}
			}
			$yi--;
		}
	}
}

sub drawText {
	my $client = shift;
	my $xpos   = shift;
	my $ypos   = shift;
	my $text   = shift;

	$::d_plugins
	  && Slim::Utils::Misc::msg("WeatherTime-Text ($xpos,$ypos): $text\n");
	if ( $xmax{$client} && $ymax{$client} ) {
		for ( my $ci = 0 ; $ci < length($text) ; $ci++ ) {
			my $c         = substr( $text, $ci, 1 );
			my $firstline = 1;
			my $xs        = $xpos < 0 ? 0 : $xpos + $ci * 6;
			my $yi        = $ypos > $ymax{$client} ? $ymax{$client} : $ypos;

			#Try to handle special characters danish/sweedish local chars
			#not beautiful but will work for now
			my $outcharset;
			if ( defined( $Codepage{$c} ) ) {
				$outcharset = $Codepage{$c};
			}
			else {
				$outcharset = $UnicodeCodepage{ ord($c) };
			}

			for my $line ( split( '\n', $Charset[$outcharset] ) ) {

				# first line must be skipped (empty)
				if ($firstline) {
					$firstline = 0;
					next;
				}
				chomp $line;
				for (my $xi = $xs ;	$xi < length($line) + $xs
					&& $xi < $xmax{$client}
					&& $yi >= 0 ;
					$xi++
				  )
				{
					if ( substr( $line, $xi - $xs, 1 ) eq "*" ) {
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
	my $width  = shift;
	my $line1  = "";

	for ( my $x = 0 ; $x < $width && $x < $xmax{$client} ; $x++ ) {
		my $byte;
		for ( my $y = $ymax{$client} ; $y > 0 ; $y -= 8 ) {
			$byte =
			  ( $hashDisp{$client}[$x][ $y - 1 ] << 7 ) +
			  ( $hashDisp{$client}[$x][ $y - 2 ] << 6 ) +
			  ( $hashDisp{$client}[$x][ $y - 3 ] << 5 ) +
			  ( $hashDisp{$client}[$x][ $y - 4 ] << 4 ) +
			  ( $hashDisp{$client}[$x][ $y - 5 ] << 3 ) +
			  ( $hashDisp{$client}[$x][ $y - 6 ] << 2 ) +
			  ( $hashDisp{$client}[$x][ $y - 7 ] << 1 ) +
			  $hashDisp{$client}[$x][ $y - 8 ];
			$line1 .= pack( "C", $byte );
		}
	}
	return $line1;
}

#------------------------------------------------------------------------
# methods for temperature conversion
#------------------------------------------------------------------------
sub windspeed {
	my $windspeed = shift;
	if ( metric() == "0" ) {

		#windspeed is in Miles pr. hour
		if ( Linethreeunit() == "0" ) {
			#Output as meters pr. second
			my $ms =
			  sprintf( "%d", ( ( $windspeed * 1609.344 ) / 3600 ) + 0.5 );
			return $ms;
		}
		elsif ( Linethreeunit() == "1" ) {
			#Output as kilometers pr. hour
			my $ms = sprintf( "%d", ( $windspeed * 1.609344 ) + 0.5 );
			return $ms;
		}
		else {
			#Output as miles pr. hour
			return $windspeed;
		}
	}
	else {
		#Windspeec is in Kilometers pr. hour
		if ( Linethreeunit() == "0" ) {
			#Output as meters pr. second
			my $ms =
			  sprintf( "%d", ( ( $windspeed * 1000 ) / 3600 ) + 0.5 );
			return $ms;
		}
		elsif ( Linethreeunit() == "1" ) {
			#Output as kilometers pr. hour
			return $windspeed;
		}
		else {
			#Output as miles pr. hour
			my $ms = sprintf( "%d", ( $windspeed / 1.609344 ) + 0.5 );
			return $ms;
		}
	}
}

sub getStringString () {
	my $fortxt = shift;
	my $fortxt2 = shift;
	$fortxt = uc $fortxt.$fortxt2;
	$fortxt =~ tr/ \//__/;
	$fortxt =~ s/_+/_/g;
	Slim::Utils::Strings::stringExists($fortxt)
		  || Slim::Utils::Misc::msg(
"Plugin WeatherTime: need to add condition |$fortxt| to translation STRINGS\n"
			  );
	$fortxt =  Slim::Utils::Strings::stringExists($fortxt)
			  ? string($fortxt)
			  : $fortxt2;
	return $fortxt;
}

#
# access server settings
#
sub metric {
	return $prefs->get('units') || $Metric;
}

sub City {
	return $prefs->get('city') || $City;
}

sub City_Code {
	return $prefs->get('citycode') || $City_Code;
}

sub Interval {
	return $prefs->get('interval') || $Interval;
}

sub TimeDateformat {
	return $prefs->get('timedateformat') || $TimeDateformat;
}

sub Dateformat {
	return $prefs->get('dateformat') || $Dateformat;
}

sub Linethree {
	return $prefs->get('linethree') || $Linethree;
}

sub Linethreeunit {
	return $prefs->get('linethreeunit') || $Linethreeunit;
}

sub FormatTime {
  my $time = shift;
  return $time;
}

sub Timeformatted {
	my $fmt = TimeDateformat();
	if ( $fmt eq 'dateonly' ) {
		return '';
	}
	elsif ( $fmt eq 'none' ) {
		return Slim::Utils::DateTime::timeF();
	}
	else {
		return Slim::Utils::DateTime::timeF() . '  -  ';
	}
}

sub Dateformatted {
	my $fmt = TimeDateformat();
	my $datefmt = Dateformat();
	if ( $fmt eq 'std' ) {
		return Slim::Utils::DateTime::shortDateF();
	}
	elsif ( $fmt eq 'none' ) {
		return '';
	}
	else {
		my $date = strftime( $datefmt, localtime( time() ) );
		$date =~ s/\|0*//;
		return Slim::Utils::Unicode::utf8decode_locale($date);
	}
}

1;

__END__

# Local Variables:
# tab-width:4
# indent-tabs-mode:t
# End:
