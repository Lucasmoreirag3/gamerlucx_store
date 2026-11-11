import 'produto.dart';

class ComputadorGamer extends Produto {
  final String processador;
  final String placaDeVideo;
  final int memoriaRamGb;
  final String armazenamento;
  final String fonteAlimentacao;
  final bool possuiWaterCooler;

  const ComputadorGamer({
    required super.id,
    required super.nome,
    required super.marca,
    required super.preco,
    required super.imagemUrl,
    required super.descricao,
    required super.quantidadeEstoque,
    super.avaliacao = 5.0,
    super.emDestaque = false,
    super.categoria = CategoriaProduto.computador,
    required this.processador,
    required this.placaDeVideo,
    required this.memoriaRamGb,
    required this.armazenamento,
    required this.fonteAlimentacao,
    required this.possuiWaterCooler,
  });

  @override
  String obterDescricaoTecnica() {
    return 'Processador: $processador\nPlaca de Vídeo: $placaDeVideo\nMemória: ${memoriaRamGb}GB RAM\nArmazenamento:$armazenamento\nFonte: $fonteAlimentacao\nRefrigeração: ${possuiWaterCooler ? "Water Cooler 240mm" : "Air Cooler"}';
  }

  @override
  double calcularDescontoPix() {
    return preco * 0.88;
  }

  @override
  String obterResumoEspecificacoes() {
    return '$processador \vert{}$placaDeVideo | ${memoriaRamGb}GB \vert{}$armazenamento';
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
      'tipo_categoria': 'computador',
      'processador': processador,
      'placaDeVideo': placaDeVideo,
      'memoriaRamGb': memoriaRamGb,
      'armazenamento': armazenamento,
      'fonteAlimentacao': fonteAlimentacao,
      'possuiWaterCooler': possuiWaterCooler,
    };
  }

  factory ComputadorGamer.fromJson(Map<String, dynamic> json) {
    return ComputadorGamer(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? json['title'] ?? 'PC Gamer',
      marca: json['marca'] ?? 'GameLuX Custom',
      preco: (json['preco'] as num?)?.toDouble() ?? 5999.00,
      imagemUrl: json['imagemUrl'] ?? 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=500',
      descricao: json['descricao'] ?? json['body'] ?? 'PC Gamer de alta performance pronto para jogar.',
      quantidadeEstoque: json['quantidadeEstoque'] ?? 5,
      avaliacao: (json['avaliacao'] as num?)?.toDouble() ?? 5.0,
      emDestaque: json['emDestaque'] ?? true,
      categoria: CategoriaProduto.computador,
      processador: json['processador'] ?? 'Intel Core i7 13700F',
      placaDeVideo: json['placaDeVideo'] ?? 'GeForce RTX 4070 12GB',
      memoriaRamGb: json['memoriaRamGb'] ?? 32,
      armazenamento: json['armazenamento'] ?? '1TB SSD NVMe M.2',
      fonteAlimentacao: json['fonteAlimentacao'] ?? '750W 80 Plus Gold',
      possuiWaterCooler: json['possuiWaterCooler'] ?? true,
    );
  }
}