    function [labeledClusters] = parzen_grid(iteration,grid,sigma,extentLatLong,latPerGrid,longPerGrid)
    global maxClustNum ;

    maxClustNum = maxClustNum + 13

    iteration = iteration + 1 
    
    
    disp(strcat(text, 'Entering iteration','" "', num2str(iteration)));
    grid_size  = size(grid);

    
    size_x = grid_size(1);
    size_y = grid_size(2);
    hWin = 50;
    

    g = exp(-((-hWin:hWin).^2)/(2*sigma.^2)); 
    g = g' * g;
    pEst = conv2(grid, g, 'same');
    
    labeledClusters  = bwlabel(pEst >  5);imagesc(labeledClusters);
    
    maxClustNum = max(maxClustNum,max(max(labeledClusters) ));
    
    contours = getClusterContours(labeledClusters,extentLatLong.minLat,extentLatLong.minLong,latPerGrid,longPerGrid);
    
    [clusterRanking,~] = rankClusters(pEst,labeledClusters,contours);

    %cluster ranking 
    rankedClusterNumbers = clusterRanking(:,1);
    
    %update used cluster numbers
    
    
    %find all clusters with a greater than 12 grids
    % clusterRanking(2,:) has the number of grids of the cluster
    overSizedClusters = rankedClusterNumbers(find(clusterRanking(:,2) > 5000));

    contours = removeOverSizeContours(contours,overSizedClusters);    
    
    for i = 1:length(overSizedClusters)
        %find the row and cols of the ith oversized cluster
        curOverSizeCluster = overSizedClusters(i);
        
        disp(strcat(text, 'Dealing with custer ','" "', num2str(i)));

        [big_clust_row, big_clust_col ]= find ( labeledClusters == curOverSizeCluster );

        %number of rows in new grid
        new_grid_rows = max(big_clust_row) - min(big_clust_row) + 1;
        new_grid_cols = max(big_clust_col) - min(big_clust_col) + 1;

        min_row = min(big_clust_row);
        max_row = max (big_clust_row);
        min_col = min(big_clust_col);
        max_col = max(big_clust_col);

        % new smaller grid which we will now cluster 
        new_grid = grid(min_row:max_row,min_col:max_col);

        %new_label is the smaller labelled clusters grid we will use this as a
        %reference to set grid cells not in this cluster to zero 
        new_label = labeledClusters (min(big_clust_row):max(big_clust_row),min(big_clust_col):max(big_clust_col));

        %no copy row and column 
        [row_nc col_nc ]  = find(new_label ~= curOverSizeCluster) ;
        [row_c col_c ]  = find(new_label == curOverSizeCluster) ;
        
        %if part of another cluster we don't want to touch that
        new_grid( find (new_label ~= curOverSizeCluster) ) = 0 ; 

        %multiply by rand to avoid conflicts with already existing cluster
        %names. This can definetely be improved - consider using a global
        %static that keeps track of the maximum cluster number assigned so
        %far
        %recursize call to parzen_grid
        new_clust_grid = parzen_grid(iteration,new_grid,sigma/1.001,extentLatLong,latPerGrid,longPerGrid);
        
        %set cluster numbers to atleast 
        maxClustNum = maxClustNum + 10
        
        new_clust_grid(new_clust_grid ~= 0) = new_clust_grid(new_clust_grid ~= 0)  + maxClustNum;%floor(rand*100);
        
        row_size = max_row - min_row  + 1;
        col_size = max_col - min_col + 1; 
        
        tStart=tic;

        %update labeled clusters grid 
        disp(strcat(text, 'Enter udpate cluster ',''));

        row_c_lab_clust = row_c + min_row - 1;
        col_c_lab_clust = col_c + min_col - 1 ;
        
        ind_lab_clust = sub2ind(size(labeledClusters),row_c_lab_clust,col_c_lab_clust); 
        
        ind_new_clust = sub2ind(size(new_clust_grid),row_c,col_c);
        
        
        labeledClusters(ind_lab_clust) = new_clust_grid(ind_new_clust);
        
        tElapsed = toc(tStart);
        
        disp(strcat(text, 'Udpating cluster took ','" "', num2str(tElapsed )));
%        

   end
    disp(strcat(text, 'Exiting iteration','" "', num2str(iteration)));
    
end
