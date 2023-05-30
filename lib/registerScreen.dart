import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  Future<void> cadastrarFirebase() async {
    try {
      var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: senha.text,
      );
      print(credential.user?.email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuário registrado com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao registrar usuário. Tente novamente.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 15, 32, 10),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: senha,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: cadastrarFirebase,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
