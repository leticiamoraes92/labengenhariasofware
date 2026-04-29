import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../model/cliente.dart';

class ControlCliente{
  static final _dataBaseName = "teste.db";
  static Database? database;

  ControlCliente();

  Future startDatabase() async{
    if (database !=null){
      return database;
    }
    database = await _openOrCreateDatabase();

    return database;
  }

  Future _openOrCreateDatabase() async {
    var dataBasePath = await getDatabasesPath();
    String path = dataBasePath + _dataBaseName;
      await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future <void> _onCreate(Database db, int version) async {
    await db.execute(
     'CREATE TABLE IF NOT EXISTS CLIENTE (nome Text, endereco Text, '
     ' cidade Text, nasc Text)',
    );
  }

  Future insertDatabase(Cliente cli) async{
    Database db = await startDatabase();
    String sql = "";
    sql = 'Insert into Cliente (nome, cidade, endereco, nasc) Values (';
    sql = sql + "'" + cli.nome + "', " + cli.cidade + " ', "
        + cli.endereco + " ', " + cli.nascimento + " )";
   try{
     await db.rawInsert(sql);
     print(sql);
     print("Cliente inserido");
   }finally{

   }

  }

  Future <List<Map<String, dynamic>>> queryFind(String parametro) async{
   Database db = await startDatabase();
   return await (db.rawQuery(' Select * from cliente where nome like'
     + "'%" + parametro + "%'"
   ));
  }



}