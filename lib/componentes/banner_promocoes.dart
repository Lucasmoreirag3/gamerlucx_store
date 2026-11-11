import 'dart:async';
import 'package:flutter/material.dart';

class BannerPromocoes extends StatefulWidget {
  const BannerPromocoes({super.key});

  @override
  State<BannerPromocoes> createState() => _BannerPromocoesState();
}

class _BannerPromocoesState extends State<BannerPromocoes> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _paginaAtual = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'tag': 'HOT DROP',
      'titulo': 'RTX ARCADE',
      'descricao': 'Até 15% OFF em PCs e periféricos com setup gamer em 4K.',
      'cor1': const Color(0xFF0B1026),
      'cor2': const Color(0xFF3B1F78),
      'icone': Icons.flash_on_rounded,
      'botao': 'Ver ofertas',
    },
    {
      'tag': 'NOVO',
      'titulo': 'SETUP READY',
      'descricao': 'Frete express e combos com teclado, mouse e monitor em destaque.',
      'cor1': const Color(0xFF081320),
      'cor2': const Color(0xFF0E6C7A),
      'icone': Icons.rocket_launch_rounded,
      'botao': 'Ver combos',
    },
    {
      'tag': 'LIMITADO',
      'titulo': 'E-SPORTS NIGHT',
      'descricao': 'Descontos especiais para gamers que querem dominar a próxima partida.',
      'cor1': const Color(0xFF120E1E),
      'cor2': const Color(0xFF5D0D7A),
      'icone': Icons.shield_outlined,
      'botao': 'Entrar',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final proxima = (_paginaAtual + 1) % _slides.length;
      _pageController.animateToPage(
        proxima,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (pagina) => setState(() => _paginaAtual = pagina),
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.cyan.withValues(alpha: 0.45), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withValues(alpha: 0.25),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [slide['cor1'], slide['cor2']],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withValues(alpha: 0.68),
                                Colors.black.withValues(alpha: 0.28),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 18,
                        right: 18,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            slide['tag'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                              letterSpacing: 1.6,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                              ),
                              child: Icon(slide['icone'], color: Colors.yellowAccent, size: 40),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    slide['titulo'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    slide['descricao'],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF00E5FF), Color(0xFF9D4EDD)],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.cyan.withValues(alpha: 0.35),
                                          blurRadius: 14,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        slide['botao'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            final ativo = index == _paginaAtual;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: ativo ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: ativo ? Colors.cyanAccent : Colors.white24,
              ),
            );
          }),
        ),
      ],
    );
  }
}