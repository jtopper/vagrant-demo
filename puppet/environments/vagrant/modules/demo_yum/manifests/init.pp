class demo_yum::local {

    yumrepo { 'base':
        gpgcheck   => '0',
        descr      => 'CentOS-$releasever - Base',
        baseurl    => 'file:///mirror/CentOS/$releasever/base',
        enabled    => '1'
    }

}

class demo_yum::remote {

    yumrepo { 'base':
        gpgcheck   => '1',
        gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
        descr      => 'CentOS-$releasever - Base',
        baseurl    => 'http://mirror.centos.org/centos/$releasever/os/$basearch/',
        mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os',
        enabled    => '1'
    }

}

class demo_yum ( $use_local_mirror = false ) {

    file { "/etc/yum.conf":
        content => template("demo_yum/yum.conf")
    }

    exec { "yum-clean":
        command     => "/usr/bin/yum clean all",
        refreshonly => true,
        subscribe   => File["/etc/yum.conf"]
    }

    exec { "purge-yum.repos.d":
        command     => "/bin/find /etc/yum.repos.d -type f -delete",
        refreshonly => true,
        subscribe   => Exec["yum-clean"]
    }

    notice("Has local mirror: $use_local_mirror")

    if( $use_local_mirror ) {
        class { demo_yum::local: }
    } else {
        class { demo_yum::remote: }
    }

    # Enforce ordering - purge all repos first (because Yumrepo is not an enumerable resource)
    # then configure repos, then consider packages:

    File['/etc/yum.conf'] -> Exec['purge-yum.repos.d'] -> Yumrepo<| |> -> Package<| |> 

}
