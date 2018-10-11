function [contourLatLong ] = getClusterContours(labeledClusters,minLat,minLong,latPerGrid,longPerGrid)
%UNTITLED3 get the contours of a cluster given labelled cluster grid


    tStart=tic;
    t = imdilate(labeledClusters,strel(ones(3)));
    contours =  t - labeledClusters;
    
    
    gridSize = size(labeledClusters);
    clusters = unique(contours);
    
    %remove the zero cluster
    clusters = clusters(clusters>0);

    numClusters = size(clusters);
    
    %allocate structure for storing contours
    contourLatLong = struct('id',[],'lat',[],'long',[]);
    
    disp(strcat(text, 'Number clusters','" "', num2str(numClusters)));
    
    for i = 1:numClusters(1)
        if (clusters(i) ~= 0)
            [longInd,latInd] = find(contours == clusters(i));
            
            contourLatLong(i).id = clusters(i);
            contourLatLong(clusters(i)).id = clusters(i);
            
            
            clusterLat = latInd*latPerGrid    ;
            clusterLong = longInd*longPerGrid ;
            
            
            contourLatLong(clusters(i)).lat = clusterLat + minLat + 0.5*latPerGrid;
            contourLatLong(clusters(i)).long = clusterLong + minLong + 1.2*longPerGrid;

        end
    end
    
       tElapsed = toc(tStart);
    disp(strcat(text, ' contours took','" "', num2str(tElapsed)));
end

