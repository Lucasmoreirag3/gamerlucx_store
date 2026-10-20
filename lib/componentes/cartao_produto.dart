import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/produto.dart';
import '../utilitarios/formatadores.dart';
import '../servicos/cache_local_servico.dart';

/// Critério 11 (Desejável): Otimizando código através de componentização.
/// Card gamer modular para exibição de produtos no catálogo com suporte a favoritos no cache local.
class CartaoProduto extends StatefulWidget {
  final Produto produto;
  final VoidCallback aoClicar;
  final VoidCallback aoAdicionarCarrinho;

  const CartaoProduto({
    super.key,
    required this.produto,
    required this.aoClicar,
    required this.aoAdicionarCarrinho,
  });

  @override
  State<CartaoProduto> createState() => _CartaoProdutoState();
}

class _CartaoProdutoState extends State<CartaoProduto> {
  bool _favorito = false;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
  }

  Future<void> _verificarFavorito() async {
    final status = await CacheLocalServico.isFavorito(widget.produto.id);
    if (mounted) {
      setState(() {
        _favorito = status;
      });
    }
  }

  Future<void> _alternarFavorito() async {
    await CacheLocalServico.alternarFavorito(widget.produto.id);
    if (mounted) {
      setState(() {
        _favorito = !_favorito;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _favorito
                ? '${widget.produto.nome} adicionado aos favoritos!'
                : '${widget.produto.nome} removido dos favoritos.',
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: CoresApp.superficieCardElevada,
        ),
      );
    }
  }

  Widget _construirImagemProduto() {
    final url = widget.produto.imagemUrl;
    Widget imagemWidget;

    if (url.startsWith('assets/')) {
      imagemWidget = Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: CoresApp.superficieCardElevada,
          child: const Icon(Icons.sports_esports, color: CoresApp.roxoNeon, size: 50),
        ),
      );
    } else if (url.startsWith('http')) {
      imagemWidget = Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: CoresApp.superficieCardElevada,
          child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
        ),
      );
    } else {
      imagemWidget = Container(
        color: CoresApp.superficieCardElevada,
        child: const Icon(Icons.sports_esports, color: CoresApp.cianoEletrico, size: 50),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: AspectRatio(
        aspectRatio: 16 / 11,
        child: Hero(
          tag: 'produto_${widget.produto.id}',
          child: imagemWidget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produto = widget.produto;

    return Container(
      decoration: BoxDecoration(
        color: CoresApp.superficieCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: produto.emDestaque
              ? CoresApp.roxoNeon.withOpacity(0.5)
              : CoresApp.bordaCard,
          width: produto.emDestaque ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: produto.emDestaque
                ? CoresApp.roxoNeon.withOpacity(0.12)
                : Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.aoClicar,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem e Badges
              Stack(
                children: [
                  _construirImagemProduto(),
                  // Badge Categoria
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: CoresApp.cianoEletrico, width: 0.8),
                      ),
                      child: Text(
                        produto.nomeCategoriaEmPortugues,
                        style: const TextStyle(
                          color: CoresApp.cianoEletrico,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Botão de Favorito no Cache
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.black.withOpacity(0.65),
                      child: IconButton(
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          _favorito ? Icons.favorite : Icons.favorite_border,
                          color: _favorito ? Colors.redAccent : Colors.white70,
                        ),
                        onPressed: _alternarFavorito,
                      ),
                    ),
                  ),
                ],
              ),

              // Conteúdo textual e especificações
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avaliação e Marca
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                produto.marca.toUpperCase(),
                                style: const TextStyle(
                                  color: CoresApp.textoApagado,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 3),
                                  Text(
                                    produto.avaliacao.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // Nome do Produto
                          Text(
                            produto.nome,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CoresApp.textoPrincipal,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Resumo de Especificações (Polimórfico - Critério 11)
                          Text(
                            produto.obterResumoEspecificacoes(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CoresApp.cianoEletrico,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Preço e Botão de Adicionar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Preço normal e parcelamento
                          Text(
                            produto.preco.paraReal(),
                            style: const TextStyle(
                              color: CoresApp.textoSecundario,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          // Preço com Desconto no PIX (Polimórfico)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                produto.calcularDescontoPix().paraReal(),
                                style: const TextStyle(
                                  color: CoresApp.verdeSucesso,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'no PIX',
                                style: TextStyle(
                                  color: CoresApp.verdeSucesso,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Botão Comprar / Adicionar
                          SizedBox(
                            width: double.infinity,
                            height: 36,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CoresApp.roxoEscuro,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: produto.temEstoque ? widget.aoAdicionarCarrinho : null,
                              icon: const Icon(Icons.add_shopping_cart, size: 16),
                              label: Text(
                                produto.temEstoque ? 'Comprar' : 'Esgotado',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
