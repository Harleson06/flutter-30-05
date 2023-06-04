import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeLogin extends StatefulWidget {
  const HomeLogin({Key? key}) : super(key: key);

  @override
  State<HomeLogin> createState() => _HomeLoginState();
}

class _HomeLoginState extends State<HomeLogin> {
  final TextEditingController nomeLivroController = TextEditingController();
  final TextEditingController autorLivroController = TextEditingController();
  final TextEditingController descricaoLivroController = TextEditingController();

  CollectionReference<Map<String, dynamic>> livrosCollection =
  FirebaseFirestore.instance.collection('livros');

  Future<void> deslogarFirebase() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  Future<void> cadastrarLivroDoacao() async {
    final String nomeLivro = nomeLivroController.text;
    final String autorLivro = autorLivroController.text;
    final String descricaoLivro = descricaoLivroController.text;

    if (nomeLivro.isNotEmpty &&
        autorLivro.isNotEmpty &&
        descricaoLivro.isNotEmpty) {
      final livro = {
        'nome': nomeLivro,
        'autor': autorLivro,
        'descricao': descricaoLivro,
      };

      await livrosCollection.add(livro);

      nomeLivroController.clear();
      autorLivroController.clear();
      descricaoLivroController.clear();
    }
  }

  Future<void> emprestarLivro(String livroId) async {
    // Atualizar o livro com o status de empréstimo
    await livrosCollection.doc(livroId).update({'emprestado': true});
  }

  Future<void> devolverLivro(String livroId) async {
    // Atualizar o livro com o status de devolução
    await livrosCollection.doc(livroId).update({'emprestado': false});
  }

  @override
  void dispose() {
    nomeLivroController.dispose();
    autorLivroController.dispose();
    descricaoLivroController.dispose();
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
                TextField(
                  controller: descricaoLivroController,
                  decoration: InputDecoration(
                    labelText: 'Descrição do livro',
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
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: livrosCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final livros = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: livros.length,
                    itemBuilder: (context, index) {
                      final livro = livros[index].data();
                      final livroId = livros[index].id;
                      final bool emprestado = livro['emprestado'] ?? false;
                      return ListTile(
                        title: Text(livro['nome']?.toString() ?? ''),
                        subtitle: Text(livro['autor']?.toString() ?? ''),
                        leading: CircleAvatar(
                          backgroundImage:
                          NetworkImage(livro['fotoUrl']?.toString() ?? ''),
                        ),
                        trailing: emprestado
                            ? ElevatedButton(
                          onPressed: () => devolverLivro(livroId),
                          child: Text('Devolver'),
                        )
                            : ElevatedButton(
                          onPressed: () => emprestarLivro(livroId),
                          child: Text('Emprestar'),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar os livros');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
