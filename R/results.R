setClass('Data.WorldResult',
         contains='DBIResult',
         slots=c(.Data='data.frame'))

#' Send a query to a data.world dataset.
#'
#' @param conn A \code{Data.WorldConnection} object, as created
#' by \code{\link[dwDBI]{dbConnect}}.
#' @param statement A SQL query string. The query
#' can be parameterized.
#' @param params Any parameters to pass into the
#' query before running.
#'
#' @return A \code{Data.WorldResult} object. A data
#' frame with the query results can be obtained by
#' calling \code{\link{dbFetch}} on the result.
#'
#' @seealso \code{\link[dwapi]{sql}}.
#' @export
setMethod('dbSendQuery', c('Data.WorldConnection'),
          function(conn, statement, params, ...) {
            res <- dwapi::sql(conn@dataset, query, params)
            new('Data.WorldResult', .Data=res)
          })

#' @export
setMethod('dbClearResult', 'Data.WorldResult',
          function(res) { TRUE })

#' Get a data frame with results of a sent query.
#'
#' @param res a \code{Data.WorldResult} object, resulting
#' from a call to \code{\link{dbSendQuery}}.
#' @param n Not used. All rows are fetched.
#'
#' @return A data frame.
#'
#' @examples
#' \dontrun{
#' conn <- dbConnect(Data.World(), 'johndoe/petstore')
#' old_cats_res <- dbSendQuery(conn,
#'                             'SELECT name, age, color
#'                              FROM pets
#'                              WHERE species=='cat' AND age > 10')
#' old_cats <- dbFetch(old_cats_res)
#' }
#'
#' }
#' @export
setMethod('dbFetch', 'Data.WorldResult',
          function(res, n=NULL, ...) { res@.Data })


#' @export
setMethod('dbHasCompleted', 'Data.WorldResult',
          function(res, ...) { TRUE })

#' Get the column types of a query result.
#'
#' @param A \code{Data.WorldResult} object. A data
#' frame with the query results can be obtained by
#' calling \code{\link{dbFetch}} on the result.
#'
#' @return A data frame with columns "name" and
#' "type" that list the result's columns and their
#' types.
#'
#' @importFrom purrr map_chr
#' @export
setMethod('dbColumnInfo', 'Data.WorldResult',
          function(res, ...) {
            data_frame(name=names(res@.Data),
                       type=map_chr(res@.Data, typeof))})
