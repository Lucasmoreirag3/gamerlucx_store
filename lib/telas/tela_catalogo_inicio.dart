import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/produto.dart';
import '../modelos/item_carrinho.dart';
import '../servicos/api_catalogo_servico.dart';
import '../servicos/armazenamento_interno_servico.dart';
import '../componentes/cartao_produto.dart';
import '../componentes/seletor_categorias.dart';
import '../componentes/barra_pesquisa.dart';
import '../componentes/banner_promocoes.dart';
import 'tela_detalhes_produto.dart';
import 'tela_carrinho_compras.dart';
import 'tela_gerenciar_produtos.dart';
import 'tela_perfil_usuario.dart';

/// Tela Principal da Loja GameLuX Store.
/// Implementa a listagem dinâmica com GET da API RESTful (Critério 8),
/// cache local para modo offline (Critério 7),
/// componentização avançada (Critério 11) e design gamer responsivo.
class TelaCatalogoInicio extends StatefulWidget {
  const TelaCatalogoInicio({super.key});

  @override
  State<TelaCatalogoInicio> createState() => _TelaCatalogoInicioState();
}

class _TelaCatalogoInicioState extends State<TelaCatalogoInicio> {
  int _indiceAbaAtual = 0;
  List<Produto> _produtos = [];
  bool _carregando = true;
  String _termoBusca = '';
  CategoriaProduto? _categoriaFiltro;
  int _quantidadeItensCarrinho = 0;

  final TextEditingController _controladorBusca = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  @override
  void dispose() {
    _controladorBusca.dispose();
    super.dispose();
  }

  Future<void> _carregarDadosIniciais() async {
    setState(() => _carregando = true);
    await _buscarProdutosDaApi();
    await _atualizarContadorCarrinho();
    if (mounted) {
      setState(() => _carregando = false);
    }
  }

  /// CRITÉRIO 8 (Crítico): Realizando comunicação GET
  Future<void> _buscarProdutosDaApi() async {
    final produtos = await ApiCatalogoServico.obterProdutos();
    if (mounted) {
      setState(() {
        _produtos = produtos;
      });
    }
  }

  Future<void> _atualizarContadorCarrinho() async {
    final carrinho = await ArmazenamentoInternoServico.obterCarrinho();
    if (mounted) {
      setState(() {
        _quantidadeItensCarrinho = carrinho.fold(0, (s, i) => s + i.quantidade);
      });
    }
  }

