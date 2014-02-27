class demo_php {

    Package {
        ensure => installed,
        notify => Service["httpd"],
    }

    package { "php": }
    package { "php-mysql": }

}
