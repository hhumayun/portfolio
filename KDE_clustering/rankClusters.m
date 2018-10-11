function [clusterRanking, contourLatLong] = rankClusters(pEst,labeledClusters,contours)

    tStart=tic;
    clusters = unique(labeledClusters);
    numClusters = size(clusters);
    
    contourLatLong  = zeros(numClusters);
    maxValues = zeros(numClusters);
    volume = zeros(numClusters);
    
    for i = 1:numClusters(1)
        if (clusters(i) ~= 0)
           
           
            curProb = pEst(labeledClusters == clusters(i));
           
            %CHANGE NEEDED
            maxValues(i) = max(max(curProb));
            volume(i) = length(curProb);
        
        end
    end 
    
    clusterRanking = [clusters volume maxValues];
    tElapsed = toc(tStart);
    disp(strcat(text, ' rank took','" "', num2str(tElapsed)));

end