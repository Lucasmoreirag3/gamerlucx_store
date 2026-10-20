/// Representa os dados sensíveis e privados do usuário cliente da GameLuX Store.
/// Conforme especificado na Situação de Aprendizagem:
/// - Dados sensíveis/privados (Nome, Email, Endereço residencial, Nick Gamer e Saldo de pontos)
///   devem ser mantidos com segurança e persistidos no armazenamento local interno do dispositivo.
class UsuarioCliente {
  final String id;
  String nomeCompleto;
  String nickGamer;
  String email;
  String cepPadrao;
  String cidadeUf;
  int pontosFidelidade;

  UsuarioCliente({
    required this.id,
    required this.nomeCompleto,
    required this.nickGamer,
    required this.email,
    required this.cepPadrao,
    required this.cidadeUf,
    this.pontosFidelidade = 1500,
  });

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

  /// Dados padrão iniciais do usuário para inicialização suave
  factory UsuarioCliente.padrao() {
    return UsuarioCliente(
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
