apt-get -y update
apt-get -y upgrade

apt-get -y install ssh
apt-get -y install rsync
apt-get -y install git

apt-get -y install python-pip

vagrantTip="[35m[1mThe shared directory is located at /vagrant\nTo access your shared files: cd /vagrant(B[m"
echo -e $vagrantTip > /etc/motd

# Save donwloadables in shared folder
cd /vagrant


echo " "
echo " "
echo "Installing Java 8..."
echo " "
echo " "


apt-get install -y software-properties-common python-software-properties
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
add-apt-repository ppa:webupd8team/java -y
apt-get update -qq
apt-get install -y oracle-java8-installer
echo "Setting environment variables for Java 8.."
apt-get install -y oracle-java8-set-default

# NOTE: Setup enironment variable:
# file: /etc/environment
# append at end: export JAVA_HOME="/usr/lib/jvm/java-8-oracle"


# Install Hadoop
echo " "
echo " "
echo "Installing Hadoop..."
echo " "
echo " "


# Download Hadoop package
hadoop_package=hadoop.tar.gz
if [[ ! -f $hadoop_pacakge ]]; then
    wget --quiet -O $hadoop_package http://mirror.symnds.com/software/Apache/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz
fi

# Extract Hadoop package
tar -xvzf $hadoop_package

# Copy pre-setup config files
cp hadoop-config-templates/* hadoop/etc/hadoop/


# Create key to allow ssh without passphrase
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys


cd hadoop
# Setup HDFS namenode
bin/hdfs namenode -format

# Start HDFS service
sbin/start-dfs.sh

# Create user directory in HDFS
bin/hdfs dfs -mkdir /user
bin/hdfs dfs -mkdir /user/vagrant

# Stop HDFS service
sbin/stop-dfs.sh

# TODO: Create symlink to /usr/local/hadoop
# TODO: update .bashrc

sbin/stop-dfs.sh

# Upate .bashrc to include hadoop
echo "export HADOOP_HOME=\"/vagrant/hadoop\"" >> ~/.bashrc
echo "export PATH=${PATH}:${HADOOP_HOME}/bin" >> ~/.bashrc
echo "export JAVA_HOME=\"/usr/lib/jvm/java-8-oracle\"" >> ~/.bashrc 
echo "export PATH=${JAVA_HOME}/bin:${PATH}" >> ~/.bashrc 
echo "export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar" >> ~/.bashrc  

source ~/.bashrc

# NOTE: Set JAVA_HOME evironment variable:
#       you may not need this step if you already exprot JAVA_HOME in /etc/environment
# file: [hadoop-2.8.0/]etc/hadoop/hadoop-env.sh
# set: export JAVA_HOME="/usr/lib/jvm/java-8-oracle"





echo " "
echo " "
echo "==========================================="
echo " "
echo "Setup complete. Run 'vagrant ssh' to start."




