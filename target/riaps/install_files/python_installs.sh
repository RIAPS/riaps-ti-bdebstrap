#!/usr/bin/env bash
set -e

# For Debian 11/12 use the 'dev-imx8' branch
apparmor_monkeys_install() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/RIAPS/apparmor_monkeys.git $TMP/apparmor_monkeys
    cd $TMP/apparmor_monkeys
    git checkout dev-imx8
    sudo pip3 install --break-system-packages .
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    echo ">>>>> installed apparmor_monkeys"
}

# NOTE: DEPRECATION: --no-binary currently disables reading from the cache of locally built wheels. 
# Replaced it with recommended '--no-cache-dir' option.
pyzmq_install(){
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/zeromq/pyzmq.git $TMP/pyzmq
    cd $TMP/pyzmq
    git checkout v25.1.2
    ZMQ_DRAFT_API=1 sudo -E pip3 install --break-system-packages -v --no-cache-dir .
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    echo ">>>>> installed pyzmq"
}

# Install bindings for czmq. Must be run after pyzmq, czmq install.
czmq_pybindings_install(){
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/zeromq/czmq.git $TMP/czmq_pybindings
    cd $TMP/czmq_pybindings/bindings/python
    git checkout v4.2.1
    sudo pip3 install --break-system-packages . --verbose
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    echo ">>>>> installed CZMQ pybindings"
}

# Install bindings for zyre. Must be run after zyre, pyzmq install.
zyre_pybindings_install(){
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/zeromq/zyre.git $TMP/zyre_pybindings
    cd $TMP/zyre_pybindings/bindings/python
    git checkout v2.0.1
    sudo pip3 install --break-system-packages . --verbose
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    echo ">>>>> installed Zyre pybindings"
}

# Link pycapnp with installed library. Must be run after capnproto install.
pycapnp_install() {
    sudo pip3 install pkgconfig --break-system-packages --verbose
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/capnproto/pycapnp.git $TMP/pycapnp
    cd $TMP/pycapnp
    git checkout v2.0.0b2
    sudo pip3 install --break-system-packages . --verbose
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    echo ">>>>> linked pycapnp with capnproto"
}

# Install prctl package
prctl_install() {
    sudo apt-get install libcap-dev -y
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/RIAPS/python-prctl.git $TMP/python-prctl
    cd $TMP/python-prctl/
    git checkout feature-ambient
    sudo pip3 install --break-system-packages . --verbose
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    echo ">>>>> installed prctl"
}

# Install dependencies: libffi-dev (already as part of timesync requirements), python-dev build-essential
# Should be called after cross_setup and timesync_requirements functions
py_lmdb_install() {
    export LMDB_FORCE_SYSTEM=1
    export LMDB_INCLUDEDIR=/usr/local/include
    export LMDB_LIBDIR=/usr/local/lib
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/jnwatson/py-lmdb.git $TMP/python-lmdb
    cd $TMP/python-lmdb/
    git checkout py-lmdb_1.4.1
    sudo -E pip3 install . --break-system-packages --verbose
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    echo ">>>>> installed lmdb"
}

cython_install() {
    pip3 install Cython --break-system-packages --verbose
    echo ">>>>> installed cython"
}

# Install other required packages
# Since python installs needing Cython typically calls for the latest version, do not specify a version for this package
pip3_3rd_party_installs(){
    pip3 install --break-system-packages 'redis==5.0.1' 'hiredis==2.3.2' --verbose
    # Moved to pydevd v3.0.3
    pip3 install --break-system-packages 'pydevd==3.0.3' 'netifaces2==0.0.19' --verbose
    pip3 install --break-system-packages 'cgroups==0.1.0' 'cgroupspy==0.2.2' --verbose
    pip3 install --break-system-packages 'pyroute2==0.7.9' 'pyserial==3.5' --verbose
    pip3 install --break-system-packages 'pybind11==2.11.1' 'toml==0.10.2' 'pycryptodomex==3.19.0' --verbose
    pip3 install --break-system-packages 'rpyc==5.3.1' 'parse==1.19.1' 'butter==0.13.1' --verbose
    pip3 install --break-system-packages 'gpiod==1.5.4' 'spdlog==2.0.6' --verbose
    pip3 install --break-system-packages 'psutil==5.9.0' 'pyyaml==6.0.1' --verbose
    # Had to move pyyaml to 6.0.1 from 5.4.1 due to a build error
    pip3 install --break-system-packages 'paramiko==3.4.0' 'cryptography==3.4.8' --verbose
    # NOTE: cryptography is already installed in /usr/lib/python3/dist-packages with v38.0.4, put v3.4.8 in /usr/local/lib
    pip3 install --break-system-packages 'fabric2==3.2.2' 'numpy==1.26.4' --verbose
    echo ">>>>> installed pip3 packages"
}


pycapnp_install
apparmor_monkeys_install
py_lmdb_install
pip3_3rd_party_installs
prctl_install
pyzmq_install
czmq_pybindings_install
zyre_pybindings_install
echo ">>>>> installed all python packages"