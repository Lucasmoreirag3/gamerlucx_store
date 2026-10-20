import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/item_carrinho.dart';
import '../modelos/pedido.dart';
import '../modelos/endereco_cep.dart';
import '../servicos/armazenamento_interno_servico.dart';
import '../servicos/armazenamento_externo_servico.dart';
import '../componentes/simulador_frete_widget.dart';
import '../componentes/botao_gamer.dart';
import '../utilitarios/formatadores.dart';

/// Tela de Finalização de Compra (Checkout).
/// Atende:
/// - Critério 7 (Crítico): Persistindo dados no armazenamento externo (exportando comprovante).
/// - Critério 7 (Desejável): Persistindo modificações no armazenamento interno (salvando o pedido e limpando o carrinho).
/// - Critério 8 (Desejável): Validação e cálculo com API ViaCEP.
class TelaCheckoutPedido extends StatefulWidget {
  final List<ItemCarrinho> itens;

  const TelaCheckoutPedido({
    super.key,
    required this.itens,
  });

  @override
  State<TelaCheckoutPedido> createState() => _TelaCheckoutPedidoState();
}

class _TelaCheckoutPedidoState extends State<TelaCheckoutPedido> {
  String _formaPagamentoSelecionada = 'PIX';
  EnderecoCep? _enderecoEntrega;
  bool _processandoPedido = false;

  double get _subtotalProdutos {
    if (_formaPagamentoSelecionada == 'PIX') {
      return widget.itens.fold(0.0, (s, i) => s + i.subtotalPix);
    }
    return widget.itens.fold(0.0, (s, i) => s + i.subtotal);
  }

  double get _valorFrete => _enderecoEntrega?.valorFrete ?? 19.90;
  double get _valorTotalFinal => _subtotalProdutos + _valorFrete;

  Future<void> _finalizarPedido() async {
    setState(() => _processandoPedido = true);

    final novoPedido = Pedido(
      id: 'PED-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      itens: List.from(widget.itens),
      valorProdutos: _subtotalProdutos,
      valorFrete: _valorFrete,
      valorTotal: _valorTotalFinal,
      formaPagamento: _formaPagamentoSelecionada,
      status: StatusPedido.aprovado,
      dataPedido: DateTime.now(),
      enderecoEntrega: _enderecoEntrega,
    );

    // 1. Persistindo no Armazenamento Interno (Critério 7)
    await ArmazenamentoInternoServico.salvarPedido(novoPedido);
    await ArmazenamentoInternoServico.limparCarrinho();

    // 2. Persistindo no Armazenamento Externo (Critério 7)
    final resultadoExportacao = await ArmazenamentoExternoServico.exportarComprovantePedido(novoPedido);

    setState(() => _processandoPedido = false);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: CoresApp.superficieCardElevada,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CoresApp.verdeSucesso.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: CoresApp.verdeSucesso, size: 60),
              ),
              const SizedBox(height: 16),
              const Text(
                'PEDIDO CONFIRMADO!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Número: ${novoPedido.id}',
                style: const TextStyle(color: CoresApp.cianoEletrico, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Valor Total: ${_valorTotalFinal.paraReal()} via $_formaPagamentoSelecionada',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              // Feedback de persistência externa
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CoresApp.superficieCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CoresApp.bordaCard),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.folder_shared, color: CoresApp.cianoEletrico, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        resultadoExportacao,
                        style: const TextStyle(color: CoresApp.textoSecundario, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.roxoNeon,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Voltar à Loja', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(ctx).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      );
    }
  }

  Widget _construirOpcaoPagamento(String id, String titulo, String subtitulo, IconData icone, Color cor) {
    final selecionado = _formaPagamentoSelecionada == id;
    return InkWell(
      onTap: () => setState(() => _formaPagamentoSelecionada = id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CoresApp.superficieCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado ? cor : CoresApp.bordaCard,
            width: selecionado ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icone, color: cor, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitulo, style: TextStyle(color: selecionado ? cor : CoresApp.textoSecundario, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              selecionado ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selecionado ? cor : Colors.white30,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.fundoPrincipal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Checkout Seguro GameLuX', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Endereço de Entrega (ViaCEP)
            const Text(
              '1. Endereço de Entrega (Integração ViaCEP)',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SimuladorFreteWidget(
              cepInicial: '13030-010',
              aoDefinirEndereco: (endereco) {
                setState(() => _enderecoEntrega = endereco);
              },
            ),
            const SizedBox(height: 24),

            // 2. Forma de Pagamento
            const Text(
              '2. Forma de Pagamento',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _construirOpcaoPagamento(
              'PIX',
              'PIX Instantâneo',
              'Aprovação imediata com até 12% de desconto',
              Icons.bolt,
              CoresApp.verdeSucesso,
            ),
            const SizedBox(height: 10),
            _construirOpcaoPagamento(
              'CARTAO',
              'Cartão de Crédito',
              'Em até 12x sem juros no cartão gamer',
              Icons.credit_card,
              CoresApp.cianoEletrico,
            ),
            const SizedBox(height: 10),
            _construirOpcaoPagamento(
              'BOLETO',
              'Boleto Bancário',
              'Vencimento em 3 dias úteis',
              Icons.receipt_long,
              Colors.orangeAccent,
            ),
            const SizedBox(height: 24),

            // 3. Resumo Financeiro
            const Text(
              '3. Resumo da Compra',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CoresApp.superficieCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: CoresApp.bordaCard),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Produtos (${widget.itens.length} itens):', style: const TextStyle(color: CoresApp.textoSecundario)),
                      Text(_subtotalProdutos.paraReal(), style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Frete:', style: TextStyle(color: CoresApp.textoSecundario)),
                      Text(_valorFrete.paraReal(), style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const Divider(color: CoresApp.bordaCard, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total a Pagar:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        _valorTotalFinal.paraReal(),
                        style: const TextStyle(
                          color: CoresApp.verdeSucesso,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Botão de Confirmação
            BotaoGamer(
              texto: 'Confirmar e Finalizar Pedido',
              icone: Icons.lock_outline,
              carregando: _processandoPedido,
              aoPressionar: _processandoPedido ? null : _finalizarPedido,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
