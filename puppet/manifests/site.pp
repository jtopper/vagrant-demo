# On every node...

node default {

    # ...apply some default settings

    class { demo_defaults: }

    # Then apply classes for each role we've found via facts:

    if( 'webserver' in $roles ) {
        notice("Found 'webserver' role via Facts")
        class { demo_role_webserver: }
    }

    if( 'database' in $roles ) {
        notice("Found 'database' role via Facts")
        class { demo_role_database: }
    }


}
