import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/cotacao_moeda.dart';

class ApiCotacaoServico {
  Future<CotacaoMoeda> buscarCotacaoDolar() async {
    final resposta = await http.get(Uri.parse('https://economia.awesomeapi.com.br/last/USD-BRL'));

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final dadosDolar = dados['USDBRL'];
      return CotacaoMoeda.fromMap(dadosDolar);
    } else {
      throw Exception('Falha ao consultar cotação de moeda');
    }
  }
}