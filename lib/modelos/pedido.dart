import 'item_carrinho.dart';
import 'endereco_cep.dart';

/// Enumeração de status do pedido na GameLuX Store.
enum StatusPedido {
  aguardandoPagamento,
  aprovado,
  emSeparacao,
  enviado,
  entregue,
}

/// Representa um pedido finalizado pelo usuário.
class Pedido {
  final String id;
  final List<ItemCarrinho> itens;
  final double valorProdutos;
  final double valorFrete;
  final double valorTotal;
  final String formaPagamento;
  final StatusPedido status;
  final DateTime dataPedido;
  final EnderecoCep? enderecoEntrega;

  Pedido({
    required this.id,
    required this.itens,
    required this.valorProdutos,
    required this.valorFrete,
    required this.valorTotal,
    required this.formaPagamento,
    this.status = StatusPedido.aprovado,
    required this.dataPedido,
    this.enderecoEntrega,
  });

  String get statusFormatado {
    switch (status) {
      case StatusPedido.aguardandoPagamento:
        return 'Aguardando Pagamento';
      case StatusPedido.aprovado:
        return 'Pagamento Confirmado';
      case StatusPedido.emSeparacao:
        return 'Separando no Estoque';
      case StatusPedido.enviado:
        return 'Em Rota de Entrega';
      case StatusPedido.entregue:
        return 'Entregue';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itens': itens.map((item) => item.toJson()).toList(),
      'valorProdutos': valorProdutos,
      'valorFrete': valorFrete,
      'valorTotal': valorTotal,
      'formaPagamento': formaPagamento,
      'status': status.name,
      'dataPedido': dataPedido.toIso8601String(),
      'enderecoEntrega': enderecoEntrega?.toJson(),
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] ?? '',
      itens: (json['itens'] as List? ?? [])
          .map((itemJson) => ItemCarrinho.fromJson(itemJson))
          .toList(),
      valorProdutos: (json['valorProdutos'] as num?)?.toDouble() ?? 0.0,
      valorFrete: (json['valorFrete'] as num?)?.toDouble() ?? 0.0,
      valorTotal: (json['valorTotal'] as num?)?.toDouble() ?? 0.0,
      formaPagamento: json['formaPagamento'] ?? 'PIX',
      status: StatusPedido.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StatusPedido.aprovado,
      ),
      dataPedido: DateTime.tryParse(json['dataPedido'] ?? '') ?? DateTime.now(),
      enderecoEntrega: json['enderecoEntrega'] != null
          ? EnderecoCep.fromJson(json['enderecoEntrega'])
          : null,
    );
  }
}
