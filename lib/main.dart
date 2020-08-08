import 'package:flutter/material.dart';
import 'MyTodos.dart';
import 'Template.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context)=>MyTodos(),
    '/template': (context)=>Template(),
  },
));
