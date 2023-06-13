import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeusLivrosScreen extends StatefulWidget {
  final String? userEmail;

  MeusLivrosScreen({required this.userEmail});

  @override
  _MeusLivrosScreenState createState() => _MeusLivrosScreenState();
}

class _MeusLivrosScreenState extends State<MeusLivrosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Livros'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('livros')
            .where('usuario', isEqualTo: widget.userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final livros = snapshot.data!.docs;

            return ListView.builder(
              itemCount: livros.length,
              itemBuilder: (context, index) {
                final livro = livros[index].data() as Map<String, dynamic>;
                final titulo = livro['nome'] ?? '';
                final autor = livro['autor'] ?? '';
                final descricao = livro['descricao'] ?? '';

                return ListTile(
                  title: Text(titulo),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Autor: $autor'),
                      Text('Descrição: $descricao'),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Erro ao carregar os livros');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
