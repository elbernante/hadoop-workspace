HADOOP_HOME=/usr/local/hadoop

# Setup HDFS namenode
${HADOOP_HOME}/bin/hdfs namenode -format

# Start HDFS service
${HADOOP_HOME}/sbin/start-dfs.sh

# Create user directory in HDFS
${HADOOP_HOME}/bin/hdfs dfs -mkdir /user
${HADOOP_HOME}/bin/hdfs dfs -mkdir /user/ubuntu

# Stop HDFS service
${HADOOP_HOME}/sbin/stop-dfs.sh