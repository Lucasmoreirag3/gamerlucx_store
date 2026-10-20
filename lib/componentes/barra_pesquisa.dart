import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';

/// Critério 11 (Desejável): Otimizando código através de componentização.
/// Barra de busca interativa com estética cyberpunk e limpeza rápida.
class BarraPesquisa extends StatelessWidget {
  final TextEditingController controlador;
  final ValueChanged<String> aoDigitar;
  final VoidCallback aoLimpar;

  const BarraPesquisa({
    super.key,
    required this.controlador,
    required this.aoDigitar,
    required this.aoLimpar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CoresApp.superficieCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CoresApp.bordaCard),
      ),
      child: TextField(
        controller: controlador,
        onChanged: aoDigitar,
        style: const TextStyle(color: CoresApp.textoPrincipal, fontSize: 14),
        cursorColor: CoresApp.cianoEletrico,
        decoration: InputDecoration(
          hintText: 'Buscar PC Gamer, Teclado, PS5, RTX...',
          hintStyle: const TextStyle(color: CoresApp.textoApagado, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: CoresApp.cianoEletrico),
          suffixIcon: controlador.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: CoresApp.textoSecundario, size: 18),
                  onPressed: aoLimpar,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
