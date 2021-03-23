# Teaching Service SQL: Query optimization

## Table of Contents
* [Introduction](#Introduction)
* [Indexes](#Indexes)
* [Queries](#Queries)
    * [Query 1](#Query-1)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Execution Time
        * Conclusion
    * [Query 2](#Query-2)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Execution Time
        * Conclusion
    * [Query 3.1](#Query-3.1)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Execution Time
        * Conclusion
    * [Query 3.2](#Query-3.2)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Execution Time
        * Conclusion
    * [Query 4](#Query-4)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Execution Time
        * Conclusion
    * [Query 5](#Query-5)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Execution Time
        * Conclusion
    * [Query 6](#Query-6)
        * SQL Formulation
        * Result
        * Execution Plan
            * Environment X
            * Environment Y
            * Environment Z
        * Execution Time
        * Conclusion



## Introduction
The project consists in the analysis of execution plans for different SQL queries and the evaluation of having different indexes and their impact on the perfomance of those queries.

For that, we created 3 different environemnts(X, Y and Z).
* **Environent X** consists of a basic environemnt without any constraints or restrictions.
* **Environment Y** consists of the same settings present in environment X but includes primary and foreign keys.
* **Environment Z** consists of the same settings present in environment Y but also include indexes.

**NOTE:** You can populate the database by using the scripts in populate/

## Setting Environment Y
### Primary keys
### Foreign keys

## Indexes
### B-tree
### Hash
...


## Queries
### Query 1
##### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 2
##### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 3.1
##### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>

**Which courses did have occurrences planned but did not get service assigned in year 2003/2004?**
#### SQL Formulation
```sql
SELECT UCS.codigo
FROM XOCORRENCIAS OCCURENCES
JOIN XUCS UCS
ON OCCURENCES.codigo = UCS.codigo
WHERE OCCURENCES.ano_letivo = '2003/2004' 
    AND UCS.codigo NOT IN (
        SELECT codigo
        FROM XTIPOSAULA CLASS_TYPES
        JOIN XDSD AS T_DISTRIBUTION
        ON CLASS_TYPES.id = T_DISTRIBUTION.id
        WHERE OCCURENCES.ano_letivo = '2003/2004'  
    )
    
```
#### Result (in JSON format)
* *61 row*
```json
{
    "results": [
        {
            "columns": [
                {
                    "name":"CODIGO",
                    "type":"VARCHAR2"
                }
            ],
            "items": [
                {
                    "codigo":"MEMT2000"
                },
                {
                    "codigo":"MEMT100"
                },
                {
                    "codigo":"MPFCA204"
                },
                {
                    "codigo":"MEAM1312"
                },
                {
                    "codigo":"CI037"
                },
                {
                    "codigo":"MPFCA100"
                },
                {
                    "codigo":"MPFCA202"
                },
                {
                    "codigo":"MPFCA104"
                },
                {
                    "codigo":"MPFCA101"
                },
                {
                    "codigo":"MEA319"
                },
                {
                    "codigo":"CI027"
                },
                {
                    "codigo":"MPFCA106"
                },
                {
                    "codigo":"MEA215"
                },
                {
                    "codigo":"MTM115"
                },
                {
                    "codigo":"CI023"
                },
                {
                    "codigo":"EEC5022"
                },
                {
                    "codigo":"MEA217"
                },
                {
                    "codigo":"EEC2207"
                },
                {
                    "codigo":"MEM191"
                },
                {
                    "codigo":"EC5200"
                },
                {
                    "codigo":"MTM111"
                },
                {
                    "codigo":"MPFCA105"
                },
                {
                    "codigo":"MPFCA107"
                },
                {
                    "codigo":"MEA219"
                },
                {
                    "codigo":"CI038"
                },
                {
                    "codigo":"MEM184"
                },
                {
                    "codigo":"MEA414"
                },
                {
                    "codigo":"MEAM1310"
                },
                {
                    "codigo":"MPFCA203"
                },
                {
                    "codigo":"MEMT1000"
                },
                {
                    "codigo":"MEMT110"
                },
                {
                    "codigo":"MPFCA205"
                },
                {
                    "codigo":"MEM182"
                },
                {
                    "codigo":"MEM181"
                },
                {
                    "codigo":"MPFCA201"
                },
                {
                    "codigo":"MEA415"
                },
                {
                    "codigo":"MEM158"
                },
                {
                    "codigo":"MTM114"
                },
                {
                    "codigo":"MEA216"
                },
                {
                    "codigo":"MEMT107"
                },
                {
                    "codigo":"MEM189"
                },
                {
                    "codigo":"CI025"
                },
                {
                    "codigo":"MEMT106"
                },
                {
                    "codigo":"MEMT135"
                },
                {
                    "codigo":"MMCCE1220"
                },
                {
                    "codigo":"MEA112"
                },
                {
                    "codigo":"MPFCA102"
                },
                {
                    "codigo":"MEA320"
                },
                {
                    "codigo":"MEEC1053"
                },
                {
                    "codigo":"MEM157"
                },
                {
                    "codigo":"MEM5000"
                },
                {
                    "codigo":"MEMT102"
                },
                {
                    "codigo":"MEMT120"
                },
                {
                    "codigo":"MEAM5000"
                },
                {
                    "codigo":"MPFCA206"
                },
                {
                    "codigo":"GEI512"
                },
                {
                    "codigo":"MPFCA103"
                },
                {
                    "codigo":"MEM187"
                },
                {
                    "codigo":"MEMT131"
                },
                {
                    "codigo":"MTM108"
                },
                {
                    "codigo":"MPFCA200"
                }
            ]
        }
    ]
}

```
#### Execution Plan
#### Environment X
#### Environment Y
#### Environment Z
---
### Query 3.2
##### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 4
##### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 5
##### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 6
##### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
