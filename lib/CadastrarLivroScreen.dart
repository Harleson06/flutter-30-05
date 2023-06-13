import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastrarLivroScreen extends StatefulWidget {
  const CadastrarLivroScreen({Key? key}) : super(key: key);

  @override
  State<CadastrarLivroScreen> createState() => _CadastrarLivroScreenState();
}

class _CadastrarLivroScreenState extends State<CadastrarLivroScreen> {
  final TextEditingController nomeLivroController = TextEditingController();
  final TextEditingController autorLivroController = TextEditingController();
  final TextEditingController descricaoLivroController = TextEditingController();

  CollectionReference<Map<String, dynamic>> livrosCollection =
  FirebaseFirestore.instance.collection('livros');

  Future<void> cadastrarLivroDoacao() async {
    final String nomeLivro = nomeLivroController.text;
    final String autorLivro = autorLivroController.text;
    final String descricaoLivro = descricaoLivroController.text;

    final user = FirebaseAuth.instance.currentUser;
    final String? userEmail = user?.email;

    if (nomeLivro.isNotEmpty && autorLivro.isNotEmpty && descricaoLivro.isNotEmpty && userEmail != null) {
      final livro = {
        'nome': nomeLivro,
        'autor': autorLivro,
        'descricao': descricaoLivro,
        'usuario': userEmail,
      };

      await livrosCollection.add(livro);

      nomeLivroController.clear();
      autorLivroController.clear();
      descricaoLivroController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeLivroController,
              decoration: const InputDecoration(
                labelText: 'Nome do livro',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: autorLivroController,
              decoration: const InputDecoration(
                labelText: 'Autor do livro',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descricaoLivroController,
              decoration: const InputDecoration(
                labelText: 'Descrição do livro',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: cadastrarLivroDoacao,
              child: const Text('Cadastrar Livro'),
            ),
          ],
        ),
      ),
    );
  }
}
