import 'package:flutter/material.dart';

class BotaoGamer extends StatelessWidget {
  final String texto;
  final IconData? icone;
  final VoidCallback aoClicar;
  final Color cor;

  const BotaoGamer({
    super.key,
    required this.texto,
    required this.aoClicar,
    this.icone,
    this.cor = Colors.deepPurpleAccent,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: aoClicar,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icone != null) ...[
            Icon(icone, size: 18),
            const SizedBox(width: 8),
          ],
          Text(texto, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}