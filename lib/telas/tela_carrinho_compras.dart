import 'package:flutter/material.dart';
import '../modelos/item_carrinho.dart';
import '../servicos/cache_local_servico.dart';
import 'tela_checkout_pedido.dart';

class TelaCarrinhoCompras extends StatefulWidget {
  final List<ItemCarrinho> itensCarrinho;

  const TelaCarrinhoCompras({super.key, required this.itensCarrinho});

  @override
  State<TelaCarrinhoCompras> createState() => _TelaCarrinhoComprasState();
}

class _TelaCarrinhoComprasState extends State<TelaCarrinhoCompras> {
  final CacheLocalServico _cacheServico = CacheLocalServico();

  double get _valorTotal => widget.itensCarrinho.fold(0.0, (soma, item) => soma + item.subtotal);

  void _removerItem(int indice) {
    setState(() {
      widget.itensCarrinho.removeAt(indice);
    });
    _cacheServico.salvarCacheSessao(_valorTotal, true);
  }

  void _alterarQuantidade(int indice, int delta) {
    setState(() {
      final novaQtd = widget.itensCarrinho[indice].quantidade + delta;
      if (novaQtd > 0) {
        widget.itensCarrinho[indice].quantidade = novaQtd;
      }
    });
    _cacheServico.salvarCacheSessao(_valorTotal, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Carrinho Gamer'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: widget.itensCarrinho.isEmpty
          ? const Center(
              child: Text(
                'O seu carrinho está vazio!',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.itensCarrinho.length,
                    itemBuilder: (context, index) {
                      final item = widget.itensCarrinho[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 72,
                                height: 72,
                                child: Image.network(
                                  item.produto.imagemUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.black26,
                                      child: const Icon(Icons.sports_esports, color: Colors.deepPurpleAccent),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.produto.nome,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'R\$ ${item.produto.preco.toStringAsFixed(2)} cada',
                                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 12),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Subtotal: R\$ ${item.subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.amber),
                                      onPressed: () => _alterarQuantidade(index, -1),
                                    ),
                                    Text(
                                      '${item.quantidade}',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, color: Colors.greenAccent),
                                      onPressed: () => _alterarQuantidade(index, 1),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _removerItem(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade900,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total:', style: TextStyle(color: Colors.white70)),
                          Text(
                            'R\$ ${_valorTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaCheckoutPedido(
                                itensCarrinho: widget.itensCarrinho,
                                valorTotal: _valorTotal,
                              ),
                            ),
                          );
                        },
                        child: const Text('Finalizar Pedido', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}