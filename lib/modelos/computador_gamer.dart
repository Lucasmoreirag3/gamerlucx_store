import 'produto.dart';

/// Critério 11 (Crítico): Subclasse concreta representando Computadores Gamers completos.
/// Herda de Produto e implementa regras de negócio específicas para hardware de alto desempenho.
class ComputadorGamer extends Produto {
  final String processador;
  final String placaDeVideo;
  final int memoriaRamGb;
  final int armazenamentoSsdGb;
  final int fonteWatts;
  final bool refrigeracaoLiquida;

  const ComputadorGamer({
    required super.id,
    required super.nome,
    required super.marca,
    required super.preco,
    required super.imagemUrl,
    required super.descricao,
    required super.quantidadeEstoque,
    super.avaliacao,
    super.emDestaque,
    required this.processador,
    required this.placaDeVideo,
    required this.memoriaRamGb,
    required this.armazenamentoSsdGb,
    required this.fonteWatts,
    this.refrigeracaoLiquida = true,
  }) : super(categoria: CategoriaProduto.computador);

  @override
  String obterDescricaoTecnica() {
    final tipoCooler = refrigeracaoLiquida ? 'Water Cooler 360mm RGB' : 'Air Cooler Gamer';
    return '''
• Processador: $processador
• Placa de Vídeo: $placaDeVideo
• Memória RAM: ${memoriaRamGb}GB DDR5 RGB
• Armazenamento: ${armazenamentoSsdGb >= 1000 ? '${armazenamentoSsdGb ~/ 1000}TB' : '${armazenamentoSsdGb}GB'} SSD NVMe M.2
• Fonte: ${fonteWatts}W 80 Plus Gold Modular
• Refrigeração: $tipoCooler
• Gabinete: Aquário Gamer com Vidro Temperado e Fans ARGB
• Sistema: Windows 11 Pro Otimizado para Jogos
''';
  }

  @override
  double calcularDescontoPix() {
    // Computadores na GameLuX contam com 12% de desconto especial no pagamento via Pix
    return preco * 0.88;
  }

  @override
  String obterResumoEspecificacoes() {
    return '$processador | $placaDeVideo | ${memoriaRamGb}GB RAM';
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
      'tipo_categoria': 'computador',
      'processador': processador,
      'placaDeVideo': placaDeVideo,
      'memoriaRamGb': memoriaRamGb,
      'armazenamentoSsdGb': armazenamentoSsdGb,
      'fonteWatts': fonteWatts,
      'refrigeracaoLiquida': refrigeracaoLiquida,
    };
  }

  factory ComputadorGamer.fromJson(Map<String, dynamic> json) {
    return ComputadorGamer(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      marca: json['marca'] ?? '',
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      imagemUrl: json['imagemUrl'] ?? '',
      descricao: json['descricao'] ?? '',
      quantidadeEstoque: (json['quantidadeEstoque'] as num?)?.toInt() ?? 0,
      avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 5.0,
      emDestaque: json['emDestaque'] == true,
      processador: json['processador'] ?? 'Intel Core i7',
      placaDeVideo: json['placaDeVideo'] ?? 'GeForce RTX',
      memoriaRamGb: (json['memoriaRamGb'] as num?)?.toInt() ?? 16,
      armazenamentoSsdGb: (json['armazenamentoSsdGb'] as num?)?.toInt() ?? 1000,
      fonteWatts: (json['fonteWatts'] as num?)?.toInt() ?? 750,
      refrigeracaoLiquida: json['refrigeracaoLiquida'] ?? true,
    );
  }
}
