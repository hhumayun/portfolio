function gridX = mapLongToGrid(x_Size,long)
    gridsPerLong = x_Size/(31.74310 -  31.1850);
    gridX = floor(gridsPerLong * (long - 31.1850));
end
