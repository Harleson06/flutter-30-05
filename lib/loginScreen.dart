import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  Future<void> loginFirebase() async {
    var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text, password: senha.text);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/homeLogin', (Route<dynamic> route) => false);
  }

  Future<void> logarGoogle() async {
    final GoogleSignIn googleSignIn = await GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/homeLogin', (Route<dynamic> route) => false);
    }
  }

  Future<void> logarFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/homeLogin', (Route<dynamic> route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao fazer login com o Facebook. Tente novamente.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> resetPasswordFirebase() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('E-mail de redefinição enviado'),
          content: Text('Um e-mail com as instruções para redefinir sua senha foi enviado para ${email.text}.'),
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
    email.dispose();
    senha.dispose();
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
              controller: email,
              decoration: InputDecoration(
                label: Text('E-mail'),
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: senha,
              decoration: InputDecoration(
                label: Text('Senha'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/register");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle),
                  SizedBox(width: 5),
                  Text('Caso não tenha conta, clique aqui'),
                ],
              ),
            ),
            SizedBox(height: 20,),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/recoveryPass");
              },
              child: Text(''),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: logarGoogle,
              child: Row(
                children: [
                  Icon(Icons.mail),
                  SizedBox(width: 10),
                  Text('Logar com o Google'),
                ],
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: logarFacebook,
              child: Row(
                children: [
                  Icon(Icons.facebook),
                  SizedBox(width: 10),
                  Text('Logar com o Facebook'),
                ],
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: loginFirebase,
              child: Text('Logar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("senhalogin");
              },
              child: Text('Esqueceu a Senha?'),
            ),
          ],
        ),
      ),
    );
  }
}
