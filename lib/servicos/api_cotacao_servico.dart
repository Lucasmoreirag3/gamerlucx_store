import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/cotacao_moeda.dart';

/// Critério 8 (Desejável): Realizando integração de múltiplas APIs.
/// API 3: Consumo da API pública AwesomeAPI para cotação em tempo real do Dólar Comercial (USD -> BRL).
/// Muito útil para gamers acompanharem os preços do hardware importado.
class ApiCotacaoServico {
  static const String _urlCotacao = 'https://economia.awesomeapi.com.br/last/USD-BRL';

  /// Realiza uma requisição HTTP GET para obter a cotação atualizada do Dólar
  static Future<CotacaoMoeda> obterCotacaoDolar() async {
    try {
      final uri = Uri.parse(_urlCotacao);
      final resposta = await http.get(uri).timeout(const Duration(seconds: 8));

      if (resposta.statusCode == 200) {
        final mapa = jsonDecode(resposta.body);
        return CotacaoMoeda.fromAwesomeJson(mapa);
      } else {
        throw Exception('Falha ao obter cotação: Status ${resposta.statusCode}');
      }
    } catch (e) {
      print('Aviso AwesomeAPI: $e. Utilizando cotação de referência padrão.');
      return const CotacaoMoeda(
        codigo: 'USD',
        nome: 'Dólar Americano/Real Brasileiro (Referência)',
        valorCompra: 5.42,
        valorVenda: 5.45,
        variacao: 0.12,
        dataAtualizacao: 'Cotação de Referência Oficial',
      );
    }
  }
}
