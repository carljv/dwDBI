#' Read an entire data.world table into a data frame.
#'
#' @param conn A \code{Data.WorldConnection} object, as created
#' by \code{\link[dwDBI]{dbConnect}}.
#' @param name Name of the table to read.
#'
#' @return A data frame.
#'
#' @examples
#' \dontrun{
#' conn <- dbConnect(Data.World(), dataset='johndoe/petstore')
#' customers <- dbReadTable(conn, customers)
#' }
#'
#' @seealso \code{\link[dwapi]{download_table_as_data_frame}}.
#' @export
setMethod('dbReadTable', c('Data.WorldConnection', 'character'),
          function(conn, name) {
            df <- dwapi::download_table_as_data_frame(conn@dataset, name)})


#' List the tables in the data.world dataset connection.
#'
#' @param conn A \code{Data.WorldConnection} object, as created
#' by \code{\link[dwDBI]{dbConnect}}.
#'
#' @return A character vector of table names.
#'
#' @seealso \code{\link[dwapi]{list_tables}}.
#' @export
setMethod('dbListTables', c('Data.WorldConnection'),
          function(conn, ...) { dwapi::list_tables(conn@dataset) })

#' Check if a table exists in a data.world dataset.
#'
#' @param conn A \code{Data.WorldConnection} object, as created
#' by \code{\link[dwDBI]{dbConnect}}.
#' @param name The name of the table to check. The comparison
#' is case-insensitive.
#'
#' @return TRUE if the table is in the dataset, FALSE if not.
#'
#' @seealso \code{\link[dwapi]{list_tables}}
#'
#' #' @export
setMethod('dbTableExists', c('Data.WorldConnection', 'character'),
          function(conn, name, ...) {
            tables <- dwapi::list_tables(conn@dataset)
            tolower(name) %in% tolower(tables)
          })

#' List the columns of a table in a data.world dataset.
#'
#' @param conn A \code{Data.WorldConnection} object, as created
#' by \code{\link[dwDBI]{dbConnect}}.
#' @param name The name of the table to check. The comparison
#' is case-insensitive.
#'
#' @return A character vector of field names.
#'
#' @seealso \code{\link[dwapi]{get_table_schema}}
#'
#' @importFrom purrr map_chr
#' @export
setMethod('dbListFields', c('Data.WorldConnection', 'character'),
          function(conn, name, ...) {
            schema <- dwapi::get_table_schema(dataset=conn@dataset,
                                              table_name=name)
            map_chr(schema, 'name')
          })

#' Upload a data frame as a CSV file a data.world dataset.
#'
#' @param conn A \code{Data.WorldConnection} object, as created
#' by \code{\link[dwDBI]{dbConnect}}.
#' @param name What the uploaded file should be named. If the
#' name does not end in '.csv', it will be added.
#' @param value A data frame to upload to the dataset.
#'
#' @returns TRUE if the file was written successfully.
#'
#' @importFrom stringr str_detect str_trim
#' @importFrom glue glue
#' @export
setMethod('dbWriteTable',
          c('Data.WorldConnection', 'character', 'data.frame'),
          function(conn, name, value, ...) {
            name <- str_trim(name)
            if (!str_detect(name, '\\.csv$')) {
              name <- glue('{name}.csv')
            }
            cat(glue('Uploading data frame to {conn@dataset}/{name}.\n'))
            dwapi::upload_data_frame(dataset=conn@dataset,
                                     data_frame=value,
                                     file_name=name)
            TRUE
          })

#' Upload a local file to a data.world dataset.
#'
#' @param conn A \code{Data.WorldConnection} object, as created
#' by \code{\link[dwDBI]{dbConnect}}.
#' @param name What the uploaded file should be named. If the
#' name does not end in '.csv', it will be added.
#' @param value A path to local file.
#'
#' @returns TRUE if the file was written successfully.
#'
#' @seealso \code{\link[dwapi]{upload_file}}
#'
#' @importFrom glue glue
#' @importFrom purrr %||%
#' @export
setMethod('dbWriteTable',
          c('Data.WorldConnection', 'character', 'character'),
          function(conn, name=NULL, value, ...) {
            filename <- basename(value)
            name <- name %||% filename
            cat(glue('Uploading {filename} to {conn@dataset}/{name}\n'))
            dwapi::upload_file(dataset=conn@dataset,
                               path=value,
                               file_name=name)
          })






