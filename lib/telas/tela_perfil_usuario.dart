import 'package:flutter/material.dart';
import '../modelos/usuario_cliente.dart';
import '../servicos/armazenamento_interno_servico.dart';

class TelaPerfilUsuario extends StatefulWidget {
  const TelaPerfilUsuario({super.key});

  @override
  State<TelaPerfilUsuario> createState() => _TelaPerfilUsuarioState();
}

class _TelaPerfilUsuarioState extends State<TelaPerfilUsuario> {
  final ArmazenamentoInternoServico _servicoInterno = ArmazenamentoInternoServico();
  UsuarioCliente? _usuario;
  bool _aCarregar = true;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    setState(() => _aCarregar = true);
    final dados = await _servicoInterno.obterUsuario();
    setState(() {
      _usuario = dados;
      _aCarregar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Perfil do Jogador'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _aCarregar
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _usuario?.nickGamer ?? 'Gamer',
                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _itemInfo('Nome Completo', _usuario?.nomeCompleto ?? ''),
                  _itemInfo('E-mail', _usuario?.email ?? ''),
                  _itemInfo('Token de Acesso Sensível', _usuario?.tokenAcesso ?? ''),
                ],
              ),
            ),
    );
  }

  Widget _itemInfo(String titulo, String valor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: const TextStyle(color: Colors.white70)),
          Text(valor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}