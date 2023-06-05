import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RepoLivro extends StatelessWidget {
  const RepoLivro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros Cadastrados'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('livros').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final livros = snapshot.data!.docs;

            return ListView.builder(
              itemCount: livros.length,
              itemBuilder: (context, index) {
                final livro = livros[index].data();

                return ListTile(
                  title: Text(livro['nome']?.toString() ?? ''),
                  subtitle: Text(livro['autor']?.toString() ?? ''),
                  // Outras informações do livro
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
    );
  }
}
