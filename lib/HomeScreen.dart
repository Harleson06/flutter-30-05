
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina Inicial'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 15, 32, 10),
        child: Column(
          children: [
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushNamed("/login");
            }, child: Text('Logar')),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushNamed("/register");
            }, child: Text('Registrar')),
          ],
        ),
      ),
    );
  }
}

