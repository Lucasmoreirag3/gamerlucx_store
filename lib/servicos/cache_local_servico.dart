import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/produto.dart';

/// Critério 7 (Crítico): Persistindo dados localmente no cache do aplicativo.
/// Gerencia o cache rápido no dispositivo para permitir carregamento instantâneo
/// e modo offline com tolerância a falhas de rede.
class CacheLocalServico {
  static const String _chaveCacheProdutos = 'gamelux_cache_produtos_v1';
  static const String _chaveTimestampCache = 'gamelux_timestamp_cache_v1';
  static const String _chaveFavoritos = 'gamelux_favoritos_ids_v1';
  static const int _duracaoValidadeMinutos = 30; // Tempo de validade do cache

  /// Salva lista de produtos no cache local do aplicativo
  static Future<void> salvarProdutosNoCache(List<Produto> produtos) async {
    try {
      final preferencias = await SharedPreferences.getInstance();
      final listaJson = produtos.map((p) => p.toJson()).toList();
      final stringJson = jsonEncode(listaJson);

      await preferencias.setString(_chaveCacheProdutos, stringJson);
      await preferencias.setInt(
        _chaveTimestampCache,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Erro ao persistir produtos no cache: $e');
    }
  }

  /// Recupera os produtos do cache local. Retorna lista vazia se não existir ou se expirado.
  static Future<List<Produto>> obterProdutosDoCache({bool ignorarExpiracao = false}) async {
    try {
      final preferencias = await SharedPreferences.getInstance();
      final stringJson = preferencias.getString(_chaveCacheProdutos);
      final timestamp = preferencias.getInt(_chaveTimestampCache);

      if (stringJson == null || stringJson.isEmpty) {
        return [];
      }

      // Verifica validade temporal do cache se não for forçado ignorar
      if (!ignorarExpiracao && timestamp != null) {
        final dataSalva = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final diferenca = DateTime.now().difference(dataSalva);
        if (diferenca.inMinutes > _duracaoValidadeMinutos) {
          // Cache expirado
          return [];
        }
      }

      final List dadosDecodificados = jsonDecode(stringJson);
      return dadosDecodificados
          .map((item) => Produto.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao recuperar cache local: $e');
      return [];
    }
  }

  /// Gerencia os produtos marcados como favoritos pelo cliente no cache
  static Future<List<String>> obterIdsFavoritos() async {
    final preferencias = await SharedPreferences.getInstance();
    return preferencias.getStringList(_chaveFavoritos) ?? [];
  }

  static Future<void> alternarFavorito(String idProduto) async {
    final preferencias = await SharedPreferences.getInstance();
    final favoritos = preferencias.getStringList(_chaveFavoritos) ?? [];
    if (favoritos.contains(idProduto)) {
      favoritos.remove(idProduto);
    } else {
      favoritos.add(idProduto);
    }
    await preferencias.setStringList(_chaveFavoritos, favoritos);
  }

  static Future<bool> isFavorito(String idProduto) async {
    final favoritos = await obterIdsFavoritos();
    return favoritos.contains(idProduto);
  }

  /// Limpa o cache do aplicativo
  static Future<void> limparCache() async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.remove(_chaveCacheProdutos);
    await preferencias.remove(_chaveTimestampCache);
  }
}
