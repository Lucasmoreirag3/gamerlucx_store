import 'package:flutter/material.dart';
import '../modelos/produto.dart';
import '../modelos/item_carrinho.dart';
import '../servicos/api_catalogo_servico.dart';
import '../componentes/banner_promocoes.dart';
import '../componentes/barra_pesquisa.dart';
import '../componentes/seletor_categorias.dart';
import '../componentes/conversor_moeda_widget.dart';
import '../componentes/simulador_frete_widget.dart';
import '../componentes/cartao_produto.dart';
import 'tela_detalhes_produto.dart';
import 'tela_carrinho_compras.dart';
import 'tela_gerenciar_produtos.dart';
import 'tela_perfil_usuario.dart';

class TelaCatalogoInicio extends StatefulWidget {
  const TelaCatalogoInicio({super.key});

  @override
  State<TelaCatalogoInicio> createState() => _TelaCatalogoInicioState();
}

class _TelaCatalogoInicioState extends State<TelaCatalogoInicio> {
  final ApiCatalogoServico _servicoApi = ApiCatalogoServico();
  List<Produto> _produtos = [];
  List<Produto> _produtosExibidos = [];
  final List<ItemCarrinho> _carrinho = [];
  bool _aCarregar = true;
  CategoriaProduto? _categoriaFiltro;
  String _termoBusca = '';

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    setState(() => _aCarregar = true);
    try {
      final itens = await _servicoApi.obterProdutos();
      setState(() {
        _produtos = itens;
        _filtrar();
      });
    } catch (_) {
      setState(() {
        _produtos = [];
        _filtrar();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao carregar produtos da API pessoal. Verifique servidor em http://localhost:3000.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
    setState(() => _aCarregar = false);
  }

  Future<void> _removerProduto(Produto produto) async {
    try {
      final ok = await _servicoApi.excluirProduto(produto.id);
      if (!ok) {
        throw Exception('Falha na exclusão do produto');
      }

      setState(() {
        _produtos.removeWhere((item) => item.id == produto.id);
        _filtrar();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${produto.nome} removido da API e do catálogo.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível remover o produto da API pessoal.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _filtrar() {
    setState(() {
      _produtosExibidos = _produtos.where((p) {
        final bateNome = p.nome.toLowerCase().contains(_termoBusca.toLowerCase());
        final bateCat = _categoriaFiltro == null || p.categoria == _categoriaFiltro;
        return bateNome && bateCat;
      }).toList();
    });
  }

  void _adicionarAoCarrinho(Produto produto) {
    setState(() {
      final idx = _carrinho.indexWhere((i) => i.produto.id == produto.id);
      if (idx >= 0) {
        _carrinho[idx].quantidade++;
      } else {
        _carrinho.add(ItemCarrinho(produto: produto));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} adicionado ao carrinho!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }

  void _abrirCarrinho() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaCarrinhoCompras(itensCarrinho: _carrinho),
      ),
    );
  }

  void _abrirMenu() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: _abrirMenu,
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFF8A2BE2)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: const Icon(Icons.videogame_asset_rounded, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              'GameLuX',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF120B2B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_rounded),
            tooltip: 'Gerenciar catálogo',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaGerenciarProdutos()),
              );
              _carregarProdutos();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_rounded),
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaPerfilUsuario()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_rounded),
                tooltip: 'Carrinho',
                onPressed: _abrirCarrinho,
              ),
              if (_carrinho.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.redAccent,
                    child: Text(
                      '${_carrinho.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0B1026),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(22)),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B1026), Color(0xFF120B2B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0B1026), Color(0xFF120B2B)],
                  ),
                  border: const Border(bottom: BorderSide(color: Colors.cyan)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00E5FF), Color(0xFF8A2BE2)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: const Icon(Icons.videogame_asset_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'GameLuX Arena',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              _menuItem(Icons.home_rounded, 'Início', () {}),
              _menuItem(Icons.shopping_bag_rounded, 'Ofertas', () {}),
              _menuItem(Icons.favorite_rounded, 'Favoritos', () {}),
              _menuItem(Icons.person_rounded, 'Perfil', () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaPerfilUsuario()),
                );
              }),
              _menuItem(Icons.inventory_2_rounded, 'Gerenciar catálogo', () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaGerenciarProdutos()),
                );
              }),
              const Divider(color: Colors.white12),
              _menuItem(Icons.shopping_cart_rounded, 'Carrinho', () {
                Navigator.pop(context);
                _abrirCarrinho();
              }),
            ],
          ),
        ),
      ),
      body: _aCarregar
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : RefreshIndicator(
              onRefresh: _carregarProdutos,
              child: ListView(
                children: [
                  const BannerPromocoes(),
                  const ConversorMoedaWidget(),
                  const SimuladorFreteWidget(),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF150F2A), Color(0xFF0D1E3A)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.cyan.withValues(alpha: 0.35)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withValues(alpha: 0.22),
                          blurRadius: 16,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'LOJA GAMER',
                                style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Prepare seu setup para ganhar partidas!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00E5FF), Color(0xFF9D4EDD)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan.withValues(alpha: 0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _abrirCarrinho,
                            icon: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
                            label: const Text('Carrinho', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BarraPesquisa(
                    aoDigitar: (texto) {
                      _termoBusca = texto;
                      _filtrar();
                    },
                  ),
                  SeletorCategorias(
                    categoriaAtiva: _categoriaFiltro,
                    aoSelecionar: (cat) {
                      _categoriaFiltro = cat;
                      _filtrar();
                    },
                  ),
                  const SizedBox(height: 8),
                  ..._produtosExibidos.asMap().entries.map((entry) {
                    final index = entry.key;
                    final prod = entry.value;
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.9, end: 1),
                      duration: Duration(milliseconds: 300 + (index * 90)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, (1 - value) * 14),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: CartaoProduto(
                        produto: prod,
                        aoEditar: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaDetalhesProduto(
                              produto: prod,
                              aoComprar: () => _adicionarAoCarrinho(prod),
                            ),
                          ),
                        ),
                        aoEliminar: () => _removerProduto(prod),
                        aoAdicionarAoCarrinho: () => _adicionarAoCarrinho(prod),
                        aoVerDetalhes: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaDetalhesProduto(
                                produto: prod,
                                aoComprar: () => _adicionarAoCarrinho(prod),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
        decoration: const BoxDecoration(
          color: Color(0xFF120B2B),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: ElevatedButton.icon(
          onPressed: _abrirCarrinho,
          icon: const Icon(Icons.shopping_cart_rounded),
          label: const Text('IR PARA O CARRINHO'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.cyanAccent),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
      ),
    );
  }
}