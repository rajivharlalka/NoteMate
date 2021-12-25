# DATABASES



### ACID Properties of Relational Databases

* Atomicity 
* Isolation
* Concurrency
*  Durability



#### Atomicity

Transactions can roll back in case an error has occurred . Transactions are not committed till the last query has executed. Once the last query executes , the whole transaction is committed and saved at once. If an error occurs in the middle of a transaction, the whole transaction fails and is rolled-back to it's initial stage.

#### Isolation

This property defines how much a particular transaction can read from other transaction's commits.

There are various Read Phenomena's that can occur.

- Dirty Reads
- Non-Repeatable Read
- Phantom Read
- (Lost Updates)

##### <u>Dirty Read</u>

If a Query is under process and has read a particular value, and then a different Query changes a value in a particular cell and has not yet committed, So there always exist a possibility that the change can roll back , making the read data useless and wrong.

![Dirty read](https://i.imgur.com/iTvSqGL.png)

##### <u>Non-Repeatable Read</u>

If a Query is under process and has read a particular value, and then a different Query changes a value in a particular cell and has committed the change,and the first query makes a read again, It would read a wrong value making discrepancies in the read Data.

![Non-repeatable Read](https://i.imgur.com/na9dqIe.png)

##### <u>Phantom Read</u>

If a Query is under process and has read a particular value, and then a different Query adds a row and has committed the change,and the first query makes a read again, It would now also read the new Row which wasn't read earlier, making discrepancies in the read Data.

![Phantom Read](https://i.imgur.com/zMTEFzO.png)



### Isolation Levels

- Read Uncommitted - No Isolation,any change from the outside is visible to the transaction
- Read Committed - Each Query in a transaction only sees committed stuff.
- Repeatable Read - Each Query in a transaction only sees committed updates at the beginning of the transaction.
- Serializable - Transaction are serialized.

![Isolation Level](https://i.imgur.com/Ec5qLVd.png)



#### Consistency

- Consistency in Data
- Consistency in Reads

###### Consistency in Data

- Defined by the user
- Referential Integrity
- Atomicity
- Isolation

###### Consistency in reads

If a  transaction committed a change will a new transaction immediately see the change?

this is the main logic behind the consistency in reads.

#### Durability

Committed transaction must be persisted in a durable non-volatile storage.



### Eventual Consistency in Database Systems

* A major property of No-SQL Database.
* Both SQL and No-SQL databases suffer from this as long as caching or horizontal scaling is introduced.

### <u>Indexing</u>

It creates indexes on the selected column so that searching in them is real quick. Indexing creates a DS( B tree or LSM tree) consisting of the key to be stored .

> INSERT INTO TEMP(T) SELECT RANDOM()*100 FROM GENERATE_SERIES(0,10000000)
>
> This adds 10000000 rows to a database into with random integers.



1. Key Indexing - Creates Indexes on a particular column.
2. Non-Key Column Indexing- Creates Indexes on a particular column, but can also add other columns also in the indexes, which makes query faster.

Example of non key column indexing in Postgres SQL.

`CREATE INDEX G_IDX ON GRADES_ORG (G) INCLUDE (NAME)`



### Types of Scans

- Parallel Seq Scan / Full Scan
- Index Scan
- Index Only Scan
- Bitmap Index Scan+Bitmap Hap Scan ( Specific to Postgres)

##### SQL Pagination with Offset is bad

When the number of columns to be fetched is much less than the number of rows to be filtered , it is a lot time consuming for the database to run through and fetch all rows and then limit to be a lot less



Suppose I have a table as shown below,

| Column | Type    |
| ------ | ------- |
| id     | Integer |
| a      | text    |
| b      | text    |
| c      | integer |
| title  | text    |

And I need to fetch 10 rows after 1 million'th row.

A Query using offset can be somewhat like this

```sql
SELECT TITLE FROM NEWS ORDER BY ID DESC OFFSET 1000000 LIMIT=10;	
```

Even if the indexes are present it is a lot of work for the database to pull 1 million +10 rows and then limit it to just 10;

In such case , a handy hack can be using id field for getting a limit value of rows as rows are ordered.

```sql
SELECT TITTLE,ID FROM NEWS WHERE ID<1000000 ORDER BY ID DESC LIMIT 10;
```

 in such query one can store the id of the last row and use it to query the database the next time. This helps in saving a lot of CPU computation of the database.



## <u>Partitioning</u>

#### <u>Types of Partitioning</u>

* Horizontal Partitioning
  * splits rows into partitions
  * Range or list
* Vertical Partitioning
  * Large column(blob) that whose queries can be slow.

#### <u>Partitioning Types</u>

* By Range	
  * Dates, ids(log date)
* By List
  * Discrete Value or zip codes
* By Hash
  * Hash Consistent(consistent Hashing)

###### How to partition a database with 1 Million rows !

- Main database 

 Column |  Type   | Collation | Nullable |                Default
--------|---------|-----------|----------|----------------------------------------
 id     | integer |           | not null | nextval('grades_org_id_seq'::regclass)
 g      | integer |           | not null |

- Create a partiton database that would store the different partitions

  ​	

  ```sql
  create table grades_parts (id serial not null, g int not null) partition by range(g);
  ```

   Column |  Type   | Collation | Nullable |                 Default
  --------|---------|-----------|----------|------------------------------------------
   id     | integer |           | not null | nextval('grades_parts_id_seq'::regclass)
   g      | integer |           | not null |

  Partition key: RANGE (g)

- Create different partitons table

  ​	

  ```sql
  create table g0035 (like grades_parts including indexes); 
  ```

  ​	Create as many partition table as you want with proper naming so that knowing which table consists of 	which values is easy.

  - Attach different partitions to the partition table with check which data must enter which partition.

    ​	

    ```sql
    alter table grades_parts attach partition g0035 for values from (0) to (35) 
    ```

  - Add the data into the partition table and POSTGRES will automatically filter which row should enter which table

    ```sql
    insert into grades_parts select * from grades_org; 
    ```

    

*To check which size of partitions etc*

```sql
select pg_relation_size(oid),relname from pg_class order by pg_relation_size(oid) desc;
```

P.S. Remember to enable ENABLE_PARTITION_PRUNING  otherwise a lot of resource is wasted in checking partitions which do not even contain the relevant matter.

##  SHARDING

Sharding is basically advanced HP(Horizontal Partitioning). Instead of just having different tables , the databases are separated from one another and are linked through hash functions. [Consistent hashing](https://medium.com/system-design-blog/consistent-hashing-b9134c8a9062#:~:text=Consistent%20Hashing%20is%20a%20distributed,without%20affecting%20the%20overall%20system.) links each entry in a db to which port has this entry been exposed to.

- [Vitess.io](Vitess.io) is a open source middleware that intelligently helps in sharding

![SHARDING](https://imgur.com/AllYBqa.png)

### Horizontal Partitioning V/S Sharding

* HP splits big table into multiple tables in the same database, client is agnostic
* Sharding splits big table into multiple tables across multiple database servers.
* HP table name changes
* Sharding everything is same just the server changes.

### Bloom Filters

Times occur when there are queries where we need to check for a particular value and so we need to hit a database and search through it all over. For example , checking for username "Tim" , such queries can be very time consuming. In such cases Bloom Filters come in handy. It is basically a bit-string of size n which stores 0 and 1 at different values. The hash of the query is calculated M.O.D the length of bit-string; If the position of the resultant value in the bit-string is 0 then it can be confirmaly said that the username does not exist.

## Locks

Locks are basically conditions where the read/write or both the capabilities of a row/multiple rows get locked. This is basically done to ensure consistency in the read data and maintain concurrency. There can be various cases and types of locks whose use-cases may be different.

- Exclusive locks

  - Both read and write options disabled.
  - are useful during maintaining a database such as booking where one ticket cannot be booked twice.
  - `for update` keyword creates an exclusive lock on POSTGRES on a particular row/set of rows.
- Shared Locks

  - The write option is disabled but the data can be read.
- `for share` keyword in POSTGRES for a shared lock
- Deadlocks
  - When two or more processes depend on a value pending in a transanction then a race for deadlock arises and needs to be handled explicitly.
  - The last query to enter the deadlock gets an error and is rolled back and the other queries get executed.

### Some famous databases problems

- Two booking problem

  - This is a case of booking platforms when a set if  booked at the same millisecond would be booked by two different people.
  - This is resolved easily by putting a exclusive lock on the statement checking if the seat is booked or not

  ```sql
  select * from bookings where id=$1 and isbooked=0 for update
  ```

  an example query 👆

### Connection pooling

​	Having a pool of connection makes the queries faster as opening and closing the TCP connection takes time which wont be needed while having the pool.

