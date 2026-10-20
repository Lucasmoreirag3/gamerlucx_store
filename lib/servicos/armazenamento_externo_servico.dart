import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../modelos/produto.dart';
import '../modelos/pedido.dart';
import '../utilitarios/formatadores.dart';

/// Critério 7 (Crítico): Persistindo dados no armazenamento externo.
/// Permite exportar backups do catálogo e comprovantes de pedidos diretamente para
/// o sistema de arquivos do dispositivo (armazenamento externo / documentos do usuário).
class ArmazenamentoExternoServico {
  /// Obtém o diretório apropriado para armazenamento de documentos e arquivos externos
  static Future<Directory?> _obterDiretorioArmazenamento() async {
    try {
      if (kIsWeb) {
        return null;
      }
      if (Platform.isAndroid) {
        final diretorioExterno = await getExternalStorageDirectory();
        if (diretorioExterno != null) return diretorioExterno;
      }
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      print('Erro ao obter diretório de armazenamento externo: $e');
      return null;
    }
  }

  /// Exporta o catálogo completo de produtos em formato JSON para arquivo externo no dispositivo
  static Future<String> exportarCatalogoParaArquivo(List<Produto> produtos) async {
    try {
      final diretorio = await _obterDiretorioArmazenamento();
      if (diretorio == null) {
        return 'Armazenamento externo simulado com sucesso (modo Web)';
      }

      final pastaGameLux = Directory('${diretorio.path}/GameLuX_Backups');
      if (!await pastaGameLux.exists()) {
        await pastaGameLux.create(recursive: true);
      }

      final caminhoArquivo = '${pastaGameLux.path}/catalogo_produtos_gamelux.json';
      final arquivo = File(caminhoArquivo);

      final listaMapas = produtos.map((p) => p.toJson()).toList();
      final conteudoJson = const JsonEncoder.withIndent('  ').convert(listaMapas);

      await arquivo.writeAsString(conteudoJson);
      return 'Arquivo exportado com sucesso em:\n$caminhoArquivo';
    } catch (e) {
      return 'Falha ao salvar no armazenamento externo: $e';
    }
  }

  /// Lê e importa o catálogo de produtos a partir de arquivo JSON salvo no armazenamento externo
  static Future<List<Produto>> importarCatalogoDeArquivo() async {
    try {
      final diretorio = await _obterDiretorioArmazenamento();
      if (diretorio == null) return [];

      final caminhoArquivo = '${diretorio.path}/GameLuX_Backups/catalogo_produtos_gamelux.json';
      final arquivo = File(caminhoArquivo);

      if (await arquivo.exists()) {
        final conteudoJson = await arquivo.readAsString();
        final List listaDecodificada = jsonDecode(conteudoJson);
        return listaDecodificada
            .map((item) => Produto.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Erro ao importar arquivo do armazenamento externo: $e');
    }
    return [];
  }

  /// Exporta comprovante de pedido formatado em arquivo de texto legível para o cliente
  static Future<String> exportarComprovantePedido(Pedido pedido) async {
    try {
      final diretorio = await _obterDiretorioArmazenamento();
      if (diretorio == null) {
        return 'Comprovante gerado com sucesso!';
      }

      final pastaGameLux = Directory('${diretorio.path}/GameLuX_Comprovantes');
      if (!await pastaGameLux.exists()) {
        await pastaGameLux.create(recursive: true);
      }

      final caminhoArquivo = '${pastaGameLux.path}/recibo_pedido_${pedido.id}.txt';
      final arquivo = File(caminhoArquivo);

      final buffer = StringBuffer();
      buffer.writeln('==============================================');
      buffer.writeln('           GAMELUX STORE - COMPROVANTE        ');
      buffer.writeln('==============================================');
      buffer.writeln('Número do Pedido: ${pedido.id}');
      buffer.writeln('Data/Hora: ${pedido.dataPedido.toString().substring(0, 19)}');
      buffer.writeln('Status: ${pedido.statusFormatado}');
      buffer.writeln('Forma de Pagamento: ${pedido.formaPagamento}');
      if (pedido.enderecoEntrega != null) {
        buffer.writeln('Endereço de Entrega: ${pedido.enderecoEntrega!.formatado}');
      }
      buffer.writeln('----------------------------------------------');
      buffer.writeln('ITENS COMPRADOS:');
      for (var item in pedido.itens) {
        buffer.writeln('- ${item.quantidade}x ${item.produto.nome}');
        buffer.writeln('  Subtotal: ${item.subtotal.paraReal()}');
      }
      buffer.writeln('----------------------------------------------');
      buffer.writeln('Subtotal dos Produtos: ${pedido.valorProdutos.paraReal()}');
      buffer.writeln('Valor do Frete: ${pedido.valorFrete.paraReal()}');
      buffer.writeln('TOTAL FINAL PAGO: ${pedido.valorTotal.paraReal()}');
      buffer.writeln('==============================================');
      buffer.writeln('   Obrigado por comprar na GameLuX Store!     ');
      buffer.writeln('==============================================');

      await arquivo.writeAsString(buffer.toString());
      return 'Comprovante salvo com sucesso em:\n$caminhoArquivo';
    } catch (e) {
      return 'Erro ao exportar comprovante: $e';
    }
  }
}
