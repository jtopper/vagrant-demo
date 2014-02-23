class demo_apache {

    package { "httpd":
        ensure => installed
    }

    file { "/etc/httpd/conf.d/00default.conf":
        source  => "puppet:///modules/demo_apache/httpd.conf",
        owner   => root,
        group   => root,
        require => Package["httpd"],
        notify  => Service["httpd"],
    }

    service { "httpd":
        ensure  => running,
        enable  => true,
        require => File["/etc/httpd/conf.d/00default.conf"],
    }
    
}
