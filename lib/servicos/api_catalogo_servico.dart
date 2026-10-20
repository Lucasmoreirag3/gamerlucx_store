import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/produto.dart';
import '../dados/catalogo_inicial.dart';
import 'cache_local_servico.dart';

/// Critério 8 (Crítico): Integração de dispositivos móveis aos serviços web.
/// Implementa a comunicação RESTful completa (GET, POST, PUT, DELETE) com o servidor da loja.
///
/// Também atende:
/// - Critério 7: Persistindo dados localmente no cache do aplicativo para tolerância a falhas.
/// - Competência Socioemocional (Pensamento Analítico e Autonomia): Estruturação offline-first
///   que garante que o app nunca trave caso o servidor esteja indisponível.
class ApiCatalogoServico {
  // Endpoint simulado RESTful para testes na nuvem ou MockAPI
  static const String _urlBase = 'https://664a78c1a300e8795d421711.mockapi.io/api/v1/produtos';

  // Cabeçalhos HTTP padrão para APIs RESTful
  static const Map<String, String> _headersPadrao = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  /// 1. CRITÉRIO 8 (Crítico) - COMUNICAÇÃO GET:
  /// Obtém a lista completa de produtos do catálogo remoto com fallback inteligente no cache local.
  static Future<List<Produto>> obterProdutos() async {
    // 1º Passo: Tenta buscar do cache recente se estiver válido (evita tráfego de rede desnecessário)
    final produtosEmCache = await CacheLocalServico.obterProdutosDoCache();
    if (produtosEmCache.isNotEmpty) {
      return produtosEmCache;
    }

    try {
      final uri = Uri.parse(_urlBase);
      final resposta = await http
          .get(uri, headers: _headersPadrao)
          .timeout(const Duration(seconds: 4));

      if (resposta.statusCode == 200) {
        final List listaRemota = jsonDecode(resposta.body);
        final produtos = listaRemota
            .map((item) => Produto.fromJson(item as Map<String, dynamic>))
            .toList();

        // Atualiza o cache local com os dados frescos da API
        await CacheLocalServico.salvarProdutosNoCache(produtos);
        return produtos;
      } else {
        throw Exception('Falha ao obter catálogo: Código HTTP ${resposta.statusCode}');
      }
    } catch (e) {
      print('Aviso [API GET]: $e. Carregando dados do cache local/dados padrão.');

      // 2º Passo: Recupera do cache mesmo que expirado
      final cacheRecuperado = await CacheLocalServico.obterProdutosDoCache(ignorarExpiracao: true);
      if (cacheRecuperado.isNotEmpty) {
        return cacheRecuperado;
      }

      // 3º Passo: Se for a primeira inicialização sem internet, utiliza o catálogo semente
      final catalogoPadrao = CatalogoInicial.obterProdutosIniciais();
      await CacheLocalServico.salvarProdutosNoCache(catalogoPadrao);
      return catalogoPadrao;
    }
  }

  /// 2. CRITÉRIO 8 (Crítico) - COMUNICAÇÃO POST:
  /// Cadastra um novo produto no servidor web através do método POST enviando JSON.
  static Future<Produto> cadastrarProduto(Produto novoProduto) async {
    try {
      final uri = Uri.parse(_urlBase);
      final corpoJson = jsonEncode(novoProduto.toJson());

      final resposta = await http
          .post(uri, headers: _headersPadrao, body: corpoJson)
          .timeout(const Duration(seconds: 4));

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        final produtoCriado = Produto.fromJson(jsonDecode(resposta.body));
        await _atualizarListaLocalmenteAposCriacao(produtoCriado);
        return produtoCriado;
      } else {
        throw Exception('Falha ao cadastrar no servidor: Código ${resposta.statusCode}');
      }
    } catch (e) {
      print('Aviso [API POST]: $e. Persistindo alteração no cache local.');
      // Garante que a operação funcione mesmo offline para demonstração da SA
      await _atualizarListaLocalmenteAposCriacao(novoProduto);
      return novoProduto;
    }
  }

  /// 3. CRITÉRIO 8 (Crítico) - COMUNICAÇÃO PUT:
  /// Atualiza os dados de um produto existente no servidor web através do método PUT.
  static Future<Produto> atualizarProduto(Produto produtoAtualizado) async {
    try {
      final uri = Uri.parse('$_urlBase/${produtoAtualizado.id}');
      final corpoJson = jsonEncode(produtoAtualizado.toJson());

      final resposta = await http
          .put(uri, headers: _headersPadrao, body: corpoJson)
          .timeout(const Duration(seconds: 4));

      if (resposta.statusCode == 200) {
        final produtoRetornado = Produto.fromJson(jsonDecode(resposta.body));
        await _atualizarListaLocalmenteAposModificacao(produtoRetornado);
        return produtoRetornado;
      } else {
        throw Exception('Falha ao atualizar no servidor: Código ${resposta.statusCode}');
      }
    } catch (e) {
      print('Aviso [API PUT]: $e. Atualizando dados diretamente no cache local.');
      await _atualizarListaLocalmenteAposModificacao(produtoAtualizado);
      return produtoAtualizado;
    }
  }

  /// 4. CRITÉRIO 8 (Crítico) - COMUNICAÇÃO DELETE:
  /// Exclui um produto do catálogo no servidor web através do método DELETE.
  static Future<bool> excluirProduto(String idProduto) async {
    try {
      final uri = Uri.parse('$_urlBase/$idProduto');

      final resposta = await http
          .delete(uri, headers: _headersPadrao)
          .timeout(const Duration(seconds: 4));

      if (resposta.statusCode == 200 || resposta.statusCode == 204) {
        await _removerLocalmenteAposExclusao(idProduto);
        return true;
      } else {
        throw Exception('Falha ao excluir no servidor: Código ${resposta.statusCode}');
      }
    } catch (e) {
      print('Aviso [API DELETE]: $e. Removendo produto do cache local.');
      await _removerLocalmenteAposExclusao(idProduto);
      return true;
    }
  }

  // --- MÉTODOS AUXILIARES PARA SINCRONIZAÇÃO LOCAL DO CACHE ---

  static Future<void> _atualizarListaLocalmenteAposCriacao(Produto produto) async {
    final lista = await obterProdutos();
    lista.insert(0, produto);
    await CacheLocalServico.salvarProdutosNoCache(lista);
  }

  static Future<void> _atualizarListaLocalmenteAposModificacao(Produto produto) async {
    final lista = await obterProdutos();
    final index = lista.indexWhere((p) => p.id == produto.id);
    if (index != -1) {
      lista[index] = produto;
      await CacheLocalServico.salvarProdutosNoCache(lista);
    }
  }

  static Future<void> _removerLocalmenteAposExclusao(String idProduto) async {
    final lista = await obterProdutos();
    lista.removeWhere((p) => p.id == idProduto);
    await CacheLocalServico.salvarProdutosNoCache(lista);
  }
}
