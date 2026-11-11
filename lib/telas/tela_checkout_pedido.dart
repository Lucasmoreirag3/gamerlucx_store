import 'package:flutter/material.dart';
import '../modelos/item_carrinho.dart';
import '../modelos/pedido.dart';
import '../servicos/armazenamento_externo_servico.dart';

class TelaCheckoutPedido extends StatefulWidget {
  final List<ItemCarrinho> itensCarrinho;
  final double valorTotal;

  const TelaCheckoutPedido({
    super.key,
    required this.itensCarrinho,
    required this.valorTotal,
  });

  @override
  State<TelaCheckoutPedido> createState() => _TelaCheckoutPedidoState();
}

class _TelaCheckoutPedidoState extends State<TelaCheckoutPedido> {
  final ArmazenamentoExternoServico _servicoExterno = ArmazenamentoExternoServico();
  bool _aProcessar = false;
  String _metodoPagamento = 'PIX';

  Future<void> _concluirPedido() async {
    setState(() => _aProcessar = true);

    final novoPedido = Pedido(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itens: List.from(widget.itensCarrinho),
      valorProdutos: widget.valorTotal,
      valorFrete: 0,
      valorTotal: widget.valorTotal,
      formaPagamento: _metodoPagamento,
      dataPedido: DateTime.now(),
    );

    final sucesso = await _servicoExterno.sincronizarPedidoServidor(novoPedido);

    setState(() => _aProcessar = false);

    if (sucesso && mounted) {
      widget.itensCarrinho.clear();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Pedido Aprovado!', style: TextStyle(color: Colors.greenAccent)),
          content: const Text(
            'A sua compra foi sincronizada com a base externa com sucesso.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Voltar à Loja', style: TextStyle(color: Colors.deepPurpleAccent)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Checkout Seguro'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo da Compra',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total de Itens:', style: TextStyle(color: Colors.white70)),
                      Text('${widget.itensCarrinho.length}', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Valor Total:', style: TextStyle(color: Colors.white70)),
                      Text(
                        'R\$ ${widget.valorTotal.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Método de Pagamento:',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('PIX (Aprovação Imediata)', style: TextStyle(color: Colors.white)),
                  value: 'PIX',
                  groupValue: _metodoPagamento,
                  onChanged: (valor) => setState(() => _metodoPagamento = valor ?? 'PIX'),
                  activeColor: Colors.deepPurpleAccent,
                ),
                RadioListTile<String>(
                  title: const Text('Cartão de Crédito em até 12x', style: TextStyle(color: Colors.white)),
                  value: 'CARTAO',
                  groupValue: _metodoPagamento,
                  onChanged: (valor) => setState(() => _metodoPagamento = valor ?? 'CARTAO'),
                  activeColor: Colors.deepPurpleAccent,
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _aProcessar ? null : _concluirPedido,
                child: _aProcessar
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Confirmar e Pagar',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}