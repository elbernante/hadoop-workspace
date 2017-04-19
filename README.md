# Hadoop Workspace
Hadoop 2.8.0 installed in Ubuntu 16.04 Xenial 64-bit. The Hadoop is configured in Pseudo-Distributed mode.

### System Requirements
- [Vagrant 1.9](https://www.vagrantup.com/downloads.html)
- [VirtualBox 5.1](https://www.virtualbox.org/wiki/Downloads)

### Setting Up
Clone `hadoop-workspace` repository from https://github.com/elbernante/hadoop-workspace by issuing the following the command line:

```
$ git clone https://github.com/elbernante/hadoop-workspace.git
```

Go to the root directory of the cloned repo and fire up vagrant:

```
$ cd hadoop-workspace
$ vagrant up
```

Running `vagrant up` for the first time may take a while. It will download all the necessary setup files including Hadoop 2.8.0 distribution package (≈430MB). Subsequent `vagrant up` commands will be significantly faster.

SSH to the virtual machine by issuing the command:

```
$ vagrant ssh
```

You are now connected to an Ubuntu 16.04 machine with Hadoop 2.8.0 running in pseudo-distributed mode.

### Running a Sample MapReduce Job: WordCount
The repository comes with a sample java code for a MapReduce job that counts the number of occurrences of words in input files.

After logging in to the virtual machine (via `vagrant ssh`), go to the `wordcount` directory:
```
$ cd /vagrant/wordcount
```

##### Compiling the `WordCount.java` source code

Compile `WordCount.java` and package the resulting classes in a jar file:

```
$ hadoop com.sun.tools.javac.Main WordCount.java
$ jar cf wc.jar WordCount*.class
```

A `wc.jar` file should now be created in the current directory.

##### Uploading Input files to Hadoop Distributed File System (HDFS)
Sample input files are loacated in `/vagrant/wordcount/input/`. These files need to be uploaded to HDFS in order for Hadoop to process it.

Create a destination directory in HDFS where we want to upload our input files:

```
$ hadoop fs -mkdir wordcount
$ hadoop fs -mkdir wordcount/input
```

Upload the input files from the local directory `/vagrant/wordcount/input/` to HDFS directory `/user/ubuntu/wordcount/input/`:

```
$ hadoop fs -put input/* wordcount/input
```

You can verify that the input files are uploaded by running the command:

```
$ hadoop fs -ls wordcount/input

Found 2 items
-rw-r--r--   1 ubuntu supergroup   22 2017-04-19 19:10 wordcount/input/file01
-rw-r--r--   1 ubuntu supergroup   28 2017-04-19 19:10 wordcount/input/file02
```

##### Running the Application

Run the application using the command:

```
$ hadoop jar wc.jar WordCount wordcount/input wordcount/output
```

The ouput files will be generated in `wordcount/output` in HDFS:

```
$ hadoop fs -ls wordcount/output

Found 2 items
-rw-r--r-- 1 ubuntu supergroup  0 2017-04-19 20:21 wordcount/output/_SUCCESS
-rw-r--r-- 1 ubuntu supergroup 41 2017-04-19 20:21 wordcount/output/part-r-00000
```

To view the contents of the output files:

```
$ hadoop fs -cat wordcount/output/*

Bye	1
Goodbye	1
Hadoop	2
Hello	2
World	2
```
