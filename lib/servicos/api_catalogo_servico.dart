import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../modelos/produto.dart';

class ApiCatalogoServico {
  final String urlBase = defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:3000/produtos'
      : 'http://localhost:3000/produtos';

  Future<List<Produto>> obterProdutos() async {
    final resposta = await http.get(Uri.parse(urlBase));

    if (resposta.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(resposta.body);
      final List<Produto> listaFinal = [];

      for (int i = 0; i < dados.length; i++) {
        final item = dados[i];
        listaFinal.add(Produto.fromJson({
          'id': item['id'].toString(),
          'nome': item['nome'] ?? 'Produto GameLuX',
          'marca': item['marca'] ?? 'GameLuX',
          'preco': (item['preco'] ?? 0).toDouble(),
          'imagemUrl': item['imagemUrl'] ?? 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=500',
          'descricao': item['descricao'] ?? 'Produto da GameLuX Store.',
          'quantidadeEstoque': item['quantidadeEstoque'] ?? 0,
          'avaliacao': (item['avaliacao'] ?? 5.0).toDouble(),
          'emDestaque': item['emDestaque'] ?? false,
          'tipo_categoria': item['tipo_categoria'] ?? 'periferico',
          'processador': item['processador'],
          'placaDeVideo': item['placaDeVideo'],
          'memoriaRamGb': item['memoriaRamGb'],
          'armazenamento': item['armazenamento'],
          'fonteAlimentacao': item['fonteAlimentacao'],
          'possuiWaterCooler': item['possuiWaterCooler'],
          'tipoConexao': item['tipoConexao'],
          'iluminacaoRgb': item['iluminacaoRgb'],
          'dpiOuFrequencia': item['dpiOuFrequencia'],
          'subcategoria': item['subcategoria'],
          'plataforma': item['plataforma'],
          'capacidadeArmazenamento': item['capacidadeArmazenamento'],
          'quantidadeControlesInclusos': item['quantidadeControlesInclusos'],
          'suportaMidiaFisica': item['suportaMidiaFisica'],
        }));
      }

      return listaFinal;
    } else {
      throw Exception('Falha ao comunicar com a API via GET');
    }
  }

  Future<Produto> cadastrarProduto(Produto produto) async {
    final resposta = await http.post(
      Uri.parse(urlBase),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(produto.toJson()),
    );

    if (resposta.statusCode == 201 || resposta.statusCode == 200) {
      return produto;
    } else {
      throw Exception('Falha ao registar produto via POST');
    }
  }

  Future<Produto> atualizarProduto(String id, Produto produto) async {
    final resposta = await http.put(
      Uri.parse('$urlBase/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(produto.toJson()),
    );

    if (resposta.statusCode == 200) {
      return produto;
    } else {
      throw Exception('Falha ao atualizar produto via PUT');
    }
  }

  Future<bool> excluirProduto(String id) async {
    final resposta = await http.delete(Uri.parse('$urlBase/$id'));
    return resposta.statusCode == 200;
  }
}