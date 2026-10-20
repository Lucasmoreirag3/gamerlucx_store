import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/cotacao_moeda.dart';
import '../servicos/api_cotacao_servico.dart';

/// Critério 8 (Desejável): Realizando integração de múltiplas APIs.
/// Exibe a cotação em tempo real do Dólar Comercial (AwesomeAPI) e calcula o preço em moeda estrangeira.
class ConversorMoedaWidget extends StatefulWidget {
  final double precoEmReais;

  const ConversorMoedaWidget({
    super.key,
    required this.precoEmReais,
  });

  @override
  State<ConversorMoedaWidget> createState() => _ConversorMoedaWidgetState();
}

class _ConversorMoedaWidgetState extends State<ConversorMoedaWidget> {
  CotacaoMoeda? _cotacao;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarCotacao();
  }

  Future<void> _carregarCotacao() async {
    try {
      final cot = await ApiCotacaoServico.obterCotacaoDolar();
      if (mounted) {
        setState(() {
          _cotacao = cot;
          _carregando = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: CoresApp.superficieCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: CoresApp.bordaCard),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 1.8, color: CoresApp.cianoEletrico),
            ),
            SizedBox(width: 8),
            Text('Consultando cotação USD (AwesomeAPI)...', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      );
    }

    if (_cotacao == null) return const SizedBox.shrink();

    final valorEmDolar = _cotacao!.converterRealParaDolar(widget.precoEmReais);
    final variacaoPositiva = _cotacao!.variacao >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: CoresApp.superficieCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CoresApp.bordaCard),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: CoresApp.verdeSucesso.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.attach_money, color: CoresApp.verdeSucesso, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Cotação Hardware Internacional: ',
                      style: TextStyle(color: CoresApp.textoSecundario, fontSize: 11),
                    ),
                    Text(
                      'USD \$${valorEmDolar.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '1 USD = R\$ ${_cotacao!.valorCompra.toStringAsFixed(2)} (${variacaoPositiva ? '+' : ''}${_cotacao!.variacao.toStringAsFixed(2)}%) • AwesomeAPI',
                  style: TextStyle(
                    color: variacaoPositiva ? CoresApp.verdeSucesso : CoresApp.vermelhoAlerta,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
