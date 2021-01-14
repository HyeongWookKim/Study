# lec3_4.r
# Reading other format data : EXCEL, SPSS, SAS, ODBC

# set working directory
setwd("D:/tempstore/moocr")

# 1. several sheets in Excel file
install.packages("readxl")
library(readxl)

mtcars1 <- read_excel("D:/tempstore/moocr/mtcarsb.xlsx", 
                      sheet = "mtcars")
mtcars1 <- read_excel("D:/tempstore/moocr/mtcarsb.xlsx", 
                      sheet = 1)
head(mtcars1)

brain1<-read_excel("D:/tempstore/moocr/mtcarsb.xlsx", 
                 sheet = "brain")
head(brain1)

brainm<-read_excel("D:/tempstore/moocr/mtcarsb.xlsx", 
                   sheet = 2)
head(brainm)

# 2. ODBC data import- STATA, Systat, Weka, dBase ..
install.packages("foreign")
library(foreign)

# 3. Reading SAS data file
install.packages("sas7bdat")
library(sas7bdat)

b1<-read.sas7bdat("brain.sas7bdat")
head(b1)
str(b1)

# 4. Reading from SQL database
# by Anders Stockmarr, Kasper Kristensen

# reading data from SQL databse

install.packages("RODBC")
library(RODBC)

connStr <- paste(
  "Server=msedxeus.database.windows.net",
  "Database=DAT209x01",
  "uid=RLogin",
  "pwd=P@ssw0rd",
  "Driver={SQL Server}",
  sep=";"
)

conn <- odbcDriverConnect(connStr)

#A first query

tab <- sqlTables(conn)
head(tab)

#Getting a table

mf <- sqlFetch(conn,"bi.manufacturer")
mf

close(conn)

