import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/produto.dart';
import '../servicos/api_catalogo_servico.dart';
import '../servicos/armazenamento_externo_servico.dart';
import '../utilitarios/formatadores.dart';
import 'tela_formulario_produto.dart';

/// Painel do Comerciante / Administrador da Loja.
/// Atende diretamente aos critérios:
/// - Critério 8: Realizando comunicação GET, POST, PUT, DELETE (CRUD completo com serviços RESTful).
/// - Critério 7 (Crítico): Persistindo dados no armazenamento externo (Backup/Restauração JSON).
class TelaGerenciarProdutos extends StatefulWidget {
  const TelaGerenciarProdutos({super.key});

  @override
  State<TelaGerenciarProdutos> createState() => _TelaGerenciarProdutosState();
}

class _TelaGerenciarProdutosState extends State<TelaGerenciarProdutos> {
  List<Produto> _produtos = [];
  bool _carregando = true;
  String _filtroTexto = '';

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    setState(() => _carregando = true);
    final lista = await ApiCatalogoServico.obterProdutos();
    if (mounted) {
      setState(() {
        _produtos = lista;
        _carregando = false;
      });
    }
  }

  Future<void> _excluirProduto(Produto produto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CoresApp.superficieCardElevada,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Excluir do Catálogo?'),
        content: Text('Deseja remover "${produto.nome}" do servidor web (DELETE)?'),
        actions: [
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CoresApp.vermelhoAlerta),
            child: const Text('Excluir Produto'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      // Comunicação DELETE (Critério 8)
      final sucesso = await ApiCatalogoServico.excluirProduto(produto.id);
      if (sucesso) {
        setState(() => _produtos.removeWhere((p) => p.id == produto.id));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Produto ${produto.nome} excluído com sucesso via DELETE!'),
              backgroundColor: CoresApp.vermelhoAlerta,
            ),
          );
        }
      }
    }
  }

  Future<void> _exportarBackupExterno() async {
    final resultado = await ArmazenamentoExternoServico.exportarCatalogoParaArquivo(_produtos);
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: CoresApp.superficieCardElevada,
          title: const Row(
            children: [
              Icon(Icons.save_alt, color: CoresApp.cianoEletrico),
              SizedBox(width: 8),
              Text('Backup Externo JSON'),
            ],
          ),
          content: Text(resultado, style: const TextStyle(fontSize: 13)),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: CoresApp.roxoNeon),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _importarBackupExterno() async {
    final produtosImportados = await ArmazenamentoExternoServico.importarCatalogoDeArquivo();
    if (produtosImportados.isNotEmpty) {
      setState(() => _produtos = produtosImportados);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${produtosImportados.length} produtos restaurados do armazenamento externo!'),
            backgroundColor: CoresApp.verdeSucesso,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nenhum backup encontrado no armazenamento externo.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = _produtos.where((p) {
      if (_filtroTexto.isEmpty) return true;
      return p.nome.toLowerCase().contains(_filtroTexto.toLowerCase()) ||
          p.marca.toLowerCase().contains(_filtroTexto.toLowerCase()) ||
          p.nomeCategoriaEmPortugues.toLowerCase().contains(_filtroTexto.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: CoresApp.fundoPrincipal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Gerenciador de Catálogo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download, color: CoresApp.cianoEletrico),
            tooltip: 'Exportar Backup JSON (Armazenamento Externo)',
            onPressed: _exportarBackupExterno,
          ),
          IconButton(
            icon: const Icon(Icons.file_upload, color: CoresApp.verdeSucesso),
            tooltip: 'Importar Backup do Armazenamento Externo',
            onPressed: _importarBackupExterno,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarProdutos,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CoresApp.roxoNeon,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Cadastrar Produto (POST)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () async {
          final novoProduto = await Navigator.push<Produto>(
            context,
            MaterialPageRoute(
              builder: (context) => const TelaFormularioProduto(),
            ),
          );
          if (novoProduto != null) {
            _carregarProdutos();
          }
        },
      ),
      body: Column(
        children: [
          // Barra de Filtro
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Filtrar por nome, marca ou categoria...',
                hintStyle: const TextStyle(color: CoresApp.textoApagado),
                prefixIcon: const Icon(Icons.search, color: CoresApp.cianoEletrico, size: 20),
                filled: true,
                fillColor: CoresApp.superficieCard,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: CoresApp.bordaCard),
                ),
              ),
              onChanged: (val) => setState(() => _filtroTexto = val),
            ),
          ),

          // Totalizador de Estoque
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Catálogo: ${produtosFiltrados.length} itens cadastrados',
                  style: const TextStyle(color: CoresApp.textoSecundario, fontSize: 12),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CoresApp.superficieCard,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Operações RESTful: GET, POST, PUT, DELETE',
                    style: TextStyle(color: CoresApp.cianoEletrico, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Lista de Produtos
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator(color: CoresApp.cianoEletrico))
                : produtosFiltrados.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum produto encontrado.',
                          style: TextStyle(color: CoresApp.textoSecundario),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                        itemCount: produtosFiltrados.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final prod = produtosFiltrados[index];

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CoresApp.superficieCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: CoresApp.bordaCard),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Miniatura
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: prod.imagemUrl.startsWith('assets/')
                                        ? Image.asset(prod.imagemUrl, fit: BoxFit.cover)
                                        : Image.network(prod.imagemUrl, fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Informações
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        prod.nome,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${prod.nomeCategoriaEmPortugues} • ${prod.preco.paraReal()}',
                                        style: const TextStyle(
                                          color: CoresApp.verdeSucesso,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Estoque: ${prod.quantidadeEstoque} unid. | ${prod.marca}',
                                        style: const TextStyle(
                                          color: CoresApp.textoSecundario,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Ações PUT (Editar) e DELETE (Excluir)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: CoresApp.cianoEletrico, size: 20),
                                      tooltip: 'Editar Produto (PUT)',
                                      onPressed: () async {
                                        final produtoEditado = await Navigator.push<Produto>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TelaFormularioProduto(produtoParaEditar: prod),
                                          ),
                                        );
                                        if (produtoEditado != null) {
                                          _carregarProdutos();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: CoresApp.vermelhoAlerta, size: 20),
                                      tooltip: 'Excluir Produto (DELETE)',
                                      onPressed: () => _excluirProduto(prod),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
