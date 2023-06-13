import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'repoLivro.dart';


class EmprestarLivro extends StatefulWidget {
  const EmprestarLivro({Key? key}) : super(key: key);

  @override
  State<EmprestarLivro> createState() => _EmprestarLivroState();
}

class _EmprestarLivroState extends State<EmprestarLivro> {
  final TextEditingController nomeLivroController = TextEditingController();
  final TextEditingController autorLivroController = TextEditingController();
  final TextEditingController descricaoLivroController =
  TextEditingController();

  List<String> livrosSelecionados = [];

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
        title: Text('Emprestar Livro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _mostrarRepositorioLivros();
              },
              child: Text('Buscar Livros'),
            ),
            SizedBox(height: 20),
            Text(
              'Livros Selecionados:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: livrosSelecionados.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(livrosSelecionados[index]),
                    trailing: IconButton(
                      onPressed: () {
                        _removerLivro(index);
                      },
                      icon: Icon(Icons.remove),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final emailUsuario =
                    FirebaseAuth.instance.currentUser?.email;
                _adicionarLivroAoUsuario(emailUsuario);
              },
              child: Text('Emprestar Livro'),
            ),
          ],
        ),
      ),
    );
  }

  void _removerLivro(int index) {
    setState(() {
      livrosSelecionados.removeAt(index);
    });
  }

  void _mostrarRepositorioLivros() async {
    final livroSelecionado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RepoLivro()),
    );

    if (livroSelecionado != null) {
      setState(() {
        livrosSelecionados.add(livroSelecionado);
      });
    }
  }

  void _adicionarLivroAoUsuario(String? emailUsuario) {
    if (emailUsuario != null && livrosSelecionados.isNotEmpty) {
      for (String livroSelecionado in livrosSelecionados) {
        FirebaseFirestore.instance
            .collection('usuarios')
            .doc(emailUsuario)
            .update({
          'listaLivros': FieldValue.arrayUnion([livroSelecionado])
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Livro(s) adicionado(s) à lista.'),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao adicionar o(s) livro(s).'),
            ),
          );print(error);
        });

      }
    }
  }

}
