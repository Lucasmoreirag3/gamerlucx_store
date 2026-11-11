import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/pedido.dart';

class ArmazenamentoExternoServico {
  final String urlServicoNuvem = 'https://jsonplaceholder.typicode.com/posts';

  Future<bool> sincronizarPedidoServidor(Pedido pedido) async {
    final resposta = await http.post(
      Uri.parse(urlServicoNuvem),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(pedido.toMap()),
    );
    return resposta.statusCode == 201 || resposta.statusCode == 200;
  }
}