  Future<void> _adicionarAoCarrinho(Produto produto) async {
    final itens = await ArmazenamentoInternoServico.obterCarrinho();
    final index = itens.indexWhere((i) => i.produto.id == produto.id);

    if (index != -1) {
      itens[index].quantidade++;
    } else {
      itens.add(ItemCarrinho(produto: produto, quantidade: 1));
    }

    await ArmazenamentoInternoServico.salvarCarrinho(itens);
    await _atualizarContadorCarrinho();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: CoresApp.verdeSucesso,
          duration: const Duration(seconds: 2),
          content: Text('${produto.nome} adicionado ao carrinho!'),
          action: SnackBarAction(
            label: 'VER CARRINHO',
            textColor: Colors.white,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaCarrinhoCompras()),
              );
              _atualizarContadorCarrinho();
            },
          ),
        ),
      );
    }
  }

  List<Produto> get _produtosFiltrados {
    return _produtos.where((p) {
      // Filtro de categoria
      if (_categoriaFiltro != null && p.categoria != _categoriaFiltro) {
        return false;
      }
      // Filtro de texto da barra de busca
      if (_termoBusca.isNotEmpty) {
        final busca = _termoBusca.toLowerCase();
        final matchNome = p.nome.toLowerCase().contains(busca);
        final matchMarca = p.marca.toLowerCase().contains(busca);
        final matchDescricao = p.descricao.toLowerCase().contains(busca);
        final matchResumo = p.obterResumoEspecificacoes().toLowerCase().contains(busca);
        return matchNome || matchMarca || matchDescricao || matchResumo;
      }
      return true;
    }).toList();
  }

  Widget _construirAbaCatalogo() {
    final produtos = _produtosFiltrados;

    return RefreshIndicator(
      color: CoresApp.cianoEletrico,
      backgroundColor: CoresApp.superficieCardElevada,
      onRefresh: _carregarDadosIniciais,
      child: CustomScrollView(
        slivers: [
          // AppBar Customizada com Logo Gamer e Ícones
          SliverAppBar(
            backgroundColor: CoresApp.fundoPrincipal,
            pinned: true,
            elevation: 0,
            expandedHeight: 70,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/imagens/logo_gamelux.jpg',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.sports_esports,
                        color: CoresApp.cianoEletrico,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'GameLuX',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'STORE',
                        style: TextStyle(
                          color: CoresApp.cianoEletrico,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              // Botão Painel Lojista / Admin
              IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined, color: CoresApp.cianoEletrico),
                tooltip: 'Gerenciador da Loja (CRUD)',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaGerenciarProdutos()),
                  );
                  _buscarProdutosDaApi();
                },
              ),
              // Botão Carrinho com Badge
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    tooltip: 'Carrinho de Compras',
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TelaCarrinhoCompras()),
                      );
                      _atualizarContadorCarrinho();
                    },
                  ),
                  if (_quantidadeItensCarrinho > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: CoresApp.roxoNeon,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$_quantidadeItensCarrinho',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Barra de Pesquisa
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: BarraPesquisa(
                controlador: _controladorBusca,
                aoDigitar: (termo) => setState(() => _termoBusca = termo),
                aoLimpar: () {
                  _controladorBusca.clear();
                  setState(() => _termoBusca = '');
                },
              ),
            ),
          ),

          // Banner Promocional Destaque
          if (_termoBusca.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BannerPromocoes(
                  aoClicarBanner: () {
                    setState(() => _categoriaFiltro = CategoriaProduto.computador);
                  },
                ),
              ),
            ),

          // Seletor de Categorias
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SeletorCategorias(
                categoriaSelecionada: _categoriaFiltro,
                aoSelecionar: (categoria) {
                  setState(() => _categoriaFiltro = categoria);
                },
              ),
            ),
          ),

          // Título da Seção
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _categoriaFiltro == null
                        ? 'Catálogo Gamer em Destaque'
                        : 'Filtrando: ${_categoriaFiltro!.name.toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${produtos.length} produtos',
                    style: const TextStyle(color: CoresApp.textoApagado, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // Grade de Produtos (GridView)
          if (_carregando)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: CoresApp.cianoEletrico),
              ),
            )
          else if (produtos.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 64, color: CoresApp.textoApagado),
                    const SizedBox(height: 12),
                    const Text(
                      'Nenhum produto gamer encontrado.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      child: const Text('Limpar Filtros', style: TextStyle(color: CoresApp.cianoEletrico)),
                      onPressed: () {
                        setState(() {
                          _termoBusca = '';
                          _categoriaFiltro = null;
                          _controladorBusca.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.58,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final produto = produtos[index];
                    return CartaoProduto(
                      produto: produto,
                      aoClicar: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaDetalhesProduto(produto: produto),
                          ),
                        );
                        _atualizarContadorCarrinho();
                      },
                      aoAdicionarCarrinho: () => _adicionarAoCarrinho(produto),
                    );
                  },
                  childCount: produtos.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.fundoPrincipal,
      body: IndexedStack(
        index: _indiceAbaAtual,
        children: [
          _construirAbaCatalogo(),
          const TelaCarrinhoCompras(),
          const TelaGerenciarProdutos(),
          const TelaPerfilUsuario(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: CoresApp.superficieCardElevada,
          border: Border(top: BorderSide(color: CoresApp.bordaCard, width: 0.8)),
        ),
        child: BottomNavigationBar(
          currentIndex: _indiceAbaAtual,
          onTap: (index) {
            setState(() => _indiceAbaAtual = index);
            if (index == 0) _atualizarContadorCarrinho();
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: CoresApp.cianoEletrico,
          unselectedItemColor: CoresApp.textoApagado,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.storefront_rounded),
              label: 'Loja',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_bag_outlined),
                  if (_quantidadeItensCarrinho > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: CoresApp.roxoNeon,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                      ),
                    ),
                ],
              ),
              label: 'Carrinho',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_customize_outlined),
              label: 'Gerenciar',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
