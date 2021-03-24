# Teaching Service SQL: Query optimization

## Table of Contents
* [Introduction](#Introduction)
* [Setting Environment Y](#Setting-Environment-Y)
    * Primary keys
    * Foreign keys
* [Setting Environment Z](#Setting-Environment-Z)
* [Queries](#Queries)
    * [Query 1](#Query-1)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Conclusion
    * [Query 2](#Query-2)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Conclusion
    * [Query 3.1](#Query-3.1)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Conclusion
    * [Query 3.2](#Query-3.2)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Conclusion
    * [Query 4](#Query-4)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Conclusion
    * [Query 5](#Query-5)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Conclusion
    * [Query 6](#Query-6)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Conclusion



## Introduction
The project consists in the analysis of execution plans for different SQL queries and the evaluation of having different indexes and their impact on the perfomance of those queries.

For that, we created 3 different environemnts(X, Y and Z).
* **Environent X** consists of a basic environemnt without any constraints or restrictions.
* **Environment Y** consists of the same settings present in environment X but includes primary and foreign keys.
* **Environment Z** consists of the same settings present in environment Y but also include indexes.

**NOTE:** You can populate the database by using the scripts in populate/

## Setting Environment Y
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
### Primary keys
```sql
ALTER TABLE "YDOCENTES" ADD CONSTRAINT YDOCENTES_PKEY PRIMARY KEY("NR")
ALTER TABLE "YDSD" ADD CONSTRAINT YDSD_PKEY PRIMARY KEY("NR", "ID")
ALTER TABLE "YTIPOSAULA" ADD CONSTRAINT YTIPOSAULA_PKEY PRIMARY KEY("ID")
ALTER TABLE "YOCORRENCIAS" ADD CONSTRAINT YOCORRENCIAS_PKEY PRIMARY KEY("CODIGO", "ANO LETIVO", "PERIODO")
ALTER TABLE "YUCS" ADD CONSTRAINT YUCS_PKEY PRIMARY KEY("CODIGO")
```
### Foreign keys
```sql
ALTER TABLE "YDSD" ADD CONSTRAINT YDSD_FKEY_YDOCENTES FOREIGN KEY("NR") REFERENCES "YDOCENTES"("NR")
ALTER TABLE "YDSD" ADD CONSTRAINT YDSD_FKEY_YTIPOSAULA FOREIGN KEY("ID") REFERENCES "YTIPOSAULA"("ID")
ALTER TABLE "YOCORRENCIAS" ADD CONSTRAINT YOCORRENCIAS_FKEY_YUCS FOREIGN KEY("CODIGO") REFERENCES "YUCS"("CODIGO")
```
### Setting Environment Z
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>


## Indexes
### B-tree
### Hash
...


## Queries
### Query 1
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 2
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 3.1
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>

**Which courses did have occurrences planned but did not get service assigned in year 2003/2004?***[Using NOT IN]*
#### SQL Formulation
```sql
SELECT DISTINCT UCS.codigo
FROM XOCORRENCIAS OCCURENCES
INNER JOIN XUCS UCS ON OCCURENCES.codigo = UCS.codigo 
WHERE OCCURENCES.ano_letivo = '2003/2004'
    AND UCS.codigo NOT IN (
        SELECT DISTINCT codigo
        FROM XTIPOSAULA CLASS_TYPES
        INNER JOIN XDSD T_DISTRIBUTION ON CLASS_TYPES.id = T_DISTRIBUTION.id
        WHERE CLASS_TYPES.ano_letivo = '2003/2004'  
     )
```
Try with materialized view or index view or normal view
or another table to see if execution plan cost is reduced
#### Result (in JSON format)
* *138 row*
```json
{
  "results" : [
    {
      "columns" : [
        {
          "name" : "CODIGO",
          "type" : "VARCHAR2"
        }
      ],
      "items" : [
        {
          "codigo" : "MEMT1000"
        },
        {
          "codigo" : "MEMT100"
        },
        {
          "codigo" : "EQ418"
        },
        {
          "codigo" : "MTM108"
        },
        {
          "codigo" : "MEMT131"
        },
        {
          "codigo" : "MEEC1053"
        },
        {
          "codigo" : "MEM157"
        },
        {
          "codigo" : "MEM181"
        },
        {
          "codigo" : "MDI1205"
        },
        {
          "codigo" : "MPFCA103"
        },
        {
          "codigo" : "MPFCA204"
        },
        {
          "codigo" : "EIC4220"
        },
        {
          "codigo" : "EIC4221"
        },
        {
          "codigo" : "EIC4222"
        },
        {
          "codigo" : "CI027"
        },
        {
          "codigo" : "MEMT107"
        },
        {
          "codigo" : "MEMT102"
        },
        {
          "codigo" : "MEAM1310"
        },
        {
          "codigo" : "MPPAU2215"
        },
        {
          "codigo" : "MEM187"
        },
        {
          "codigo" : "MEM189"
        },
        {
          "codigo" : "MEA219"
        },
        {
          "codigo" : "EI1107"
        },
        {
          "codigo" : "MPFCA106"
        },
        {
          "codigo" : "EIC4225"
        },
        {
          "codigo" : "CI014"
        },
        {
          "codigo" : "CI018"
        },
        {
          "codigo" : "CI007"
        },
        {
          "codigo" : "CI017"
        },
        {
          "codigo" : "CI008"
        },
        {
          "codigo" : "MEA412"
        },
        {
          "codigo" : "MTM111"
        },
        {
          "codigo" : "MDI1105"
        },
        {
          "codigo" : "MDI1103"
        },
        {
          "codigo" : "MEMT2000"
        },
        {
          "codigo" : "MEAM1312"
        },
        {
          "codigo" : "MEMT135"
        },
        {
          "codigo" : "MPPAU1113"
        },
        {
          "codigo" : "EIC3209"
        },
        {
          "codigo" : "MEM179"
        },
        {
          "codigo" : "MEA215"
        },
        {
          "codigo" : "MEA414"
        },
        {
          "codigo" : "MDI1107"
        },
        {
          "codigo" : "MDI1208"
        },
        {
          "codigo" : "MDI1108"
        },
        {
          "codigo" : "MPPAU2217"
        },
        {
          "codigo" : "MPFCA101"
        },
        {
          "codigo" : "MPFCA205"
        },
        {
          "codigo" : "EIC5127"
        },
        {
          "codigo" : "MTM115"
        },
        {
          "codigo" : "EMM528"
        },
        {
          "codigo" : "MTM110"
        },
        {
          "codigo" : "MEAM5000"
        },
        {
          "codigo" : "EC5280"
        },
        {
          "codigo" : "MPFCA100"
        },
        {
          "codigo" : "MPFCA104"
        },
        {
          "codigo" : "MPFCA200"
        },
        {
          "codigo" : "EC5200"
        },
        {
          "codigo" : "EEC5022"
        },
        {
          "codigo" : "EIC5124"
        },
        {
          "codigo" : "CI020"
        },
        {
          "codigo" : "CI016"
        },
        {
          "codigo" : "CI011"
        },
        {
          "codigo" : "MTM114"
        },
        {
          "codigo" : "MPPAU1114"
        },
        {
          "codigo" : "MEM180"
        },
        {
          "codigo" : "MVC1211"
        },
        {
          "codigo" : "MEA112"
        },
        {
          "codigo" : "MEA217"
        },
        {
          "codigo" : "MEA320"
        },
        {
          "codigo" : "MEMT106"
        },
        {
          "codigo" : "EC5287"
        },
        {
          "codigo" : "MDI1106"
        },
        {
          "codigo" : "MPPAU2219"
        },
        {
          "codigo" : "MPFCA105"
        },
        {
          "codigo" : "MPFCA107"
        },
        {
          "codigo" : "MPFCA201"
        },
        {
          "codigo" : "MPFCA202"
        },
        {
          "codigo" : "MPFCA206"
        },
        {
          "codigo" : "EIC5125"
        },
        {
          "codigo" : "EIC5126"
        },
        {
          "codigo" : "CI038"
        },
        {
          "codigo" : "MEB205"
        },
        {
          "codigo" : "EQ407"
        },
        {
          "codigo" : "MDI1204"
        },
        {
          "codigo" : "MDI1100"
        },
        {
          "codigo" : "MFAMF1108"
        },
        {
          "codigo" : "MPPAU2220"
        },
        {
          "codigo" : "MPPAU2216"
        },
        {
          "codigo" : "MEM163"
        },
        {
          "codigo" : "MEM175"
        },
        {
          "codigo" : "MEM184"
        },
        {
          "codigo" : "MEM188"
        },
        {
          "codigo" : "MEM191"
        },
        {
          "codigo" : "MEA415"
        },
        {
          "codigo" : "EIC4223"
        },
        {
          "codigo" : "EIC5122"
        },
        {
          "codigo" : "EIC5123"
        },
        {
          "codigo" : "CI023"
        },
        {
          "codigo" : "CI009"
        },
        {
          "codigo" : "MEM1205"
        },
        {
          "codigo" : "GEI512"
        },
        {
          "codigo" : "MEMT105"
        },
        {
          "codigo" : "MTM104"
        },
        {
          "codigo" : "MEAM1314"
        },
        {
          "codigo" : "EQ411"
        },
        {
          "codigo" : "MDI1207"
        },
        {
          "codigo" : "MDI1209"
        },
        {
          "codigo" : "MEB204"
        },
        {
          "codigo" : "MMCCE1220"
        },
        {
          "codigo" : "EEC2207"
        },
        {
          "codigo" : "EIC4224"
        },
        {
          "codigo" : "EIC5129"
        },
        {
          "codigo" : "CI019"
        },
        {
          "codigo" : "CI002"
        },
        {
          "codigo" : "CI025"
        },
        {
          "codigo" : "CI037"
        },
        {
          "codigo" : "MEB105"
        },
        {
          "codigo" : "EQ308"
        },
        {
          "codigo" : "MPPAU2218"
        },
        {
          "codigo" : "MPPAU1112"
        },
        {
          "codigo" : "EEC5272"
        },
        {
          "codigo" : "MEM5000"
        },
        {
          "codigo" : "MEM158"
        },
        {
          "codigo" : "MEM182"
        },
        {
          "codigo" : "MEM183"
        },
        {
          "codigo" : "MEA216"
        },
        {
          "codigo" : "MEA319"
        },
        {
          "codigo" : "MEST210"
        },
        {
          "codigo" : "MEMT110"
        },
        {
          "codigo" : "MDI1206"
        },
        {
          "codigo" : "MEMT120"
        },
        {
          "codigo" : "MPPAU1115"
        },
        {
          "codigo" : "MPFCA102"
        },
        {
          "codigo" : "MPFCA203"
        },
        {
          "codigo" : "CI003"
        },
        {
          "codigo" : "CI004"
        },
        {
          "codigo" : "CI013"
        }
      ]
    }
  ]
}
```
#### Execution Plan
|           | Environment X | Environment Y | Environment Z |
| --------- | ------------- | ------------- | ------------- |
| Cost      |   670         |      86       |               |
| Time (ms) |   106         |      55       |               |

##### Environment X
![](https://i.imgur.com/tMCBKS6.png)
##### Environment Y
![](https://i.imgur.com/UU6W6pH.png)
##### Environment Z

#### Conclusion
---
### Query 3.2
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>

**Which courses did have occurrences planned but did not get service assigned in year 2003/2004?** *[Using external join and is null]*
#### SQL Formulation
```sql
SELECT DISTINCT UCS.codigo
FROM XOCORRENCIAS OCCURENCES
INNER JOIN XUCS UCS ON OCCURENCES.codigo = UCS.codigo
LEFT OUTER JOIN (
    SELECT DISTINCT codigo
    FROM XTIPOSAULA CLASS_TYPES
    INNER JOIN XDSD T_DISTRIBUTION ON CLASS_TYPES.id = T_DISTRIBUTION.id
    WHERE CLASS_TYPES.ano_letivo = '2003/2004'
) PLANNED_UCS ON PLANNED_UCS.codigo = UCS.codigo
WHERE PLANNED_UCS.CODIGO IS NULL 
    AND ANO_LETIVO = '2003/2004'
```
Try with materialized view or index view or normal view
or another table to see if execution plan cost is reduced
#### Result (in JSON format)
* The same result as in [Query 3.1](#Query-3.1)
#### Execution Plan
|           | Environment X | Environment Y | Environment Z |
| --------- | ------------- | ------------- | ------------- |
| Cost      |   671         |      87       |               |
| Time (ms) |   64          |      51       |               |

##### Environment X
![](https://i.imgur.com/erJTuaF.png)
##### Environment Y
![](https://i.imgur.com/BbyqtbR.png)
##### Environment Z
---
### Query 4
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 5
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 6
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
