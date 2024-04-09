#!/usr/bin/env bash
set -e

# Note that using CMake with qemu for an arm 32 processor is a known issue
# (https://gitlab.kitware.com/cmake/cmake/-/issues/20568). So doing individual builds
build_tsn_libraries() {
    build_libyang
    build_libnetconf2
    build_sysrepo
    build_netopeer2
    sudo ldconfig
    build_nwconfigurator
    echo ">>>>> built all TSN libraries"
}

#libyang
build_libyang() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/CESNET/libyang.git $TMP/libyang
    cd $TMP/libyang
    git checkout v2.1.148
    start=`date +%s`
    mkdir build 
    cd build
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..
    make -j2
    sudo make install
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    end=`date +%s`
    echo ">>>>> built libyang library"
    diff=`expr $end - $start`
    echo ">>>>> Execution time was $(($diff/60)) minutes and $(($diff%60)) seconds."
}

#libnetconf2 - depends on libyang and libssh
build_libnetconf2() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/CESNET/libnetconf2.git $TMP/libnetconf2
    cd $TMP/libnetconf2
    git checkout v3.0.8
    start=`date +%s`
    mkdir build 
    cd build
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..
    make -j2
    sudo make install
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    end=`date +%s`
    echo ">>>>> built libnetconf2 library"
    diff=`expr $end - $start`
    echo ">>>>> Execution time was $(($diff/60)) minutes and $(($diff%60)) seconds."
}

#sysrepo - depends on libyang
# MM TODO: libredblack build is a total guess right now, no documentation found on install
build_sysrepo() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    start=`date +%s`
    git clone https://github.com/sysrepo/sysrepo.git $TMP/sysrepo
    cd $TMP/sysrepo
    git checkout v2.2.150
    mkdir build 
    cd build
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..
    make -j2
    sudo make install
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    end=`date +%s`
    echo ">>>>> built sysrepo library"
    diff=`expr $end - $start`
    echo ">>>>> Execution time was $(($diff/60)) minutes and $(($diff%60)) seconds."
}

#netopeer2 - depends on libyang, libnetconf2, sysrepo, curl
build_netopeer2() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/CESNET/netopeer2.git $TMP/netopeer2
    cd $TMP/netopeer2
    git checkout v2.2.13
    start=`date +%s`
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .
    make -j2
    sudo make install
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    end=`date +%s`
    echo ">>>>> built netopeer2 library"
    diff=`expr $end - $start`
    echo ">>>>> Execution time was $(($diff/60)) minutes and $(($diff%60)) seconds."
}

#nw-configurator - depends on sysrepo
build_nwconfigurator() {
    gcc nw-configurator.c -o nw-configurator -lsysrepo
    sudo cp nw-configurator /usr/local/bin/
    echo ">>>>> built nw-configurator library"
}

build_tsn_libraries