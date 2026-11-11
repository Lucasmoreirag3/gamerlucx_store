import 'package:flutter/material.dart';
import '../servicos/api_cotacao_servico.dart';
import '../modelos/cotacao_moeda.dart';

class ConversorMoedaWidget extends StatefulWidget {
  const ConversorMoedaWidget({super.key});

  @override
  State<ConversorMoedaWidget> createState() => _ConversorMoedaWidgetState();
}

class _ConversorMoedaWidgetState extends State<ConversorMoedaWidget> {
  final ApiCotacaoServico _servico = ApiCotacaoServico();
  CotacaoMoeda? _cotacao;
  bool _aCarregar = false;

  @override
  void initState() {
    super.initState();
    _buscarCambio();
  }

  Future<void> _buscarCambio() async {
    setState(() => _aCarregar = true);
    try {
      final dados = await _servico.buscarCotacaoDolar();
      setState(() => _cotacao = dados);
    } catch (_) {}
    setState(() => _aCarregar = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.currency_exchange, color: Colors.greenAccent, size: 18),
              SizedBox(width: 8),
              Text(
                'Dólar Comercial (AwesomeAPI):',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          _aCarregar
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  _cotacao != null
                      ? 'R\$ ${_cotacao!.valorCompra.toStringAsFixed(2)}'
                      : 'Indisponível',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
        ],
      ),
    );
  }
}