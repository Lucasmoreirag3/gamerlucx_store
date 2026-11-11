import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/endereco_cep.dart';

class ApiCepServico {
  Future<EnderecoCep> buscarPorCep(String cep) async {
    final cepTratado = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepTratado.length != 8) {
      throw Exception('Formato de CEP inválido');
    }

    final resposta = await http.get(Uri.parse('https://viacep.com.br/ws/$cepTratado/json/'));

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      if (dados.containsKey('erro')) {
        throw Exception('CEP não encontrado');
      }

      return EnderecoCep.fromMap(dados);
    } else {
      throw Exception('Falha ao consultar a API ViaCEP');
    }
  }
}