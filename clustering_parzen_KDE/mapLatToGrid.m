function gridY = mapLatToGrid(y_Size,lat)
   
    gridsPerLat  = y_Size/(74.68126 -  73.98826);
    gridY = floor(gridsPerLat * (lat - 73.98826) );
end 
