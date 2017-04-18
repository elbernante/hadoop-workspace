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

# hadoop_package=hadoop-2.8.0.tar.gz
# if [[ ! -f $hadoop_pacakge ]]; then
#     wget --quiet -O $hadoop_package http://mirror.symnds.com/software/Apache/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz
# fi

# tar -xvzf $hadoop_package

# NOTE: Set JAVA_HOME evironment variable:
#       you may not need this step if you already exprot JAVA_HOME in /etc/environment
# file: [hadoop-2.8.0/]etc/hadoop/hadoop-env.sh
# set: export JAVA_HOME="/usr/lib/jvm/java-8-oracle"


# Install Scala
echo " "
echo " "
echo "Installing Scala"
echo " "
echo " "

# apt-get -y install scala


# # Install Spark
# spark_package=spark-2.1.0-bin-hadoop2.7.tgz
# if [[ ! -f $hadoop_pacakge ]]; then
#     wget --quiet -O $spark_package http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz
# fi

# tar -xvzf $spark_package


echo " "
echo " "
echo "==========================================="
echo " "
echo "Setup complete. Run 'vagrant ssh' to start."
# echo "To access iPython Notebook from browser on host,"
# echo "go to your notebooks folder and run:"
# echo "ipython notebook --ip=0.0.0.0.0"



