#' @import DBI methods
NULL

#' Driver for the data.world API.
#'
#' @keywords internal
#' @export
setClass('Data.WorldDriver', contains='DBIDriver')

setMethod('show', 'Data.WorldDriver',
          function(object) cat('<Data.WorldDriver>\n'))

#' @export
Data.World <- function() new("Data.WorldDriver")

