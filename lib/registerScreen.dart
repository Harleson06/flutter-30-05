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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 15, 32, 10),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: email,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                    )
                ),
              ),
            ),
            SizedBox(height: 10),
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
