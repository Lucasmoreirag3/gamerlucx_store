import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/item_carrinho.dart';
import '../servicos/armazenamento_interno_servico.dart';
import '../utilitarios/formatadores.dart';
import '../componentes/botao_gamer.dart';
import 'tela_checkout_pedido.dart';

/// Tela de Carrinho de Compras da GameLuX Store.
/// Implementa a persistência de modificações no armazenamento interno (Critério 7).
class TelaCarrinhoCompras extends StatefulWidget {
  const TelaCarrinhoCompras({super.key});

  @override
  State<TelaCarrinhoCompras> createState() => _TelaCarrinhoComprasState();
}

class _TelaCarrinhoComprasState extends State<TelaCarrinhoCompras> {
  List<ItemCarrinho> _itens = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarCarrinho();
  }

  Future<void> _carregarCarrinho() async {
    final itens = await ArmazenamentoInternoServico.obterCarrinho();
    if (mounted) {
      setState(() {
        _itens = itens;
        _carregando = false;
      });
    }
  }

  Future<void> _atualizarQuantidade(int index, int novaQtd) async {
    if (novaQtd <= 0) {
      _removerItem(index);
      return;
    }
    setState(() {
      _itens[index].quantidade = novaQtd;
    });
    await ArmazenamentoInternoServico.salvarCarrinho(_itens);
  }

  Future<void> _removerItem(int index) async {
    final itemRemovido = _itens[index];
    setState(() {
      _itens.removeAt(index);
    });
    await ArmazenamentoInternoServico.salvarCarrinho(_itens);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${itemRemovido.produto.nome} removido do carrinho.'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'DESFAZER',
            onPressed: () {
              setState(() {
                _itens.insert(index, itemRemovido);
              });
              ArmazenamentoInternoServico.salvarCarrinho(_itens);
            },
          ),
        ),
      );
    }
  }

  Future<void> _limparCarrinho() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CoresApp.superficieCardElevada,
        title: const Text('Limpar Carrinho?'),
        content: const Text('Deseja realmente remover todos os itens do carrinho?'),
        actions: [
          TextButton(
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CoresApp.vermelhoAlerta),
            child: const Text('Limpar Tudo'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() => _itens.clear());
      await ArmazenamentoInternoServico.limparCarrinho();
    }
  }

  double get _totalGeral => _itens.fold(0.0, (soma, item) => soma + item.subtotal);
  double get _totalPix => _itens.fold(0.0, (soma, item) => soma + item.subtotalPix);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.fundoPrincipal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Meu Carrinho Gamer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_itens.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white70),
              tooltip: 'Limpar Carrinho',
              onPressed: _limparCarrinho,
            ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: CoresApp.cianoEletrico))
          : _itens.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: CoresApp.textoApagado,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Seu carrinho está vazio!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Equipe seu setup com os melhores PCs, periféricos e consoles da GameLuX Store.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: CoresApp.textoSecundario, fontSize: 14),
                        ),
                        const SizedBox(height: 30),
                        BotaoGamer(
                          texto: 'Explorar Produtos',
                          icone: Icons.explore,
                          expandir: false,
                          aoPressionar: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _itens.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = _itens[index];
                          final prod = item.produto;

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CoresApp.superficieCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: CoresApp.bordaCard),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    width: 75,
                                    height: 75,
                                    child: prod.imagemUrl.startsWith('assets/')
                                        ? Image.asset(prod.imagemUrl, fit: BoxFit.cover)
                                        : Image.network(prod.imagemUrl, fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Detalhes
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
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        prod.obterResumoEspecificacoes(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: CoresApp.cianoEletrico,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Subtotal e Controles
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.subtotal.paraReal(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'PIX: ${item.subtotalPix.paraReal()}',
                                                style: const TextStyle(
                                                  color: CoresApp.verdeSucesso,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Botoes + / -
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove_circle_outline, size: 20),
                                                color: Colors.white70,
                                                onPressed: () => _atualizarQuantidade(index, item.quantidade - 1),
                                              ),
                                              Text(
                                                '${item.quantidade}',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add_circle_outline, size: 20),
                                                color: CoresApp.cianoEletrico,
                                                onPressed: () => _atualizarQuantidade(index, item.quantidade + 1),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Rodapé Fixo com Totais e Botão de Checkout
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: CoresApp.superficieCardElevada,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 15,
                            offset: Offset(0, -4),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Subtotal normal:',
                                  style: TextStyle(color: CoresApp.textoSecundario, fontSize: 13),
                                ),
                                Text(
                                  _totalGeral.paraReal(),
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total com Desconto PIX:',
                                  style: TextStyle(
                                    color: CoresApp.verdeSucesso,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _totalPix.paraReal(),
                                  style: const TextStyle(
                                    color: CoresApp.verdeSucesso,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            BotaoGamer(
                              texto: 'Avançar para o Pagamento',
                              icone: Icons.arrow_forward,
                              aoPressionar: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TelaCheckoutPedido(itens: _itens),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
