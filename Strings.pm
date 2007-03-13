package Plugins::WeatherTime::Strings;


sub strings { return '
PLUGIN_SCREENSAVER_WEATHERTIME
	DE	Wetter/Zeit Bildschirmschoner
	EN	Weather, Date and Time
	FR	Temp�rature, Date et Heure
	NL	Weer, datum en tijd

PLUGIN_SCREENSAVER_WEATHERTIME_START
	DE	PLAY drücken zum Starten des Bildschirmschoners
	EN	Press PLAY to start this screensaver
	FR	Appuyez sur PLAY pour activer cet �cran de veille
	NL	Druk op PLAY om deze schermbeveiliger aan te zetten

PLUGIN_SCREENSAVER_WEATHERTIME_ENABLE
	DE	PLAY drücken zum Aktivieren des Bildschirmschoners
	EN	Press PLAY to enable this screensaver
	FR	Appuyez sur PLAY pour activer cet �cran de veille
	NL	Druk op PLAY om deze schermbeveiliger aan te zetten

PLUGIN_SCREENSAVER_WEATHERTIME_DISABLE
	DE	PLAY drücken zum Deaktivieren dieses Bildschirmschoners
	EN	Press PLAY to disable this screensaver
	FR	Appuyer sur PLAY pour d�sactiver cet �cran de veille
	NL	Druk op PLAY om deze schermbeveiliger uit te zetten

PLUGIN_SCREENSAVER_WEATHERTIME_ENABLING
	DE	Wetter/Zeit Bildschirmschoner aktivieren
	EN	Enabling WeatherTime as current screensaver
	FR	Activation de WeatherTime comme �cran de veille actuel
	NL	Aanzetten van Weer, datum en tijd als huidige schermbeveiliger

PLUGIN_SCREENSAVER_WEATHERTIME_DISABLING
	DE	Standard-Bildschirmschoner deaktivieren
	EN	Resetting to default screensaver
	FR	Retour � l\'�cran de veille par d�faut
	NL	Herstellen standaard schermbeveiliger

PLUGIN_SCREENSAVER_WEATHERTIME_UPDATING
	DE	Aktualisiere aktuelle Wetterdaten...
	EN	Updating Weather Forecast...
	FR	Mise � jour des pr�visions m�t�o...
	NL	Bijwerken weersvoorspelling

PLUGIN_SCREENSAVER_NOSETUP_LINE1
	DE	Registrierung und/oder Setup erforderlich
	EN	Registration and/or Setup Required
	FR	Enregistrement et/ou configuration requis
	NL	Registratie en/of instellen noodzakelijk

PLUGIN_SCREENSAVER_NOSETUP_LINE2
	DE	Bei auf http://registration.weather.com/registration/xmloap/step1 registrieren und ID und Key in server settings eintragen.
	EN	Sign up at http://registration.weather.com/registration/xmloap/step1 and enter ID and Key in server settings.
	FR	Enregistrez-vous � http://registration.weather.com/registration/xmloap/step1 et entrez votre identification et cl� dans les param�tres de serveur.
	NL	Registeren bij http://registration.weather.com/registration/xmloap/step1 en enter ID en key in server instellingen

SETUP_GROUP_PLUGIN_WEATHERTIME
	DE	Wetter/Zeit Bildschirmschoner
	EN	Weather, Date and Time Screensaver
	FR	Ecran de veille Temp�rature, Date et Heure
	NL	Weer, datum en tijd schermbeveiliger

SETUP_GROUP_PLUGIN_WEATHERTIME_DESC
	EN	The weather data is retrieved from <i>The Weather Channel&reg;</i>. You need to sign up at http://registration.weather.com/registration/xmloap/step1 and enter ID and Key in server settings. To localize your forecast you also need to find out the weather.com citycode, e.g. GMXX0007 for Berlin, Germany. You can see the citycode in the URL of your local forecast on <i>weather.com&reg;</i>.
	FR	L\'information m�t�o est extraite de <i>The Weather Channel&reg;</i>. Vous devez vous inscrire � http://registration.weather.com/registration/xmloap/step1 et entrer identification et cl� dans les param�tres de serveur. Pour localiser vos pr�visions vous devez aussi d�terminer le code de ville de weather.com, par exemple CAXX0301 pour Montr�al, Canada. Vous pouvez voir le code de ville dans le URL de vos pr�visions locales sur <i>weather.com&reg;</i>.
	DE	Die Wetterdaten werden von <i>The Weather Channel&reg;</i> bezogen. Eine Registrierung unter http://registration.weather.com/registration/xmloap/step1 ist erforderlich, um die Partner ID und den Lizenzschlüssel zu erhalten. Der Citycode stammt ebenfalls von weather.com, zum Beispiel GMXX0007 für Berlin, und kann der URL des entsprechenden Wetterberichts auf <i>weather.com&reg;</i> entnommen werden.
	NL	Het weerbericht is opgehaald van  <i>The Weather Channel&reg;</i>. Je moet registreren bij http://registration.weather.com/registration/xmloap/step1 en vul je ID en Key in bij de Server instellingen. Om het weerbericht te localiseren heb je de citycode van weather.com nodig. Bijvoorbeeld NLXX0002 voor Amsterdam. Je kunt de citycode uit de URL halen als je het weerbericht voor de plaats opzoekt.

SETUP_PLUGIN_WEATHERTIME_UNITS
	EN	Weather Units
	FR	Unit�s M�t�o
	DE	Einheiten
	NL	Eenheden

SETUP_PLUGIN_WEATHERTIME_1
	EN	Metric Units
	FR	Unit�s M�triques
	DE	metrisch
	NL	Metrisch

SETUP_PLUGIN_WEATHERTIME_0
	EN	Imperial Units
	FR	Unit�s Imp�riales
	DE	englisch
	NL	Engels

SETUP_PLUGIN_WEATHERTIME_CITY
	EN	City
	FR	Ville
	DE	Name der Stadt
	NL	Plaatsnaam

SETUP_PLUGIN_WEATHERTIME_CITYCODE
	EN	Weather.com Citycode
	FR	Code de ville weather.com
	DE	Weather.com Citycode
	NL	Weather.com Citycode

SETUP_PLUGIN_WEATHERTIME_INTERVAL
	EN	Fetch Interval (seconds)
	FR	Intervalle de mise-�-jour (secondes)
	DE	Aktualisierungsintervall (sekunden)
	NL	Interval voor bijwerken in seconden

SETUP_PLUGIN_WEATHERTIME_PARTNER
	EN	Partner ID
	FR	Partner ID
	DE	Partner ID
	NL	Partner ID

SETUP_PLUGIN_WEATHERTIME_LICENSE
	EN	License Key
	FR	Cl� de License
	DE	Lizenzschlüssel
	NL	Licentiesleutel

SETUP_PLUGIN_WEATHERTIME_DATEFORMAT
	EN	Date format
	FR	Format des dates
	DE	Datumsformat
	NL	Datumformaat

SETUP_PLUGIN_WEATHERTIME_STDDATE
	EN	standard
	FR	standard
	DE	Standardformat
	NL	standaardformat

SETUP_PLUGIN_WEATHERTIME_NODATE
	EN	no date (time only)
	FR	sans date (heure seulement)
	DE	kein Datum (nur Zeit)
	NL	geen datum (alleen de tijd)

PLUGIN_SCREENSAVER_WEATHERTIME_NOINFO
	DE	Wetterdaten werden geladen
	EN	Weather Forecast loading
	FR	Chargement des pr�visions m�t�o
	NL	Laden weerbericht

PLUGIN_WEATHERTIME_NO_FORECAST_AVAILABLE
	DE	keine Vorhersage vorhanden
	EN	no forecast available
	FR	Pr�visions non disponibles
	NL	geen weerbericht beschikbaar

PLUGIN_WEATHERTIME_CURRENTTEMP
	DE	Jetzt
	EN	Now
	FR	Maintenant
	NL	Nu

PLUGIN_WEATHERTIME_TODAY
	DE	Heute
	EN	Today
	FR	Aujourd\'hui
	NL	Vandaag

PLUGIN_WEATHERTIME_TONIGHT
	DE	Nachts
	EN	Tonight
	FR	Ce soir
	NL	Vannacht

PLUGIN_WEATHERTIME_TOMORROW
	DE	Morgen
	EN	Tomorrow
	FR	Demain
	NL	Morgen

PLUGIN_WEATHERTIME_SUNDAY
	DE	Sonntag
	EN	Sunday
	FR	Dimanche
	NL	Zondag

PLUGIN_WEATHERTIME_MONDAY
	DE	Montag
	EN	Monday
	FR	Lundi
	NL	Maandag

PLUGIN_WEATHERTIME_TUESDAY
	DE	Dienstag
	EN	Tuesday
	FR	Mardi
	NL	Dinsdag

PLUGIN_WEATHERTIME_WEDNESDAY
	DE	Mittwoch
	EN	Wednesday
	FR	Mercredi
	NL	Woensdag

PLUGIN_WEATHERTIME_THURSDAY
	DE	Donnerstag
	EN	Thursday
	FR	Jeudi
	NL	Donderdag

PLUGIN_WEATHERTIME_FRIDAY
	DE	Freitag
	EN	Friday
	FR	Vendredi
	NL	Vrijdag

PLUGIN_WEATHERTIME_SATURDAY
	DE	Samstag
	EN	Saturday
	FR	Samedi
	NL	Zaterdag

PLUGIN_WEATHERTIME_NIGHT
	DE	Nachts
	EN	Night
	FR	Nuit
	NL	\'s Nachts

PLUGIN_WEATHERTIME_DAY
	DE	Tags�ber
	EN	Day
	FR	Jour
	NL	Overdag

PLUGIN_WEATHERTIME_HIGH
	DE	Max
	EN	High
	FR	Maximum
	NL	Max

PLUGIN_WEATHERTIME_LOW
	DE	Min
	EN	Low
	FR	Minimum
	NL	Min

PLUGIN_WEATHERTIME_PRECIP
	DE	Regen
	EN	Precip
	FR	Pr�cip
	NL	Regen

PLUGIN_WEATHERTIME_CLOUDY
	EN	Cloudy
	FR	Nuageux
	DE	bewölkt
	NL	zwaarbewolkt

PLUGIN_WEATHERTIME_MOSTLY_CLOUDY
	EN	Mostly Cloudy
	FR	Plut�t nuageux
	DE	meist bewölkt
	NL	bewolkt

PLUGIN_WEATHERTIME_PARTLY_CLOUDY
	EN	Partly Cloudy
	FR	Partiellement nuageux
	DE	teilw. bewölkt
	NL	halfbewolkt

PLUGIN_WEATHERTIME_LIGHT_RAIN
	EN	Light Rain
	FR	Pluie l�g�re
	DE	etwas Regen
	NL	enige regen

PLUGIN_WEATHERTIME_LIGHT_RAIN_WIND
	EN	Light Rain / Wind
	FR	Pluie l�g�re / Vent
	DE	etwas Regen, Wind
	NL	enige regen / winderig

PLUGIN_WEATHERTIME_SHOWERS
	EN	Showers
	FR	Averses
	DE	Schauer
	NL	buien

PLUGIN_WEATHERTIME_RAIN
	EN	Rain
	FR	Pluie
	DE	Regen
	NL	regen

PLUGIN_WEATHERTIME_AM_SHOWERS
	EN	AM Showers
	FR	Averses AM
	DE	Vorm. Schauer
	NL	ocht. buien

PLUGIN_WEATHERTIME_SHOWERS_EARLY
	EN	Showers early
	FR	Averses T�t
	DE	anfangs Schauer
	NL	vroeg buien

PLUGIN_WEATHERTIME_SHOWERS_LATE
	EN	Showers late
	FR	Averses Tard
	DE	abends Schauer
	NL	avond buien

PLUGIN_WEATHERTIME_FOG
	EN	Fog
	FR	Brouillard
	DE	Nebel
	NL	mist

PLUGIN_WEATHERTIME_FEW_SHOWERS
	EN	Few Showers
	FR	Quelques Averses
	DE	vereinzelte Schauer
	NL	enkele buien

PLUGIN_WEATHERTIME_MOSTLY_SUNNY
	EN	Mostly Sunny
	FR	Plut�t Ensoleill�
	DE	meist sonnig
	NL	vooral zonnig

PLUGIN_WEATHERTIME_SUNNY
	EN	Sunny
	FR	Ensoleill�
	DE	sonnig
	NL	zonnig

PLUGIN_WEATHERTIME_SCATTERED_FLURRIES
	EN	Scattered Flurries
	FR	Neige Passag�re
	DE	Böen aus wechselnder Richtung
	NL	lokaal buien

PLUGIN_WEATHERTIME_AM_CLOUDS_PM_SUN
	EN	AM Clouds/PM Sun
	FR	Nuageux AM / Soleil PM
	DE	Vorm. Wolken, nachm. Sonne
	NL	bewolkt later zonnig

PLUGIN_WEATHERTIME_CLOUDS_EARLY_CLEARING_LATE
	EN	Clouds Early / Clearing Late
	FR	Nuages T�t / Eclaircissements
	DE	anfangs Wolken / abends klar
	NL	bewolkt later opklaringen

PLUGIN_WEATHERTIME_ISOLATED_T-STORMS
	EN	Isolated T-Storms
	FR	Orages Isol�es
	DE	vereinzelte Gewitter
	NL	een enkele onweersbui

PLUGIN_WEATHERTIME_SCATTERED_THUNDERSTORMS
	EN	Scattered Thunderstorms
	FR	Orages Dispers�es
	DE	verteilte Gewitter
	NL	lokaal onweersbuien

PLUGIN_WEATHERTIME_SCATTERED_T-STORMS
	EN	Scattered Thunderstorms
	FR	Orages Dispers�es
	DE	verteilte Gewitter
	NL	lokaal onweersbuien

PLUGIN_WEATHERTIME_SCATTERED_SHOWERS
	EN	Scattered Showers
	FR	Averses Dispers�es
	DE	verteilte Schauer
	NL	lokaal buien

PLUGIN_WEATHERTIME_PM_SHOWERS
	EN	PM Showers
	FR	Averses PM
	DE	Nachm. Schauer
	NL	middag buien

PLUGIN_WEATHERTIME_PM_SHOWERS_WIND
	EN	PM Showers/Wind
	FR	Averses/Vent PM
	DE	Nachm. Schauer/Wind
	NL	midd. buien/winderig

PLUGIN_WEATHERTIME_RAIN_SNOW_SHOWERS
	EN	Rain/Snow Showers
	FR	Averses Pluie/Neige
	DE	Regen/Schneeschauer
	NL	regen/sneeuwbuien

PLUGIN_WEATHERTIME_FEW_SNOW_SHOWERS
	EN	Few Snow Showers
	FR	Quelques Averses de Neige
	DE	vereinzelte Schneeschauer
	NL	enkele sneeuwbuien

PLUGIN_WEATHERTIME_CLOUDY_WIND
	EN	Cloudy/Wind
	FR	Nuageux/Venteux
	DE	bewölkt/windig
	NL	zwaarbewolkt/winderig

PLUGIN_WEATHERTIME_FLURRIES_WIND
	EN	Flurries/Wind
	FR	Neige/Vent
	DE	böeig/windig
	NL	windvlagen

PLUGIN_WEATHERTIME_MOSTLY_CLOUDY_WINDY
	EN	Mostly Cloudy/Windy
	FR	Plut�t Nuageux/Venteux
	DE	meist bewölkt/windig
	NL	bewolkt/winderig

PLUGIN_WEATHERTIME_RAIN_THUNDER
	EN	Rain/Thunder
	FR	Pluie/Orages
	DE	Regen/Gewitter
	NL	regen/onweer

PLUGIN_WEATHERTIME_PARTLY_CLOUDY_WIND
	EN	Partly Cloudy/Wind
	FR	Partiellement Nuageux/Venteux
	DE	teilw. bewölkt/Wind
	NL	halfbewolkt/winderig

PLUGIN_WEATHERTIME_AM_RAIN_SNOW_SHOWERS
	EN	AM Rain/Snow Showers
	FR	Pluie/Averses de neige AM
	DE	Vorm. Regen/Schneeschauer
	NL	ocht. regen/sneeuwbui

PLUGIN_WEATHERTIME_LIGHT_RAIN_WIND
	EN	Light Rain/Wind
	FR	Pluie/Vents L�gers
	DE	leichter Regen/Wind
	NL	enige regen/winderig

PLUGIN_WEATHERTIME_SHOWERS_WIND
	EN	Showers/Wind
	FR	Averses/Vent
	DE	Schauer/Wind
	NL	buien/winderig

PLUGIN_WEATHERTIME_MOSTLY_SUNNY_WIND
	EN	Mostly Sunny/Wind
	FR	Plut�t Ensoleill�/Vent
	DE	meist sonnig/Wind
	NL	vooral zonnig/winderig

PLUGIN_WEATHERTIME_FLURRIES
	EN	Flurries
	FR	Neige
	DE	Böen
	NL	buien

PLUGIN_WEATHERTIME_RAIN_WIND
	EN	Rain/Wind
	FR	Pluie/Vent
	DE	Regen/Wind
	NL	regen/winderig

PLUGIN_WEATHERTIME_SCT_FLURRIES_WIND
	EN	Sct Flurries/Wind
	FR	Averses de Neige/Vent
	DE	verteilte, böeige Winde
	NL	lokaal buien/winderig

PLUGIN_WEATHERTIME_SCT_STRONG_STORMS
	EN	Sct Strong Storms
	FR	Fortes Temp�tes Dispers�es
	DE	verteilte, heftige Stürme
	NL	lokaal zware stormen

PLUGIN_WEATHERTIME_PM_T-STORMS
	EN	PM T-Storms
	FR	Orages PM
	DE	Nachm. Gewitter
	NL	midd. onweersbuien

PLUGIN_WEATHERTIME_T-STORMS
	EN	T-Storms
	FR	Orages
	DE	Gewitter
	NL	onweersbuien

PLUGIN_WEATHERTIME_THUNDERSTORMS
	EN	Thunderstorms
	FR	Orages
	DE	Gewitter
	NL	onweer

PLUGIN_WEATHERTIME_SUNNY_WINDY
	EN	Sunny/Windy
	FR	Ensoleill�/Venteux
	DE	sonnig/windig
	NL	zonnig/winderig

PLUGIN_WEATHERTIME_AM_THUNDERSTORMS
	EN	AM Thunderstorms
	FR	Orages AM
	DE	Vorm. Gewitter
	NL	ocht. onweersbuien

PLUGIN_WEATHERTIME_AM_RAIN
	EN	AM Rain
	FR	Pluie AM
	DE	Vorm. Regen
	NL	ochtend regen

PLUGIN_WEATHERTIME_ISO_T-Storms_WIND
	EN	Iso T-Storms/Wind
	FR	Orages/Vent Dispers�s
	DE	vereinzelte Gewitter/Wind
	NL	enkele onweersbui/winderig

PLUGIN_WEATHERTIME_RAIN_SNOW
	EN	Rain/Snow
	FR	Pluie/Neige
	DE	Regen/Schnee
	NL	regen/sneeuw

PLUGIN_WEATHERTIME_RAIN_SNOW_WIND
	EN	Rain/Snow/Wind
	FR	Pluie/Neige/Vent
	DE	Regen/Schnee/Wind
	NL	regen/sneeuw/winderig

PLUGIN_WEATHERTIME_SCT_T-STORMS_WIND
	EN	Sct T-Storms/Wind
	FR	Orages Dispers�es/Vent
	DE	verteilte Gewitter/Wind
	NL	lokaal onweersbui/winderig

PLUGIN_WEATHERTIME_AM_SHOWERS_WIND
	EN	AM Showers/Wind
	FR	Averses/Vent AM
	DE	Vorm. Schauer/Wind
	NL	ocht. buien/winderig

PLUGIN_WEATHERTIME_SCT_SNOW_SHOWERS
	EN	Sct Snow Showers
	FR	Averses de Neige Dispers�es
	DE	verteilte Schneeschauer
	NL	lokaal sneeuwbuien

PLUGIN_WEATHERTIME_SCATTERED_SNOW_SHOWERS
	EN	Scattered Snow Showers
	FR	Averses de Neige Dispers�es
	DE	verteilte Schneeschauer
	NL	lokaal sneeuwbuien

PLUGIN_WEATHERTIME_SNOW_TO_ICE_WIND
	EN	Snow to Ice/Wind
	FR	Neige � Glace/Vent
	DE	Schnee in Hagel überg./Wind
	NL	sneeuw tot hagel/winderig

PLUGIN_WEATHERTIME_SNOW_TO_RAIN
	EN	Snow to Rain
	FR	Neige � Pluie
	DE	Schnee in Regen überg.
	NL	sneeuw tot regen

PLUGIN_WEATHERTIME_AM_LIGHT_RAIN
	EN	AM Light Rain
	FR	Pluie L�g�re AM
	DE	Vorm. etwas Regen
	NL	ocht. enige regen

PLUGIN_WEATHERTIME_PM_LIGHT_RAIN
	EN	PM Light Rain
	FR	Pluie L�g�re PM
	DE	Nachm. etwas Regen
	NL	midd. enige regen

PLUGIN_WEATHERTIME_LIGHT_RAIN_LATE
	EN	Light Rain Late
	FR	Pluie L�g�re Tard
	DE	Abends etwas Regen
	NL	avond enige regen

PLUGIN_WEATHERTIME_RAIN_LATE
	EN	Rain Late
	FR	Pluie Tard
	DE	Abends Regen
	NL	avond regen

PLUGIN_WEATHERTIME_PM_RAIN
	EN	PM Rain
	FR	Pluie PM
	DE	Nachm. Regen
	NL	midd. regen

PLUGIN_WEATHERTIME_SNOW_SHOWERS
	EN	Snow Showers
	FR	Averses de Neige
	DE	Schneeschauer
	NL	sneeuwbuien

PLUGIN_WEATHERTIME_SNOW_SHOWER
	EN	Snow Shower
	FR	Averse de Neige
	DE	Schneeschauer
	NL	sneeuwbui

PLUGIN_WEATHERTIME_RAIN_TO_SNOW
	EN	Rain to Snow
	FR	Pluie � Neige
	DE	Regen in Schnee überg.
	NL	regen tot sneeuw

PLUGIN_WEATHERTIME_PM_RAIN_SNOW
	EN	PM Rain/Snow
	FR	Pluie/Neige PM
	DE	Nachm. Regen/Schnee
	NL	midd. regen/sneeuw

PLUGIN_WEATHERTIME_FEW_SHOWERS_WIND
	EN	Few Showers/Wind
	FR	Quelques Averses/Vent
	DE	wenige Schauer/Wind
	NL	enkele buien/winderig

PLUGIN_WEATHERTIME_SNOW_WIND
	EN	Snow/Wind
	FR	Neige/Vent
	DE	Schnee/Wind
	NL	sneeuw/winderig

PLUGIN_WEATHERTIME_PM_RAIN_SNOW_SHOWERS
	EN	PM Rain/Snow Showers
	FR	Averses de Pluie/Neige PM
	DE	Nachm. Regen/Schneeschauer
	NL	midd. regen/sneeuwbuien

PLUGIN_WEATHERTIME_PM_RAIN_SNOW_WIND
	EN	PM Rain/Snow/Wind
	FR	Pluie/Neige/Vent PM
	DE	Nachm. Regen/Schnee/Wind
	NL	midd. regen/sneeuw/winderig

PLUGIN_WEATHERTIME_RAIN_SNOW_SHOWERS_WIND
	EN	Rain/Snow Showers/Wind
	FR	Pluie/Averses de Neige/Vent
	DE	Regen/Schneeschauer/Wind
	NL	regen/sneeubuien/winderig

PLUGIN_WEATHERTIME_RAIN_SNOW_WIND
	EN	Rain/Snow/Wind
	FR	Pluie/Neige/Vent
	DE	Regen/Schnee/Wind
	NL	regen/sneeuw/winderig

PLUGIN_WEATHERTIME_LIGHT_SNOW
	EN	Light Snow
	FR	Neige L�g�re
	DE	etwas Schnee
	NL	lichte sneeuw

PLUGIN_WEATHERTIME_PM_SNOW
	EN	PM Snow
	FR	Neige PM
	DE	Nachm. Schnee
	NL	midd. sneeuw

PLUGIN_WEATHERTIME_FEW_SNOW_SHOWERS_WIND
	EN	Few Snow Showers/Wind
	FR	Quelques Averses de Neige/Vent
	DE	wenige Schneeschauer/Wind
	NL	enkele sneeuwbuien/winderig

PLUGIN_WEATHERTIME_LIGHT_SNOW_WIND
	EN	Light Snow/Wind
	FR	Neige/Vent L�ger
	DE	etwas Schnee/Wind
	NL	lichte sneeuw/winderig

PLUGIN_WEATHERTIME_WINTRY_MIX
	EN	Wintry Mix
	FR	M�lange Hivernal
	DE	Winter-Mix
	NL	winters

PLUGIN_WEATHERTIME_AM_WINTRY_MIX
	EN	AM Wintry Mix
	FR	M�lange Hivernal AM
	DE	Vorm. Winter-Mix
	NL	ocht. winters

PLUGIN_WEATHERTIME_HVY_RAIN_FREEZING_RAIN
	EN	Hvy Rain/Freezing Rain
	FR	Pluie Forte/Vergla�ante
	DE	heftiger/gefr. Regen
	NL	sterke (ijs)regen

PLUGIN_WEATHERTIME_AM_LIGHT_SNOW
	EN	AM Light Snow
	FR	Neige L�g�re AM
	DE	Vorm. etwas Schnee
	NL	ocht. enige sneeuw

PLUGIN_WEATHERTIME_RAIN_FREEZING_RAIN
	EN	Rain/Freezing Rain
	FR	Pluie/Pluie Vergla�ante
	DE	Regen/gefr. Regen
	NL	regen/ijsregen

PLUGIN_WEATHERTIME_T-STORMS_WIND
	EN	T-Storms/Wind
	FR	Orages/Vent
	DE	Gewitter/Wind
	NL	onweer/winderig

PLUGIN_WEATHERTIME_SPRINKLES
	EN	Sprinkles
	FR	Quelques Gouttes
	DE	Graupel
	NL	motregen

PLUGIN_WEATHERTIME_AM_SNOW_SHOWERS
	EN	AM Snow Showers
	FR	Averses de Neige AM
	DE	Vorm. Schneeschauer
	NL	ocht. sneeuwbuien

PLUGIN_WEATHERTIME_SNOW_SHOWERS_EARLY
	EN	Snow Showers Early
	FR	Averses de Neige T�t
	DE	anfangs Schneeschauer
	NL	vroeg sneeuwbuien

PLUGIN_WEATHERTIME_AM_CLOUDS_PM_SUN_WIND
	EN	AM Clouds/PM Sun/Wind
	FR	Nuages AM / Soleil/Vent PM
	DE	Vorm. Wolken/Nachm. Sonne/Wind
	NL	bewolkt later zon/winderig

PLUGIN_WEATHERTIME_AM_RAIN_SNOW_WIND
	EN	AM Rain/Snow/Wind
	FR	Pluie/Neige/Vent AM
	DE	Vorm. Regen/Schnee/Wind
	NL	ocht. regen/sneeuw/winderig

PLUGIN_WEATHERTIME_RAIN_TO_SNOW_WIND
	EN	Rain to Snow/Wind
	FR	Pluie � Neige/Vent
	DE	Regen in Schnee überg./Wind
	NL	regen tot sneeuw/winderig

PLUGIN_WEATHERTIME_SNOW_TO_WINTRY_MIX
	EN	Snow to Wintry Mix
	FR	Neige � M�lange Hivernal
	DE	Schnee in Winter-Mix überg.
	NL	sneeuw tot winters

PLUGIN_WEATHERTIME_PM_SNOW_SHOWERS_WIND
	EN	PM Snow Showers/Wind
	FR	Averses de Neige/Vent PM
	DE	Nachm. Schneeschauer/Wind
	NL	midd. sneeuwbuien/winderig

PLUGIN_WEATHERTIME_SNOW_AND_ICE_TO_RAIN
	EN	Snow and Ice to Rain
	FR	Neige et Glace � Pluie
	DE	Schnee und Hagel in Regen überg.
	NL	sneeuw/hagel tot regen

PLUGIN_WEATHERTIME_HEAVY_RAIN
	EN	Heavy Rain
	FR	Pluie Forte
	DE	heftiger Regen
	NL	zware buien

PLUGIN_WEATHERTIME_AM_RAIN_ICE
	EN	AM Rain/Ice
	FR	Pluie/Glace AM
	DE	Vorm. Regen/Hagel
	NL	ocht. regen/hagel

PLUGIN_WEATHERTIME_AM_SNOW_SHOWERS_WIND
	EN	AM Snow Showers/Wind
	FR	Averses de Neige/Vent AM
	DE	Vorm. Schneeschauer/Wind
	NL	ocht. sneeuwbuien/winderig

PLUGIN_WEATHERTIME_AM_LIGH_SNOW_WIND
	EN	AM Light Snow/Wind
	FR	Neige L�g�re/Vent AM
	DE	Vorm. etwas Schnee/Wind
	NL	ocht. lichte sneeuw/winderig

PLUGIN_WEATHERTIME_PM_LIGHT_RAIN_WIND
	EN	PM Light Rain/Wind
	FR	Pluie L�g�re/Vent PM
	DE	Nachm. etwas Regen/Wind
	NL	midd. lichte regen/winderig

PLUGIN_WEATHERTIME_AM_LIGHT_WINTRY_MIX
	EN	AM Light Wintry Mix
	FR	M�lange Hivernal L�ger AM
	DE	Vorm. leichter Winter-Mix
	NL	ocht. lichte winters

PLUGIN_WEATHERTIME_PM_LIGHT_SNOW_WIND
	EN	PM Light Snow/Wind
	FR	Neige L�g�re/Vent PM
	DE	Nachm. etwas Schnee/Wind
	NL	midd. lichte sneeuw/winderig

PLUGIN_WEATHERTIME_HEAVY_RAIN_WIND
	EN	Heavy Rain/Wind
	FR	Pluie/Vent Forts
	DE	heftiger Regen/Wind
	NL	zware regen/winderig

PLUGIN_WEATHERTIME_PM_SNOW_SHOWER
	EN	PM Snow Shower
	FR	Averse de Neige PM
	DE	Nachm. Schneeschauer
	NL	midd. sneeuwbui

PLUGIN_WEATHERTIME_PM_SNOW_SHOWERS
	EN	PM Snow Showers
	FR	Averses de Neige PM
	DE	Nachm. Schneeschauer
	NL	midd. sneeuwbuien

PLUGIN_WEATHERTIME_SNOW_SHOWERS_LATE
	EN	Snow Showers Late
	FR	Averses de Neige Tard
	DE	Abends Schneeschauer
	NL	avond sneeuwbui

PLUGIN_WEATHERTIME_RAIN_SNOW_SHOWERS_LATE
	EN	Rain / Snow Showers Late
	FR	Pluie / Averses de Neige Tard
	DE	Regen / Abends Schneeschauer
	NL	Regen later sneeuwbuien

PLUGIN_WEATHERTIME_SNOW_TO_RAIN_WIND
	EN	Snow to Rain/Wind
	FR	Neige � Pluie/Vent
	DE	Schnee in Regen überg./Wind
	NL	sneeuw tot regen/winderig

PLUGIN_WEATHERTIME_PM_LIGHT_RAIN_ICE
	EN	PM Light Rain/Ice
	FR	Pluie/Glace L�ger PM
	DE	Nachm. leichter Regen/Hagel
	NL	midd. lichte regen/hagel

PLUGIN_WEATHERTIME_SNOW
	EN	Snow
	FR	Neige
	DE	Schnee
	NL	sneeuw

PLUGIN_WEATHERTIME_AM_SNOW
	EN	AM Snow
	FR	Neige AM
	DE	Vorm. Schnee
	NL	ocht. sneeuw

PLUGIN_WEATHERTIME_SNOW_TO_ICE
	EN	Snow to Ice
	FR	Neige � Glace
	DE	Schnee in Hagel überg.
	NL	sneeuw tot hagel

PLUGIN_WEATHERTIME_WINTRY_MIX_WIND
	EN	Wintry Mix/Wind
	FR	M�lange Hivernal/Vent
	DE	Winter-Mix/Wind
	NL	winters/winderig

PLUGIN_WEATHERTIME_PM_LIGHT_SNOW
	EN	PM Light Snow
	FR	Neige L�g�re PM
	DE	Nachm. etwas Schnee
	NL	midd. enige sneeuw

PLUGIN_WEATHERTIME_AM_DRIZZLE
	EN	AM Drizzle
	FR	Bruine AM
	DE	Vorm. Nieselregen
	NL	ocht. motregen

PLUGIN_WEATHERTIME_STRONG_STORMS_WIND
	EN	Strong Storms/Wind
	FR	Fortes Temp�tes/Vent
	DE	starke Stürme/Wind
	NL	zware storm/winderig

PLUGIN_WEATHERTIME_PM_DRIZZLE
	EN	PM Drizzle
	FR	Bruine PM
	DE	Nachm. Nieselregen
	NL	middag motregen

PLUGIN_WEATHERTIME_DRIZZLE
	EN	Drizzle
	FR	Bruine
	DE	Nieselregen
	NL	motregen

PLUGIN_WEATHERTIME_AM_LIGHT_RAIN_WIND
	EN	AM Light Rain/Wind
	FR	Pluie/Vent L�gers AM
	DE	Vorm. etwas Regen/Wind
	NL	ocht. lichte regen/winderig

PLUGIN_WEATHERTIME_AM_RAIN_WIND
	EN	AM Rain/Wind
	FR	Pluie/vent AM
	DE	Vorm. Regen/Wind
	NL	ocht. regen/winderig

PLUGIN_WEATHERTIME_WINTRY_MIX_TO_SNOW
	EN	Wintry Mix to Snow
	FR	M�lange Hivernal � Neige
	DE	Winter-Mix in Schnee überg.
	NL	winters tot sneeuw

PLUGIN_WEATHERTIME_SNOW_SHOWERS_WINDY
	EN	Snow Showers/Windy
	FR	Averses de Neige/Venteux
	DE	Schneeschauer/Wind
	NL	sneeuwbuien/winderig

PLUGIN_WEATHERTIME_LIGHT_RAIN_SHOWER
	EN	Light Rain Shower
	FR	Averse de Pluie L�g�re
	DE	leichte Regenschauer
	NL	lichte regenbui

PLUGIN_WEATHERTIME_LIGHT_RAIN_WITH_THUNDER
	EN	Light Rain with Thunder
	FR	Pluie L�g�re avec Tonerre
	DE	etwas Regen mit Donner
	NL	lichte regen met donder

PLUGIN_WEATHERTIME_LIGHT_DRIZZLE
	EN	Light Drizzle
	FR	Bruine L�g�re
	DE	leichter Nieselregen
	NL	lichte motregen

PLUGIN_WEATHERTIME_MIST
	EN	Mist
	FR	Brume
	DE	Nebel
	NL	mist

PLUGIN_WEATHERTIME_SMOKE
	EN	Smoke
	FR	Fum�e
	DE	Rauch
	NL	smoke

PLUGIN_WEATHERTIME_HAZE
	EN	Haze
	FR	Brume
	DE	Dunst
	NL	heiig

PLUGIN_WEATHERTIME_LIGHT_SNOW_SHOWER
	EN	Light Snow Shower
	FR	Averse de Neige L�g�re
	DE	leichte Schneeschauer
	NL	lichte sneeuwbui

PLUGIN_WEATHERTIME_LIGHT_SNOW_SHOWER_WINDY
	EN	Light Snow Shower/ Windy
	FR	Averse de Neige L�g�re/ Venteux
	DE	leichte Schneeschauer/Wind
	NL	lichte sneeuwbui/winderig

PLUGIN_WEATHERTIME_CLEAR
	EN	Clear
	FR	D�gag�
	DE	Klar
	NL	helder

PLUGIN_WEATHERTIME_MOSTLY_CLEAR
	EN	Mostly Clear
	FR	Plut�t D�gag�
	DE	Meist klar
	NL	meestal helder

PLUGIN_WEATHERTIME_A_FEW_CLOUDS
	EN	A Few Clouds
	FR	Quelques Nuages
	DE	wenige Wolken
	NL	enkele wolken

PLUGIN_WEATHERTIME_FAIR
	EN	Fair
	FR	Agr�able
	DE	Freundlich
	NL	redelijk

PLUGIN_WEATHERTIME_PM_T-SHOWERS
	EN	PM T-Showers
	FR	Orages PM
	DE	Nachm. gewittrige Schauer
	NL	midd. onweersbui

PLUGIN_WEATHERTIME_T-SHOWERS
	EN	T-Showers
	FR	Orages
	DE	gewittrige Schauer
	NL	onweersbui

PLUGIN_WEATHERTIME_T-SHOWERS_WIND
	EN	T-Showers / Wind
	FR	Orages / Vent
	DE	gewittrige Schauer/Wind
	NL	onweersbui/winderig

PLUGIN_WEATHERTIME_T-STORMS_EARLY
	EN	T-Storms early
	FR	Orages en matin�e
	DE	anfangs Gewitter
	NL	vroeg onweer

PLUGIN_WEATHERTIME_LIGHT_RAIN_EARLY
	EN	Light Rain Early
	FR	Pluie l�g�re en matin�e
	DE	anfangs leichter Regen
	NL	vroeg lichte buien

PLUGIN_WEATHERTIME_SUNNY_WIND
	EN	Sunny/Wind
	FR	Ensoleill�/Venteux
	DE	sonnig/Wind
	NL	zonnig/winderig
';}


1;
