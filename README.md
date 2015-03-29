# dplyrr - Tools for improvement of experience on dplyr with databases
Koji MAKIYAMA  



## Overview

`dplyr` is the most powerful package for data handling in R, and it has also the ability of working with databases([See Vignette](http://cran.rstudio.com/web/packages/dplyr/vignettes/databases.html)).  
But the functionalities of dealing with databases in `dplyr` is developing yet.

Now, I'm trying to make `dplyr` with databases more comfortable by using some functions.  
For that purpose, I've created `dplyrr` package.

`dplyrr` has below functions:

- `load_tbls()` : Easy to load table objects for all tables in a database.
- `moving_average()` : Compute moving average for PostgreSQL.

`dplyrr` is going to have below functions:

- Easy to create case statement with `cut()`.
- Compute `first_value` for PostgreSQL.

## How to install


```r
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("hoxo-m/dplyrr")
```

## Common functions for all databases

In this section, we use a database file, "my_db.sqlite3", for illustration.  
If you want to trace the codes, you should first create the databese.


```r
library(dplyrr)
library(nycflights13)

db <- src_sqlite("my_db.sqlite3", create = TRUE)
copy_nycflights13(db)
```

### `load_tbls()`

Usually, when we use a database with `dplyr`, we first create database object, and we can see the tables in the databese by `show()`.


```r
library(dplyrr)
# Create database object
db <- src_sqlite("my_db.sqlite3")
show(db)
```

```
## src:  sqlite 3.8.6 [my_db.sqlite3]
## tbls: airlines, airports, flights, planes, sqlite_stat1, weather
```

Next, we create table objects for pulling data in some tables in the database.


```r
airlines_tbl <- tbl(db, "airlines")
airports_tbl <- tbl(db, "airports")
flights_tbl <- tbl(db, "flights")
planes_tbl <- tbl(db, "planes")
weather_tbl <- tbl(db, "weather")
```

Typing this code is really a bore!

If you want to create table objects for **all tables in the database**, you can use `load_tbls()`.


```r
load_tbls(db)
```

```
## airlines_tbl <- tbl(db, "airlines")
## airports_tbl <- tbl(db, "airports")
## flights_tbl <- tbl(db, "flights")
## planes_tbl <- tbl(db, "planes")
## sqlite_stat1_tbl <- tbl(db, "sqlite_stat1")
## weather_tbl <- tbl(db, "weather")
```

Check the created table objects.


```r
ls(pattern = "_tbl$")
```

```
## [1] "airlines_tbl"     "airports_tbl"     "flights_tbl"     
## [4] "planes_tbl"       "sqlite_stat1_tbl" "weather_tbl"
```

```r
glimpse(airlines_tbl)
```

```
## Observations: 16
## Variables:
## $ carrier (chr) "9E", "AA", "AS", "B6", "DL", "EV", "F9", "FL", "HA", ...
## $ name    (chr) "Endeavor Air Inc.", "American Airlines Inc.", "Alaska...
```

## Functions for PostgreSQL

### `moving_average()`

