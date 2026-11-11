import 'produto.dart';

class PerifericoGamer extends Produto {
  final String tipoConexao;
  final bool iluminacaoRgb;
  final int dpiOuFrequencia;
  final String subcategoria;

  const PerifericoGamer({
    required super.id,
    required super.nome,
    required super.marca,
    required super.preco,
    required super.imagemUrl,
    required super.descricao,
    required super.quantidadeEstoque,
    super.avaliacao = 5.0,
    super.emDestaque = false,
    super.categoria = CategoriaProduto.periferico,
    required this.tipoConexao,
    required this.iluminacaoRgb,
    required this.dpiOuFrequencia,
    required this.subcategoria,
  });

  @override
  String obterDescricaoTecnica() {
    return 'Tipo: $subcategoria\nConexão: $tipoConexao\nRGB Chroma: ${iluminacaoRgb ? "Sim" : "Não"}\nDPI/Frequência: $dpiOuFrequencia';
  }

  @override
  double calcularDescontoPix() {
    return preco * 0.90;
  }

  @override
  String obterResumoEspecificacoes() {
    return '$subcategoria | $tipoConexao | ${iluminacaoRgb ? "RGB" : "Sem RGB"}';
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
      'categoria': categoria.name,
      'tipo_categoria': 'periferico',
      'tipoConexao': tipoConexao,
      'iluminacaoRgb': iluminacaoRgb,
      'dpiOuFrequencia': dpiOuFrequencia,
      'subcategoria': subcategoria,
    };
  }

  factory PerifericoGamer.fromJson(Map<String, dynamic> json) {
    return PerifericoGamer(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? json['title'] ?? 'Periférico Pro',
      marca: json['marca'] ?? 'Razer / Logitech',
      preco: (json['preco'] as num?)?.toDouble() ?? 399.90,
      imagemUrl: json['imagemUrl'] ?? 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500',
      descricao: json['descricao'] ?? json['body'] ?? 'Periférico gamer com alta precisão e ergonomia.',
      quantidadeEstoque: json['quantidadeEstoque'] ?? 12,
      avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 4.8,
      emDestaque: json['emDestaque'] ?? false,
      categoria: CategoriaProduto.periferico,
      tipoConexao: json['tipoConexao'] ?? 'Wireless / USB-C',
      iluminacaoRgb: json['iluminacaoRgb'] ?? true,
      dpiOuFrequencia: json['dpiOuFrequencia'] ?? 20000,
      subcategoria: json['subcategoria'] ?? 'Mouse Gamer',
    );
  }
}