#!/usr/bin/env bash
set -e

# These libraries are built based on TI's Arago Yocto recipes located at 
# https://git.ti.com/cgit/arago-project/meta-arago/tree/meta-arago-extras/recipes-sysrepo
build_tsn_libraries() {
    build_libyang
    build_libnetconf2
    # Note: This does not compile on arm64 (library is too old) - apt installed `libavl1` instead
    #build_libredblack
    build_sysrepo
    build_netopeer2
    sudo ldconfig
    build_nwconfigurator
    install_yang_models
    echo ">>>>> built all TSN libraries"
}

#libyang
build_libyang() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/CESNET/libyang.git $TMP/libyang
    cd $TMP/libyang
    # Newer version: git checkout v2.1.148 - not used
    # Yocto recipe version: v2.1.77 - used
    git checkout a804113c9bbac3e36c53221be469c1ca5af5b435
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
    # Newer version: git checkout v3.0.8 - not used
    # Yocto recipe version: v2.1.34 - used
    git checkout 91cd6d75722c65de5c005d908f6d645b48cee89b
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

#libredblack - searching/sorter library
# Latest commit is the one indicated in the Yocto recipe
build_libredblack() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/sysrepo/libredblack.git $TMP/libredblack
    cd $TMP/libredblack
    start=`date +%s`
    ./configure --without-rbgen
    make -j2
    sudo make install
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    end=`date +%s`
    echo ">>>>> built libredblack library"
    diff=`expr $end - $start`
    echo ">>>>> Execution time was $(($diff/60)) minutes and $(($diff%60)) seconds."
}

#sysrepo - depends on libyang, libredblack
build_sysrepo() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    start=`date +%s`
    git clone https://github.com/sysrepo/sysrepo.git $TMP/sysrepo
    cd $TMP/sysrepo
    # Newer version: git checkout v2.2.150 - not used
    # Yocto recipe version: v2.2.71 - used
    git checkout b828f0ab4693c613cc66efd053a146e05854d5c8
    mkdir build 
    cd build
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..
    make -j2
    sudo make install
    mkdir -p /etc/sysrepo/data/notifications
    mkdir -p /etc/sysrepo/yang
    cp /usr/local/share/yang/modules/ietf-netconf-notifications.yang /etc/sysrepo/yang/ietf-netconf-notifications@2012-02-06.yang
    cp /usr/local/share/yang/modules/ietf-netconf-with-defaults.yang /etc/sysrepo/yang/ietf-netconf-with-defaults@2011-06-01.yang
    cp /usr/local/share/yang/modules/ietf-netconf.yang /etc/sysrepo/yang/ietf-netconf@2011-06-01.yang
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    end=`date +%s`
    echo ">>>>> built sysrepo library"
    diff=`expr $end - $start`
    echo ">>>>> Execution time was $(($diff/60)) minutes and $(($diff%60)) seconds."
}

#netopeer2 - depends on libyang, libnetconf2, sysrepo, curl
# Note: 0001-Add-EST-Yang-Models.patch from YOCTO is incorporated into the uploaded /usr/local/share/netopeer2/setup.sh file in config file:riaps-am64-bookworm-rt.yaml
build_netopeer2() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/CESNET/netopeer2.git $TMP/netopeer2
    cd $TMP/netopeer2
    # Newer version: git checkout v2.2.13 - not used
    # Yocto recipe version: v2.1.59 - used
    git checkout b81788d9a81770313a0eb7f88d4224726b3d6e15
    start=`date +%s`
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local -DINSTALL_MODULES=OFF -DGENERATE_HOSTKEY=OFF -DMERGE_LISTEN_CONFIG=OFF . 
    make -j2
    sudo make install
    mkdir -p /etc/netopeer2
    # netopeer2 install places scripts in /usr/local/share/netopeer2 folder, not /etc/netopeer2/scripts
    #   The 'netopeer2-serverd.service' (uploaded in riaps-am64-bookworm-rt.yaml) has been modified to reflect this location
    # Below is from the YOCTO recipe (for reference only, but intentionally not used)
    #install -d ${D}${sysconfdir}/netopeer2/scripts
    #install -o root -g root ${S}/scripts/setup.sh ${D}${sysconfdir}/netopeer2/scripts/setup.sh
    #install -o root -g root ${S}/scripts/merge_hostkey.sh ${D}${sysconfdir}/netopeer2/scripts/merge_hostkey.sh
    #install -o root -g root ${S}/scripts/merge_config.sh ${D}${sysconfdir}/netopeer2/scripts/merge_config.sh
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    end=`date +%s`
    echo ">>>>> built netopeer2 library"
    diff=`expr $end - $start`
    echo ">>>>> Execution time was $(($diff/60)) minutes and $(($diff%60)) seconds."
}

#nw-configurator - depends on sysrepo
build_nwconfigurator() {
    cd /opt/riaps
    echo "Building nw-configurator in $PWD"
    ls -al
    gcc nw-configurator.c -o nw-configurator -lsysrepo
    sudo cp nw-configurator /usr/local/bin/.
    echo ">>>>> built nw-configurator library"
}

#YangModels
install_yang_models() {
    PREVIOUS_PWD=$PWD
    TMP=`mktemp -d`
    git clone https://github.com/YangModels/yang.git $TMP/yangmodels
    cd $TMP/yangmodels
    git checkout d3f6ca02ec9ce7c96b55066d209d08adbe851897
    install -o root -g root ./standard/ietf/RFC/iana-if-type.yang /usr/local/share/yang/modules/netopeer2/iana-if-type@2017-01-19.yang
    install -o root -g root ./standard/ieee/draft/802.1/Qcw/ieee802-types.yang /usr/local/share/yang/modules/netopeer2/ieee802-types@2022-10-31.yang
    install -o root -g root ./standard/ieee/draft/802.1/Qcw/ieee802-dot1q-types.yang /usr/local/share/yang/modules/netopeer2/ieee802-dot1q-types@2022-10-31.yang
    install -o root -g root ./standard/ieee/draft/802.1/Qcw/ieee802-dot1q-bridge.yang /usr/local/share/yang/modules/netopeer2/ieee802-dot1q-bridge@2022-10-31.yang
    install -o root -g root ./standard/ieee/draft/802.1/Qcw/ieee802-dot1q-sched.yang /usr/local/share/yang/modules/netopeer2/ieee802-dot1q-sched@2022-08-18.yang
    install -o root -g root ./standard/ieee/draft/802.1/Qcw/ieee802-dot1q-sched-bridge.yang /usr/local/share/yang/modules/netopeer2/ieee802-dot1q-sched-bridge@2022-08-18.yang
    cd $PREVIOUS_PWD
    sudo rm -rf $TMP
    echo ">>>>> installed yang models"
}


build_tsn_libraries