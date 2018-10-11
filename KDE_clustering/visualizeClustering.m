function  visualizeClustering(ar_mode,ranking,contours,x,id,cluster_algo,crime_type,address,append,clusterfile,pointsfile)
% Function to visualize 2D clustering
% ar_mode: Pointer array to mode
% x:       Dataset

[a,b,ar] = unique(ar_mode);
ar;
x;
c = lines(length(x));


%struture to store convHulls
convHulls = struct('Geometry','Polygon','X',[],'Y',[]);

%A = imread('Map New z 15.png');

%{
finalfig = figure, hold on;


if(size(x,1)==2)
    plot(x(1,:), x(2,:),'r.');
else
    plot3(x(1,:), x(2,:),x(3,:),'r.');
end
%}

clusterSize = randn(length(x),1);

%for JSON output -
clusters = struct('id',[],'rank',[],'polygon',struct('lat',[],'long',[]), 'points',struct('id',[],'lat',[],'long',[]),'name','crimeType');


%remove the zero cluster  - i.e. points that didnt clusters
a = a( a > 0);

for ci = 1:length(a)
    
    cur_cluster = x(:,ar_mode == a(ci));
    points_id = id(ar_mode == a(ci));
    cluster_addresses = address(ar_mode == a(ci));
    
    q = cur_cluster(1,:);
    w = cur_cluster(2,:);
    
    
    g = size(cur_cluster);
    if (g(2) > 10)
        f = 0;
    end
    
    
    [contours(a(ci)).lat, contours(a(ci)).long] = orderClockWise(contours(a(ci)).lat,contours(a(ci)).long);
  
    
    clusters(ci).id = a(ci);
%    clusters(ci).rank = max(ranking(ranking(:,1) == a(ci),2));
    clusters(ci).polygon.lat = contours(a(ci)).lat' ;
    clusters(ci).polygon.long = contours(a(ci)).long';
    clusters(ci).points.id = points_id;
    clusters(ci).points.lat  = w ;
    clusters(ci).points.long = q ;
    clusters(ci).crimeType = crime_type;

    cName = getClusterName(clusters(ci),cluster_addresses);
    uniqueClusterId = strcat(num2str(crime_type),'0',num2str(clusters(ci).id));

    if (strcmpi(cName,'') == 1)
        clusters(ci).name = uniqueClusterId;
    else
        clusters(ci).name = cName;
    end 
    
    
    convHulls(ci).Geometry = 'Polygon';
    %convHulls(ci).X = q;
    %convHulls(ci).Y = w;
    convHulls(ci).X = contours(a(ci)).long;
    convHulls(ci).Y = contours(a(ci)).lat;
    
    q = contours(a(ci)).long;
    w = contours(a(ci)).lat;
    
    
    clusterSize(ar_mode == a(ci)) = length(cur_cluster);
    
    %write cluster id, name and coordinates, current cluster to file
    
    %polygon string
    
    writeClusters(clusters(ci),clusterfile,pointsfile);
    
    try
        K = convhull(contours(a(ci)).long, contours(a(ci)).lat);
    catch
        continue;
    end
    
    %plot(q(K),w(K), 'LineWidth',1,'Color',c(ci,:))
    %plot(contours(a(ci)).long, contours(a(ci)).lat,'LineWidth',1,'Color',c(ci,:))
end


%savejson('/Users/hamzahumayun/Desktop/TPI/police/clustering/parzen',clusters,'json');

l = x';
artemp = ar';

numPoints = length(id);
cluster_algo_vec = cluster_algo*ones(numPoints,1);
crime_type_vec = crime_type*ones(numPoints,1);


tosave = [id l(:,1) l(:,2)  artemp' ranking clusterSize cluster_algo_vec crime_type_vec];

if (append)
    dlmwrite(strcat('results5_',num2str(crime_type),'.csv'), tosave, 'delimiter', ',', 'precision', 9,'-append');
else
    dlmwrite(strcat('results5_',num2str(crime_type),'.csv'), tosave, 'delimiter', ',', 'precision', 9,'-append');
end

