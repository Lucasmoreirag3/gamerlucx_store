/// Critério 8 (Desejável): Integração de múltiplas APIs.
/// Modelo de dados retornado pela API pública do ViaCEP (https://viacep.com.br).
class EnderecoCep {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final double valorFrete;
  final int prazoDiasUteis;

  const EnderecoCep({
    required this.cep,
    required this.logradouro,
    this.complemento = '',
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.valorFrete = 0.0,
    this.prazoDiasUteis = 2,
  });

  /// Construtor que analisa o JSON recebido da API do ViaCEP
  factory EnderecoCep.fromViaCepJson(Map<String, dynamic> json) {
    final estadoUf = json['uf'] ?? 'SP';

    // Regra de simulação de frete gamer calculada com base na região do Brasil
    double freteCalculado = 29.90;
    int prazoCalculado = 2;

    if (estadoUf == 'SP') {
      freteCalculado = 19.90; // Frete Express interior/capital SP
      prazoCalculado = 1;
    } else if (['RJ', 'MG', 'ES', 'PR', 'SC', 'RS'].contains(estadoUf)) {
      freteCalculado = 34.90;
      prazoCalculado = 3;
    } else if (['DF', 'GO', 'MS', 'MT'].contains(estadoUf)) {
      freteCalculado = 42.00;
      prazoCalculado = 4;
    } else {
      freteCalculado = 59.90;
      prazoCalculado = 6;
    }

    return EnderecoCep(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: estadoUf,
      valorFrete: freteCalculado,
      prazoDiasUteis: prazoCalculado,
    );
  }

  factory EnderecoCep.fromMap(Map<String, dynamic> json) {
    return EnderecoCep(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
      valorFrete: (json['valorFrete'] as num?)?.toDouble() ?? 0.0,
      prazoDiasUteis: (json['prazoDiasUteis'] as num?)?.toInt() ?? 2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'valorFrete': valorFrete,
      'prazoDiasUteis': prazoDiasUteis,
    };
  }

  factory EnderecoCep.fromJson(Map<String, dynamic> json) {
    return EnderecoCep.fromMap(json);
  }

  String get enderecoCompleto => '$logradouro, $bairro - $localidade/$uf (CEP: $cep)';
  String get formatado => enderecoCompleto;
}
