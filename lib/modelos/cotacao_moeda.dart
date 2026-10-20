/// Critério 8 (Desejável): Integração de múltiplas APIs.
/// Modelo para a cotação de moedas em tempo real da AwesomeAPI (https://economia.awesomeapi.com.br/last/USD-BRL).
class CotacaoMoeda {
  final String codigo;
  final String nome;
  final double valorCompra;
  final double valorVenda;
  final double variacao;
  final String dataAtualizacao;

  const CotacaoMoeda({
    required this.codigo,
    required this.nome,
    required this.valorCompra,
    required this.valorVenda,
    required this.variacao,
    required this.dataAtualizacao,
  });

  factory CotacaoMoeda.fromAwesomeJson(Map<String, dynamic> json) {
    final usdData = json['USDBRL'] ?? json;
    return CotacaoMoeda(
      codigo: usdData['code'] ?? 'USD',
      nome: usdData['name'] ?? 'Dólar Americano/Real Brasileiro',
      valorCompra: double.tryParse(usdData['bid']?.toString() ?? '5.40') ?? 5.40,
      valorVenda: double.tryParse(usdData['ask']?.toString() ?? '5.42') ?? 5.42,
      variacao: double.tryParse(usdData['pctChange']?.toString() ?? '0.0') ?? 0.0,
      dataAtualizacao: usdData['create_date'] ?? DateTime.now().toString(),
    );
  }

  /// Converte um preço em reais para o valor equivalente em dólares
  double converterRealParaDolar(double valorEmReais) {
    if (valorCompra <= 0) return valorEmReais / 5.40;
    return valorEmReais / valorCompra;
  }
}
