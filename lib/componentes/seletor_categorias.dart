import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/produto.dart';

/// Critério 11 (Desejável): Otimizando código através de componentização.
/// Barra horizontal com chips de filtros de categoria gamer.
class SeletorCategorias extends StatelessWidget {
  final CategoriaProduto? categoriaSelecionada;
  final Function(CategoriaProduto?) aoSelecionar;

  const SeletorCategorias({
    super.key,
    required this.categoriaSelecionada,
    required this.aoSelecionar,
  });

  Widget _construirChip({
    required BuildContext context,
    required String titulo,
    required IconData icone,
    required bool selecionado,
    required VoidCallback aoTocar,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: selecionado ? CoresApp.gradienteRoxoCiano : null,
            color: selecionado ? null : CoresApp.superficieCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selecionado ? Colors.transparent : CoresApp.bordaCard,
            ),
            boxShadow: selecionado
                ? [
                    BoxShadow(
                      color: CoresApp.roxoNeon.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icone,
                size: 16,
                color: selecionado ? Colors.white : CoresApp.textoSecundario,
              ),
              const SizedBox(width: 6),
              Text(
                titulo,
                style: TextStyle(
                  color: selecionado ? Colors.white : CoresApp.textoSecundario,
                  fontSize: 13,
                  fontWeight: selecionado ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _construirChip(
            context: context,
            titulo: 'Todos',
            icone: Icons.grid_view_rounded,
            selecionado: categoriaSelecionada == null,
            aoTocar: () => aoSelecionar(null),
          ),
          _construirChip(
            context: context,
            titulo: 'PCs Gamer',
            icone: Icons.computer_rounded,
            selecionado: categoriaSelecionada == CategoriaProduto.computador,
            aoTocar: () => aoSelecionar(CategoriaProduto.computador),
          ),
          _construirChip(
            context: context,
            titulo: 'Periféricos',
            icone: Icons.keyboard_rounded,
            selecionado: categoriaSelecionada == CategoriaProduto.periferico,
            aoTocar: () => aoSelecionar(CategoriaProduto.periferico),
          ),
          _construirChip(
            context: context,
            titulo: 'Consoles & Jogos',
            icone: Icons.sports_esports_rounded,
            selecionado: categoriaSelecionada == CategoriaProduto.console,
            aoTocar: () => aoSelecionar(CategoriaProduto.console),
          ),
        ],
      ),
    );
  }
}
