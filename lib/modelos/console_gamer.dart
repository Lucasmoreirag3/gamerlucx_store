import 'produto.dart';

class ConsoleGamer extends Produto {
  final String plataforma;
  final String capacidadeArmazenamento;
  final int quantidadeControlesInclusos;
  final bool suportaMidiaFisica;

  const ConsoleGamer({
    required super.id,
    required super.nome,
    required super.marca,
    required super.preco,
    required super.imagemUrl,
    required super.descricao,
    required super.quantidadeEstoque,
    super.avaliacao = 5.0,
    super.emDestaque = false,
    super.categoria = CategoriaProduto.console,
    required this.plataforma,
    required this.capacidadeArmazenamento,
    required this.quantidadeControlesInclusos,
    required this.suportaMidiaFisica,
  });

  @override
  String obterDescricaoTecnica() {
    return 'Plataforma: $plataforma\nArmazenamento: $capacidadeArmazenamento\nControles: $quantidadeControlesInclusos\nMídia Física: ${suportaMidiaFisica ? "Sim" : "Apenas Digital"}';
  }

  @override
  double calcularDescontoPix() {
    return preco * 0.92;
  }

  @override
  String obterResumoEspecificacoes() {
    return '$plataforma | $capacidadeArmazenamento | ${suportaMidiaFisica ? "Com Leitor" : "Digital"}';
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
      'tipo_categoria': 'console',
      'plataforma': plataforma,
      'capacidadeArmazenamento': capacidadeArmazenamento,
      'quantidadeControlesInclusos': quantidadeControlesInclusos,
      'suportaMidiaFisica': suportaMidiaFisica,
    };
  }

  factory ConsoleGamer.fromJson(Map<String, dynamic> json) {
    return ConsoleGamer(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? json['title'] ?? 'Console Gamer',
      marca: json['marca'] ?? 'Sony / Microsoft / Nintendo',
      preco: (json['preco'] as num?)?.toDouble() ?? 4299.00,
      imagemUrl: json['imagemUrl'] ?? 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=500',
      descricao: json['descricao'] ?? json['body'] ?? 'Console de última geração com suporte a jogos 4K.',
      quantidadeEstoque: json['quantidadeEstoque'] ?? 8,
      avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 4.9,
      emDestaque: json['emDestaque'] ?? true,
      categoria: CategoriaProduto.console,
      plataforma: json['plataforma'] ?? 'PlayStation 5',
      capacidadeArmazenamento: json['capacidadeArmazenamento'] ?? '1TB SSD',
      quantidadeControlesInclusos: json['quantidadeControlesInclusos'] ?? 1,
      suportaMidiaFisica: json['suportaMidiaFisica'] ?? true,
    );
  }
}