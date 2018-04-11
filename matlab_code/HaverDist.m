function haverDist = meanHaverDist(lat1,lon1,lat2,lon2)

R = 6371;                                          % Earth's radius in km
lat=abs(lat1-lat2)*pi/180;                  % difference in latitude
lon=abs(lon1-lon2)*pi/180;                  % difference in longitude
	lat1=lat1*pi/180;
	lat2=lat2*pi/180;

a = sin(lat/2).*sin(lat/2)+cos(lat1).*cos(lat2).*sin(lon/2).*sin(lon/2);
d = 2.*atan2(sqrt(a),sqrt(1-a));

haverDist = R.*d;
    

end