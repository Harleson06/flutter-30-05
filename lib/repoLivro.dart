import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RepoLivro extends StatelessWidget {
  const RepoLivro({Key? key}) : super(key: key);

  Future<void> emprestarLivro(String livroId) async {
    await FirebaseFirestore.instance
        .collection('livros')
        .doc(livroId)
        .update({'emprestado': true});
  }

  Future<void> devolverLivro(String livroId) async {
    await FirebaseFirestore.instance
        .collection('livros')
        .doc(livroId)
        .update({'emprestado': false});
  }

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
                final livroId = livros[index].id;
                final bool emprestado = livro['emprestado'] ?? false;

                return ListTile(
                  title: Text(livro['nome']?.toString() ?? ''),
                  subtitle: Text(livro['autor']?.toString() ?? ''),
                  trailing: emprestado ? Text('Emprestado') : Text('Disponível'),
                  onTap: () {
                    if (emprestado) {
                      devolverLivro(livroId);
                    } else {
                      emprestarLivro(livroId);
                    }
                  },
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
