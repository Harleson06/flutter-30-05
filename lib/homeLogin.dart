import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_28_5/MeusLivrosScreen.dart';
import 'package:firebase_28_5/CadastrarLivroScreen.dart';
import 'package:firebase_28_5/RepoLivro.dart';
import 'package:firebase_28_5/LivrosEmprestadosScreen.dart';
import 'package:firebase_28_5/EmprestarLivroScreen.dart';

class HomeLogin extends StatelessWidget {
  const HomeLogin({Key? key}) : super(key: key);

  Future<void> deslogarFirebase(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser!.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina Logada'),
        actions: [
          GestureDetector(
            onTap: () => deslogarFirebase(context),
            child: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userEmail!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('Meus Livros Cadastrados'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeusLivrosScreen(
                      userEmail: userEmail!,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Livros Emprestados'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LivrosEmprestadosScreen(
                      userEmail: userEmail!,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sair'),
              onTap: () => deslogarFirebase(context),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/HomeLoginScreen.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastrarLivroScreen(),
                          ),
                        );
                      },
                      child: Text('Cadastrar Livro'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RepoLivro()),
                );
              },
              child: Text('Ir para RepoLivro'),
            ),
          ],
        ),
      ),
    );
  }
}
