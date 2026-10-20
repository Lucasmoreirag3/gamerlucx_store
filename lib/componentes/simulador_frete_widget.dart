import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/endereco_cep.dart';
import '../servicos/api_cep_servico.dart';
import '../utilitarios/formatadores.dart';

/// Critério 8 (Desejável): Realizando integração de múltiplas APIs.
/// Componente interativo para cálculo de frete e validação de endereço via API ViaCEP.
class SimuladorFreteWidget extends StatefulWidget {
  final Function(EnderecoCep endereco)? aoDefinirEndereco;
  final String? cepInicial;

  const SimuladorFreteWidget({
    super.key,
    this.aoDefinirEndereco,
    this.cepInicial,
  });

  @override
  State<SimuladorFreteWidget> createState() => _SimuladorFreteWidgetState();
}

class _SimuladorFreteWidgetState extends State<SimuladorFreteWidget> {
  final TextEditingController _controladorCep = TextEditingController();
  bool _carregando = false;
  String? _mensagemErro;
  EnderecoCep? _enderecoResultado;

  @override
  void initState() {
    super.initState();
    if (widget.cepInicial != null && widget.cepInicial!.isNotEmpty) {
      _controladorCep.text = widget.cepInicial!;
      _consultarCep(widget.cepInicial!);
    }
  }

  @override
  void dispose() {
    _controladorCep.dispose();
    super.dispose();
  }

  Future<void> _consultarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'\D'), '');
    if (cepLimpo.length != 8) {
      setState(() {
        _mensagemErro = 'Digite um CEP válido com 8 dígitos';
        _enderecoResultado = null;
      });
      return;
    }

    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final resultado = await ApiCepServico.consultarCep(cepLimpo);
      setState(() {
        _enderecoResultado = resultado;
        _carregando = false;
      });

      if (resultado != null && widget.aoDefinirEndereco != null) {
        widget.aoDefinirEndereco!(resultado);
      }
    } catch (e) {
      setState(() {
        _mensagemErro = e.toString().replaceAll('Exception: ', '');
        _carregando = false;
        _enderecoResultado = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CoresApp.superficieCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CoresApp.bordaCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, color: CoresApp.cianoEletrico, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Simulador de Frete Gamer (API ViaCEP)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: CoresApp.cianoEletrico.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'API REST',
                  style: TextStyle(
                    color: CoresApp.cianoEletrico,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Campo de entrada do CEP
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controladorCep,
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Ex: 13030-010',
                    hintStyle: const TextStyle(color: CoresApp.textoApagado),
                    filled: true,
                    fillColor: CoresApp.fundoPrincipal,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: CoresApp.bordaCard),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: CoresApp.cianoEletrico),
                    ),
                  ),
                  onSubmitted: _consultarCep,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoresApp.cianoEletrico,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _carregando ? null : () => _consultarCep(_controladorCep.text),
                child: _carregando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text('Calcular', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),

          if (_mensagemErro != null) ...[
            const SizedBox(height: 10),
            Text(
              _mensagemErro!,
              style: const TextStyle(color: CoresApp.vermelhoAlerta, fontSize: 12),
            ),
          ],

          // Resultado do Frete
          if (_enderecoResultado != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CoresApp.superficieCardElevada,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CoresApp.verdeSucesso.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Frete GameLuX Express: ${_enderecoResultado!.valorFrete.paraReal()}',
                        style: const TextStyle(
                          color: CoresApp.verdeSucesso,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Prazo: ${_enderecoResultado!.prazoDiasUteis} dia(s) útil(eis)',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Destino: ${_enderecoResultado!.formatado}',
                    style: const TextStyle(color: CoresApp.textoSecundario, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
