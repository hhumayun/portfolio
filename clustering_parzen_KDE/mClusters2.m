function [pointLabels,ranking,contours] = mClusters(x,roads,sigma,thToMax,x_km,y_km)

    temp = 0;

    n = length(x(:,1));
    %with current data km along long =  58.2906km
    %current data along lat - 52.9297
    
    gridSizeLong = 5000 ; 
    gridSizeLat = floor(gridSizeLong * x_km/y_km); %about 11% 'wider' than long
    
    roads = roads';

    lhr = zeros(gridSizeLong+2,gridSizeLat+2);
    %roads = imresize(roads,gridSizeLat+2,gridSizeLong+2);
    %imagesc(roads);

    long = x(:,1);
    lat = x(:,2);

    extentLatLong = struct('minLat',min(lat),'maxLat',max(lat),'minLong',min(long),'maxLong',max(long));
%    extentLatLong = struct('minLat',31.2291,'maxLat',31.6468,'minLong',74.2281,'maxLong',74.4449);
    

    longInd = zeros(gridSizeLong + 2 ,1);
    latInd = zeros(gridSizeLat + 2,1);

    longInd(1:n) = 1 + floor(((long-min(long)) / (max(long) - min(long))) * (gridSizeLong)) ;
    latInd(1:n) =  1 + floor(((lat-min(lat)) / (max(lat) - min(lat))) * (gridSizeLat)) ;

    longPerGrid = (extentLatLong.maxLong - extentLatLong.minLong)/gridSizeLong;
    latPerGrid = (extentLatLong.maxLat - extentLatLong.minLat )/gridSizeLat;
    
 
    %assign points to lat/long index 
    for i = 1:n
        if (latInd(i) > 0 && longInd(i) > 0) 
            lhr(longInd(i),latInd(i)) = lhr(longInd(i),latInd(i)) + 1;
        end
    end

    %parzen_grid

    pointLabels = zeros(length(x),2);
    
    [labeledClusters] = parzen_grid(0,lhr,sigma,extentLatLong,latPerGrid,longPerGrid);

    contours = getClusterContours(labeledClusters,extentLatLong.minLat,extentLatLong.minLong,latPerGrid,longPerGrid);
   
    ranking = zeros(length(x),1);

    for i = 1:length(x)
            clusterNumber = labeledClusters(longInd(i),latInd(i));
            pointLabels(i,1) = clusterNumber;
            ranking(i,1) = clusterNumber;
            ranking(i,2) = 2 ;%clusterRanking(clusterRanking(:,1) == clusterNumber,2);
    end

    %some points not clustered - assign them random numbers so convex hull can 
    % be properly drawn
    clusters = pointLabels(:,1);
    %notClustered = rand(size(clusters(clusters==0)))*100000000;

    %clusters (clusters == 0 ) = round(notClustered);
    pointLabels(:,1) = clusters;
end


% %pointLabel = labeledClusters((latInd-1)*(gridSize+2) + longInd);

