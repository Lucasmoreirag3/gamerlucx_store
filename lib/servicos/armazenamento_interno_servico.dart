import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/usuario_cliente.dart';

class ArmazenamentoInternoServico {
  static const String _chaveId = 'gamelucx_utilizador_id';
  static const String _chaveNome = 'gamelucx_utilizador_nome';
  static const String _chaveApelido = 'gamelucx_utilizador_apelido';
  static const String _chaveEmail = 'gamelucx_utilizador_email';
  static const String _chaveToken = 'gamelucx_utilizador_token_sensivel';

  Future<void> gravarUsuario(UsuarioCliente usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveId, usuario.id);
    await prefs.setString(_chaveNome, usuario.nomeCompleto);
    await prefs.setString(_chaveApelido, usuario.nickGamer);
    await prefs.setString(_chaveEmail, usuario.email);
    await prefs.setString(_chaveToken, usuario.tokenAcesso);
  }

  Future<UsuarioCliente> obterUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return UsuarioCliente(
      id: prefs.getString(_chaveId) ?? '001',
      nomeCompleto: prefs.getString(_chaveNome) ?? 'Lucas Silva',
      nickGamer: prefs.getString(_chaveApelido) ?? 'GameLuX_Master',
      email: prefs.getString(_chaveEmail) ?? 'cliente@gamelucx.com',
      cepPadrao: '13030-010',
      cidadeUf: 'Campinas / SP',
      pontosFidelidade: 1500,
    );
  }

  Future<void> limparDadosInternos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveId);
    await prefs.remove(_chaveNome);
    await prefs.remove(_chaveApelido);
    await prefs.remove(_chaveEmail);
    await prefs.remove(_chaveToken);
  }
}