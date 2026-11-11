import 'package:shared_preferences/shared_preferences.dart';

class CacheLocalServico {
  static const String _chaveUltimoAcesso = 'gamelucx_cache_data_acesso';
  static const String _chaveTotalCarrinho = 'gamelucx_cache_valor_carrinho';
  static const String _chaveTemaEscuro = 'gamelucx_cache_modo_escuro';

  Future<void> salvarCacheSessao(double total, bool modoEscuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveUltimoAcesso, DateTime.now().toIso8601String());
    await prefs.setDouble(_chaveTotalCarrinho, total);
    await prefs.setBool(_chaveTemaEscuro, modoEscuro);
  }

  Future<Map<String, dynamic>> obterCacheSessao() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'ultimoAcesso': prefs.getString(_chaveUltimoAcesso) ?? '',
      'totalCarrinho': prefs.getDouble(_chaveTotalCarrinho) ?? 0.0,
      'modoEscuro': prefs.getBool(_chaveTemaEscuro) ?? true,
    };
  }

  Future<void> limparCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveUltimoAcesso);
    await prefs.remove(_chaveTotalCarrinho);
    await prefs.remove(_chaveTemaEscuro);
  }
}