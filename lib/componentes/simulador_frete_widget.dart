import 'package:flutter/material.dart';
import '../servicos/api_cep_servico.dart';
import '../modelos/endereco_cep.dart';

class SimuladorFreteWidget extends StatefulWidget {
  const SimuladorFreteWidget({super.key});

  @override
  State<SimuladorFreteWidget> createState() => _SimuladorFreteWidgetState();
}

class _SimuladorFreteWidgetState extends State<SimuladorFreteWidget> {
  final TextEditingController _controladorCep = TextEditingController();
  final ApiCepServico _servicoCep = ApiCepServico();
  EnderecoCep? _endereco;
  bool _aConsultar = false;

  Future<void> _consultar() async {
    if (!mounted) return;
    setState(() => _aConsultar = true);
    try {
      final resultado = await _servicoCep.buscarPorCep(_controladorCep.text);
      if (!mounted) return;
      setState(() => _endereco = resultado);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao consultar CEP')),
      );
    }
    if (!mounted) return;
    setState(() => _aConsultar = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calcular Envio para a Sua Região (ViaCEP):',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _controladorCep,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Digite o CEP (ex: 13010001)',
                      hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                      filled: true,
                      fillColor: Colors.black38,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                  onPressed: _aConsultar ? null : _consultar,
                  child: _aConsultar
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Consultar', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
          if (_endereco != null) ...[
            const SizedBox(height: 8),
            Text(
              'Destino: ${_endereco!.enderecoCompleto}',
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}