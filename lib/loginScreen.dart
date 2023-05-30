
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController Email = TextEditingController();
  TextEditingController Senha = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Email.dispose();
    Senha.dispose();
    super.dispose();
  }

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
            TextField(
              controller: Email,
              decoration: InputDecoration(
                label: Text('E-mail'),
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: Senha,
              decoration: InputDecoration(
                label: Text('Senha'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            TextButton(onPressed: (){
              Navigator.of(context).pushNamed("/register");
            }, child: Text('Caso não tenha conta, clique aqui')),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){}, child: Text('Logar'))
          ],
        ),

      ),
    );
  }
}
