function  writeClusters( cluster,clusterfile,pointfile)

prexml = '<Polygon><outerBoundaryIs><LinearRing><coordinates>';
postxml = '</coordinates></LinearRing></outerBoundaryIs></Polygon>';

polyLat = cluster.polygon.lat;
polyLong = cluster.polygon.long;

polyString = '';

length(polyLat) 

if (length(cluster.points.lat) >= 15 && length(polyLat) >= 5 )
     
    try         
        K = convhull(polyLat,polyLong);
        polyLat = cluster.polygon.lat(K);
        polyLong = cluster.polygon.long(K);
    catch
        
    end 
    
    
    numPoints = length(polyLat);
    
    for i = 1:numPoints
        if (i == 1)
            polyString = strcat(polyString,num2str(polyLat(i),10),',',num2str(polyLong(i),10),',0');
        else
            polyString = strcat([polyString ' ' num2str(polyLat(i),10) ',' num2str(polyLong(i),10) ',0']);
        end
    end
    
    polyString = strcat (prexml,polyString,postxml);
    %<Point><coordinates>74.214661,31.413427,0</coordinates></Point>
    
    uniqueClusterId = strcat(num2str(cluster.crimeType),'0',num2str(cluster.id));
    
    pointLats = cluster.points.lat;
    pointLongs = cluster.points.long;
    
    prexml = '<Point><coordinates>';
    postxml = '</coordinates></Point>';
    pointString = prexml;
    
    %discard clusters less than 4 in size
    if (length(pointLats) > 3)
        fprintf(clusterfile,'%s\t',num2str(uniqueClusterId));
        fprintf(clusterfile,'%s\t',cluster.name);
        fprintf(clusterfile,'%s\t',polyString);
        fprintf(clusterfile,'%s\t',num2str(length(polyLat)));
        fprintf(clusterfile,'%s\n',strcat(' ',num2str(cluster.crimeType)));
        for i = 1:length(pointLats)
            pointString = prexml;
            pointString = strcat(pointString,num2str(pointLongs(i),10),',',num2str(pointLats(i),10));
            pointString = strcat(pointString,postxml);
            fprintf(pointfile,'%s\t',num2str(uniqueClusterId));
            fprintf(pointfile,'%s\t',num2str(cluster.points.id(i)));
            fprintf(pointfile,'%s\t',num2str(num2str(cluster.crimeType)));
            fprintf(pointfile,'%s\t',cluster.name);
            fprintf(pointfile,'%s\n',strcat(' ',pointString));
        end
    end
end
end

