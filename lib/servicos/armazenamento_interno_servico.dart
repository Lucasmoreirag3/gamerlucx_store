import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/usuario_cliente.dart';
import '../modelos/item_carrinho.dart';
import '../modelos/pedido.dart';

/// Critério 7 (Desejável): Persistindo modificações no armazenamento interno.
/// Guarda com segurança informações sensíveis do cliente (perfil, dados de pagamento e carrinho)
/// dentro do armazenamento privado da aplicação no dispositivo móvel.
class ArmazenamentoInternoServico {
  static const String _chaveUsuario = 'gamelux_usuario_cliente_v1';
  static const String _chaveCarrinho = 'gamelux_carrinho_itens_v1';
  static const String _chavePedidos = 'gamelux_pedidos_historico_v1';

  // --- PERSISTÊNCIA DE DADOS DO USUÁRIO (DADOS SENSÍVEIS) ---

  static Future<void> salvarUsuario(UsuarioCliente usuario) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringJson = jsonEncode(usuario.toJson());
      await prefs.setString(_chaveUsuario, stringJson);
    } catch (e) {
      print('Erro ao salvar dados do usuário no armazenamento interno: $e');
    }
  }

  static Future<UsuarioCliente> obterUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringJson = prefs.getString(_chaveUsuario);
      if (stringJson != null && stringJson.isNotEmpty) {
        final mapa = jsonDecode(stringJson);
        return UsuarioCliente.fromJson(mapa);
      }
    } catch (e) {
      print('Erro ao ler dados do usuário no armazenamento interno: $e');
    }
    return UsuarioCliente.padrao();
  }

  // --- PERSISTÊNCIA DO CARRINHO DE COMPRAS ---

  static Future<void> salvarCarrinho(List<ItemCarrinho> itens) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listaJson = itens.map((item) => item.toJson()).toList();
      await prefs.setString(_chaveCarrinho, jsonEncode(listaJson));
    } catch (e) {
      print('Erro ao salvar carrinho no armazenamento interno: $e');
    }
  }

  static Future<List<ItemCarrinho>> obterCarrinho() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringJson = prefs.getString(_chaveCarrinho);
      if (stringJson != null && stringJson.isNotEmpty) {
        final List lista = jsonDecode(stringJson);
        return lista.map((i) => ItemCarrinho.fromJson(i)).toList();
      }
    } catch (e) {
      print('Erro ao obter carrinho do armazenamento interno: $e');
    }
    return [];
  }

  static Future<void> limparCarrinho() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveCarrinho);
  }

  // --- PERSISTÊNCIA DE HISTÓRICO DE PEDIDOS ---

  static Future<void> salvarPedido(Pedido pedido) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pedidosAtuais = await obterHistoricoPedidos();
      pedidosAtuais.insert(0, pedido); // insere no início (mais recente)

      final listaJson = pedidosAtuais.map((p) => p.toJson()).toList();
      await prefs.setString(_chavePedidos, jsonEncode(listaJson));
    } catch (e) {
      print('Erro ao persistir pedido no armazenamento interno: $e');
    }
  }

  static Future<List<Pedido>> obterHistoricoPedidos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringJson = prefs.getString(_chavePedidos);
      if (stringJson != null && stringJson.isNotEmpty) {
        final List lista = jsonDecode(stringJson);
        return lista.map((p) => Pedido.fromJson(p)).toList();
      }
    } catch (e) {
      print('Erro ao obter pedidos do armazenamento interno: $e');
    }
    return [];
  }
}
