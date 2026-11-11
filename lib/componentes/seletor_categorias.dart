import 'package:flutter/material.dart';
import '../modelos/produto.dart';

class SeletorCategorias extends StatelessWidget {
  final CategoriaProduto? categoriaAtiva;
  final ValueChanged<CategoriaProduto?> aoSelecionar;

  const SeletorCategorias({
    super.key,
    required this.categoriaAtiva,
    required this.aoSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          _construirChip(null, 'Todos'),
          _construirChip(CategoriaProduto.computador, 'PCs Gamer'),
          _construirChip(CategoriaProduto.periferico, 'Periféricos'),
          _construirChip(CategoriaProduto.console, 'Consolas'),
        ],
      ),
    );
  }

  Widget _construirChip(CategoriaProduto? categoria, String rotulo) {
    final bool selecionado = categoriaAtiva == categoria;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(rotulo),
        selected: selecionado,
        selectedColor: Colors.deepPurpleAccent,
        backgroundColor: Colors.grey.shade900,
        labelStyle: TextStyle(
          color: selecionado ? Colors.white : Colors.white70,
          fontSize: 12,
          fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (_) => aoSelecionar(categoria),
      ),
    );
  }
}