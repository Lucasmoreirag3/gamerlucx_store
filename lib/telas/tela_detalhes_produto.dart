import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/produto.dart';
import '../modelos/item_carrinho.dart';
import '../servicos/armazenamento_interno_servico.dart';
import '../utilitarios/formatadores.dart';
import '../componentes/simulador_frete_widget.dart';
import '../componentes/conversor_moeda_widget.dart';
import '../componentes/botao_gamer.dart';
import '../servicos/cache_local_servico.dart';

/// Tela de visualização detalhada com especificações polimórficas (Critério 11),
/// simulador de frete ViaCEP (Critério 8) e cotação AwesomeAPI (Critério 8).
class TelaDetalhesProduto extends StatefulWidget {
  final Produto produto;

  const TelaDetalhesProduto({
    super.key,
    required this.produto,
  });

  @override
  State<TelaDetalhesProduto> createState() => _TelaDetalhesProdutoState();
}

class _TelaDetalhesProdutoState extends State<TelaDetalhesProduto> {
  bool _favorito = false;
  int _quantidade = 1;

  @override
  void initState() {
    super.initState();
    _carregarFavorito();
  }

  Future<void> _carregarFavorito() async {
    final status = await CacheLocalServico.isFavorito(widget.produto.id);
    if (mounted) setState(() => _favorito = status);
  }

  Future<void> _alternarFavorito() async {
    await CacheLocalServico.alternarFavorito(widget.produto.id);
    if (mounted) {
      setState(() => _favorito = !_favorito);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_favorito ? 'Adicionado aos favoritos' : 'Removido dos favoritos'),
          duration: const Duration(seconds: 1),
          backgroundColor: CoresApp.superficieCardElevada,
        ),
      );
    }
  }

  Future<void> _adicionarAoCarrinho({bool irParaCarrinho = false}) async {
    final itensAtuais = await ArmazenamentoInternoServico.obterCarrinho();
    final indexExistente = itensAtuais.indexWhere((i) => i.produto.id == widget.produto.id);

    if (indexExistente != -1) {
      itensAtuais[indexExistente].quantidade += _quantidade;
    } else {
      itensAtuais.add(ItemCarrinho(produto: widget.produto, quantidade: _quantidade));
    }

    await ArmazenamentoInternoServico.salvarCarrinho(itensAtuais);

    if (mounted) {
      if (irParaCarrinho) {
        Navigator.pushNamed(context, '/carrinho');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: CoresApp.verdeSucesso,
            content: Text('${widget.produto.nome} adicionado ao carrinho!'),
            action: SnackBarAction(
              label: 'VER CARRINHO',
              textColor: Colors.white,
              onPressed: () => Navigator.pushNamed(context, '/carrinho'),
            ),
          ),
        );
      }
    }
  }

  Widget _construirImagemHeader() {
    final url = widget.produto.imagemUrl;
    Widget imagem;

    if (url.startsWith('assets/')) {
      imagem = Image.asset(url, fit: BoxFit.cover);
    } else if (url.startsWith('http')) {
      imagem = Image.network(url, fit: BoxFit.cover);
    } else {
      imagem = Container(color: CoresApp.superficieCardElevada);
    }

    return Hero(
      tag: 'produto_${widget.produto.id}',
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: imagem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produto = widget.produto;

    return Scaffold(
      backgroundColor: CoresApp.fundoPrincipal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          produto.nomeCategoriaEmPortugues,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _favorito ? Icons.favorite : Icons.favorite_border,
              color: _favorito ? Colors.redAccent : Colors.white,
            ),
            onPressed: _alternarFavorito,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/carrinho'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem Principal
            _construirImagemHeader(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Marca e Avaliação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: CoresApp.superficieCardElevada,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: CoresApp.cianoEletrico),
                        ),
                        child: Text(
                          produto.marca.toUpperCase(),
                          style: const TextStyle(
                            color: CoresApp.cianoEletrico,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            produto.avaliacao.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${produto.quantidadeEstoque} em estoque)',
                            style: TextStyle(
                              color: produto.temEstoque ? CoresApp.verdeSucesso : CoresApp.vermelhoAlerta,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nome Completo
                  Text(
                    produto.nome,
                    style: const TextStyle(
                      color: CoresApp.textoPrincipal,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Bloco de Preços
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CoresApp.superficieCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: CoresApp.bordaCard),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'De ${produto.preco.paraReal()}',
                          style: const TextStyle(
                            color: CoresApp.textoSecundario,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              produto.calcularDescontoPix().paraReal(),
                              style: const TextStyle(
                                color: CoresApp.verdeSucesso,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'à vista no PIX',
                              style: TextStyle(
                                color: CoresApp.verdeSucesso,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'ou ${produto.preco.emAte12x()}',
                          style: const TextStyle(color: CoresApp.textoSecundario, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cotação Internacional (AwesomeAPI)
                  ConversorMoedaWidget(precoEmReais: produto.preco),
                  const SizedBox(height: 20),

                  // Descrição Geral
                  const Text(
                    'Sobre o Produto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produto.descricao,
                    style: const TextStyle(
                      color: CoresApp.textoSecundario,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Especificações Técnicas Polimórficas (Critério 11)
                  const Text(
                    'Ficha Técnica Oficial',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CoresApp.superficieCardElevada,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CoresApp.roxoNeon.withOpacity(0.3)),
                    ),
                    child: Text(
                      produto.obterDescricaoTecnica().trim(),
                      style: const TextStyle(
                        color: CoresApp.textoPrincipal,
                        fontSize: 13,
                        height: 1.6,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Simulador de Frete ViaCEP (Critério 8)
                  const SimuladorFreteWidget(),
                  const SizedBox(height: 30),

                  // Seletor de Quantidade
                  Row(
                    children: [
                      const Text(
                        'Quantidade:',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        decoration: BoxDecoration(
                          color: CoresApp.superficieCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: CoresApp.bordaCard),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _quantidade > 1 ? () => setState(() => _quantidade--) : null,
                            ),
                            Text(
                              '$_quantidade',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: _quantidade < produto.quantidadeEstoque
                                  ? () => setState(() => _quantidade++)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botões de Ação
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: CoresApp.roxoNeon, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: produto.temEstoque ? () => _adicionarAoCarrinho() : null,
                          child: const Text(
                            'Adicionar ao Carrinho',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BotaoGamer(
                          texto: 'Comprar Agora',
                          icone: Icons.flash_on,
                          aoPressionar: produto.temEstoque ? () => _adicionarAoCarrinho(irParaCarrinho: true) : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
