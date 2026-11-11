import 'package:flutter/material.dart';
import '../modelos/produto.dart';
import '../servicos/api_catalogo_servico.dart';
import 'tela_formulario_produto.dart';

class TelaGerenciarProdutos extends StatefulWidget {
  const TelaGerenciarProdutos({super.key});

  @override
  State<TelaGerenciarProdutos> createState() => _TelaGerenciarProdutosState();
}

class _TelaGerenciarProdutosState extends State<TelaGerenciarProdutos> {
  final ApiCatalogoServico _servicoApi = ApiCatalogoServico();
  List<Produto> _produtos = [];
  bool _aCarregar = true;

  @override
  void initState() {
    super.initState();
    _buscarItens();
  }

  Future<void> _buscarItens() async {
    setState(() => _aCarregar = true);
    try {
      final itens = await _servicoApi.obterProdutos();
      setState(() => _produtos = itens);
    } catch (_) {}
    setState(() => _aCarregar = false);
  }

  Future<void> _confirmarExclusao(String id, int indice, String nomeProduto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text(
          'Remover produto',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Deseja realmente remover "$nomeProduto" da API e do catálogo?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _eliminar(id, indice);
    }
  }

  Future<void> _eliminar(String id, int indice) async {
    final ok = await _servicoApi.excluirProduto(id);
    if (ok) {
      setState(() => _produtos.removeAt(indice));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item eliminado com sucesso (DELETE)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Gerir Catálogo (CRUD)'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _aCarregar
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : ListView.builder(
              itemCount: _produtos.length,
              itemBuilder: (context, index) {
                final item = _produtos[index];
                return ListTile(
                  title: Text(item.nome, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    'R\$ ${item.preco.toStringAsFixed(2)} | ${item.nomeCategoriaEmPortugues}',
                    style: const TextStyle(color: Colors.white60),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.amber),
                        onPressed: () async {
                          final atualizado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaFormularioProduto(produtoParaEditar: item),
                            ),
                          );
                          if (atualizado == true) _buscarItens();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _confirmarExclusao(item.id, index, item.nome),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final criado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelaFormularioProduto()),
          );
          if (criado == true) _buscarItens();
        },
      ),
    );
  }
}