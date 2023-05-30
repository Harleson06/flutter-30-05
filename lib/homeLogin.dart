import 'package:flutter/material.dart';

class HomeLogin extends StatefulWidget {
  const HomeLogin({Key? key}) : super(key: key);

  @override
  State<HomeLogin> createState() => _HomeLoginState();
}

class _HomeLoginState extends State<HomeLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina Logada'),
      ),
    );
  }
}
