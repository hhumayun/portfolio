


d = textread('clusters.csv','%s' ,'delimiter' , '\t' );

id = str2double(d(1:5:end));
name = d(2:5:end);
latlong = d(3:5:end);
numCrime = (d(4:5:end));
crimeType = (d(5:5:end));

clusterfile = fopen (strcat('clusters.kml'),'w');


fprintf(clusterfile,'%s\n','<kml xmlns="http://www.opengis.net/kml/2.2">');
fprintf(clusterfile,'%s\n','<Document>');
filename = '<name>Clusters</name>'
fprintf(clusterfile,'%s\n',filename);

for i = 1:length(id)

    fprintf(clusterfile,'%s\n','<Placemark>');
    fprintf(clusterfile,'%s\n','<name>');
 
    fprintf(clusterfile,'%s\n',name{i});
    fprintf(clusterfile,'%s\n','</name>');
 
    fprintf(clusterfile,'%s\n','<ExtendedData>');     
    
    fprintf(clusterfile,'%s\n','<Data name = "crimeType">');     
    
    fprintf(clusterfile,'%s\n','<value>');
    fprintf(clusterfile,'%s\n',crimeType{i});
    fprintf(clusterfile,'%s\n','</value>');
    
    fprintf(clusterfile,'%s\n','</Data>');     
    
  
    
    fprintf(clusterfile,'%s\n','<Data name = "numCrime">');     
    fprintf(clusterfile,'%s\n','<value>');
    fprintf(clusterfile,'%s\n',numCrime{i});
    fprintf(clusterfile,'%s\n','</value>');
    fprintf(clusterfile,'%s\n','</Data>');     
  
    
    
    fprintf(clusterfile,'%s\n','</ExtendedData>');     

    fprintf(clusterfile,'%s\n',latlong{i});     
  
    fprintf(clusterfile,'%s\n','</Placemark>');
    
    
end

fprintf(clusterfile,'%s\n','</Document>');
fprintf(clusterfile,'%s\n','</kml>');
fclose(clusterfile);



