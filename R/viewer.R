# RStudio Connections viewer contract

#' @include connection.R
NULL

#' View a data.world dataset in the RStudio Connections panel.
#'
#' @param dataset The name of a data.world dataset.
#'
#' @export
dw_dataset_viewer <- function(dataset) {
  code <- glue('dwDBI::dw_dataset_viewer("{dataset}")')
  conn <- dw_connect(dataset)
  dw_viewer_opened(code, conn)
}

dw_viewer_opened <- function(code, conn) {
  observer <- getOption('connectionObserver')
  if (!is.null(observer)) {
    observer$connectionOpened(
      icon=system.file('icons', 'datadotworld.icon', package='dwDBI'),
      type='data.world',
      host='data.world',
      displayName='data.world dataset viewer',
      connectCode=code,
      disconnect=dw_viewer_closed,
      listObjectTypes=dw_viewer_list_object_types,
      listObject=function() { dw_viewer_list_objects(conn) },
      listColumn=function(table) { dw_viewer_list_columns(conn, table) },
      previewObject=function(limit=100, table=NULL) {
        dw_viewer_preview_object(conn, table, limit)
        },
      actions=list(),
      connectionObject=conn)
  }
}

dw_viewer_closed <- function(...) {
  observer <- getOption('connectionObserver')
  if (!is.null(observer)) {
    observer$connectionClosed(type='data.world', host='data.world')
  }
}

dw_viewer_list_object_types <- function() {
  list(table=list(contains='data'))
}

#' @importFrom tibble data_frame
dw_viewer_list_objects <- function(conn) {
  data_frame(name=dbListTables(conn), type='table')
}

#' @importFrom purrr map_chr
#' @importFrom stringr str_match
#' @importFrom dplyr %>%
#' @importFrom tibble data_frame
dw_viewer_list_columns <- function(conn, table) {
  schema <- dwapi::get_table_schema(conn@dataset, table)
  names <- map_chr(schema$fields, 'name')
  types <- schema$fields %>%
    map_chr('rdf_type') %>%
    str_match('#(.*)$')
  data_frame(name=names, type=types[ , 2])
}

#' @importFrom glue glue_sql
#' @importFrom tibble data_frame
dw_viewer_preview_object <- function(conn, table, limit) {
  qry <- glue_sql('select * from {`table`} limit {limit}',
                  .con=conn)
  dbGetQuery(conn, qry)
}