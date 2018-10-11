
function [ orderedClusterLats,orderedClusterLongs ] = orderClockWise( clusterLats, clusterLongs)
%This function orders points clockwise 

    latMean = mean(clusterLats);
    longMean = mean(clusterLongs);
    
    a = atan2(clusterLats - latMean, clusterLongs - longMean);
   
    [~, order] = sort(a);
    
    
    orderedClusterLats = clusterLats(order);
    orderedClusterLongs = clusterLongs(order);

end