import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Reader{
   Future<String> get localPath async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> localFile(String f) async{
    final path  = await localPath;
    return File('$path/$f.txt');
  }

  Future<String> readData(String f) async{
    try{
      final file = await localFile(f);
      String body = await file.readAsString();
      //print(file);
      //print("read");
      //print(body);
      return body;
    }
    catch(e){
      return null;
    }
  }

  Future<File> writeData(String f, String data) async{
     final file = await localFile(f);
     //print(file);
     //print("write");
     return file.writeAsString("$data");
  }
   Future<File> delFile(String f) async{
     final file  = await localFile(f);
     await file.delete();
     //print(file);
     //print("deleted");
     return file;
   }
}