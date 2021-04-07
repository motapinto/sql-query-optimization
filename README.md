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
ALTER TABLE "YDOCENTES" 
    ADD CONSTRAINT YDOCENTES_PKEY 
    PRIMARY KEY("NR")
    
ALTER TABLE "YDSD" 
    ADD CONSTRAINT YDSD_PKEY 
    PRIMARY KEY("NR", "ID")
    
ALTER TABLE "YTIPOSAULA" 
    ADD CONSTRAINT YTIPOSAULA_PKEY 
    PRIMARY KEY("ID")

ALTER TABLE "YOCORRENCIAS" 
    ADD CONSTRAINT YOCORRENCIAS_PKEY 
    PRIMARY KEY("CODIGO", "ANO_LETIVO", "PERIODO")
    
ALTER TABLE "YUCS" 
    ADD CONSTRAINT YUCS_PKEY 
    PRIMARY KEY("CODIGO")
```
### Foreign keys
```sql
ALTER TABLE "YDSD" 
    ADD CONSTRAINT YDSD_FKEY_YDOCENTES 
    FOREIGN KEY("NR") 
    REFERENCES "YDOCENTES"("NR")
    
ALTER TABLE "YDSD" 
    ADD CONSTRAINT YDSD_FKEY_YTIPOSAULA 
    FOREIGN KEY("ID") 
    REFERENCES "YTIPOSAULA"("ID")
    
ALTER TABLE "YOCORRENCIAS" 
    ADD CONSTRAINT YOCORRENCIAS_FKEY_YUCS 
    FOREIGN KEY("CODIGO") 
    REFERENCES "YUCS"("CODIGO")

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
    PRIMARY KEY("NR")
    
ALTER TABLE "ZDSD" 
    ADD CONSTRAINT ZDSD_PKEY 
    PRIMARY KEY("NR", "ID")
    
ALTER TABLE "ZTIPOSAULA" 
    ADD CONSTRAINT ZTIPOSAULA_PKEY 
    PRIMARY KEY("ID")

ALTER TABLE "ZOCORRENCIAS" 
    ADD CONSTRAINT ZOCORRENCIAS_PKEY 
    PRIMARY KEY("CODIGO", "ANO_LETIVO", "PERIODO")
    
ALTER TABLE "ZUCS" 
    ADD CONSTRAINT ZUCS_PKEY 
    PRIMARY KEY("CODIGO")
```
### Foreign keys
```sql
ALTER TABLE "ZDSD" 
    ADD CONSTRAINT ZDSD_FKEY_ZDOCENTES 
    FOREIGN KEY("NR") 
    REFERENCES "ZDOCENTES"("NR")
    
ALTER TABLE "ZDSD" 
    ADD CONSTRAINT ZDSD_FKEY_ZTIPOSAULA 
    FOREIGN KEY("ID") 
    REFERENCES "ZTIPOSAULA"("ID")
    
ALTER TABLE "ZOCORRENCIAS" 
    ADD CONSTRAINT ZOCORRENCIAS_FKEY_ZUCS 
    FOREIGN KEY("CODIGO") 
    REFERENCES "ZUCS"("CODIGO")

ALTER TABLE "ZTIPOSAULA" 
    ADD CONSTRAINT ZTIPOSAULA_FKEY_ZOCORRENCIAS
    FOREIGN KEY("CODIGO", "ANO_LETIVO", "PERIODO") 
    REFERENCES "ZOCORRENCIAS"("CODIGO", "ANO_LETIVO", "PERIODO");
```

### Indexes
One of the things that can most improve query times is to add indexes to **foreign keys**, when this is not done automatically. Furthermore, columns that are used in complex **joins**, in **where** conditions should also be considered.

To determine the most appropriate index type we had in consideration the types of queries. Since all of them are ***SELECT*** conditions, it obviously had a considerable weight in our decisions.

**Note:** All indexes will be justified for each query. Here is just a demonstration of all indexes.

### Bitmap
* Low cardinality 

### B-tree
* High cardinality
```sql
CREATE INDEX IX_ZUCS_DESIGNACAO ON ZUCS (designacao);
CREATE INDEX IX_ZUCS_CODIGO_CURSO IN ZDSD(codigo, curso);

CREATE INDEX IX_ZUCS_CURSO ON ZUCS (CURSO DESC);
CREATE INDEX IX_ZTIPOSAULA_CODIGO ON ZTIPOSAULA(codigo) 
CREATE INDEX IX_ZTIPOSAULA_ANOLETIVO ON ZTIPOSAULA (ANO_LETIVO DESC);
CREATE INDEX IX_ZTIPOSAULA_TIPO ON ZTIPOSAULA (TIPO);

