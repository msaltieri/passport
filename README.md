passport - Manage access credentials with R
===========================================

[![Build Status](https://travis-ci.org/msaltieri/passport.svg?branch=master)](https://travis-ci.org/msaltieri/passport)

> *Copyright 2017 [Michele Stefano Altieri](http://github.com/msaltieri).
> Licensed under the MIT license.*

`passport` lets you manage username and password for databases or web services
in order to provide full access to external resources without exposing
credential within the code.

Table of contents
-----------------

-   [Installation](#install)
-   [How to use](#usage)

<h2 id="install">
Installation
</h2>

`passport` is not yet available through CRAN, but you can install the latest development version from GitHub:

    install.packages("devtools")
    devtools::install_github("msaltieri/passport")
  
<h2 id="usage">
How to use
</h2>

You can handle a simple password repository by running

    library(passport)
    my_vault <- new_vault(tempfile())
    my_vault
    
    #> Passport Vault `fileb3457449129`
    #> Empty vault
    
Then you can add your first test credentials by running

    proxy1_set <- list(service   = "postgres",
                       host      = "my_istance.dbserver.com",
                       port      = "5432",
                       username  = "admin",
                       password  = "12345")
    vault_add(my_vault, proxy1_set)
    my_vault
    
    #> Passport Vault `fileb3457449129`
    #> Service list:
    #>     1 - postgres
    
Then maybe you can even add a second set of credentials
    
    proxy2_set <- list(service   = "data_provider",
                       host      = "ftp://download.data_provider.com",
                       port      = "22",
                       username  = "alice",
                       password  = "67890")
    vault_add(my_vault, proxy2_set)
    my_vault
    
    #> Passport Vault `fileb3457449129`
    #> Service list:
    #>     1 - postgres
    #>     2 - data_provider
    
It's now easy to retrieve data from the vault by service name

    vault_get(my_vault, "postgres")
    
    #> $host
    #> [1] "my_istance.dbserver.com"
    #>
    #> $port
    #> [1] "5432"
    #>
    #> $username
    #> [1] "admin"
    #>
    #> $password
    #> [1] "12345"
    
Or maybe showing all the credential stored in the vault with just one command

    vault_getall(my_vault)
    
    #>                                           host port username password
    #> postgres               my_istance.dbserver.com 5432    admin    12345
    #> data_provider ftp://download.data_provider.com   22    alice    67890
    
If you need to delete a specific set of credentials, just run

    vault_rm(my_vault, "postgres")
    my_vault
    
    #> Passport Vault `fileb3457449129`
    #> Service list:
    #>     1 - data_provider
    
You can erase completely the vault and all the data stored inside by running

    vault_delete(my_vault)
    my_vault
    
    #> Vault removed
