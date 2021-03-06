% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connection.R
\docType{methods}
\name{dbConnect,Data.WorldDriver-method}
\alias{dbConnect,Data.WorldDriver-method}
\title{Connect to a dataset like it's a database.}
\usage{
\S4method{dbConnect}{Data.WorldDriver}(drv, dataset, ...)
}
\arguments{
\item{drv}{A \code{Data.Worldriver} object, created
by \code{\link{Data.World}()}.}

\item{dataset}{The name of a data.world dataset. E.g.,
"johndoe/pet_store".}
}
\value{
A "handle" in the form of Data.WorldConnection object.
}
\description{
Connect to a dataset like it's a database.
}
\note{
Even though it doesn't make an API call, this function
will throw an error if your data.world API token has not been
configured. See \code{\link[dwapi]{configure}}.
This ensures that any subsequent queries sent over
this connection will work.

Since data.world queries are done via API call, and there's
no persistent connection, this function really just holds
some basic parameters that are necessary for making API
calls related to the dataset.
}
\examples{
\dontrun{
conn <- dbConnect(Data.World(), dataset='johndoe/petstore')
dbGetQuery(conn, "SELECT * FROM pets WHERE species = 'dog'")
}

}