CREATE INDEX IX_ZDSD_ID IN ZDSD(ID);
```

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
Since in this query there are two expensive join operations and a where clause, we can see that using primary and foreign keys have a great impact on the cost o the query.

![](https://i.imgur.com/FdvOZhy.png)
-
##### Environment Z
This are the indexes used to improve the cost of the query. It was also used the constraints defined from the previous environment. 
```sql
CREATE INDEX IX_ZUCS_DESIGNACAO ON ZUCS (tipo);
CREATE INDEX IX_ZTIPOSAULA_CODIGO IN ZTIPOSAULA(codigo);
```
The first one is useful since the **designacao** column from **ZUCS** is used in the **WHERE** condition to get a UC with a specific designation.

The second one is also very useful because it reduces the cost of the **hash joins** operations. It uses a composite index with the columns **codigo** and **curso**.

![](https://i.imgur.com/ajCzJf9.png)

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
![](https://i.imgur.com/ce9DCBu.png)
##### Environment Z
![](https://i.imgur.com/pSV16gi.png)


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
| Cost      |   670         |      86       |    51             |

##### Environment X
Without the materialized view:
![](https://i.imgur.com/tMCBKS6.png)

With the materialized view:
![](https://i.imgur.com/ovqITw3.png)

##### Environment Y
Without the materialized view:
![](https://i.imgur.com/UU6W6pH.png)

With the materialized view:
![](https://i.imgur.com/ZtuEUGW.png)

##### Environment Z
This are the indexes used to improve the cost of the query. It was also used the constraints defined from the previous environment. 
```sql
CREATE INDEX IX_ZTIPOSAULA_ANOLETIVO ON ZTIPOSAULA (ano_letivo DESC);
CREATE INDEX IX_ZDSD_ID IN ZDSD(id);
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
| Cost      |   671         |      87       |    52           |

##### Environment X
![](https://i.imgur.com/erJTuaF.png)
##### Environment Y
![](https://i.imgur.com/BbyqtbR.png)
##### Environment Z
* The same indexes were used as in [Query 3.1](#Query-3.1)

![](https://i.imgur.com/wNx4sWX.png)

---
### Query 4
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
**Who is the professor with more class hours for each type of class, in the academic
year 2003/2004? Show the number and name of the professor, the type of class and the
total of class hours times the factor.**


#### SQL Formulation
```sql
create view test as
    select  nr, nome, tipo, fator, SUM(turnos * horas_turno) as classHours
    from (
        select *
        from (
            select *
            from xdocentes
        )
        join
        (
            select *
            from xdsd
        )
        using(nr)
    )
    join 
    (
        select *
        from xtiposaula
        where ano_letivo = '2003/2004'
    )
    using(id) 
    group by nr, nome, tipo, fator
    order by classHours desc;

select q2.nr, q2.nome, q1.tipo, q2.fator, q1.maxClassHours, q1.maxClassHours * q2.fator as finalValue
from (
    select tipo, MAX(classHours) as maxClassHours
    from test
    group by tipo
    order by MAX(classHours) desc
) q1, test q2
where q1.tipo = q2.tipo AND
q1.maxClassHours = q2.classHours

```


#### Result (in JSON format)
```json=
```
#### Execution Plan
|           | Environment X | Environment Y | Environment Z |
| --------- | ------------- | ------------- | ------------- |
| Cost      |               |               |               |

##### Environment X
![](https://i.imgur.com/aHuWh76.png)

##### Environment Y
![](https://i.imgur.com/uQgwH3c.png)

##### Environment Z
---
### Query 5
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>
---
### Query 6
###### *Shortcut:* <ins>[To the top](#Table-of-Contents)</ins>

**Select the programs (curso) that have classes with all the existing types.**
#### SQL Formulation
```sql
SELECT DISTINCT UCS.curso AS programm
FROM ZUCS UCS JOIN ZTIPOSAULA CLASS_TYPES ON UCS.codigo = CLASS_TYPES.codigo
GROUP BY UCS.curso
HAVING COUNT(DISTINCT CLASS_TYPES.tipo) = (
    SELECT COUNT(DISTINCT tipo)
    FROM ZTIPOSAULA
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
| Cost      |   671         |      87       |    52         |

##### Environment X
![](https://i.imgur.com/DVNERWm.png)

##### Environment Y
In this query we can see that using primary and foreign keys didn't change the cost of the query, since the optimizer decided to do a full access to all tables, instead of a fast full access.

![](https://i.imgur.com/jM7Vfo0.png)

##### Environment Z
This are the indexes used to improve the cost of the query. It was also used the constraints defined from the previous environment. 
```sql
CREATE INDEX IX_ZTIPOSAULA_TIPO ON ZTIPOSAULA (tipo);
CREATE INDEX IX_ZUCS_CODIGO_CURSO IN ZDSD(codigo, curso);
```
The first one is useful since the **tipo** column from **ZTIPOSAULA** is used in the **HAVING** clause to determine if a course has all types of classes. 
This makes the **HAVING** statement have a cost of 13 instead of 37. In spite of this, the total cost of the query won't change with this index.

The second one is more useful because it reduces the cost of the **hash join** between **ZUCS** and **ZTIPOSAULA**. It uses a composite index with the columns **codigo** and **curso**.


![](https://i.imgur.com/zIr0tTW.png)



---

