#' Driver for the data.world API.
#'
#' @keywords internal
#' @import DBI
#' @import methods
#' @export
setClass('Data.WorldDriver', contains='DBIDriver')

#' @rdname Data.World-class
#' @export
setMethod('dbUnloadDriver', 'Data.WorldDriver',
          function(drv, ...) { TRUE })

setMethod('show', 'Data.WorldDriver',
          function(object) cat('<Data.WorldDriver>\n'))

#' @export
Data.World <- function() new("Data.WorldDriver")

