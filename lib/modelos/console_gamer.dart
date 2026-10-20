import 'produto.dart';

/// Critério 11 (Crítico): Subclasse concreta para Videogames e Consoles.
class ConsoleGamer extends Produto {
  final String fabricante;
  final int armazenamentoGb;
  final String edicao;
  final int quantidadeControles;

  const ConsoleGamer({
    required super.id,
    required super.nome,
    required super.marca,
    required super.preco,
    required super.imagemUrl,
    required super.descricao,
    required super.quantidadeEstoque,
    super.avaliacao,
    super.emDestaque,
    required this.fabricante,
    required this.armazenamentoGb,
    required this.edicao,
    this.quantidadeControles = 1,
  }) : super(categoria: CategoriaProduto.console);

  @override
  String obterDescricaoTecnica() {
    final armazenamentoTexto = armazenamentoGb >= 1000
        ? '${armazenamentoGb ~/ 1000}TB SSD Ultra-Rápido'
        : '${armazenamentoGb}GB';

    return '''
• Fabricante Oficial: $fabricante
• Edição: $edicao
• Armazenamento Interno: $armazenamentoTexto
• Controles Inclusos: $quantidadeControles Controle(s) Sem Fio com Resposta Háptica
• Resolução: Suporte a 4K HDR a até 120 FPS / Ray Tracing nativo
• Áudio: Áudio 3D Espacial imersivo
• Garantia: 12 meses oficial com nota fiscal
''';
  }

  @override
  double calcularDescontoPix() {
    // Consoles contam com 8% de desconto no Pix à vista
    return preco * 0.92;
  }

  @override
  String obterResumoEspecificacoes() {
    final arm = armazenamentoGb >= 1000 ? '${armazenamentoGb ~/ 1000}TB SSD' : '${armazenamentoGb}GB';
    return '$fabricante | $edicao | $arm';
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
      'tipo_categoria': 'console',
      'fabricante': fabricante,
      'armazenamentoGb': armazenamentoGb,
      'edicao': edicao,
      'quantidadeControles': quantidadeControles,
    };
  }

  factory ConsoleGamer.fromJson(Map<String, dynamic> json) {
    return ConsoleGamer(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      marca: json['marca'] ?? '',
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      imagemUrl: json['imagemUrl'] ?? '',
      descricao: json['descricao'] ?? '',
      quantidadeEstoque: (json['quantidadeEstoque'] as num?)?.toInt() ?? 0,
      avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 5.0,
      emDestaque: json['emDestaque'] == true,
      fabricante: json['fabricante'] ?? 'Fabricante',
      armazenamentoGb: (json['armazenamentoGb'] as num?)?.toInt() ?? 1000,
      edicao: json['edicao'] ?? 'Padrão',
      quantidadeControles: (json['quantidadeControles'] as num?)?.toInt() ?? 1,
    );
  }
}
