# Teaching Service SQL: Query optimization

## Table of Contents
* [Introduction](#Introduction)
* [Setting Environment Y](#Setting-Environment-Y)
    * Primary keys
    * Foreign keys
* [Setting Environment Z](#Setting-Environment-Z)
    * Primary keys
    * Foreign keys
    * Indexes
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
    * [Conclusion](#Conclusion)



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
ALTER TABLE "YDOCENTES" 
    ADD CONSTRAINT YDOCENTES_PKEY 
    PRIMARY KEY("NR");
    
ALTER TABLE "YDSD" 
    ADD CONSTRAINT YDSD_PKEY 
    PRIMARY KEY("NR", "ID");
    
ALTER TABLE "YTIPOSAULA" 
    ADD CONSTRAINT YTIPOSAULA_PKEY 
    PRIMARY KEY("ID");

ALTER TABLE "YOCORRENCIAS" 
    ADD CONSTRAINT YOCORRENCIAS_PKEY 
    PRIMARY KEY("CODIGO", "ANO_LETIVO", "PERIODO");
    
ALTER TABLE "YUCS" 
    ADD CONSTRAINT YUCS_PKEY 
    PRIMARY KEY("CODIGO");
```
### Foreign keys
```sql
ALTER TABLE "YDSD" 
    ADD CONSTRAINT YDSD_FKEY_YDOCENTES 
    FOREIGN KEY("NR") 
    REFERENCES "YDOCENTES"("NR");
    
ALTER TABLE "YDSD" 
    ADD CONSTRAINT YDSD_FKEY_YTIPOSAULA 
    FOREIGN KEY("ID") 
    REFERENCES "YTIPOSAULA"("ID");
    
ALTER TABLE "YOCORRENCIAS" 
    ADD CONSTRAINT YOCORRENCIAS_FKEY_YUCS 
    FOREIGN KEY("CODIGO") 
    REFERENCES "YUCS"("CODIGO");

ALTER TABLE "YTIPOSAULA" 
    ADD CONSTRAINT YTIPOSAULA_FKEY_YOCORRENCIAS
    FOREIGN KEY("CODIGO", "ANO_LETIVO", "PERIODO") 
    REFERENCES "YOCORRENCIAS"("CODIGO", "ANO_LETIVO", "PERIODO");
```
## Setting Environment Z
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
### Primary keys
```sql
ALTER TABLE "ZDOCENTES" 
    ADD CONSTRAINT ZDOCENTES_PKEY 
    PRIMARY KEY("NR");
    
ALTER TABLE "ZDSD" 
    ADD CONSTRAINT ZDSD_PKEY 
    PRIMARY KEY("NR", "ID");
    
ALTER TABLE "ZTIPOSAULA" 
    ADD CONSTRAINT ZTIPOSAULA_PKEY 
    PRIMARY KEY("ID");

ALTER TABLE "ZOCORRENCIAS" 
    ADD CONSTRAINT ZOCORRENCIAS_PKEY 
    PRIMARY KEY("CODIGO", "ANO_LETIVO", "PERIODO");
    
ALTER TABLE "ZUCS" 
    ADD CONSTRAINT ZUCS_PKEY 
    PRIMARY KEY("CODIGO");
```
### Foreign keys
```sql
ALTER TABLE "ZDSD" 
    ADD CONSTRAINT ZDSD_FKEY_ZDOCENTES 
    FOREIGN KEY("NR") 
    REFERENCES "ZDOCENTES"("NR");
    
ALTER TABLE "ZDSD" 
    ADD CONSTRAINT ZDSD_FKEY_ZTIPOSAULA 
    FOREIGN KEY("ID") 
    REFERENCES "ZTIPOSAULA"("ID");
    
ALTER TABLE "ZOCORRENCIAS" 
    ADD CONSTRAINT ZOCORRENCIAS_FKEY_ZUCS 
    FOREIGN KEY("CODIGO") 
    REFERENCES "ZUCS"("CODIGO");

ALTER TABLE "ZTIPOSAULA" 
    ADD CONSTRAINT ZTIPOSAULA_FKEY_ZOCORRENCIAS
    FOREIGN KEY("CODIGO", "ANO_LETIVO", "PERIODO") 
    REFERENCES "ZOCORRENCIAS"("CODIGO", "ANO_LETIVO", "PERIODO");
```

### Indexes
One of the things that can most improve query times is to add indexes to **foreign keys**, when this is not done automatically. Furthermore, columns that are used in complex **joins**, in **where** conditions should also be considered.

To determine the most appropriate index type we had in consideration the types of queries. Since all of them are ***SELECT*** conditions, it obviously had a considerable weight in our decisions.

```sql
CREATE INDEX IX_ZUCS_DESIGNACAO ON ZUCS (designacao);
CREATE INDEX IX_ZUCS_CODIGO_CURSO ON ZUCS(codigo, curso);
CREATE INDEX IX_ZUCS_CURSO ON ZUCS (curso DESC);
CREATE INDEX IX_ZTIPOSAULA_ANOLETIVO ON ZTIPOSAULA (ano_letivo DESC);
CREATE INDEX IX_ZTIPOSAULA_CODIGO ON ZTIPOSAULA(codigo);
CREATE INDEX IX_ZTIPOSAULA_TIPO ON ZTIPOSAULA (tipo);
CREATE INDEX IX_ZDSD_ID ON ZDSD(id);
```

**Note:** All indexes will be justified for each query. Here is just a demonstration of all indexes.

## Queries
### Query 1
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
**Show the codigo, designacao, ano_letivo, inscritos, tipo, and turnos for the course ‘Bases de Dados’ of the program 275.**
#### SQL Formulation
```sql
SELECT codigo, designacao, ano_letivo, inscritos, tipo, turnos
FROM XUCS UCS 
JOIN XOCORRENCIAS OCCURENCES USING (codigo)
JOIN XTIPOSAULA CLASSTYPES USING (codigo, periodo, ano_letivo)
WHERE UCS.curso = 275 AND UCS.designacao = 'Bases de Dados'
```

#### Result (in JSON format)
```json
{
  "results" : [
    {
      "columns" : [
        {
          "name" : "CODIGO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "ANO_LETIVO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "DESIGNACAO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "INSCRITOS",
          "type" : "NUMBER"
        },
        {
          "name" : "TIPO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "TURNOS",
          "type" : "NUMBER"
        }
      ],
      "items" : [
        {
          "codigo" : "EIC3106",
          "ano_letivo" : "2003/2004",
          "designacao" : "Bases de Dados",
          "inscritos" : 92,
          "tipo" : "T",
          "turnos" : 1
        },
        {
          "codigo" : "EIC3106",
          "ano_letivo" : "2003/2004",
          "designacao" : "Bases de Dados",
          "inscritos" : 92,
          "tipo" : "TP",
          "turnos" : 4
        },
        {
          "codigo" : "EIC3106",
          "ano_letivo" : "2004/2005",
          "designacao" : "Bases de Dados",
          "inscritos" : 114,
          "tipo" : "T",
          "turnos" : 1
        },
        {
          "codigo" : "EIC3106",
          "ano_letivo" : "2004/2005",
          "designacao" : "Bases de Dados",
          "inscritos" : 114,
          "tipo" : "TP",
          "turnos" : 4
        },
        {
          "codigo" : "EIC3111",
          "ano_letivo" : "2005/2006",
          "designacao" : "Bases de Dados",
          "inscritos" : "",
          "tipo" : "T",
          "turnos" : 1
        },
        {
          "codigo" : "EIC3111",
          "ano_letivo" : "2005/2006",
          "designacao" : "Bases de Dados",
          "inscritos" : "",
          "tipo" : "TP",
          "turnos" : 6
        }
      ]
    }
  ]
}
```
#### Execution Plan
|           | Environment X | Environment Y | Environment Z |
| --------- | ------------- | ------------- | ------------- |
| Cost      |   642         |   55          |     14        |

##### Environment X
![](https://i.imgur.com/ZxZJu4m.png)
-
##### Environment Y
Since in this query there are two expensive join operations and a where clause, we can see that using primary and foreign keys have a great impact on the cost of the query.

![](https://i.imgur.com/FdvOZhy.png)
-
##### Environment Z
This are the indexes used to improve the cost of the query. It was also used the constraints defined from the previous environment. 
```sql
CREATE INDEX IX_ZUCS_DESIGNACAO ON ZUCS (designacao);
CREATE INDEX IX_ZTIPOSAULA_CODIGO ON ZTIPOSAULA(codigo);
CREATE INDEX IX_ZUCS_CODIGO_CURSO ON ZUCS(codigo, curso);
```
The first and the second one are useful since the **curso** and **designacao** columns from **ZUCS** are used in the **WHERE** condition to get a UC from a specific degree with a specific designation.

The third one is also very useful because it reduces the cost of the **hash joins** operations. It uses a composite index with the columns **codigo** and **curso**.

![](https://i.imgur.com/JKC4Zl3.png)


---
### Query 2
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
**How many class hours of each type did the program 233 planned in year 2004/2005?**
#### SQL Formulation
```sql
SELECT DISTINCT UCS.curso, CLASS_TYPES.ano_letivo, CLASS_TYPES.tipo, 
    SUM(CLASS_TYPES.turnos * CLASS_TYPES.horas_turno) AS TOTAL_HOURS
FROM XTIPOSAULA CLASS_TYPES 
INNER JOIN XUCS UCS ON CLASS_TYPES.codigo = UCS.codigo
WHERE CLASS_TYPES.ano_letivo='2004/2005' 
    AND UCS.curso = '233'
GROUP BY  UCS.curso, CLASS_TYPES.ano_letivo, CLASS_TYPES.tipo;
```

#### Result (in JSON format)
```json
{
  "results" : [
    {
      "columns" : [
        {
          "name" : "CURSO",
          "type" : "NUMBER"
        },
        {
          "name" : "ANO_LETIVO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "TIPO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "TOTAL_HOURS",
          "type" : "NUMBER"
        }
      ],
      "items" : [
        {
          "curso" : 233,
          "ano_letivo" : "2004/2005",
          "tipo" : "TP",
          "total_hours" : 697.5
        },
        {
          "curso" : 233,
          "ano_letivo" : "2004/2005",
          "tipo" : "P",
          "total_hours" : 581.5
        },
        {
          "curso" : 233,
          "ano_letivo" : "2004/2005",
          "tipo" : "T",
          "total_hours" : 308
        }
      ]
    }
  ]
}
```
#### Execution Plan
|           | Environment X | Environment Y | Environment Z |
| --------- | ------------- | ------------- | ------------- |
| Cost      |       50      |       50      |       10      |

##### Environment X
![](https://i.imgur.com/MYe0ihm.png)
##### Environment Y
Compared to environment X, primary and foreign key constraints didn't have any impact on the cost of the query.

![](https://i.imgur.com/ce9DCBu.png)
##### Environment Z

These are the indexes used to improve the cost of the query. Additionally, the constraints defined from the previous environment were also used. 

```sql
CREATE INDEX IX_ZUCS_CURSO ON ZUCS (curso DESC);
CREATE INDEX IX_ZTIPOSAULA_ANOLETIVO ON ZTIPOSAULA (ano_letivo DESC);
```

Both indexes are useful since the **curso** column from **ZUCS** and **ano_letivo** column from **ZTIPOSAULA** are used in the **WHERE** condition to retrieve a specific program from a specific year.

![](https://i.imgur.com/wLTXvzS.png)

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

There was also a try to have a materialized view for a portion of the query using the following DDL statement
```sql
CREATE MATERIALIZED VIEW 
PLANNED_UCS AS 
SELECT DISTINCT codigo
FROM XTIPOSAULA CLASS_TYPES
INNER JOIN XDSD T_DISTRIBUTION ON CLASS_TYPES.id = T_DISTRIBUTION.id
WHERE CLASS_TYPES.ano_letivo = '2003/2004';
```

```sql
SELECT DISTINCT UCS.codigo
FROM XOCORRENCIAS OCCURENCES
INNER JOIN XUCS UCS ON OCCURENCES.codigo = UCS.codigo 
WHERE OCCURENCES.ano_letivo = '2003/2004'
    AND NOT EXISTS  (
        SELECT codigo
        FROM PLANNED_UCS
        WHERE codigo = OCCURENCES.codigo
    )
```

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
| Cost without Mat. View     |      670      |      86       |      51       |
| Cost with Mat. View      |      610      |      31       |      31       |


##### Environment X
Without the materialized view:
![](https://i.imgur.com/tMCBKS6.png)

With the materialized view:
![](https://i.imgur.com/ovqITw3.png)

##### Environment Y
Compared to environment X, primary and foreign key constraints had a great impact on the query performance. This can be seen in the query plan where it's used a fast full scan twice in the query.

Without the materialized view:
![](https://i.imgur.com/UU6W6pH.png)

With the materialized view:
![](https://i.imgur.com/ZtuEUGW.png)

##### Environment Z
This are the indexes used to improve the cost of the query. It was also used the constraints defined from the previous environment. 
```sql
CREATE INDEX IX_ZTIPOSAULA_ANOLETIVO ON ZTIPOSAULA (ano_letivo DESC);
CREATE INDEX IX_ZDSD_ID ON ZDSD(id);
```
The first one is useful since the **ano_letivo** column from **ZTIPOSAULA** is used in the **WHERE** condition to determine the planned ucs. We could also opt to create the index on all attribute from the foreign key but that would produce the same effect.

The second one is also useful because the **primary key** on **ZDSD** is (nr, id) that creates a composite index on both attributes. The problem is that the composite index will work on statements that use only NR or both the nr and id columns. Since the **id** is used for the **JOIN** operation, that index also as an impact on the query cost.

Without the materialized view:
![](https://i.imgur.com/NStzLWm.png)

With the materialized view:
![](https://i.imgur.com/VG4bI7a.png)

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

#### Result (in JSON format)
* The same result as in [Query 3.1](#Query-3.1)
#### Execution Plan
|           | Environment X | Environment Y | Environment Z |
| --------- | ------------- | ------------- | ------------- |
| Cost      |      671      |      87       |       52      |

##### Environment X
![](https://i.imgur.com/erJTuaF.png)
##### Environment Y
Compared to environment X, primary and foreign key constraints didn't have any impact on the cost of the query since the access done was a full access.
![](https://i.imgur.com/BbyqtbR.png)
##### Environment Z
* The same indexes were used as in [Query 3.1](#Query-3.1)

![](https://i.imgur.com/wNx4sWX.png)

---
### Query 4
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
**Who is the professor with more class hours for each type of class, in the academic year 2003/2004? 
Show the number and name of the professor, the type of class and the total of class hours times the factor.**


#### SQL Formulation
```sql
SELECT nr, nome, tipo, max_hours
FROM  (
    SELECT MAX(nr) AS nr, tipo, MAX(total_hours) AS max_hours
    FROM (
        SELECT nr, tipo, SUM(horas * fator) AS total_hours
        FROM XTIPOSAULA
        NATURAL JOIN XDSD 
        WHERE ano_letivo = '2003/2004'
        GROUP BY nr, tipo
    )
    GROUP BY TIPO
) TMP
NATURAL JOIN XDOCENTES 
```


#### Result (in JSON format)
```json
{
  "results" : [
    {
      "columns" : [
        {
          "name" : "NR",
          "type" : "NUMBER"
        },
        {
          "name" : "NOME",
          "type" : "VARCHAR2"
        },
        {
          "name" : "TIPO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "MAX_HOURS",
          "type" : "NUMBER"
        }
      ],
      "items" : [
        {
          "nr" : 246626,
          "nome" : "Jorge Manuel Gomes Barbosa",
          "tipo" : "OT",
          "max_hours" : 3.5
        },
        {
          "nr" : 908100,
          "nome" : "Armínio de Almeida Teixeira",
          "tipo" : "P",
          "max_hours" : 30
        },
        {
          "nr" : 908290,
          "nome" : "José Manuel Miguez Araújo",
          "tipo" : "TP",
          "max_hours" : 26
        },
        {
          "nr" : 909330,
          "nome" : "Nuno Filipe da Cunha Nogueira",
          "tipo" : "T",
          "max_hours" : 30.67
        }
      ]
    }
  ]
}
```
#### Execution Plan
|           | Environment X | Environment Y | Environment Z |
| --------- | ------------- | ------------- | ------------- |
| Cost      |      69       |      69       |      38       |

##### Environment X
![](https://i.imgur.com/t8eEMEW.png)

##### Environment Y
Compared to environment X, primary and foreign key constraints didn't have any impact on the cost of the query.

![](https://i.imgur.com/8niDVsA.png)

##### Environment Z
Only one index was used to  improve the cost of the query. Additionally, the constraints defined from the previous environment were also used. 

```sql
CREATE INDEX IX_ZTIPOSAULA_ANOLETIVO ON ZTIPOSAULA (ano_letivo DESC);
```

This index is useful since the **ano_letivo** column from **ZTIPOSAULA** is used in the **WHERE** condition to retrieve a specific year.

![](https://i.imgur.com/UGzvPq9.png)


---
### Query 5
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>

**Compare the execution plans (just the environment Z) and the index sizes for the query giving the course code, the academic year, the period, and number of hours of the type ‘OT’ in the academic years of 2002/2003 and 2003/2004.**

* a) With a B-tree index on the type and academic year columns of the
ZTIPOSAULA table;
* b) With a bitmap index on the type and academic year columns of the
ZTIPOSAULA table;

#### B-tree index
* High cardinality
```sql
CREATE INDEX IX_ZTIPOSAULA_TIPO ON ZTIPOSAULA (TIPO);
CREATE INDEX IX_ZTIPOSAULA_ANOLETIVO ON ZTIPOSAULA (ANO_LETIVO DESC);
```

#### Bitmap index
* Low cardinality 

```sql
CREATE BITMAP INDEX IX_ZTIPOSAULA_TIPO ON ZTIPOSAULA (TIPO);
CREATE BITMAP INDEX IX_ZTIPOSAULA_ANOLETIVO ON ZTIPOSAULA (ANO_LETIVO DESC);
```
#### SQL Formulation
```sql
SELECT codigo, ano_letivo, periodo, horas_turno * turnos as NumberOfHours
FROM ZTIPOSAULA
WHERE (ano_letivo = '2002/2003' OR ano_letivo = '2003/2004') AND (tipo = 'OT')
```

#### Result (in JSON format)
```json
{
  "results" : [
    {
      "columns" : [
        {
          "name" : "CODIGO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "ANO_LETIVO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "PERIODO",
          "type" : "VARCHAR2"
        },
        {
          "name" : "NUMBEROFHOURS",
          "type" : "NUMBER"
        }
      ],
      "items" : [
        {
          "codigo" : "EIC5202",
          "ano_letivo" : "2002/2003",
          "periodo" : "2S",
          "numberofhours" : 27
        },
        {
          "codigo" : "EIC5202",
          "ano_letivo" : "2003/2004",
          "periodo" : "2S",
          "numberofhours" : 24
        }
      ]
    }
  ]
}
```

#### Execution Plan
|                  | Environment Z a) | Environment Z b) |
| ---------------- | ---------------- | ---------------- |
| Cost             |        5         |        8        | 


##### Environment Z a)
![](https://i.imgur.com/KzE05Wv.png)

In Oracle, full table scans have less cost than index range scans in cases when accessing a large fraction of the blocks in a table. The reason is that full table scans can use larger I/O calls what is cheaper than making many smaller calls.

But, Oracle optimizer uses a **range scan** when it finds one or more leading columns of an index specified in condition as it is in this task.

##### Environment Z b)
![](https://i.imgur.com/PtygCxP.png)

The way of accessing the attributes is similar to the one on the execution with the B-tree index, using an index access and a table access by index rowid, however, the query has a higher cost when executed with a bitmap index.

#### Index sizes
* Query to get index sizes:
```sql
SELECT  index_name, index_type, table_name, uniqueness, blevel, leaf_blocks, distinct_keys, num_rows
FROM user_indexes;
```
![](https://i.imgur.com/g367kMB.png)


#### Result (in JSON format) - B-tree indexes
```json
{
  "results" : [
    {
      "columns" : [
        {
          "name" : "INDEX_NAME",
          "type" : "VARCHAR2"
        },
        {
          "name" : "INDEX_TYPE",
          "type" : "VARCHAR2"
        },
        {
          "name" : "TABLE_NAME",
          "type" : "VARCHAR2"
        },
        {
          "name" : "UNIQUENESS",
          "type" : "VARCHAR2"
        },
        {
          "name" : "BLEVEL",
          "type" : "NUMBER"
        },
        {
          "name" : "LEAF_BLOCKS",
          "type" : "NUMBER"
        },
        {
          "name" : "DISTINCT_KEYS",
          "type" : "NUMBER"
        },
        {
          "name" : "NUM_ROWS",
          "type" : "NUMBER"
        }
      ],
      "items" : [
        {
        "index_name" : "IX_ZTIPOSAULA_TIPO",
          "index_type" : "NORMAL",
          "table_name" : "ZTIPOSAULA",
          "uniqueness" : "NONUNIQUE",
          "blevel" : 1,
          "leaf_blocks" : 39,
          "distinct_keys" : 5,
          "num_rows" : 21019
        },
        {
          "index_name" : "IX_ZTIPOSAULA_ANOLETIVO",
          "index_type" : "FUNCTION-BASED NORMAL",
          "table_name" : "ZTIPOSAULA",
          "uniqueness" : "NONUNIQUE",
          "blevel" : 1,
          "leaf_blocks" : 65,
          "distinct_keys" : 19,
          "num_rows" : 21019
        }
      ]
    }
  ]
}

```
#### Result (in JSON format) - Bitmap indexes
Under is showed part of JSON regarding indexes from task 5.
```json
{
  "results" : [
    {
      "columns" : [
        {
          "name" : "INDEX_NAME",
          "type" : "VARCHAR2"
        },
        {
          "name" : "INDEX_TYPE",
          "type" : "VARCHAR2"
        },
        {
          "name" : "TABLE_NAME",
          "type" : "VARCHAR2"
        },
        {
          "name" : "UNIQUENESS",
          "type" : "VARCHAR2"
        },
        {
          "name" : "BLEVEL",
          "type" : "NUMBER"
        },
        {
          "name" : "LEAF_BLOCKS",
          "type" : "NUMBER"
        },
        {
          "name" : "DISTINCT_KEYS",
          "type" : "NUMBER"
        },
        {
          "name" : "NUM_ROWS",
          "type" : "NUMBER"
        }
      ],
      "items" : [
        {
          "index_name" : "IX_ZTIPOSAULA_ANOLETIVO",
          "index_type" : "BITMAP",
          "table_name" : "ZTIPOSAULA",
          "uniqueness" : "NONUNIQUE",
          "blevel" : 0,
          "leaf_blocks" : 1,
          "distinct_keys" : 19,
          "num_rows" : 19
        },
        {
          "index_name" : "IX_ZTIPOSAULA_TIPO",
          "index_type" : "BITMAP",
          "table_name" : "ZTIPOSAULA",
          "uniqueness" : "NONUNIQUE",
          "blevel" : 1,
          "leaf_blocks" : 2,
          "distinct_keys" : 5,
          "num_rows" : 5
        }
      ]
    }
  ]
}

```
Two columns that are important to look at are: "leaf_blocks" as the number of blocks used by the index at the lowest and largest level, and "num_rows" as the number of rows that are indexed.

Looking at the given JSON results above for both indexes we can compare "leaf_blocks" values. If the "leaf_blocks" values is lager that means index consumes more space. It is visible that bitmap indexes need drastically less space than their B-tree equivalents. Also, with B-tree index we have one entry in the "leaf_blocks" for each row in the table but with Bitmap index no. 

If we take a look at the "num_rows" we can see that bitmap indexes also have significantly smaller value than b-tree indexes. The reason is because bitmap indexes store a single key value that points to many rows and because of that, there will be significantly less key values (num_rows) in a bitmap index than in the table it points to.

---
### Query 6
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>

**Select the programs (curso) that have classes with all the existing types.**
#### SQL Formulation
```sql
SELECT DISTINCT UCS.curso AS programm
FROM XUCS UCS JOIN XTIPOSAULA CLASS_TYPES ON UCS.codigo = CLASS_TYPES.codigo
GROUP BY UCS.curso
HAVING COUNT(DISTINCT CLASS_TYPES.tipo) = (
    SELECT COUNT(DISTINCT tipo)
    FROM XTIPOSAULA
)     
```

#### Result (in JSON format)
```json
{
  "results" : [
    {
      "columns" : [
        {
          "name" : "PROGRAMM",
          "type" : "NUMBER"
        }
      ],
      "items" : [
        {
          "programm" : 9461
        },
        {
          "programm" : 4495
        },
        {
          "programm" : 9508
        },
        {
          "programm" : 2021
        }
      ]
    }
  ]
}
```
#### Execution Plan
|           | Environment X | Environment Y | Environment Z |
| --------- | ------------- | ------------- | ------------- |
| Cost      |       51      |      51       |       45      |

##### Environment X
![](https://i.imgur.com/DVNERWm.png)

##### Environment Y
In this query we can see that using primary and foreign keys didn't change the cost of the query, since the optimizer decided to do a full access to all tables, instead of a fast full access.

![](https://i.imgur.com/jM7Vfo0.png)

##### Environment Z
This are the indexes used to improve the cost of the query. It was also used the constraints defined from the previous environment. 
```sql
CREATE INDEX IX_ZTIPOSAULA_TIPO ON ZTIPOSAULA (tipo);
CREATE INDEX IX_ZUCS_CODIGO_CURSO ON ZUCS(codigo, curso);
```
The first one is useful since the **tipo** column from **ZTIPOSAULA** is used in the **HAVING** clause to determine if a course has all types of classes. 
This makes the **HAVING** statement have a cost of 13 instead of 37. In spite of this, the total cost of the query won't change with this index.

The second one is more useful because it reduces the cost of the **hash join** between **ZUCS** and **ZTIPOSAULA**. It uses a composite index with the columns **codigo** and **curso**.


![](https://i.imgur.com/zIr0tTW.png)


---

# Conclusion
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>

We learned that the first thing to do when trying to optimize queries is to add the primary and foreign keys constraints since most queries this is where the cost was substantially lower. We also learned about query optimization, where different formulations can lead to very distinct results, such as doing unnecessary joins, complex operations, etc.

Moreover, the B-tree indexes reduced even further the cost of most queries. Our motto for adding them was to first add on columns used in joins. These columns most commonly refer to foreign keys, where, in some environments, such as Oracle SQL Developer, this is not done automatically. Additionally, we also added indexes to columns used in **WHERE** conditions. 

Apart from single-column indexes, we also used composite indexes in more than one query to reduce the overall number of indexes (and their size).

Although we explored Bitmap indexes, they were not used since there isn't any column that needs an index while having low cardinality, i.e., where columns have lots of duplicate values.

Finally, we also tried to experiment with **MATERIALIZED VIEWS** (*reference to [Query 3.1](#Query-3.1)*) that gave us better results but wasn't explored in too much detail due to time constraints.

In conclusion, we learned a lot about query optimization in SQL and indexes during this project. In future work, we can further improve the results and keep learning, as this process could take some time before reaching an optimal solution for all queries.
