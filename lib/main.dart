import 'package:flutter/material.dart';
import 'constantes/cores_app.dart';
import 'constantes/rotas_app.dart';
import 'telas/tela_catalogo_inicio.dart';
import 'telas/tela_carrinho_compras.dart';
import 'telas/tela_gerenciar_produtos.dart';
import 'telas/tela_perfil_usuario.dart';

/// GameLuX Store - Aplicativo Mobile de E-commerce Gamer
/// Projeto desenvolvido para a Situação de Aprendizagem "Da Tela Ao App Integrado"
/// Escola e Faculdade de Tecnologia SENAI "Roberto Mange"
/// Aluno: Lucas Moreira Gomes | Agência Digital Horizon
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GameLuxApp());
}

class GameLuxApp extends StatelessWidget {
  const GameLuxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameLuX Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CoresApp.fundoPrincipal,
        primaryColor: CoresApp.roxoNeon,
        colorScheme: const ColorScheme.dark(
          primary: CoresApp.roxoNeon,
          secondary: CoresApp.cianoEletrico,
          surface: CoresApp.superficieCard,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: CoresApp.fundoPrincipal,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      initialRoute: RotasApp.inicio,
      routes: {
        RotasApp.inicio: (context) => const TelaCatalogoInicio(),
        RotasApp.carrinho: (context) => const TelaCarrinhoCompras(),
        RotasApp.gerenciarProdutos: (context) => const TelaGerenciarProdutos(),
        RotasApp.perfil: (context) => const TelaPerfilUsuario(),
      },
    );
  }
}
