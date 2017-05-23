#' Initialize a password vault with a given filename
#' 
#' @param filename The external file where to store the credentials.
#' \code{filename} can either be an existing file or a new one. External
#' files must be in the \code{.rds} file format.
#' @return A \code{passport} vault object.
#' @examples
#' temp <- tempfile()
#' new_vault(filename = temp)
#' @export
new_vault <- function(filename) {
    
    # If the file exists, load the vault content
    if (file.exists(filename)) {
        content <- readRDS(filename)
        stopifnot(is.list(content))
        
    } else {
        # Otherwise create a new one empty
        content <- list()
        saveRDS(content, filename)
    }
    
    vault <- list(filename = filename)
    structure(vault, class = "passport")
    
}

#' Print a passport vault
#' @export
#' @keywords internal
print.passport <- function(x, ...) {
    if (!file.exists(vault_filename(x)))
        stop("vault removed",
             call. = FALSE)
    cat("Passport Vault `",
        basename(vault_filename(x)), "`",
        "\n", sep = "")
    cat("Service list:",
        "\n\t", sep = "")
    utils::write.table(x = vault_services(x),
                       col.names = FALSE,
                       quote = FALSE,
                       eol = "\n\t")
}

#' Get the vault filename
#' 
#' @param vault A \code{passport} vault object.
#' @export
#' @keywords internal
vault_filename <- function(vault) {
    stopifnot(inherits(vault, "passport"))
    vault[['filename']]
}

#' Get the list of services in the vault
#' 
#' @param vault A \code{passport} vault object.
#' @export
#' @keywords internal
vault_services <- function(vault) {
    stopifnot(inherits(vault, "passport"))
    content <- readRDS(vault_filename(vault))
    names(content)
}

#' Delete the entire vault
#' 
#' @param vault A \code{passport} vault object.
#' @export
#' @keywords internal
vault_delete <- function(vault) {
    stopifnot(inherits(vault, "passport"))
    unlink(vault_filename(vault))
}

#' Add new credentials to the vault
#' 
#' @param vault A \code{passport} vault object.
#' @param value A list with the new credential to add. \code{vault} must
#' contain the unique field `service` and the optional fields `host`, `port`,
#' `username` and `password`.
#' @export
#' @keywords internal
vault_add <- function(vault, value) {
    stopifnot(inherits(vault, "passport"))
    stopifnot(is.list(value))
    stopifnot(!is.null(value$service))
    content <- readRDS(vault_filename(vault))
    content[[value$service]] <- list(host = value$host,
                                     port = value$port,
                                     username = value$username,
                                     password = value$password)
    saveRDS(content, vault_filename(vault))
}

#' Get the credentials for a single service
#' 
#' @param vault A \code{passport} vault object.
#' @param service A service to retrieve credentials for
#' @export
#' @keywords internal
vault_get <- function(vault, service) {
    stopifnot(inherits(vault, "passport"))
    content <- readRDS(vault_filename(vault))
    content[[service]]
}

#' Get all the credentials stored in the vault
#' 
#' @param vault A \code{passport} vault object.
#' @export
#' @keywords internal
vault_getall <- function(vault) {
    stopifnot(inherits(vault, "passport"))
    content <- readRDS(vault_filename(vault))
    n <- length(content)
    if (n == 0)
        return
    fields <- names(content[[1]])
    output.tab <- matrix(nrow = n, ncol = 4)
    for (i in 1:n) {
        for (j in 1:4) {
            value <- content[[i]][[fields[j]]]
            if (is.null(value))
                break
            output.tab[i, j] <- value
        }
    }
    output.tab <- as.data.frame(output.tab, row.names = names(content))
    names(output.tab) <- fields
    output.tab
}

#' Remove the credentials for a single service
#' 
#' @param vault A \code{passport} vault object.
#' @param service A service to delete credentials to
#' @export
#' @keywords internal
vault_rm <- function(vault, service) {
    stopifnot(inherits(vault, "passport"))
    content <- readRDS(vault_filename(vault))
    if (!service %in% names(content))
        stop("service not found",
             call. = FALSE)
    content[[service]] <- NULL
    saveRDS(content, vault_filename(vault))
}

#' Remove all the credentials from the vault
#' 
#' @param vault A \code{passport} vault object.
#' @export
#' @keywords internal
vault_rmall <- function(vault) {
    stopifnot(inherits(vault, "passport"))
    content <- list()
    saveRDS(content, vault_filename(vault))
}
