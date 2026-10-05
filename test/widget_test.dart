// ===================================================================
// ATIVIDADE DE REVISÃO - SA02
// Lista de Compras
// ===================================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const TelaLista(),
    );
  }
}

// TODO 1: Crie aqui a classe/modelo Item.
class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  // TODO 2: Crie a lista que vai guardar os itens (List<Item>)
  List<Item> itens = [];

  // TODO 3: Crie a função abrirTelaAdicionar().
  Future<void> abrirTelaAdicionar() async {
    final novoItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaAdicionarItem()),
    );

    if (novoItem != null && novoItem is Item) {
      setState(() {
        itens.add(novoItem);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${novoItem.nome} adicionado à lista")),
        );
      }
    }
  }

  // TODO 4: Crie a função removerItem(indice).
  void removerItem(int indice) {
    final itemRemovido = itens[indice];
    setState(() {
      itens.removeAt(indice);
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${itemRemovido.nome} foi removido.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int itensComprados = itens.where((item) => item.comprado).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        // TODO 5: Mostre aqui quantos itens já foram comprados
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '$itensComprados de ${itens.length} comprados',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),

      // TODO 6: Use ListView.builder para exibir os itens da lista.
      body: ListView.builder(
        itemCount: itens.length,
        itemBuilder: (context, index) {
          final item = itens[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: Checkbox(
                value: item.comprado,
                onChanged: (bool? valor) {
                  setState(() {
                    item.comprado = valor ?? false;
                  });
                },
              ),
              title: Text(
                item.nome,
                style: TextStyle(
                  decoration: item.comprado
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text("Quantidade: ${item.quantidade}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () => removerItem(index),
              ),
            ),
          );
        },
      ),

      // TODO 7: Adicione um FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: abrirTelaAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {
  // TODO 8: Crie os TextEditingController necessários
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  // TODO 9: Crie a função salvar().
  void salvar() {
    final nome = nomeController.text.trim();
    final quantidadeTexto = quantidadeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("O nome do item não pode estar vazio.")),
      );
      return;
    }

    final quantidade = int.tryParse(quantidadeTexto) ?? 1;

    final novoItem = Item(nome: nome, quantidade: quantidade);
    Navigator.pop(context, novoItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO 10: Adicione um TextField para o nome do item
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do item',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // TODO 11: Adicione um TextField para a quantidade
            TextField(
              controller: quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // TODO 12: Adicione um ElevatedButton "Salvar" que chama salvar()
            ElevatedButton(
              onPressed: salvar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Salvar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}