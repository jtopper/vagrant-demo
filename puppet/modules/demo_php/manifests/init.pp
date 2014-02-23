class demo_php {

    package { "php":
        ensure => installed,
        notify => Service["httpd"],
    }

}
