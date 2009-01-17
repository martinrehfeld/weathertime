# WeatherTime/Strings.pm
# $Id$
#
#	Author: Martin Rehfeld <martin.rehfeld(at)glnetworks(dot)de>
#
#	Copyright (c) 2005-2007
#	This file is part of the WeatherTime software. The same license applies.
#	See main file Plugin.pm for details
#

package Plugins::WeatherTime::Strings;
use strict;

sub strings { return '
PLUGIN_SCREENSAVER_WEATHERTIME
	EN	Weather, Date and Time
	FR	Température, Date et Heure
	DE	Wetter/Zeit Bildschirmschoner
	NL	Weer, datum en tijd
	SE	Väder, datum och tid
	DA	Vejr, dato og tid

PLUGIN_SCREENSAVER_WEATHERTIME_START
	EN	Press PLAY to start this screensaver
	FR	Appuyez sur PLAY pour activer cet écran de veille
	DE	PLAY drücken zum Starten des Bildschirmschoners
	NL	Druk op PLAY om deze schermbeveiliger aan te zetten
	SE	Tryck PLAY för att aktivera skärmsläckaren
	DA	Tryk PLAY for at starte screensaver

PLUGIN_SCREENSAVER_WEATHERTIME_ENABLE
	EN	Press PLAY to enable this screensaver
	FR	Appuyez sur PLAY pour activer cet écran de veille
	DE	PLAY drücken zum Aktivieren des Bildschirmschoners
	NL	Druk op PLAY om deze schermbeveiliger aan te zetten
	SE	Tryck PLAY för att aktivera skärmsläckaren
	DA	Tryk PLAY for at aktivere screensaver

PLUGIN_SCREENSAVER_WEATHERTIME_DISABLE
	EN	Press PLAY to disable this screensaver
	FR	Appuyer sur PLAY pour désactiver cet écran de veille
	DE	PLAY drücken zum Deaktivieren dieses Bildschirmschoners
	NL	Druk op PLAY om deze schermbeveiliger uit te zetten
	SE	Tryck PLAY för att inaktivera skärmsläckaren
	DA	Tryk PLAY for at inaktivere screensaver

PLUGIN_SCREENSAVER_WEATHERTIME_ENABLING
	EN	Enabling WeatherTime as current screensaver
	FR	Activation de WeatherTime comme écran de veille actuel
	DE	Wetter/Zeit Bildschirmschoner aktivieren
	NL	Aanzetten van Weer, datum en tijd als huidige schermbeveiliger
	SE	Aktiverar WeatherTime som skärmsläckare
	DA	Aktiver WeatherTime som screensaver

PLUGIN_SCREENSAVER_WEATHERTIME_DISABLING
	EN	Resetting to default screensaver
	FR	Retour à l\'écran de veille par défaut
	DE	Standard-Bildschirmschoner deaktivieren
	NL	Herstellen standaard schermbeveiliger
	SE	Återställer till default skärmsläckare
	DA	Reset til default screensaver

PLUGIN_SCREENSAVER_WEATHERTIME_UPDATING
	EN	Updating Weather Forecast...
	FR	Mise à jour des prévisions météo...
	DE	Aktualisiere aktuelle Wetterdaten...
	NL	Bijwerken weersvoorspelling
	SE	Uppdaterar väderprognos...
	DA	Opdaterer vejr prognose

PLUGIN_SCREENSAVER_NOSETUP_LINE1
	EN	Setup Required
	FR	Configuration requis
	DE	Setup erforderlich
	NL	Instellen noodzakelijk
	SE	Inställningar krävs
	DA	Setup kræves

PLUGIN_SCREENSAVER_NOSETUP_LINE2
	EN	Enter server settings.
	FR	Entrez dans les paramètres de serveur.
	DE	Server settings eintragen.
	NL	Server instellingen invoeren
	SE	(server-inställningar)
	DA	(server-indstilninger).

SETUP_GROUP_PLUGIN_WEATHERTIME
	EN	Weather, Date and Time Screensaver
	FR	Ecran de veille Température, Date et Heure
	DE	Wetter/Zeit Bildschirmschoner
	NL	Weer, datum en tijd schermbeveiliger
	SE	Väder, datum och tid skärmsläckare
	DA	Vejr, dato og tid screensaver

SETUP_GROUP_PLUGIN_WEATHERTIME_DESC
	EN	The weather data is retrieved from <i>Weather Underground&reg;</i>. To localize your forecast you also need to find out a unambiguous wunderground.com citycode. It is advisable to use the 3-letter-code of your nearest airport, e.g. TXL for Berlin-Tegel, Germany.
	FR	L\'information météo est extraite de <i>Weather Underground&reg;</i>. Pour localiser vos prévisions vous devez aussi déterminer le code de ville de wunderground.com, par exemple YUL pour Montréal, Canada (Airport-Code).
	DE	Die Wetterdaten werden von <i>Weather Underground&reg;</i> bezogen. Der Citycode stammt ebenfalls von wunderground.com, zum Beispiel TXL für Berlin-Tegel (es empfiehlt sich, den 3-Buchstabencode des nächstgelegenen Flughafens zu verwenden).
	NL	Het weerbericht is opgehaald van <i>Weather Underground&reg;</i>. Om het weerbericht te localiseren heb je de citycode van wunderground.com nodig. Bijvoorbeeld AMS voor Amsterdam-Schiphol (Airport-Code).
	SE	Väderprognos hämtas från <i>Weather Underground&reg;</i>. To localize your forecast you also need to find out a unambiguous wunderground.com citycode. It is advisable to use the 3-letter-code of your nearest airport, e.g. TXL for Berlin-Tegel, Germany.
	DA	Vejrprognosen hentes fra <i>Weather Underground&reg;</i>. For lokal prognose skal du finde wunderground.com by koden, f.eks RKE for Roskilde, Danmark (Airport-Code).

SETUP_PLUGIN_WEATHERTIME_UNITS
	EN	Weather Units
	FR	Unités Météo
	DE	Einheiten
	NL	Eenheden
	SE	Enheter
	DA	Enheder

SETUP_PLUGIN_WEATHERTIME_1
	EN	Metric Units
	FR	Unités Métriques
	DE	Metrisch
	NL	Metrisch
	SE	Meter
	DA	Meter

SETUP_PLUGIN_WEATHERTIME_0
	EN	Imperial Units
	FR	Unités Impériales
	DE	Englisch
	NL	Engels
	SE	Engelska enheter
	DA	Engelske enheder

SETUP_PLUGIN_WEATHERTIME_LINETHREE
	EN	Third line
	DE	Dritte Zeile
	NL	Derde regel
	DA	Tredje linie

SETUP_PLUGIN_WEATHERTIME_LINETHREE_0
	EN	Precipitation chance
	DE	Regenwahrscheinlichkeit
	NL	Kans op regen
	DA	Risiko for regn

SETUP_PLUGIN_WEATHERTIME_LINETHREE_1
	EN	Wind info
	DE	Windrichtung
	NL	Windrichting
	DA	Vind info

SETUP_PLUGIN_WEATHERTIME_LINETHREE_UNIT
	EN	Wind info units
	DE	Wind-Einheit
	NL	Wind eenheid
	DA	Vind info enheder

SETUP_PLUGIN_WEATHERTIME_LINETHREE_UNIT_0
	EN	Meters per second
	DE	Meter pro Sekunde
	NL	Meter per seconde
	DA	Meter pr. sekund

SETUP_PLUGIN_WEATHERTIME_LINETHREE_UNIT_1
	EN	Kilometers per hour
	DE	Kilometer pro Stunde
	NL	Kilometer per uur
	DA	Kilometer i timen

SETUP_PLUGIN_WEATHERTIME_LINETHREE_UNIT_2
	EN	Miles per hour
	DE	Meilen pro Stunde
	NL	Mijl per uur
	DA	Miles i timen

SETUP_PLUGIN_WEATHERTIME_CITY
	EN	City
	FR	Ville
	DE	Name der Stadt
	NL	Plaatsnaam
	SE	Stad
	DA	By

SETUP_PLUGIN_WEATHERTIME_CITYCODE
	EN	Wunderground.com Citycode
	FR	Code de ville Wunderground.com
	DE	Wunderground.com Citycode
	NL	Wunderground.com plaatscode
	SE	Wunderground.com stadskod
	DA	Wunderground.com bykode

SETUP_PLUGIN_WEATHERTIME_INTERVAL
	EN	Fetch Interval (seconds)
	FR	Intervalle de mise-à-jour (secondes)
	DE	Aktualisierungsintervall (sekunden)
	NL	Interval voor bijwerken (seconden)
	SE	Uppdateringsfrekvens (sekunder)
	DA	Uppdateringsfrekvens (sekunder)

SETUP_PLUGIN_WEATHERTIME_TIMEDATEFORMAT
	EN	Time/Date format
	FR	Format des Heure/dates
	DE	Zeit/Datumsformat
	NL	Tijd/Datumformaat
	SE	Tid/Datumformat
	DA	Tid/Datoformat

SETUP_PLUGIN_WEATHERTIME_DATEFORMAT
	EN	Date format
	FR	Format des dates
	DE	Datumsformat
	NL	Datumformaat
	SE	Datumformat
	DA	Datoformat

SETUP_PLUGIN_WEATHERTIME_STDDATE
	EN	Standard
	FR	Standard
	DE	Standardformat
	NL	Standaardformat
	SE	Standard
	DA	Standard

SETUP_PLUGIN_WEATHERTIME_TIMEDATE
	EN	Time and Date
	FR	Heure et Date
	DE	Zeir und Datum
	NL	Tijd en Datum 
	SE	Tid och Datum 
	DA	Tid og Dato 

SETUP_PLUGIN_WEATHERTIME_NODATE
	EN	No date (time only)
	FR	Sans date (heure seulement)
	DE	Kein Datum (nur Zeit)
	NL	Geen datum (alleen de tijd)
	SE	Inget datum (endast tid)
	DA	Ingen dato (kun tid)

SETUP_PLUGIN_WEATHERTIME_DATEONLY
	EN	No time (date only)
	FR	Sans heure (date seulement)
	DE	Kein Zeit (nur Datum)
	NL	Geen tijd (alleen de datum)
	SE	Inget tid (endast datum)
	DA	Ingen tid (kun dato)

PLUGIN_SCREENSAVER_WEATHERTIME_NOINFO
	EN	loading...
	FR	Chargement...
	DE	Lade...
	NL	Laden...
	SE	hämtas...
	DA	hentes...

PLUGIN_WEATHERTIME_NO_FORECAST_AVAILABLE
	EN	No forecast available
	FR	Prévisions non disponibles
	DE	Keine Vorhersage vorhanden
	NL	Geen weerbericht beschikbaar
	SE	Ingen prognos tillgänglig
	DA	Ingen prognose tilgængelig

PLUGIN_WEATHERTIME_CURRENTTEMP
	EN	Now
	FR	Maintenant
	DE	Jetzt
	NL	Nu
	SE	Nu
	DA	Nu

PLUGIN_WEATHERTIME_TODAY
	EN	Today
	FR	Aujourd\'hui
	DE	Heute
	NL	Vandaag
	SE	Idag
	DA	I dag

PLUGIN_WEATHERTIME_TONIGHT
	EN	Tonight
	FR	Ce soir
	DE	Nachts
	NL	Vannacht
	SE	Ikväll
	DA	I aften

PLUGIN_WEATHERTIME_TOMORROW
	EN	Tomorrow
	FR	Demain
	DE	Morgen
	NL	Morgen
	SE	Imorgon
	DA	I morgen

PLUGIN_WEATHERTIME_SUNDAY
	EN	Sunday
	FR	Dimanche
	DE	Sonntag
	NL	Zondag
	SE	Söndag
	DA	Søndag

PLUGIN_WEATHERTIME_MONDAY
	EN	Monday
	FR	Lundi
	DE	Montag
	NL	Maandag
	SE	Måndag
	DA	Mandag

PLUGIN_WEATHERTIME_TUESDAY
	EN	Tuesday
	FR	Mardi
	DE	Dienstag
	NL	Dinsdag
	SE	Tisdag
	DA	Tirsdag

PLUGIN_WEATHERTIME_WEDNESDAY
	EN	Wednesday
	FR	Mercredi
	DE	Mittwoch
	NL	Woensdag
	SE	Onsdag
	DA	Onsdag

PLUGIN_WEATHERTIME_THURSDAY
	EN	Thursday
	FR	Jeudi
	DE	Donnerstag
	NL	Donderdag
	SE	Torsdag
	DA	Torsdag

PLUGIN_WEATHERTIME_FRIDAY
	EN	Friday
	FR	Vendredi
	DE	Freitag
	NL	Vrijdag
	SE	Fredag
	DA	Fredag

PLUGIN_WEATHERTIME_SATURDAY
	EN	Saturday
	FR	Samedi
	DE	Samstag
	NL	Zaterdag
	SE	Lördag
	DA	Lørdag

PLUGIN_WEATHERTIME_NIGHT
	EN	Night
	FR	Nuit
	DE	Nachts
	NL	\'s Nachts
	SE	Natt
	DA	Nat

PLUGIN_WEATHERTIME_DAY
	EN	Day
	FR	Jour
	DE	Tagsüber
	NL	Overdag
	SE	Dag
	DA	Dag

PLUGIN_WEATHERTIME_HIGH
	EN	High
	FR	Maximum
	DE	Max
	NL	Max
	SE	Max
	DA	Maks

PLUGIN_WEATHERTIME_LOW
	EN	Low
	FR	Minimum
	DE	Min
	NL	Min
	SE	Min
	DA	Min

PLUGIN_WEATHERTIME_PRECIP
	EN	Precip
	FR	Précip
	DE	Regen
	NL	Regen
	SE	Nederbörd
	DA	NedbØr

PLUGIN_WEATHERTIME_CLOUDY
	EN	Cloudy
	FR	Nuageux
	DE	bewölkt
	NL	zwaarbewolkt
	SE	Mulet
	DA	Skyet

PLUGIN_WEATHERTIME_MOSTLY_CLOUDY
	EN	Mostly Cloudy
	FR	Plutôt nuageux
	DE	Meist bewölkt
	NL	Bewolkt
	SE	Övervägande mulet
	DA	Mest skyet

PLUGIN_WEATHERTIME_PARTLY_CLOUDY
	EN	Partly Cloudy
	FR	Partiellement nuageux
	DE	Teilw. bewölkt
	NL	Halfbewolkt
	SE	Halvklart
	DA	Let skyet

PLUGIN_WEATHERTIME_LIGHT_RAIN
	EN	Light Rain
	FR	Pluie légère
	DE	Etwas Regen
	NL	Enige regen
	SE	Lätt regn
	DA	Let regn

PLUGIN_WEATHERTIME_LIGHT_RAIN_WIND
	EN	Light Rain / Wind
	FR	Pluie légère / Vent
	DE	Etwas Regen, Wind
	NL	Enige regen / winderig
	SE	Lätt regn / vind
	DA	Let regn/blæst

PLUGIN_WEATHERTIME_SHOWERS
	EN	Showers
	FR	Averses
	DE	Schauer
	NL	Buien
	SE	Skurar
	DA	Byger

PLUGIN_WEATHERTIME_RAIN
	EN	Rain
	FR	Pluie
	DE	Regen
	NL	Regen
	SE	Regn
	DA	Regn

PLUGIN_WEATHERTIME_AM_SHOWERS
	EN	AM Showers
	FR	Averses AM
	DE	Vorm. Schauer
	NL	Ocht. buien
	SE	Fm. skurar
	DA	Fm. byger

PLUGIN_WEATHERTIME_SHOWERS_EARLY
	EN	Showers early
	FR	Averses Tôt
	DE	Anfangs Schauer
	NL	Vroeg buien
	SE	Fm. skurar
	DA	Fm. byger

PLUGIN_WEATHERTIME_SHOWERS_LATE
	EN	Showers late
	FR	Averses Tard
	DE	Abends Schauer
	NL	Avond buien
	SE	Em. skurar
	DA	Byger em.

PLUGIN_WEATHERTIME_FOG
	EN	Fog
	FR	Brouillard
	DE	Nebel
	NL	Mist
	SE	Dimma
	DA	TÅGE

PLUGIN_WEATHERTIME_FEW_SHOWERS
	EN	Few Showers
	FR	Quelques Averses
	DE	Vereinzelte Schauer
	NL	Enkele buien
	SE	Enstaka skurar
	DA	Enkelte byger

PLUGIN_WEATHERTIME_MOSTLY_SUNNY
	EN	Mostly Sunny
	FR	Plutôt Ensoleillé
	DE	Meist sonnig
	NL	Vooral zonnig
	SE	Övervägande soligt
	DA	Mest solrigt

PLUGIN_WEATHERTIME_SUNNY
	EN	Sunny
	FR	Ensoleillé
	DE	Sonnig
	NL	Zonnig
	SE	Soligt
	DA	Solrigt

PLUGIN_WEATHERTIME_SCATTERED_FLURRIES
	EN	Scattered Flurries
	FR	Neige Passagère
	DE	Böen aus wechselnder Richtung
	NL	Lokaal buien
	SE	Lokala regnbyar
	DA	Lokale byger

PLUGIN_WEATHERTIME_AM_CLOUDS_PM_SUN
	EN	AM Clouds/PM Sun
	FR	Nuageux AM / Soleil PM
	DE	Vorm. Wolken, nachm. Sonne
	NL	Bewolkt later zonnig
	SE	Uppsprickande molntäcke
	DA	Skyet senere sol

PLUGIN_WEATHERTIME_CLOUDS_EARLY_CLEARING_LATE
	EN	Clouds Early / Clearing Late
	FR	Nuages Tôt / Eclaircissements
	DE	Anfangs Wolken / abends klar
	NL	Bewolkt later opklaringen
	SE	Uppsprickande molntäcke
	DA	Skyet senere opklaring

PLUGIN_WEATHERTIME_ISOLATED_T-STORMS
	EN	Isolated Thunderstorms
	FR	Orages Isolées
	DE	vereinzelte Gewitter
	NL	Een enkele onweersbui
	SE	Enstaka åskväder
	DA	Enkelte tordenbyger

PLUGIN_WEATHERTIME_SCATTERED_THUNDERSTORMS
	EN	Scattered Thunderstorms
	FR	Orages Dispersées
	DE	Verteilte Gewitter
	NL	Lokaal onweersbuien
	SE	Lokala åskväder
	DA	Lokal storm

PLUGIN_WEATHERTIME_SCATTERED_T-STORMS
	EN	Scattered Thunderstorms
	FR	Orages Dispersées
	DE	verteilte Gewitter
	NL	Lokaal onweersbuien
	SE	Lokala åskväder
	DA	Lokal torden

PLUGIN_WEATHERTIME_SCATTERED_SHOWERS
	EN	Scattered Showers
	FR	Averses Dispersées
	DE	verteilte Schauer
	NL	Lokaal buien
	SE	Lokala skurar
	DA	Lokale byger

PLUGIN_WEATHERTIME_PM_SHOWERS
	EN	PM Showers
	FR	Averses PM
	DE	Nachm. Schauer
	NL	Middag buien
	SE	em. skurar
	DA	Em. byger

PLUGIN_WEATHERTIME_PM_SHOWERS_WIND
	EN	PM Showers/Wind
	FR	Averses/Vent PM
	DE	Nachm. Schauer/Wind
	NL	Midd. buien/winderig
	SE	Em. skurar, vind
	DA	Em. byger og blæst

PLUGIN_WEATHERTIME_RAIN_SNOW_SHOWERS
	EN	Rain/Snow Showers
	FR	Averses Pluie/Neige
	DE	Regen/Schneeschauer
	NL	Regen/sneeuwbuien
	SE	Regn/Snö
	DA	Regn/sne byger

PLUGIN_WEATHERTIME_FEW_SNOW_SHOWERS
	EN	Few Snow Showers
	FR	Quelques Averses de Neige
	DE	Vereinzelte Schneeschauer
	NL	Enkele sneeuwbuien
	SE	Enstaka snöfall
	DA	Enkelte snebyger

PLUGIN_WEATHERTIME_CLOUDY_WIND
	EN	Cloudy/Wind
	FR	Nuageux/Venteux
	DE	Bewölkt/windig
	NL	Zwaarbewolkt/winderig
	SE	Mulet/blåst
	DA	Skyer/Blæst

PLUGIN_WEATHERTIME_FLURRIES_WIND
	EN	Flurries/Wind
	FR	Neige/Vent
	DE	Böeig/windig
	NL	Windvlagen
	SE	Byig vind
	DA	Hård vind

PLUGIN_WEATHERTIME_MOSTLY_CLOUDY_WINDY
	EN	Mostly Cloudy/Windy
	FR	Plutôt Nuageux/Venteux
	DE	Meist bewölkt/windig
	NL	Bewolkt/winderig
	SE	Övervägande mulet/blåsigt
	DA	Mest Skyet/blæsende

PLUGIN_WEATHERTIME_MOSTLY_CLOUDY_WIND
	EN	Mostly Cloudy/Wind
	FR	Plutôt Nuageux/Venteux
	DE	Meist bewölkt/windig
	NL	Bewolkt/winderig
	SE	Övervägande mulet/blåsigt
	DA	Mest Skyet/blæsende

PLUGIN_WEATHERTIME_RAIN_THUNDER
	EN	Rain/Thunder
	FR	Pluie/Orages
	DE	Regen/Gewitter
	NL	Regen/onweer
	SE	Regn/åska
	DA	Regn/Torden

PLUGIN_WEATHERTIME_PARTLY_CLOUDY_WIND
	EN	Partly Cloudy/Wind
	FR	Partiellement Nuageux/Venteux
	DE	Teilw. bewölkt/Wind
	NL	Halfbewolkt/winderig
	SE	Delvis mulet/vind
	DA	Let skyet/blæsende

PLUGIN_WEATHERTIME_AM_RAIN_SNOW_SHOWERS
	EN	AM Rain/Snow Showers
	FR	Pluie/Averses de neige AM
	DE	Vorm. Regen/Schneeschauer
	NL	Ocht. regen/sneeuwbui
	SE	Em. Regn/snö
	DA	Em. Regn/Sne

PLUGIN_WEATHERTIME_SHOWERS_WIND
	EN	Showers/Wind
	FR	Averses/Vent
	DE	Schauer/Wind
	NL	Buien/winderig
	SE	Regn/blåst
	DA	Regn/Blæst

PLUGIN_WEATHERTIME_MOSTLY_SUNNY_WIND
	EN	Mostly Sunny/Wind
	FR	Plutôt Ensoleillé/Vent
	DE	Meist sonnig/Wind
	NL	Vooral zonnig/winderig
	SE	Övervägande soligt/vind
	DA	Mest solrigt/blæsende

PLUGIN_WEATHERTIME_FLURRIES
	EN	Flurries
	FR	Neige
	DE	Böen
	NL	Buien
	SE	Byar
	DA	Byger

PLUGIN_WEATHERTIME_RAIN_WIND
	EN	Rain/Wind
	FR	Pluie/Vent
	DE	Regen/Wind
	NL	Regen/winderig
	SE	Regn/vind
	DA	Regn/Blæst

PLUGIN_WEATHERTIME_SCT_FLURRIES_WIND
	EN	Scattered Flurries/Wind
	FR	Averses de Neige/Vent
	DE	Verteilte, böeige Winde
	NL	Lokaal buien/winderig
	SE	Lokala vindbyar
	DA	Lokal blæst

PLUGIN_WEATHERTIME_SCT_STRONG_STORMS
	EN	Scattered Strong Storms
	FR	Fortes Tempêtes Dispersées
	DE	Verteilte, heftige Stürme
	NL	Lokaal zware stormen
	SE	Lokala stormar
	DA	Lokal hård storm

PLUGIN_WEATHERTIME_PM_T-STORMS
	EN	PM Thunderstorms
	FR	Orages PM
	DE	Nachm. Gewitter
	NL	Midd. onweersbuien
	SE	Em. åska
	DA	Em. torden

PLUGIN_WEATHERTIME_T-STORMS
	EN	Thunderstorms
	FR	Orages
	DE	Gewitter
	NL	Onweersbuien
	SE	Åska
	DA	Torden

PLUGIN_WEATHERTIME_THUNDERSTORMS
	EN	Thunderstorms
	FR	Orages
	DE	Gewitter
	NL	Onweersbuien
	SE	Stormar med åska
	DA	Torden og Storm

PLUGIN_WEATHERTIME_SUNNY_WINDY
	EN	Sunny/Windy
	FR	Ensoleillé/Venteux
	DE	Sonnig/windig
	NL	Zonnig/winderig
	SE	Soligt men blåsigt
	DA	Solrigt/blæsende

PLUGIN_WEATHERTIME_AM_THUNDERSTORMS
	EN	AM Thunderstorms
	FR	Orages AM
	DE	Vorm. Gewitter
	NL	Ocht. onweersbuien
	SE	Fm. åskskurar
	DA	Fm. tordenbyger

PLUGIN_WEATHERTIME_AM_RAIN
	EN	AM Rain
	FR	Pluie AM
	DE	Vorm. Regen
	NL	Ochtend regen
	SE	Fm. regn
	DA	Fm. regn

PLUGIN_WEATHERTIME_ISO_T-Storms_WIND
	EN	Isolated Thunderstorms/Wind
	FR	Orages/Vent Dispersés
	DE	Vereinzelte Gewitter/Wind
	NL	Enkele onweersbuien/winderig
	SE	Lokala stormar/åska 
	DA	Lokal Torden/blæst

PLUGIN_WEATHERTIME_RAIN_SNOW
	EN	Rain/Snow
	FR	Pluie/Neige
	DE	Regen/Schnee
	NL	Regen/sneeuw
	SE	Regn/snö
	DA	Regn/Sne

PLUGIN_WEATHERTIME_RAIN_SNOW_WIND
	EN	Rain/Snow/Wind
	FR	Pluie/Neige/Vent
	DE	Regen/Schnee/Wind
	NL	Regen/sneeuw/winderig
	SE	Regn/snö/vind
	DA	Regn/Sne/Blæst

PLUGIN_WEATHERTIME_SCT_T-STORMS_WIND
	EN	Scattered Thunderstorms/Wind
	FR	Orages Dispersés/Vent
	DE	Verteilte Gewitter/Wind
	NL	Lokaal onweersbuien/winderig
	SE	Lokala åskbyar, blåst
	DA	Lokal torden/blæst

PLUGIN_WEATHERTIME_AM_SHOWERS_WIND
	EN	AM Showers/Wind
	FR	Averses/Vent AM
	DE	Vorm. Schauer/Wind
	NL	Ocht. buien/winderig
	SE	Fm. skurar/blåst
	DA	Fm. Byger/Blæst

PLUGIN_WEATHERTIME_SHOWERS_WIND_EARLY
	EN	AM Showers/Wind
	FR	Averses/Vent AM
	DE	Vorm. Schauer/Wind
	NL	Ocht. buien/winderig
	SE	Fm. skurar/blåst
	DA	Fm. Byger/Blæst

PLUGIN_WEATHERTIME_SCT_SNOW_SHOWERS
	EN	Scattered Snow Showers
	FR	Averses de Neige Dispersées
	DE	Verteilte Schneeschauer
	NL	Lokaal sneeuwbuien
	SE	Lokalt snöfall
	DA	Lokale snebyger

PLUGIN_WEATHERTIME_SCATTERED_SNOW_SHOWERS
	EN	Scattered Snow Showers
	FR	Averses de Neige Dispersées
	DE	Verteilte Schneeschauer
	NL	Lokaal sneeuwbuien
	SE	Lokalt snöfall
	DA	Lokale snebyger

PLUGIN_WEATHERTIME_SNOW_TO_ICE_WIND
	EN	Snow to Ice/Wind
	FR	Neige à Glace/Vent
	DE	Schnee in Hagel überg./Wind
	NL	Sneeuw tot hagel/winderig
	SE	Snö / hagel vind
	DA	Sne og hagl/blæst

PLUGIN_WEATHERTIME_SNOW_TO_RAIN
	EN	Snow to Rain
	FR	Neige à Pluie
	DE	Schnee in Regen überg.
	NL	Sneeuw tot regen
	SE	Snö eller regn
	DA	Sne eller Regn

PLUGIN_WEATHERTIME_AM_LIGHT_RAIN
	EN	AM Light Rain
	FR	Pluie Légère AM
	DE	Vorm. etwas Regen
	NL	Ocht. enige regen
	SE	Fm. lätt regn
	DA	Fm. let regn

PLUGIN_WEATHERTIME_PM_LIGHT_RAIN
	EN	PM Light Rain
	FR	Pluie Légère PM
	DE	Nachm. etwas Regen
	NL	Midd. enige regen
	SE	Em. lätt regn
	DA	Em. let regn

PLUGIN_WEATHERTIME_LIGHT_RAIN_LATE
	EN	Light Rain Late
	FR	Pluie Légère Tard
	DE	Abends etwas Regen
	NL	Avond enige regen
	SE	Em. lätt regn
	DA	Em. let regn

PLUGIN_WEATHERTIME_RAIN_LATE
	EN	Rain Late
	FR	Pluie Tard
	DE	Abends Regen
	NL	Avond regen
	SE	Em. regn
	DA	Em. regn

PLUGIN_WEATHERTIME_PM_RAIN
	EN	PM Rain
	FR	Pluie PM
	DE	Nachm. Regen
	NL	Midd. regen
	SE	Em. regn
	DA	Em. regn

PLUGIN_WEATHERTIME_SNOW_SHOWERS
	EN	Snow Showers
	FR	Averses de Neige
	DE	Schneeschauer
	NL	Sneeuwbuien
	SE	Enstaka snöfall
	DA	Snebyger

PLUGIN_WEATHERTIME_SNOW_SHOWER
	EN	Snow Shower
	FR	Averse de Neige
	DE	Schneeschauer
	NL	Sneeuwbui
	SE	Enstaka snöfall
	DA	Snebyger

PLUGIN_WEATHERTIME_RAIN_TO_SNOW
	EN	Rain to Snow
	FR	Pluie à Neige
	DE	Regen in Schnee überg.
	NL	Regen tot sneeuw
	SE	Snöblandat regn
	DA	Regn måske sne

PLUGIN_WEATHERTIME_PM_RAIN_SNOW
	EN	PM Rain/Snow
	FR	Pluie/Neige PM
	DE	Nachm. Regen/Schnee
	NL	Midd. regen/sneeuw
	SE	Em. regn/snö
	DA	Em. regn/sne

PLUGIN_WEATHERTIME_FEW_SHOWERS_WIND
	EN	Few Showers/Wind
	FR	Quelques Averses/Vent
	DE	Wenige Schauer/Wind
	NL	Enkele buien/winderig
	SE	Enstaka skurar/blåst
	DA	Enkelte byger/blæst

PLUGIN_WEATHERTIME_SNOW_WIND
	EN	Snow/Wind
	FR	Neige/Vent
	DE	Schnee/Wind
	NL	Sneeuw/winderig
	SE	Snö/blåst
	DA	Sne/Blæst

PLUGIN_WEATHERTIME_PM_RAIN_SNOW_SHOWERS
	EN	PM Rain/Snow Showers
	FR	Averses de Pluie/Neige PM
	DE	Nachm. Regen/Schneeschauer
	NL	Midd. regen/sneeuwbuien
	SE	Em. skurar regn/snö
	DA	Em. Regn/Snebyger

PLUGIN_WEATHERTIME_PM_RAIN_SNOW_WIND
	EN	PM Rain/Snow/Wind
	FR	Pluie/Neige/Vent PM
	DE	Nachm. Regen/Schnee/Wind
	NL	Midd. regen/sneeuw/winderig
	SE	Em. regn/snö/blåst
	DA	Em. Regn/Sne/Blæst

PLUGIN_WEATHERTIME_RAIN_SNOW_SHOWERS_WIND
	EN	Rain/Snow Showers/Wind
	FR	Pluie/Averses de Neige/Vent
	DE	Regen/Schneeschauer/Wind
	NL	Regen/sneeuwbuien/winderig
	SE	Regn/snöbyar/blåst
	DA	Regn/Snebyger/Blæst

PLUGIN_WEATHERTIME_SNOW_SHOWER_WIND
	EN	Snow Showers/Wind
	DA	Snebyger/Blæst
	DE	Schneeschauer/Wind
	NL	Sneeuwbuien/Wind

PLUGIN_WEATHERTIME_RAIN_SNOW_WIND
	EN	Rain/Snow/Wind
	FR	Pluie/Neige/Vent
	DE	Regen/Schnee/Wind
	NL	Regen/sneeuw/winderig
	SE	Regn/Snö/Blåst
	DA	Regn/Sne/Blæst

PLUGIN_WEATHERTIME_LIGHT_SNOW
	EN	Light Snow
	FR	Neige Légère
	DE	Etwas Schnee
	NL	Lichte sneeuw
	SE	Lätt snö
	DA	Let sne

PLUGIN_WEATHERTIME_PM_SNOW
	EN	PM Snow
	FR	Neige PM
	DE	Nachm. Schnee
	NL	Midd. sneeuw
	SE	Em. snö
	DA	Em. sne

PLUGIN_WEATHERTIME_FEW_SNOW_SHOWERS_WIND
	EN	Few Snow Showers/Wind
	FR	Quelques Averses de Neige/Vent
	DE	Wenige Schneeschauer/Wind
	NL	Enkele sneeuwbuien/winderig
	SE	Spridda snöbyar/blåst
	DA	Få snebyger/blæst

PLUGIN_WEATHERTIME_LIGHT_SNOW_WIND
	EN	Light Snow/Wind
	FR	Neige/Vent Léger
	DE	Etwas Schnee/Wind
	NL	Lichte sneeuw/winderig
	SE	Lätt snö/blåst
	DA	Let sne/blæst

PLUGIN_WEATHERTIME_WINTRY_MIX
	EN	Wintry Mix
	FR	Mélange Hivernal
	DE	Winter-Mix
	NL	Winters
	SE	Vinterväder
	DA	Vintervejr

PLUGIN_WEATHERTIME_AM_WINTRY_MIX
	EN	AM Wintry Mix
	FR	Mélange Hivernal AM
	DE	Vorm. Winter-Mix
	NL	Ocht. winters
	SE	Vinterväder

PLUGIN_WEATHERTIME_HVY_RAIN_FREEZING_RAIN
	EN	Hvy Rain/Freezing Rain
	FR	Pluie Forte/Verglaçante
	DE	heftiger/gefr. Regen
	NL	Zware ijzel
	SE	Underkylt regn
	DA	Hård/Frysende regn

PLUGIN_WEATHERTIME_AM_LIGHT_SNOW
	EN	AM Light Snow
	FR	Neige Légère AM
	DE	Vorm. etwas Schnee
	NL	Ocht. enige sneeuw
	SE	Tidigt lätt snöfall
	DA	Fm. let sne

PLUGIN_WEATHERTIME_RAIN_FREEZING_RAIN
	EN	Rain/Freezing Rain
	FR	Pluie/Pluie Verglaçante
	DE	Regen/gefr. Regen
	NL	Regen/ijzel
	SE	Regn/underkylt regn
	DA	Regn/Frysende regn

PLUGIN_WEATHERTIME_T-STORMS_WIND
	EN	Thunderstorms/Wind
	FR	Orages/Vent
	DE	Gewitter/Wind
	NL	Onweer/winderig
	SE	Åskväder/blåst
	DA	Torden/Blæst

PLUGIN_WEATHERTIME_SPRINKLES
	EN	Sprinkles
	FR	Quelques Gouttes
	DE	Graupel
	NL	Motregen
	SE	Strilregn
	DA	Silende regn

PLUGIN_WEATHERTIME_AM_SNOW_SHOWERS
	EN	AM Snow Showers
	FR	Averses de Neige AM
	DE	Vorm. Schneeschauer
	NL	Ocht. sneeuwbuien
	SE	Fm. snöfall
	DA	Fm. snebyger

PLUGIN_WEATHERTIME_SNOW_SHOWERS_EARLY
	EN	Snow Showers Early
	FR	Averses de Neige Tôt
	DE	Anfangs Schneeschauer
	NL	Vroeg sneeuwbuien
	SE	Fm. snöfall
	DA	Fm. snebyger

PLUGIN_WEATHERTIME_AM_CLOUDS_PM_SUN_WIND
	EN	AM Clouds/PM Sun/Wind
	FR	Nuages AM / Soleil/Vent PM
	DE	Vorm. Wolken/Nachm. Sonne/Wind
	NL	Bewolkt later zon/winderig
	SE	Fm. mulet em. soligt/blåst
	DA	Fm.skyet/em.sol/blæst

PLUGIN_WEATHERTIME_AM_RAIN_SNOW_WIND
	EN	AM Rain/Snow/Wind
	FR	Pluie/Neige/Vent AM
	DE	Vorm. Regen/Schnee/Wind
	NL	Ocht. regen/sneeuw/winderig
	SE	Fm. regn/snö/blåst
	DA	Fm. regn/sne/blæst

PLUGIN_WEATHERTIME_RAIN_TO_SNOW_WIND
	EN	Rain to Snow/Wind
	FR	Pluie à Neige/Vent
	DE	Regen in Schnee überg./Wind
	NL	Regen tot sneeuw/winderig
	SE	Regn till snö/blåst
	DA	Regn eller sne/blæst

PLUGIN_WEATHERTIME_SNOW_TO_WINTRY_MIX
	EN	Snow to Wintry Mix
	FR	Neige à Mélange Hivernal
	DE	Schnee in Winter-Mix überg.
	NL	Sneeuw tot winters
	SE	Snö/vinterväder
	DA	Sne eller vintervejr

PLUGIN_WEATHERTIME_PM_SNOW_SHOWERS_WIND
	EN	PM Snow Showers/Wind
	FR	Averses de Neige/Vent PM
	DE	Nachm. Schneeschauer/Wind
	NL	Midd. sneeuwbuien/winderig
	SE	Fm. snöbyar
	DA	Fm. snebyger/blæst

PLUGIN_WEATHERTIME_SNOW_AND_ICE_TO_RAIN
	EN	Snow and Ice to Rain
	FR	Neige et Glace à Pluie
	DE	Schnee und Hagel in Regen überg.
	NL	Sneeuw/hagel tot regen
	SE	Snö till regn
	DA	Sne og Hagl eller regn

PLUGIN_WEATHERTIME_HEAVY_RAIN
	EN	Heavy Rain
	FR	Pluie Forte
	DE	Heftiger Regen
	NL	Zware buien
	SE	Regn
	DA	Hård regn

PLUGIN_WEATHERTIME_AM_RAIN_ICE
	EN	AM Rain/Ice
	FR	Pluie/Glace AM
	DE	Vorm. Regen/Hagel
	NL	Ocht. regen/hagel
	SE	Fm. regn/hagel
	DA	Fm. regn/hagl

PLUGIN_WEATHERTIME_AM_SNOW_SHOWERS_WIND
	EN	AM Snow Showers/Wind
	FR	Averses de Neige/Vent AM
	DE	Vorm. Schneeschauer/Wind
	NL	Ocht. sneeuwbuien/winderig
	SE	Fm. regnbyar
	DA	Fm. snebyger/blæst

PLUGIN_WEATHERTIME_AM_LIGH_SNOW_WIND
	EN	AM Light Snow/Wind
	FR	Neige Légère/Vent AM
	DE	Vorm. etwas Schnee/Wind
	NL	Ocht. lichte sneeuw/winderig
	SE	Fm. lätt snöfall
	DA	Fm. let sne/blæst

PLUGIN_WEATHERTIME_PM_LIGHT_RAIN_WIND
	EN	PM Light Rain/Wind
	FR	Pluie Légère/Vent PM
	DE	Nachm. etwas Regen/Wind
	NL	Midd. lichte regen/winderig
	SE	Em. lätt regn/blåst
	DA	Em. let regn/blæst

PLUGIN_WEATHERTIME_AM_LIGHT_WINTRY_MIX
	EN	AM Light Wintry Mix
	FR	Mélange Hivernal Léger AM
	DE	Vorm. leichter Winter-Mix
	NL	Ocht. lichte winters
	SE	Vinterväder
	DA	Fm. let vintervejr

PLUGIN_WEATHERTIME_PM_LIGHT_SNOW_WIND
	EN	PM Light Snow/Wind
	FR	Neige Légère/Vent PM
	DE	Nachm. etwas Schnee/Wind
	NL	Midd. lichte sneeuw/winderig
	SE	Em. lätt snö/blåst
	DA	Em. let sne/blæst

PLUGIN_WEATHERTIME_HEAVY_RAIN_WIND
	EN	Heavy Rain/Wind
	FR	Pluie/Vent Forts
	DE	Heftiger Regen/Wind
	NL	Zware regen/winderig
	SE	Regn/blåst
	DA	Hård regn/blæst

PLUGIN_WEATHERTIME_PM_SNOW_SHOWER
	EN	PM Snow Shower
	FR	Averse de Neige PM
	DE	Nachm. Schneeschauer
	NL	midd. sneeuwbui
	SE	Em. snöfall
	DA	Em. snebyger

PLUGIN_WEATHERTIME_PM_SNOW_SHOWERS
	EN	PM Snow Showers
	FR	Averses de Neige PM
	DE	Nachm. Schneeschauer
	NL	Midd. sneeuwbuien
	SE	Em. snöfall
	DA	Em. snebyger

PLUGIN_WEATHERTIME_SNOW_SHOWERS_LATE
	EN	Snow Showers Late
	FR	Averses de Neige Tard
	DE	Abends Schneeschauer
	NL	Avond sneeuwbui
	SE	Em. snöfall
	DA	Em. snebyger

PLUGIN_WEATHERTIME_RAIN_SNOW_SHOWERS_LATE
	EN	Rain / Snow Showers Late
	FR	Pluie / Averses de Neige Tard
	DE	Regen / Abends Schneeschauer
	NL	Regen later sneeuwbuien
	SE	Em. regn/snö
	DA	Em. regn/sne-byger

PLUGIN_WEATHERTIME_SNOW_TO_RAIN_WIND
	EN	Snow to Rain/Wind
	FR	Neige à Pluie/Vent
	DE	Schnee in Regen überg./Wind
	NL	Sneeuw tot regen/winderig
	SE	Snö till regn/blåst
	DA	Sne eller regn/blæst

PLUGIN_WEATHERTIME_PM_LIGHT_RAIN_ICE
	EN	PM Light Rain/Ice
	FR	Pluie/Glace Léger PM
	DE	Nachm. leichter Regen/Hagel
	NL	Midd. lichte regen/hagel
	SE	Em. lätt regn
	DA	Em. let regn/hagl

PLUGIN_WEATHERTIME_SNOW
	EN	Snow
	FR	Neige
	DE	Schnee
	NL	Sneeuw
	SE	Snö
	DA	Sne

PLUGIN_WEATHERTIME_AM_SNOW
	EN	AM Snow
	FR	Neige AM
	DE	Vorm. Schnee
	NL	Ocht. sneeuw
	SE	Fm. snö
	DA	Fm. sne

PLUGIN_WEATHERTIME_SNOW_TO_ICE
	EN	Snow to Ice
	FR	Neige à Glace
	DE	Schnee in Hagel überg.
	NL	Sneeuw tot hagel
	SE	Snö til hagel
	DA	Sne eller hagl

PLUGIN_WEATHERTIME_WINTRY_MIX_WIND
	EN	Wintry Mix/Wind
	FR	Mélange Hivernal/Vent
	DE	Winter-Mix/Wind
	NL	Winters/winderig
	SE	Vinterväder/blåst
	DA	Vintervejr/blæst

PLUGIN_WEATHERTIME_PM_LIGHT_SNOW
	EN	PM Light Snow
	FR	Neige Légère PM
	DE	Nachm. etwas Schnee
	NL	Midd. enige sneeuw
	SE	Em. lätt snö
	DA	Em. let sne

PLUGIN_WEATHERTIME_AM_DRIZZLE
	EN	AM Drizzle
	FR	Bruine AM
	DE	Vorm. Nieselregen
	NL	Ocht. motregen
	SE	Fm. duggregn
	DA	Fm. småregn

PLUGIN_WEATHERTIME_STRONG_STORMS_WIND
	EN	Strong Storms/Wind
	FR	Fortes Tempêtes/Vent
	DE	Starke Stürme/Wind
	NL	Zware storm/winderig
	SE	Stormbyar
	DA	Hård storm

PLUGIN_WEATHERTIME_PM_DRIZZLE
	EN	PM Drizzle
	FR	Bruine PM
	DE	Nachm. Nieselregen
	NL	Middag motregen
	SE	Em. duggregn
	DA	Em. smÅregn

PLUGIN_WEATHERTIME_DRIZZLE
	EN	Drizzle
	FR	Bruine
	DE	Nieselregen
	NL	Motregen
	SE	Smågregn
	DA	småregn

PLUGIN_WEATHERTIME_AM_LIGHT_RAIN_WIND
	EN	AM Light Rain/Wind
	FR	Pluie/Vent Légers AM
	DE	Vorm. etwas Regen/Wind
	NL	Ocht. lichte regen/winderig
	SE	Fm. lätt regn
	DA	Fm. let Regn/Blæst

PLUGIN_WEATHERTIME_AM_RAIN_WIND
	EN	AM Rain/Wind
	FR	Pluie/vent AM
	DE	Vorm. Regen/Wind
	NL	Ocht. regen/winderig
	SE	Fm. regn/blåst
	DA	Fm. Regn/Blæst

PLUGIN_WEATHERTIME_WINTRY_MIX_TO_SNOW
	EN	Wintry Mix to Snow
	FR	Mélange Hivernal à Neige
	DE	Winter-Mix in Schnee überg.
	NL	Winters tot sneeuw
	SE	Vinterväder / snö
	DA	Vintervejr måske sne

PLUGIN_WEATHERTIME_SNOW_SHOWERS_WINDY
	EN	Snow Showers/Windy
	FR	Averses de Neige/Venteux
	DE	Schneeschauer/Wind
	NL	Sneeuwbuien/winderig
	SE	Snöfall/blåst
	DA	Snebyger/Blæst

PLUGIN_WEATHERTIME_LIGHT_RAIN_SHOWER
	EN	Light Rain Shower
	FR	Averse de Pluie Légère
	DE	Leichte Regenschauer
	NL	Lichte regenbui
	SE	Lätta regnskurar
	DA	Lette regnbyger

PLUGIN_WEATHERTIME_LIGHT_RAIN_WITH_THUNDER
	EN	Light Rain with Thunder
	FR	Pluie Légère avec Tonerre
	DE	Etwas Regen mit Gewitter
	NL	Lichte regen met onweer
	SE	Lätt regn med åska
	DA	Let regn med torden

PLUGIN_WEATHERTIME_LIGHT_DRIZZLE
	EN	Light Drizzle
	FR	Bruine Légère
	DE	Leichter Nieselregen
	NL	Lichte motregen
	SE	Lätt duggregn
	DA	Let småregn

PLUGIN_WEATHERTIME_DRIZZLE_LATE
	EN	Drizzle late
	FR	Bruine tard
	DA	Småregn sent
	NL	Later motregen

PLUGIN_WEATHERTIME_MIST
	EN	Mist
	FR	Brume
	DE	Nebel
	NL	Mist
	SE	Dimma
	DA	Tåget

PLUGIN_WEATHERTIME_SMOKE
	EN	Smoke
	FR	Fumée
	DE	Rauch
	NL	Smoke
	SE	Rök
	DA	Smog

PLUGIN_WEATHERTIME_HAZE
	EN	Haze
	FR	Brume
	DE	Dunst
	NL	Heiig
	SE	Dis
	DA	Hagl

PLUGIN_WEATHERTIME_LIGHT_SNOW_SHOWER
	EN	Light Snow Shower
	FR	Averse de Neige Légère
	DE	Leichte Schneeschauer
	NL	Lichte sneeuwbui
	SE	Lätt snöfall
	DA	Let sne

PLUGIN_WEATHERTIME_LIGHT_SNOW_SHOWER_WINDY
	EN	Light Snow Shower/ Windy
	FR	Averse de Neige Légère/ Venteux
	DE	Leichte Schneeschauer/Wind
	NL	Lichte sneeuwbui/winderig
	SE	Lätt snöfall / blåst
	DA	Let sne/blæst

PLUGIN_WEATHERTIME_CLEAR
	EN	Clear
	FR	Dégagé
	DE	Klar
	NL	Helder
	SE	Klart
	DA	Klart

PLUGIN_WEATHERTIME_MOSTLY_CLEAR
	EN	Mostly Clear
	FR	Plutôt Dégagé
	DE	Meist klar
	NL	Meestal helder
	SE	Mestadels klart
	DA	Mest klart

PLUGIN_WEATHERTIME_A_FEW_CLOUDS
	EN	A Few Clouds
	FR	Quelques Nuages
	DE	Wenige Wolken
	NL	Enkele wolken
	SE	enstaka moln
	DA	Enkelte skyer

PLUGIN_WEATHERTIME_FAIR
	EN	Fair
	FR	Agréable
	DE	Freundlich
	NL	Redelijk
	SE	Klart
	DA	Klart

PLUGIN_WEATHERTIME_PM_T-SHOWERS
	EN	PM Thundershowers
	FR	Orages PM
	DE	Nachm. gewittrige Schauer
	NL	Midd. onweersbui
	SE	Em. skurar med åska
	DA	Em. Tordenbyger

PLUGIN_WEATHERTIME_T-SHOWERS
	EN	Thundershowers
	FR	Orages
	DE	Gewittrige Schauer
	NL	Onweersbui
	SE	Åskskurar
	DA	Tordenbyger

PLUGIN_WEATHERTIME_T-SHOWERS_WIND
	EN	Thundershowers / Wind
	FR	Orages / Vent
	DE	Gewittrige Schauer/Wind
	NL	Onweersbui/winderig
	SE	Åskskurar
	DA	Tordenbyger/Blæst

PLUGIN_WEATHERTIME_T-STORMS_EARLY
	EN	Thunderstorms early
	FR	Orages en matinée
	DE	Anfangs Gewitter
	NL	Vroeg onweer
	SE	Tidiga åskskurar
	DA	Tidlig tordenbyger

PLUGIN_WEATHERTIME_LIGHT_RAIN_EARLY
	EN	Light Rain Early
	FR	Pluie légère en matinée
	DE	Anfangs leichter Regen
	NL	Vroeg lichte buien
	SE	Fm. duggregn
	DA	Fm. let regn

PLUGIN_WEATHERTIME_SUNNY_WIND
	EN	Sunny/Wind
	FR	Ensoleillé/Venteux
	DE	Sonnig/Wind
	NL	Zonnig/winderig
	SE	Soligt/blåst
	DA	Solrigt/Blæsende

PLUGIN_WEATHERTIME_FOGGY
	EN	Foggy
	FR	Brumeux
	DE	Nebelig
	NL	Mistig
	SE	Dimma
	DA	Tåge

PLUGIN_WEATHERTIME_PM_FOG
	EN	PM Fog
	FR	Brumeux après-midi
	DE	nachmittags Nebel
	NL	Na de middag mist
	SE	Em. dimma
	DA	Em. Tåge

PLUGIN_WEATHERTIME_AM_FOG_PM_SUN
	EN	AM Fog / PM Sun
	FR	AM Brume / PM Soleil
	DE	Vorm. Nebel/nachm. Sonne
	NL	Ocht. mist/midd. zon
	SE	Fm. dimma em. sol
	DA	Fm. Tåge/em. Sol

PLUGIN_WEATHERTIME_DRIZZLE_FOG
	EN	Drizzle/Fog
	FR	Bruine/Brume
	DE	Nieselregen/Nebel
	NL	Motregen / mist
	SE	Duggregn / dimma
	DA	Let småregn/Tåge

PLUGIN_WEATHERTIME_LIGHT_RAIN_FOG
	EN	Light Rain/Fog
	FR	Pluie Légère/Brume
	DE	Leichter Regen/Nebel
	NL	Lichte regen / mist
	SE	Duggregn / dimma
	DA	Let regn/tåge

PLUGIN_WEATHERTIME_AM_FOG_PM_CLOUDS
	EN	AM Fog / PM Clouds
	FR	AM Brume / PM Nuages
	DE	Vorm. Nebel/nachm. Wolken
	NL	Ocht. mistig / midd. bewolkt
	DA	Fm. Tåge/em. Skyet

PLUGIN_WEATHERTIME_WIND_0
	EN	m/s
	FR	m/s
	DE	m/s
	NL	m/s
	DA	m/s

PLUGIN_WEATHERTIME_WIND_1
	EN	km/h
	FR	km/h
	DE	km/h
	NL	km/h
	DA	km/t

PLUGIN_WEATHERTIME_WIND_2
	EN	mph
	FR	mi/h
	DE	mi/h
	NL	ml/h
	DA	m/t

PLUGIN_WEATHERTIME_WIND_NORTH
	EN	N
	FR	N
	DE	N
	NL	N
	DA	N

PLUGIN_WEATHERTIME_WIND_N
	EN	N
	FR	N
	DE	N
	NL	N
	DA	N

PLUGIN_WEATHERTIME_WIND_NNE
	EN	NNE
	FR	NNE
	DE	NNO
	NL	NNO
	DA	NNØ

PLUGIN_WEATHERTIME_WIND_NE
	EN	NE
	FR	NE
	DE	NO
	NL	NO
	DA	NØ

PLUGIN_WEATHERTIME_WIND_ENE
	EN	ENE
	FR	ENE
	DE	ONO
	NL	ONO
	DA	ØNØ

PLUGIN_WEATHERTIME_WIND_EAST
	EN	E
	FR	E
	DE	O
	NL	O
	DA	Ø

PLUGIN_WEATHERTIME_WIND_E
	EN	E
	FR	E
	DE	O
	NL	O
	DA	Ø

PLUGIN_WEATHERTIME_WIND_ESE
	EN	ESE
	FR	ESE
	DE	OSO
	NL	OZO
	DA	ØSØ

PLUGIN_WEATHERTIME_WIND_SE
	EN	SE
	FR	SE
	DE	SO
	NL	ZO
	DA	SØ

PLUGIN_WEATHERTIME_WIND_SSE
	EN	SSE
	FR	SSE
	DE	SSO
	NL	ZZO
	DA	SSØ

PLUGIN_WEATHERTIME_WIND_SOUTH
	EN	S
	FR	S
	DE	S
	NL	Z
	DA	S

PLUGIN_WEATHERTIME_WIND_S
	EN	S
	FR	S
	DE	S
	NL	Z
	DA	S

PLUGIN_WEATHERTIME_WIND_SSW
	EN	SSW
	FR	SSO
	DE	SSW
	NL	ZZW
	DA	SSV

PLUGIN_WEATHERTIME_WIND_SW
	EN	SW
	FR	SO
	DE	SW
	NL	ZW
	DA	SV

PLUGIN_WEATHERTIME_WIND_WSW
	EN	WSW
	FR	OSO
	DE	WSW
	NL	WZW
	DA	VSV

PLUGIN_WEATHERTIME_WIND_W
	EN	W
	FR	O
	DE	W
	NL	W
	DA	V

PLUGIN_WEATHERTIME_WIND_WEST
	EN	W
	FR	O
	DE	W
	NL	W
	DA	V

PLUGIN_WEATHERTIME_WIND_WNW
	EN	WNW
	FR	ONO
	DE	WNW
	NL	WNW
	DA	VNV

PLUGIN_WEATHERTIME_WIND_NW
	EN	NW
	FR	NO
	DE	NW
	NL	NW
	DA	NV

PLUGIN_WEATHERTIME_WIND_NNW
	EN	NNW
	FR	NNO
	DE	NNW
	NL	NNW
	DA	NNV

PLUGIN_WEATHERTIME_WIND_ALL
	EN	ALL
	FR	NSEO
	DE	NSOW
	NL	VAR
	DA	NSØV

PLUGIN_WEATHERTIME_SUNRISE
	EN	Sunrise
	FR	Lever du Soleil
	DE	Sonnenaufgang
	NL	Zonsopgang
	DA	Solopgang

PLUGIN_WEATHERTIME_SUNSET
	EN	Sunset
	FR	Coucher du Soleil
	DE	Sonnenuntergang
	NL	Zonsondergang
	DA	Solnedgang

PLUGIN_WEATHERTIME_HUMID
	EN	Humidity
	FR	Humidité
	DE	Luftfeuchtigkeit
	NL	Luchtvochtigheid
	DA	Luftfugtighed

PLUGIN_WEATHERTIME_WINDGUST
	EN	Windgust
	FR	Bourrasques
	DE	Böen
	NL	Windgust
	DA	Vindstød

PLUGIN_WEATHERTIME_CURRENTBAR
	EN	Pressure
	FR	Pression
	DE	Luftdruck
	NL	Druk
	DA	Tryk

PLUGIN_WEATHERTIME_CURRENTBAR_FALLING
	EN	Falling
	FR	Diminuant
	DE	Fallend
	NL	Vallend
	DA	Faldende

PLUGIN_WEATHERTIME_CURRENTBAR_RISING
	EN	Rising
	FR	Augmentant
	DE	Steigend
	NL	Stijgend
	DA	Stigende

PLUGIN_WEATHERTIME_CURRENTBAR_STEADY
	EN	Steady
	FR	Stable
	DE	Konstant
	NL	Stabiel
	DA	Stabilt

PLUGIN_WEATHERTIME_CURRENTBAR_N_A
	EN	N/A
	FR	N/D
	DE	Unbekannt
	NL	Onbekend
	DA	Ukendt

PLUGIN_WEATHERTIME_VISIBILITY
	EN	Visibility
	FR	Visibilité
	NL	Zicht
	DA	Sigtbarhed

PLUGIN_WEATHERTIME_UVINDEX
	EN	UV-index
	FR	Index-UV
	DE	UV-Index
	NL	UV-index
	DA	UV-index

PLUGIN_WEATHERTIME_UVINDEX_
	EN	Low
	FR	Bas
	DE	Niedrig
	NL	laag
	DA	Lavt

PLUGIN_WEATHERTIME_UVINDEX_LOW
	EN	Low
	FR	Bas
	DE	Niedrig
	NL	Laag
	DA	Lavt

PLUGIN_WEATHERTIME_MOON
	EN	Moon
	FR	Lune
	DE	Mond
	NL	Maan
	DA	Måne

PLUGIN_WEATHERTIME_MOON_NEW
	EN	New
	FR	Nouvelle
	DE	Neu
	NL	Nieuw
	DA	Ny

PLUGIN_WEATHERTIME_MOON_FULL
	EN	Full
	FR	Pleine
	DE	Voll
	NL	Vol
	DA	Fuld

PLUGIN_WEATHERTIME_MOON_FIRST_QUARTER
	EN	First quarter
	FR	Premier quart
	NL	Eerste kwart
	DA	Tiltagende (halv)

PLUGIN_WEATHERTIME_MOON_THIRD_QUARTER
	EN	Third quarter
	FR	Troisième quart
	NL	Derde kwart
	DA	Aftagende (halv)

PLUGIN_WEATHERTIME_MOON_WAXING_GIBBOUS
	EN	Waxing gibbous
	FR	Lune montante
	DA	Tiltagende (stor)

PLUGIN_WEATHERTIME_MOON_LAST_QUARTER
	EN	Last quarter
	FR	Dernier quart
	NL	Laatste kwart
	DA	Aftagende (lille)

PLUGIN_WEATHERTIME_MOON_WAXING_CRESCENT
	EN	Waxing crescent
	FR	Premier croissant
	DA	Tiltagende (lille) 

PLUGIN_WEATHERTIME_MOON_WANING_GIBBOUS
	EN	Waning gibbous
	FR	Lune descendante
	DA	Aftagende (stor)

PLUGIN_WEATHERTIME_MOON_WANING_CRESCENT
	EN	Waning crescent
	FR	Dernier croissant
	DA	Aftagende (lille)

PLUGIN_WEATHERTIME_FOG_LATE
	EN	Fog Late
	FR	Brume Tard
	DE	Abends Nebel
	NL	Avond mist
	DA	Aften tåge

PLUGIN_WEATHERTIME_FOGGY_WIND
	EN	Foggy / Wind
	FR	Brumeux / Venteux
	DE	Neblig / Wind
	NL	Mistig / wind
	DA	Tåge / Blæst

PLUGIN_WEATHERTIME_WIND_CALM
	EN	Wind Calm
	FR	Vent calme
	DE	Wind ruhig
	NL	Wind kalm
	DA	Let blæst

PLUGIN_WEATHERTIME_WIND_VAR
	EN	Wind variable
	FR	Vent variable
	DE	Wind variabel
	NL	Wind variabel
	DA	blæst skiftende

PLUGIN_WEATHERTIME_CHANCE_OF_RAIN
	EN	Chance of Rain
	FR	Risque de Pluie
	DE	Regen möglich
	NL	Kans op regen

PLUGIN_WEATHERTIME_SCATTERED_CLOUDS
	EN	Scattered Clouds
	DE	Teils wolkig
	FR	Partiellement nuageux
	NL	Halfbewolkt
	SE	Halvklart
	DA	Let skyet

PLUGIN_WEATHERTIME_OVERCAST
	EN	Overcast
	FR	Nuageux
	DE	Bewölkt
	NL	Bewolkt
	SE	Mulet
	DA	Skyet

PLUGIN_WEATHERTIME_CHANCE_OF_SNOW
	EN	Chance of Snow
	FR	Risque de Neige
	DE	Schnee möglich
	NL	Kans op sneeuw

PLUGIN_WEATHERTIME_CHANCE_OF_FREEZING_RAIN
	EN	Chance of Freezing Rain
	FR	Risque de Pluie verglaçante
	DE	Eisregen möglich
	NL	Kans op ijzel

PLUGIN_WEATHERTIME_CHANCE_OF_A_THUNDERSTORM
	EN	Chance of Thunder
	FR	Risque d\'Orages
	DE	Gewitter möglich
	NL	Kans op onweer
';}

1;
