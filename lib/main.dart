import 'package:apphabitsv01/core/widgets/main_shell.dart';
import 'package:apphabitsv01/features/auth/presentation/screens/login_screen.dart';
import 'package:apphabitsv01/features/habits/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(home: HomeScreen(),debugShowCheckedModeBanner: false,));
}