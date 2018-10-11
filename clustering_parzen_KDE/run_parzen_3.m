% Simple example to tool around with
% Two Gaussian distributions of sigma = 1, centered on (0,0) and (5,5)
% Results for one iteration and for the complete algorithm are shown

clear;

clust_count = 0 ;
%sigma = 0.000075; % murder
%sigma = 0.00006; %at murder
%sigma = 0.0001; %hurt
%sigma = 0.00003; %kidnap no cluster
%sigma =  0.000007; %mctheft
%sigma = 0.00003; %burglary
%sigma = 0.00003; %burglary
%sigma = 0.000008; %robbery
%sigma = 0.000009; %other v
%sigma = 0.000007; %other v
%sigma = 0.000003; % BandWid_use default 6000
% sigma = 1;
global maxClustNum ;
maxClustNum = 0;

% 1 murder
% 2 at murder
% 3 hurt
% 4 kidnap
% 5 robbery
% 6 burglary
% 7 dacoity
% 8 vehicle snatching
% 9 mctheft
% 10 otherv theft; %other v

murder = 1;
att_murder = 2;
hurt = 3;
kidnap = 4;
robbery = 5;
burglary = 6;
dacoity = 7;
vSnatching = 8;
mcTheft = 9;
ovTheft = 10;
vTheft = 910;
violentProperty = 578;
againstPerson = 1234;
all = 12345678910;
againstProp = 5678910;

crimeTypes = [murder;att_murder;hurt;kidnap;robbery;burglary;dacoity;vSnatching;mcTheft;ovTheft;vTheft;violentProperty;againstPerson;all;againstProp];

clusterfile = fopen ('clusters.csv','w');
pointsfile = fopen ('points.csv','w');

%this will be usd when setting cluster ids 


sigma = 0.025
    

%{
sigmaPerson = 0.065;
sigmaViolent =  0.06;
sigmaBurglary = 0.0575;
sigmaVTheft = 0.028;
sigmaAll = 0.0259;
sigmaProp  = 0.0259041;
sigmaValues = zeros(13,1);
%}

sigmaPerson = 8;
sigmaViolent =  20;
sigmaBurglary = 20;
sigmaVTheft = 20 ;
sigmaAll = 4 ;
sigmaProp  = 4 ;
sigmaValues = zeros(13,1);

sigmaValues(1:4) = sigmaPerson;
sigmaValues(5) =   sigmaViolent;
sigmaValues(6) = sigmaBurglary;
sigmaValues(7) = sigmaViolent;
sigmaValues(8) = sigmaViolent;
sigmaValues(9:10) = sigmaVTheft;
sigmaValues(11) =  sigmaVTheft;
sigmaValues(12) =  sigmaViolent;
sigmaValues(13) =  sigmaPerson;
sigmaValues(14) =  sigmaAll;
sigmaValues(15) =  sigmaProp;

MEDOID = 1;
HIER = 2;
PARZEN = 3;
KMEANS = 4;

d = textread('firdata8.csv','%s' ,'delimiter' , ',' );

id = str2double(d(1:8:end));
lat = str2double(d(6:8:end));
lng = str2double(d(5:8:end));
crime = str2double(d(7:8:end));
address = d(8:8:end);
thana = d(3:8:end);
division = d(4:8:end);

cluster = 3;
%run through cluster algorithms = 1,2,3 => medoid, hierarchical parzen

maxLat  = 31.647022;
minLat = 31.2034;

maxLong = 74.444891;
minLong = 74.227911;

filter = lat < maxLat & lng < maxLong & lat > minLat & lng > minLong;

lat = lat(filter);
lng = lng(filter);
id = id(filter);
crime = crime(filter);
address = address(filter);
thana = thana(filter);
division = division(filter);

extentLatLong = struct('minLat',0,'maxLat',0,'minLong',0,'maxLong',0);

extentLatLong.minLat = min(lat);
extentLatLong.maxLat = max(lat);

extentLatLong.minLong = min(lng);
extentLatLong.maxLong = max(lng);

for crime_Type = 15:15%length(crimeTypes)    
    if (crime_Type == 14)
        continue;
    end
    
    sigma = sigmaValues(crime_Type);
    id_use = getCrimeList(crimeTypes(crime_Type),crime,id);
    lat_use = getCrimeList(crimeTypes(crime_Type),crime,lat);
    lng_use = getCrimeList(crimeTypes(crime_Type),crime,lng);
    crime_use = getCrimeList(crimeTypes(crime_Type),crime,crime);
    thana_use = getCrimeList(crimeTypes(crime_Type),crime,thana);
    division_use = getCrimeList(crimeTypes(crime_Type),crime,division);
    location_use = getCrimeList(crimeTypes(crime_Type),crime,address);
    
    N = length(id_use);
    x = randn(2,N);
    
    for R = 1:N
        x(1,R) = lat_use(R);
        x(2,R) = lng_use(R);
    end
    
    x_km = distLatLongKM(extentLatLong.minLat,extentLatLong.minLong,extentLatLong.minLat,extentLatLong.maxLong) ;
    y_km = distLatLongKM(extentLatLong.minLat,extentLatLong.minLong,extentLatLong.maxLat,extentLatLong.minLong) ;
    
    text= ' ' ;
    
    tstart =  0   ;
    tElapsed = 0  ;
    
    %orig 0.055 sigma 
    tStart=tic;
    roads = aligngrid('roads_lahore_raster1.tif',extentLatLong);
    
    disp(strcat('crime type ',num2str(crime_Type))) ;
    
    [ar_mode2,ranking,contours] = mClusters2(x',roads,sigma,0.1,x_km,y_km);
        
    text = strcat('Parzen ',num2str(crime_Type));
    tElapsed = toc(tStart);
    
    disp(strcat(text, ' clustering took','" "', num2str(tElapsed),'" z"',' seconds on ',num2str(N),' data points'));

    
    appendToExisting = false;
    
    %armode(:,1) = points cluster label
    %armode(:,2) = ranking metric
    
    visualizeClustering(ar_mode2(:,1),ranking,contours,x,id_use,cluster,crimeTypes(crime_Type),location_use,appendToExisting,clusterfile,pointsfile); % Visualize Result
    title(sprintf(text));
   
end

 fclose(clusterfile);
 fclose(pointsfile);

 %write to db. ensure mysql is in path for this to run 
 system('mysql -u root < update_clusters_in_db.sql')

