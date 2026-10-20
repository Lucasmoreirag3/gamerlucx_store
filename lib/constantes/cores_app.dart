import 'package:flutter/material.dart';

/// Paleta de cores oficial da GameLuX Store.
/// Estilo gamer moderno: tema escuro imersivo, roxo neon, ciano elétrico e detalhes em verde status.
class CoresApp {
  // Fundo e superfícies
  static const Color fundoPrincipal = Color(0xFF0B0E17);
  static const Color superficieCard = Color(0xFF151926);
  static const Color superficieCardElevada = Color(0xFF1F2437);
  static const Color bordaCard = Color(0xFF2A314A);

  // Cores de destaque (Gamer Neon)
  static const Color roxoNeon = Color(0xFF8B5CF6);
  static const Color roxoEscuro = Color(0xFF6D28D9);
  static const Color cianoEletrico = Color(0xFF06B6D4);
  static const Color azulGamer = Color(0xFF3B82F6);
  static const Color verdeSucesso = Color(0xFF10B981);
  static const Color vermelhoAlerta = Color(0xFFEF4444);
  static const Color amareloDestaque = Color(0xFFF59E0B);

  // Textos
  static const Color textoPrincipal = Color(0xFFF8FAFC);
  static const Color textoSecundario = Color(0xFF94A3B8);
  static const Color textoApagado = Color(0xFF64748B);

  // Gradientes
  static const LinearGradient gradienteRoxoCiano = LinearGradient(
    colors: [roxoNeon, cianoEletrico],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradienteCard = LinearGradient(
    colors: [Color(0xFF1A1F30), Color(0xFF121624)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
