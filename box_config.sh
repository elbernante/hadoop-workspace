apt-get -y update
apt-get -y upgrade

apt-get -y install ssh
apt-get -y install rsync
apt-get -y install git

apt-get -y install python-pip

vagrantTip="[35m[1mThe shared directory is located at /vagrant\nTo access your shared files: cd /vagrant(B[m"
echo -e $vagrantTip > /etc/motd

# Create directory for installation destinations
VAGRANT_LOCAL=/vagrant/local
mkdir -p ${VAGRANT_LOCAL}

# Empty installation destinations in case it was already created
rm -rf ${VAGRANT_LOCAL}/*


# Save donwloadables in shared folder
cd /vagrant


echo " "
echo "========================================"
echo "         Installing Java 8              "
echo "========================================"

apt-get install -y software-properties-common python-software-properties
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
add-apt-repository ppa:webupd8team/java -y
apt-get update -qq
apt-get install -y oracle-java8-installer
echo "Setting environment variables for Java 8.."
apt-get install -y oracle-java8-set-default



# Install Hadoop
echo " "
echo "========================================"
echo "        Installing Hadoop 2.8.0         "
echo "========================================"

# Download Hadoop package
hadoopp_dir=hadoop-2.8.0
hadoop_package=${hadoopp_dir}.tar.gz
if [[ ! -f $hadoop_package ]]; then
    echo "Downloading hadoop distribution package..."
    wget --quiet -O $hadoop_package http://mirror.symnds.com/software/Apache/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz
fi

# Extract Hadoop package
tar -xvzf $hadoop_package -C ${VAGRANT_LOCAL}

# Copy pre-configured configuration files
HADOOP_ENV_SH=${VAGRANT_LOCAL}/${hadoopp_dir}/etc/hadoop/hadoop-env.sh
sed -i "s/^export JAVA_HOME.*/export JAVA_HOME=\$(readlink -f \/usr\/bin\/javac | sed \"s:\/bin\/javac::\")/" ${HADOOP_ENV_SH}
cp hadoop-config-templates/* ${VAGRANT_LOCAL}/${hadoopp_dir}/etc/hadoop/

# Move hadoop installation to /usr/local
# mv ${HADOOP_TMP_INSTALL}/${hadoopp_dir} /usr/local/hadoop
# chown -R ubuntu:ubuntu /usr/local/hadoop
# rmdir ${HADOOP_TMP_INSTALL}

# Create symbolic link to /usr/local
ln -s ${VAGRANT_LOCAL}/${hadoopp_dir} /usr/local/hadoop

# Create key to allow ssh without passphrase
ssh-keygen -t rsa -P '' -f /home/ubuntu/.ssh/id_rsa
cat /home/ubuntu/.ssh/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys
chmod 0600 /home/ubuntu/.ssh/authorized_keys

chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa.pub

# Add localhost to known hosts
ssh-keyscan localhost,0.0.0.0  > /home/ubuntu/.ssh/known_hosts
chown ubuntu:ubuntu /home/ubuntu/.ssh/known_hosts

# Create directory for HDFS
mkdir ${VAGRANT_LOCAL}/hdfs
mkdir ${VAGRANT_LOCAL}/hdfs/nn
mkdir ${VAGRANT_LOCAL}/hdfs/data
chown -R ubuntu:ubuntu ${VAGRANT_LOCAL}/hdfs
chmod -R 775 ${VAGRANT_LOCAL}/hdfs

# Upate .bashrc to include hadoop
echo "export HADOOP_HOME=\"/usr/local/hadoop\"" >> /home/ubuntu/.bashrc
echo "export PATH=\${PATH}:\${HADOOP_HOME}/bin" >> /home/ubuntu/.bashrc
echo "export JAVA_HOME=\$(readlink -f /usr/bin/javac | sed \"s:/bin/javac::\")" >> /home/ubuntu/.bashrc
echo "export PATH=\${JAVA_HOME}/bin:\${PATH}" >> /home/ubuntu/.bashrc
echo "export HADOOP_CLASSPATH=\${JAVA_HOME}/lib/tools.jar" >> /home/ubuntu/.bashrc



# Install Scala
echo " "
echo "========================================"
echo "           Installing Scala             "
echo "========================================"
apt-get -y install scala



# Install Apache Spark
echo " "
echo "========================================"
echo "        Installing Apache Spark         "
echo "========================================"

# Download Spark package without Hadoop
spark_dir=spark-2.1.0-bin-without-hadoop
spark_package=${spark_dir}.tgz
if [[ ! -f $spark_package ]]; then
    echo "Downloading Apache spark distribution package..."
    wget --quiet -O $spark_package http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-without-hadoop.tgz
fi

# Extract spark package
# SPARK_TMP_INSTALL=/tmp/spark-install
# mkdir ${SPARK_TMP_INSTALL}
# tar -xvzf $spark_package -C ${SPARK_TMP_INSTALL}
tar -xvzf $spark_package -C ${VAGRANT_LOCAL}

# Copy pre-configured configuration files
cp spark-config-templates/* ${VAGRANT_LOCAL}/${spark_dir}/conf

# Move spark installation to /usr/local
# mv ${SPARK_TMP_INSTALL}/${spark_dir} /usr/local/spark
# chown -R ubuntu:ubuntu /usr/local/spark
# rmdir ${SPARK_TMP_INSTALL}

# Create symbolic link to /usr/local
ln -s ${VAGRANT_LOCAL}/${spark_dir} /usr/local/spark

# Update PATH to include spark
echo "export PATH=\${PATH}:/usr/local/spark/bin" >> /home/ubuntu/.bashrc

source /home/ubuntu/.bashrc
