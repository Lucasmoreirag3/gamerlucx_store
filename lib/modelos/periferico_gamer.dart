import 'produto.dart';

/// Critério 11 (Crítico): Subclasse concreta para Periféricos Gamers (Teclados, Mouses, Headsets, Monitores).
class PerifericoGamer extends Produto {
  final String tipoPeriferico;
  final String conexao;
  final String especificacaoChave;
  final bool iluminacaoRgb;

  const PerifericoGamer({
    required super.id,
    required super.nome,
    required super.marca,
    required super.preco,
    required super.imagemUrl,
    required super.descricao,
    required super.quantidadeEstoque,
    super.avaliacao,
    super.emDestaque,
    required this.tipoPeriferico,
    required this.conexao,
    required this.especificacaoChave,
    this.iluminacaoRgb = true,
  }) : super(categoria: CategoriaProduto.periferico);

  @override
  String obterDescricaoTecnica() {
    final rgbTexto = iluminacaoRgb ? 'RGB Chroma Personalizável via Software' : 'Sem iluminação RGB';
    return '''
• Tipo de Dispositivo: $tipoPeriferico
• Destaque Técnico: $especificacaoChave
• Conexão: $conexao
• Iluminação: $rgbTexto
• Construção: Materiais premium com alta durabilidade (ultra-resistente)
• Compatibilidade: PC, Mac, PlayStation e Xbox
''';
  }

  @override
  double calcularDescontoPix() {
    // Periféricos contam com 10% de desconto no Pix à vista
    return preco * 0.90;
  }

  @override
  String obterResumoEspecificacoes() {
    return '$tipoPeriferico | $conexao | $especificacaoChave';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'marca': marca,
      'preco': preco,
      'imagemUrl': imagemUrl,
      'descricao': descricao,
      'quantidadeEstoque': quantidadeEstoque,
      'avaliacao': avaliacao,
      'emDestaque': emDestaque,
      'tipo_categoria': 'periferico',
      'tipoPeriferico': tipoPeriferico,
      'conexao': conexao,
      'especificacaoChave': especificacaoChave,
      'iluminacaoRgb': iluminacaoRgb,
    };
  }

  factory PerifericoGamer.fromJson(Map<String, dynamic> json) {
    return PerifericoGamer(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      marca: json['marca'] ?? '',
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      imagemUrl: json['imagemUrl'] ?? '',
      descricao: json['descricao'] ?? '',
      quantidadeEstoque: (json['quantidadeEstoque'] as num?)?.toInt() ?? 0,
      avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 5.0,
      emDestaque: json['emDestaque'] == true,
      tipoPeriferico: json['tipoPeriferico'] ?? 'Periférico',
      conexao: json['conexao'] ?? 'USB',
      especificacaoChave: json['especificacaoChave'] ?? 'Alta Precisão',
      iluminacaoRgb: json['iluminacaoRgb'] ?? true,
    );
  }
}
