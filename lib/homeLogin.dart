import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeLogin extends StatefulWidget {
  const HomeLogin({Key? key}) : super(key: key);

  @override
  State<HomeLogin> createState() => _HomeLoginState();
}

class _HomeLoginState extends State<HomeLogin> {
  final TextEditingController nomeLivroController = TextEditingController();
  final TextEditingController autorLivroController = TextEditingController();

  List<Map<String, String>> livrosDoacao = [];

  Future<void> deslogarFirebase() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  void cadastrarLivroDoacao() {
    final String nomeLivro = nomeLivroController.text;
    final String autorLivro = autorLivroController.text;

    if (nomeLivro.isNotEmpty && autorLivro.isNotEmpty) {
      final livro = {
        'nome': nomeLivro,
        'autor': autorLivro,
      };
      setState(() {
        livrosDoacao.add(livro);
      });
      nomeLivroController.clear();
      autorLivroController.clear();
    }
  }

  @override
  void dispose() {
    nomeLivroController.dispose();
    autorLivroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina Logada'),
        actions: [
          GestureDetector(
            onTap: deslogarFirebase,
            child: Icon(Icons.logout),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nomeLivroController,
                  decoration: InputDecoration(
                    labelText: 'Nome do livro',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: autorLivroController,
                  decoration: InputDecoration(
                    labelText: 'Autor do livro',
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: cadastrarLivroDoacao,
                  child: Text('Cadastrar Livro'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: livrosDoacao.length,
              itemBuilder: (context, index) {
                final livro = livrosDoacao[index];
                return ListTile(
                  title: Text(livro['nome']!),
                  subtitle: Text(livro['autor']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


