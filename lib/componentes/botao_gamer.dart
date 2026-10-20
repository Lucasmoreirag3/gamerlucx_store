import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';

/// Critério 11 (Desejável): Otimizando código através de componentização.
/// Botão gamer reutilizável com efeito de gradiente neon roxo/ciano e cantos arredondados.
class BotaoGamer extends StatelessWidget {
  final String texto;
  final VoidCallback? aoPressionar;
  final IconData? icone;
  final bool carregando;
  final bool expandir;
  final Color? corFundo;
  final LinearGradient? gradiente;

  const BotaoGamer({
    super.key,
    required this.texto,
    required this.aoPressionar,
    this.icone,
    this.carregando = false,
    this.expandir = true,
    this.corFundo,
    this.gradiente,
  });

  @override
  Widget build(BuildContext context) {
    Widget conteudo = Row(
      mainAxisSize: expandir ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (carregando) ...[
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icone != null) ...[
          Icon(icone, color: Colors.white, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    final decoracao = BoxDecoration(
      gradient: aoPressionar == null
          ? null
          : (gradiente ?? (corFundo == null ? CoresApp.gradienteRoxoCiano : null)),
      color: aoPressionar == null
          ? Colors.white12
          : (gradiente == null ? corFundo : null),
      borderRadius: BorderRadius.circular(12),
      boxShadow: aoPressionar != null
          ? [
              BoxShadow(
                color: (corFundo ?? CoresApp.roxoNeon).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]
          : null,
    );

    return InkWell(
      onTap: carregando ? null : aoPressionar,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: decoracao,
        child: conteudo,
      ),
    );
  }
}
