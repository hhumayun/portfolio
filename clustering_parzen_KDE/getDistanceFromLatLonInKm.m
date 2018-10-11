function d = getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) 

  R = 6371; 
dlat = degtorad(lat2 - lat1);
dlon = degtorad(lon2 - lon1);
a = (sin(dlat/2)).^2 + cos(degtorad(lat1)).* cos(degtorad(lat2)).* (sin(dlon/2)).^2 ;
c = 2 * atan2( sqrt(a), sqrt(1-a) ) ;
d = 6371 * c ;

end




