
host = 'localhost'; user = 'root';password = '';dbName = 'tpi';

jdbcString = sprintf('jdbc:mysql://%s/%s', host, dbName);
jdbcDriver = 'com.mysql.jdbc.Driver';
javaaddpath('/Users/hamzahumayun/Dev/mysql-connector-java-5.1.29/mysql-connector-java-5.1.29-bin.jar')
dbConn = database(dbName, user , password, jdbcDriver, jdbcString);

runsqlscript(dbConn,'/Users/hamzahumayun/Desktop/TPI/police/clustering/consolidation/update_clusters_in_db.sql');

