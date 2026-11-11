/// Representa os dados sensíveis e privados do usuário cliente da GameLuX Store.
class UsuarioCliente {
  final String id;
  final String nomeCompleto;
  final String nickGamer;
  final String email;
  final String cepPadrao;
  final String cidadeUf;
  final int pontosFidelidade;

  const UsuarioCliente({
    required this.id,
    required this.nomeCompleto,
    required this.nickGamer,
    required this.email,
    required this.cepPadrao,
    required this.cidadeUf,
    this.pontosFidelidade = 1500,
  });

  String get nome => nomeCompleto;
  String get apelidoGamer => nickGamer;
  String get tokenAcesso => 'JWT_TOKEN_LOCAL_SENSIVEL_XYZ';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeCompleto': nomeCompleto,
      'nickGamer': nickGamer,
      'email': email,
      'cepPadrao': cepPadrao,
      'cidadeUf': cidadeUf,
      'pontosFidelidade': pontosFidelidade,
    };
  }

  factory UsuarioCliente.fromJson(Map<String, dynamic> json) {
    return UsuarioCliente(
      id: json['id'] ?? 'user_1',
      nomeCompleto: json['nomeCompleto'] ?? 'Lucas Moreira',
      nickGamer: json['nickGamer'] ?? 'LuX_Gamer',
      email: json['email'] ?? 'lucas.gomes@aluno.senai.br',
      cepPadrao: json['cepPadrao'] ?? '13030-010',
      cidadeUf: json['cidadeUf'] ?? 'Campinas / SP',
      pontosFidelidade: (json['pontosFidelidade'] as num?)?.toInt() ?? 1500,
    );
  }

  factory UsuarioCliente.padrao() {
    return const UsuarioCliente(
      id: 'user_gamer_01',
      nomeCompleto: 'Lucas Moreira Gomes',
      nickGamer: 'LuX_Gamer',
      email: 'lucas.gomes@aluno.senai.br',
      cepPadrao: '13030-010',
      cidadeUf: 'Campinas / SP',
      pontosFidelidade: 2500,
    );
  }
}
