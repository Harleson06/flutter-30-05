
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController Email = TextEditingController();
  TextEditingController Senha = TextEditingController();

  Future <void> loginFirebase() async {
    var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Email.text, password: Senha.text);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/homeLogin', (Route<dynamic> route) => false);
  }

  Future<void> logarGoogle() async {
    final GoogleSignIn googleSignIn = await GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential authResult = await FirebaseAuth.instance
        .signInWithCredential(credential);
    final User? user = authResult.user;

    //customMaterialBanner(context, 'Logado com sucesso!', Colors.green);
    if (user != null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(
          '/homeLogin', (Route<dynamic> route) => false);
    }
  }



  Future<void> resetPasswordFirebase() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: Email.text);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('E-mail de redefinição enviado'),
          content: Text('Um e-mail com as instruções para redefinir sua senha foi enviado para ${Email.text}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
        title: Text('Página de Login'),
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
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/recoveryPass");
                },
                child: Text('Esqueceu a Senha?')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: logarGoogle, child: Text('Logar usando Conta Google')),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: loginFirebase, child: Text('Logar')),
            ElevatedButton(
              onPressed: resetPasswordFirebase,
              child: Text('Esqueci minha senha'),
            ),
          ],
        ),

      ),
    );
  }
}
