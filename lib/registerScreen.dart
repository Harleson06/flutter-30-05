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

  final _formKey = GlobalKey<FormState>();
  bool _emailValido = true; // Inicialmente definido como verdadeiro
  bool _formValido = false;

  bool validarEmail(String email) {
    if (email.contains('@')) {
      return true; // Retornar true quando o e-mail contém o caractere '@'
    }
    return false;
  }

  void _atualizarFormularios() {
    setState(() {
      _emailValido = validarEmail(email.text);
      _formValido = _formKey.currentState!.validate();
    });
  }

  @override
  void initState() {
    super.initState();
    email.addListener(_atualizarFormularios);
  }

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
    email.removeListener(_atualizarFormularios);
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: _emailValido ? Colors.blueAccent : Colors.red,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _emailValido ? Colors.blueAccent : Colors.red,
                        ),
                      ),
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _emailValido = validarEmail(value);
                        _formValido = _formKey.currentState!.validate();
                      });
                    },
                    validator: (String? email) {
                      if (email == null || email.isEmpty) {
                        return 'Por favor preencha o campo';
                      } else if (!_emailValido) {
                        return 'E-mail Inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: senha,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _formValido = _formKey.currentState!.validate();
                      });
                    },
                    validator: (String? senha) {
                      if (senha == null || senha.isEmpty) {
                        return 'Por favor preencha o campo';
                      } else if (senha.length < 8) {
                        return 'A senha deve ter no mínimo 8 caracteres';
                      }
                      return null;
                    },
                  ),
                ],
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
