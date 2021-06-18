#----------------------------------------------------------------------------
#
# Package         : wildfly/wildfly
# Version         : 23.0.2.Final
# Source repo     : https://github.com/wildfly/wildfly
# Tested on       : ubi:8
# Maintainer      : srividya chittiboina <Srividya.Chittiboina@ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------
#!/bin/bash
# ----------------------------------------------------------------------------
# Prerequisites:
#
# JDK 8 or newer - check java -version
#
# Maven 3.6.0 or newer - check mvn -v
#
# git must be installed
# ----------------------------------------------------------------------------
dnf install git
#install java
dnf install java-11-openjdk-devel
#setting environment variable
vi /etc/environment
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.292.b10-1.el8_4.ppc64le
source /etc/environment
#install maven
dnf install maven -y
#cloning wildfly repo to your local system
git clone https://github.com/wildfly/wildfly

#switching to our repo
cd wildfly
git checkout 23.0.2.Final
#building the repo
./build.sh
#running test suites
#mvn test
#mvn install -DallTests