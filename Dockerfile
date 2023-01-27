FROM tomcat:10.1.5
RUN rm /usr/local/tomcat/webapps/* -rf
ADD artifact /usr/local/tomcat/webapps
EXPOSE 8080