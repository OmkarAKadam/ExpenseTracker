FROM tomcat:10.1-jdk17
COPY target/ExpenseTracker-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/expense-tracker.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
