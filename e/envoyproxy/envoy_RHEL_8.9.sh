#!/bin/bash -e
# ----------------------------------------------------------------------------
#
# Package        : envoy
# Version        : v2.5
# Source repo    : https://github.com/maistra/envoy.git , https://github.com/maistra/proxy.git
# Tested on      : RHEL 8.9
# Script License : Apache License, Version 2 or later
# Maintainer     : Nishikant Thorat <Nishikant.Thorat@ibm.com>
# Travis-Check   : True
# Language       : go, c++
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------
#
# Install dependencies
#
yum update -y
yum install -y git python3 libtool automake curl gcc vim cmake openssl-devel npm
yum install -y java-11-openjdk-devel
yum install -y openssl clang
yum install -y gcc-c++-8.5.0-4.el8_5 gcc-8.5.0-4.el8_5
yum install -y perl lld patch
yum install -y java-11-openjdk-devel
rpm -ihv https://rpmfind.net/linux/centos/8-stream/PowerTools/ppc64le/os/Packages/libstdc++-static-8.5.0-4.el8_5.ppc64le.rpm


mkdir $HOME/istio_build/
export SOURCE_ROOT=$HOME/istio_build/
#
# Install ninja
#
cd $SOURCE_ROOT
git clone https://github.com/ninja-build/ninja.git
cd ninja
git checkout v1.8.2
yum install -y python2
yum install -y python3
ln -s /usr/bin/python3 /usr/bin/python
./configure.py --bootstrap
ln -sf $SOURCE_ROOT/ninja/ninja /usr/local/bin/ninja
#
# Install gn
#
cd $SOURCE_ROOT
git clone https://gn.googlesource.com/gn
cd gn
git checkout 5787e994aa4cb6cdb09c2c72ae6f1c6a7f1cf91a
python build/gen.py
ninja -C out
export PATH=/root/istio_build/gn/out:$PATH
#
# Install llvm 
#
cd $SOURCE_ROOT
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
git checkout llvmorg-13.0.1
cd $SOURCE_ROOT
mkdir -p llvm_build
cd llvm_build
cmake3 -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="PowerPC" -DLLVM_ENABLE_PROJECTS="clang;lld" -G "Ninja" ../llvm-project/llvm
ninja -j$(nproc)
export PATH=/root/istio_build/llvm_build/bin:$PATH
export CC=/root/istio_build/llvm_build/bin/clang
export CXX=/root/istio_build/llvm_build/bin/clang++
#
# Install go
#
cd $SOURCE_ROOT
yum install -y wget
wget https://go.dev/dl/go1.20.13.linux-ppc64le.tar.gz
tar -C /usr/local -xzf go1.20.13.linux-ppc64le.tar.gz
export PATH=$PATH:/usr/local/go/bin
export GOPATH=/root/go
export GOBIN=/usr/local/go/bin
which go
go version
#
# Get bazel from brew builds (Needed to get builds on RH infra)
#
wget https://download.eng.bos.redhat.com/brewroot/vol/rhel-8/packages/bazel/6.3.2/1.el8eng/ppc64le/bazel-6.3.2-1.el8eng.ppc64le.rpm
rpm -ihv bazel-6.3.2-1.el8eng.ppc64le.rpm
#
# Build proxy
#
git clone https://github.com/maistra/proxy
cd proxy/
git checkout maistra-2.5
# Below commit is tested -  26/26 tests passed
# git checkout 04b70a395411958c9f140eb013ff44a047c36119
./maistra/ci/pre-submit.sh
