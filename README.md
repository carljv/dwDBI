dwDBI: A DBI interface for data.world datasets
================

Intro
-----

The `dwDBI` package provides:

1.  A light [DBI](http://db.rstudio.com/dbi/) wrapper around the [data.world API package](https://cran.r-project.org/web/packages/data.world/index.html). The benefit of this is that you can write SQL queries in RMarkdown chunks and evaluate them.
2.  Contracts that let you browse data.world datasets with the RStudio Connections panel.

Querying data.world dataset in RMarkdown Notebooks
==================================================

First import the package.

``` r
library('dwDBI')
```

Make sure that you've configured your data.world API key.

``` r
dwapi::configure('YOUR API KEY HERE')
```

To run a SQL query, connect to a data.world dataset with the `dw_connect()` function.

``` r
sql101_conn <- dw_connect('ryantuck/sql-101-training')
```

In RStudio, you can write and run SQL code chunks by specifying a connection option.

    # ```{sql, connection=sql101_conn}
    #     ... your query here ...
    #```

Running the SQL code chunk returns a data frame.

``` sql
select *
from customers
order by `last`
```

|   id| first     | last      |
|----:|:----------|:----------|
|   14| Margaret  | Atwood    |
|    2| Jane      | Austen    |
|   12| Charlotte | Brontë    |
|   20| Emily     | Brontë    |
|    0| Ernest    | Hemingway |
|   17| Victor    | Hugo      |
|   10| Franz     | Kafka     |
|    8| Jack      | Kerouac   |
|   16| Harper    | Lee       |
|    6| Vladimir  | Nabokov   |

RStudio Connections
-------------------

You can also explore the tables in data.world datasets in the [RStudio Connections pane](https://support.rstudio.com/hc/en-us/articles/115010915687-Using-RStudio-Connections). Just use the "New Connection" button in the pane, select the "Data.World" connection type, and enter the name of the dataset you want to view.
