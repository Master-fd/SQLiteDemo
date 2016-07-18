
#FMDB操作SQLite的Demo  
sqlite是个高性能的数据库，非常适合移动开发的数据储存，但是apple对sqlite的api确实不怎么滴  
FMDB是对sqlite操作封装的第三方库，使用起来非常方便，对多线程支持也非常好  

##FMDB常用类和方法  
FMDatabase ： 一个单一的SQLite数据库，用于执行SQL语句。  
FMResultSet ：执行查询一个FMDatabase结果集。  
FMDatabaseQueue ：在多个线程来执行查询和更新时会使用这个类  
executeUpdate:  执行所有的更新操作  删除，插入，新建等  
executeQuery:   只能执行查找操作，查找数据库

##FMDB多线程  
FMDB使用FMDatabaseQueue来保证线程安全了。应用中不可在多个线程中共同使用一个FMDatabase对象操作数据库，这样会引起数据库数据混乱。  
为了多线程操作数据库安全，FMDB使用了FMDatabaseQueue，使用FMDatabaseQueue很简单，首先用一个数据库文件地址来初使化FMDatabaseQueue，然后就  
以将一个闭包(block)传入inDatabase方法中。在闭包中操作数据库则是多线程安全的，而不直接参与FMDatabase的管理  

##我的博客   
欢迎光临：http://www.cnblogs.com/hepingqingfeng/
