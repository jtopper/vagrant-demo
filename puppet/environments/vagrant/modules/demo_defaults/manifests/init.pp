class demo_defaults {

    # The capitalised version of "Package" here sets defaults for every
    # other "package" resource in this scope.

    Package { 
        ensure => installed
    }

    # ...so these packages are all implicitly installed:

    package { "sysstat": }
    package { "lsof":    }


    # Configure a package repo
    # (use the local mirror on the host, if facts say that's available)

    class { demo_yum:
        use_local_mirror => $has_local_package_mirror
    }


    # If this is a vagrant box, let's just stop iptables because we don't need
    # any firewalling.

    if( $vagrant ) {
        service { "iptables":
            ensure => stopped,
            enable => false,
        }
    }


}
