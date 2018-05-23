## Feed Name
nww_snotel

##Title
National Resource Conservation Service (NRCS) SNOTEL

##Feed ID
8A

##Acquisition Site
http://www.wcc.nrcs.usda.gov/awdbWebService/services?WSDL
#For web interface:
http://www.wcc.nrcs.usda.gov/snow/

##Login User
None

##USACE Point of Contact(s)
Gene Spangrude, gene.r.spangrude@usace.army.mil, 509-527-7447

##Agency Points of Contact(s)
Rashawn Tama, rashawn.tama@por.usda.gov, 503-414-3010

##Feed Path
/usr/da/nww/snotel

##Acquisition Interval
Hourly script at :25
Daily script at 00:50,06:50,10:50

##Description
This feed gathers standard SNOTEL sensor data from the NRCS for stations that NWW use for seasonal volumne forecasts and water studies.

##Additional Details
This feed uses NRCS' web service which works off of SOAP calls and outputs which is not condusive for manual web interface, use the second acquisition site link for manual queries.