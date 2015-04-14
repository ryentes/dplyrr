# dplyrr - Tools for improvement of experience on dplyr with databases
Koji MAKIYAMA  



## Overview

`dplyr` is the most powerful package for data handling in R, and it has also the ability of working with databases([See Vignette](http://cran.rstudio.com/web/packages/dplyr/vignettes/databases.html)).  
But the functionalities of dealing with databases in `dplyr` is developing yet.

Now, I'm trying to make `dplyr` with databases more comfortable by using some functions.  
For that purpose, I've created `dplyrr` package.

`dplyrr` has below functions:

- `load_tbls()` : Easy to load table objects for all tables in a database.
- `case_cut()` : Easy to create a case statement by using the grammar like the `base::cut()`.
- `filter()` : Improved `filter()` for `tbl_sql` which adds parentheses appropriately.
- `moving_average()` : Compute moving average for PostgreSQL.

`dplyrr` is going to have below functions:

- Compute `first_value` for PostgreSQL.

## How to install


```r
install.packages("devtools") # if you have not installed "devtools" package
devtools::install_github("hoxo-m/dplyrr")
```

## Common functions for all databases

In this section, we use a database file, "my_db.sqlite3", for illustration.  
If you want to trace codes below, you should first create the databese.


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
## Loading: airlines_tbl
## Loading: airports_tbl
## Loading: flights_tbl
## Loading: planes_tbl
## Loading: sqlite_stat1_tbl
## Loading: weather_tbl
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

### `case_cut()`

If you want to write case statement with like cut(), you can `case_cut()` function.

For example, there is `air_time` column in the database.


```r
db <- src_sqlite("my_db.sqlite3")
flights_tbl <- tbl(db, "flights")
q <- flights_tbl %>% select(air_time)
air_time <- q %>% collect
head(air_time, 3)
```

```
## Source: local data frame [3 x 1]
## 
##   air_time
## 1      227
## 2      227
## 3      160
```

If you want to group the `air_time` by break points `c(0, 80, 120, 190, 900)`, you think you must write next code.


```r
q <- flights_tbl %>% 
  select(air_time) %>%
  mutate(air_time_cut=if(air_time > 0 && air_time <= 80) "(0,80]"
         else if(air_time > 80 && air_time <= 120) "(80,120]"
         else if(air_time > 120 && air_time <= 190) "(120,190]"
         else if(air_time > 190 && air_time <= 900) "(190,900]")
air_time_with_cut <- q %>% collect
head(air_time_with_cut, 3)
```

```
## Source: local data frame [3 x 2]
## 
##   air_time air_time_cut
## 1      227    (190,900]
## 2      227    (190,900]
## 3      160    (120,190]
```

When the break points increase, you are going to be tired to write more lines.

Using `case_cut()` function, it can be easily.


```r
q <- flights_tbl %>% 
  select(air_time) %>%
  case_cut(air_time_cut=air_time, breaks=c(0, 80, 120, 190, 900))
air_time_with_cut <- q %>% collect
head(air_time_with_cut, 3)
```

```
## Source: local data frame [3 x 2]
## 
##   air_time air_time_cut
## 1      227    (190,900]
## 2      227    (190,900]
## 3      160    (120,190]
```

The `case_cut()` has more arguments such as `labels` coming from `base::cut()`.

### Improved `filter()`


```r
detach("package:dplyrr", unload = TRUE)
detach("package:dplyr", unload = TRUE)
library(dplyr)

db <- src_sqlite("my_db.sqlite3")
flights_tbl <- tbl(db, "flights")
q <- flights_tbl %>%
  select(month, air_time) %>%
  filter(month == 1) %>%
  filter(air_time > 200 || air_time < 100)
q$query
```

```
## <Query> SELECT "month" AS "month", "air_time" AS "air_time"
## FROM "flights"
## WHERE "month" = 1.0 AND "air_time" > 200.0 OR "air_time" < 100.0
## <SQLiteConnection>
```


```r
library(dplyrr)

db <- src_sqlite("my_db.sqlite3")
flights_tbl <- tbl(db, "flights")
q <- flights_tbl %>%
  select(month, air_time) %>%
  filter(month == 1) %>%
  filter(air_time > 200 || air_time < 100)
q$query
```

```
## <Query> SELECT "month" AS "month", "air_time" AS "air_time"
## FROM "flights"
## WHERE ("month" = 1.0) AND ("air_time" > 200.0 OR "air_time" < 100.0)
## <SQLiteConnection>
```

## Functions for PostgreSQL

### `moving_average()`


```r
db <- src_postgres()
account_tbl <- tbl(db, "account")
q <- account_tbl %>% 
  filter(between(register_datetime, "2010-09-01", "2010-10-01")) %>%
  count(date=date_trunc("days", register_datetime)) %>%
  rename(account_num=n) %>%
  arrange(date) %>%
  moving_average(moving_average3=account_num(1), moving_average5=account_num(2))
data <- q %>% collect
data
```

