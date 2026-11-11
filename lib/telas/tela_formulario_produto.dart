import 'package:flutter/material.dart';
import '../modelos/produto.dart';
import '../servicos/api_catalogo_servico.dart';

class TelaFormularioProduto extends StatefulWidget {
  final Produto? produtoParaEditar;

  const TelaFormularioProduto({super.key, this.produtoParaEditar});

  @override
  State<TelaFormularioProduto> createState() => _TelaFormularioProdutoState();
}

class _TelaFormularioProdutoState extends State<TelaFormularioProduto> {
  final _chaveFormulario = GlobalKey<FormState>();
  final ApiCatalogoServico _servicoApi = ApiCatalogoServico();

  late TextEditingController _controladorNome;
  late TextEditingController _controladorPreco;
  late TextEditingController _controladorDescricao;
  String _tipoSelecionado = 'periferico';
  bool _aGravar = false;

  @override
  void initState() {
    super.initState();
    _controladorNome = TextEditingController(text: widget.produtoParaEditar?.nome ?? '');
    _controladorPreco = TextEditingController(
      text: widget.produtoParaEditar != null ? widget.produtoParaEditar!.preco.toString() : '',
    );
    _controladorDescricao = TextEditingController(text: widget.produtoParaEditar?.descricao ?? '');
  }

  Future<void> _submeter() async {
    if (!_chaveFormulario.currentState!.validate()) return;

    setState(() => _aGravar = true);

    final mapDados = {
      'id': widget.produtoParaEditar?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'nome': _controladorNome.text,
      'marca': 'GameLuX Pro',
      'preco': double.tryParse(_controladorPreco.text) ?? 199.90,
      'imagemUrl': 'https://via.placeholder.com/150',
      'descricao': _controladorDescricao.text,
      'quantidadeEstoque': 10,
      'avaliacao': 5.0,
      'emDestaque': true,
      'tipo_categoria': _tipoSelecionado,
      'tipoConexao': 'USB-C',
      'iluminacaoRgb': true,
      'dpiOuFrequencia': 16000,
      'subcategoria': 'Gamer Extra',
    };

    final novoProduto = Produto.fromJson(mapDados);

    try {
      if (widget.produtoParaEditar == null) {
        await _servicoApi.cadastrarProduto(novoProduto);
      } else {
        await _servicoApi.atualizarProduto(widget.produtoParaEditar!.id, novoProduto);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao gravar produto')),
      );
    }

    if (mounted) {
      setState(() => _aGravar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.produtoParaEditar == null ? 'Novo Item Gamer' : 'Editar Item'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _chaveFormulario,
          child: ListView(
            children: [
              TextFormField(
                controller: _controladorNome,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nome do Equipamento',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Insira o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _controladorPreco,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Preço (R\$)',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Insira o preço' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _tipoSelecionado,
                dropdownColor: Colors.grey.shade900,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                items: const [
                  DropdownMenuItem(value: 'computador', child: Text('PC Gamer')),
                  DropdownMenuItem(value: 'periferico', child: Text('Periférico')),
                  DropdownMenuItem(value: 'console', child: Text('Consola')),
                ],
                onChanged: (val) => setState(() => _tipoSelecionado = val ?? _tipoSelecionado),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _controladorDescricao,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Descrição Resumida',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _aGravar ? null : _submeter,
                child: _aGravar
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Gravar Produto', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}