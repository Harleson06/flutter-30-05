import 'package:firebase_28_5/HomeScreen.dart';
import 'package:firebase_28_5/alterarSenha.dart';
import 'package:firebase_28_5/homeLogin.dart';
import 'package:firebase_28_5/loginScreen.dart';
import 'package:firebase_28_5/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_28_5/repoLivro.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      "/home": (_) => HomeScreen(),
      "/register": (_) => RegisterScreen(),
      "/login": (_) => LoginScreen(),
      "/homeLogin": (_) => HomeLogin(),
      "senhalogin": (_) => SenhaScreen(),
      "livros": (_) => RepoLivro(),


    }
  ));
}
