#' @include driver.R
NULL

#' data.world connection class
#'
#' @keywords internal
#' @export
setClass('Data.WorldConnection',
         contains='DBIConnection',
         slots=c(dataset='character'))

#' Connect to a dataset like it's a database.
#'
#' @param drv A \code{Data.Worldriver} object, created
#' by \code{\link{Data.World}()}.
#' @param dataset The name of a data.world dataset. E.g.,
#' "johndoe/pet_store".
#'
#' @note Even though it doesn't make an API call, this function
#' will throw an error if your data.world API token has not been
#' configured. See \code{\link[dwapi]{configure}}.
#' This ensures that any subsequent queries sent over
#' this connection will work.
#'
#' Since data.world queries are done via API call, and there's
#' no persistent connection, this function really just holds
#' some basic parameters that are necessary for making API
#' calls related to the dataset.
#'
#' @examples
#' \dontrun{
#' conn <- dbConnect(Data.World(), dataset='johndoe/petstore')
#' dbGetQuery(conn, "SELECT * FROM pets WHERE species = 'dog'")
#' }
#'
#' @return A "handle" in the form of Data.WorldConnection object.
#' @export
setMethod('dbConnect', 'Data.WorldDriver',
          function(drv, dataset, ...) {
            # Check if the API token has been configured.
            # This will throw a helpful error if not.
            dwapi:::auth_token()
            new('Data.WorldConnection', dataset=dataset, ...)
            })

#' Connect to a dataset like it's a database.
#'
#' @param dataset The name of a data.world dataset.
#'
#' @note Even though it doesn't make an API call, this function
#' will throw an error if your data.world API token has not been
#' configured. See \code{\link[dwapi]{configure}}.
#' This ensures that any subsequent queries sent over
#' this connection will work.
#'
#' @return A "handle" in the form of Data.WorldConnection object.
#'
#' @examples
#' \dontrun{
#' conn <- dw_connect('johndoe/petstore')
#' dbGetQuery(conn, "SELECT * FROM pets WHERE species = 'dog'")
#' }
#'
#' @export
dw_connect <- function(dataset) {
  dbConnect(Data.World(), dataset)
}

#' A disconnect method for Data.World connections.
#'
#' This is a placeholder that doesn't do anything.
#'
#' @param conn A \code{Data.WorldConnection} object, as created
#' by \code{\link[dwDBI]{dbConnect}}.
#'
#' @export
setMethod('dbDisconnect', 'Data.WorldConnection',
          function(conn, ...) { TRUE })

#' @importFrom glue glue
setMethod('show', 'Data.WorldConnection',
          function(object) {
            cat(glue('<Data.WorldConnection(dataset={object@dataset})>\n'))
          })


#' Get information about a data.world dataset.
#'
#' @param conn A \code{Data.WorldConnection} object, as created
#' by \code{\link[dwDBI]{dbConnect}}.
#'
#' @return A named list with the following entries:
#' \itemize{
#'   \item owner
#'   \item id
#'   \item title
#'   \item visibility
#'   \item updated
#'   \item created
#'   \item status
#'   \item description
#'   \item summary
#'   \item tags
#'   \item license
#'   \item files
#'   }
setMethod('dbGetInfo', 'Data.WorldConnection',
          function(dbObj, ...) {
            dwapi::get_dataset(dbObj@dataset)
          })
