import 'produto.dart';

/// Representa um item selecionado pelo cliente no carrinho de compras.
class ItemCarrinho {
  final Produto produto;
  int quantidade;

  ItemCarrinho({
    required this.produto,
    this.quantidade = 1,
  });

  double get subtotal => produto.preco * quantidade;
  double get subtotalPix => produto.calcularDescontoPix() * quantidade;

  Map<String, dynamic> toJson() {
    return {
      'produto': produto.toJson(),
      'quantidade': quantidade,
    };
  }

  factory ItemCarrinho.fromJson(Map<String, dynamic> json) {
    return ItemCarrinho(
      produto: Produto.fromJson(json['produto']),
      quantidade: (json['quantidade'] as num?)?.toInt() ?? 1,
    );
  }
}
