import 'computador_gamer.dart';
import 'periferico_gamer.dart';
import 'console_gamer.dart';

/// Enumeração para as categorias suportadas na GameLuX Store.
enum CategoriaProduto {
  computador,
  periferico,
  console,
}

/// Critério 11 (Crítico): Programação Orientada a Objetos com Classes e Subclasses.
/// Classe abstrata base que define o contrato e atributos comuns a todos os produtos da loja.
abstract class Produto {
  final String id;
  final String nome;
  final String marca;
  final double preco;
  final String imagemUrl;
  final String descricao;
  final int quantidadeEstoque;
  final double avaliacao;
  final bool emDestaque;
  final CategoriaProduto categoria;

  const Produto({
    required this.id,
    required this.nome,
    required this.marca,
    required this.preco,
    required this.imagemUrl,
    required this.descricao,
    required this.quantidadeEstoque,
    required this.categoria,
    this.avaliacao = 5.0,
    this.emDestaque = false,
  });

  /// Método polimórfico: cada subclasse implementa a formatação das suas especificações técnicas
  String obterDescricaoTecnica();

  /// Método polimórfico: calcula o valor com desconto especial para pagamento à vista no PIX
  double calcularDescontoPix();

  /// Método polimórfico: retorna uma linha resumida com os pontos fortes do item
  String obterResumoEspecificacoes();

  /// Converte o objeto para formato JSON para envio e persistência RESTful
  Map<String, dynamic> toJson();

  /// Construtor Factory do Dart: Instancia dinamicamente a subclasse correta de acordo com a categoria
  factory Produto.fromJson(Map<String, dynamic> json) {
    final tipo = json['tipo_categoria'] ?? json['categoria'] ?? 'periferico';

    if (tipo == 'computador' || tipo == CategoriaProduto.computador.name) {
      return ComputadorGamer.fromJson(json);
    } else if (tipo == 'console' || tipo == CategoriaProduto.console.name) {
      return ConsoleGamer.fromJson(json);
    } else {
      return PerifericoGamer.fromJson(json);
    }
  }

  /// Retorna o nome da categoria em português amigável
  String get nomeCategoriaEmPortugues {
    switch (categoria) {
      case CategoriaProduto.computador:
        return 'PC Gamer';
      case CategoriaProduto.periferico:
        return 'Periférico';
      case CategoriaProduto.console:
        return 'Console / Videogame';
    }
  }

  /// Verifica se há produto disponível para pronta entrega
  bool get temEstoque => quantidadeEstoque > 0;
}
