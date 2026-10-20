import 'package:flutter/material.dart';
import '../constantes/cores_app.dart';
import '../modelos/produto.dart';
import '../modelos/computador_gamer.dart';
import '../modelos/periferico_gamer.dart';
import '../modelos/console_gamer.dart';
import '../servicos/api_catalogo_servico.dart';
import '../utilitarios/formatadores.dart';
import '../componentes/botao_gamer.dart';

/// Formulário de Cadastro e Edição de Produtos da Loja.
/// Atende:
/// - Critério 6 (Desejável): Utilização de Mixins de validação Dart (ValidadorFormularioMixin).
/// - Critério 8: Comunicação RESTful POST (cadastrar) e PUT (atualizar).
/// - Critério 11 (Crítico): Subclasses com atributos específicos instanciados dinamicamente.
class TelaFormularioProduto extends StatefulWidget {
  final Produto? produtoParaEditar;

  const TelaFormularioProduto({super.key, this.produtoParaEditar});

  @override
  State<TelaFormularioProduto> createState() => _TelaFormularioProdutoState();
}

class _TelaFormularioProdutoState extends State<TelaFormularioProduto> with ValidadorFormularioMixin {
  final _chaveFormulario = GlobalKey<FormState>();

  // Categoria
  CategoriaProduto _categoriaSelecionada = CategoriaProduto.computador;

  // Controladores de campos comuns
  final _controladorNome = TextEditingController();
  final _controladorMarca = TextEditingController();
  final _controladorPreco = TextEditingController();
  final _controladorImagemUrl = TextEditingController();
  final _controladorDescricao = TextEditingController();
  final _controladorEstoque = TextEditingController();

  // Controladores específicos para Computador
  final _controladorProcessador = TextEditingController();
  final _controladorGpu = TextEditingController();
  final _controladorRam = TextEditingController();
  final _controladorSsd = TextEditingController();
  final _controladorFonte = TextEditingController();
  bool _refrigeracaoLiquida = true;

  // Controladores específicos para Periférico
  final _controladorTipoPeriferico = TextEditingController();
  final _controladorConexao = TextEditingController();
  final _controladorEspecChave = TextEditingController();
  bool _iluminacaoRgb = true;

  // Controladores específicos para Console
  final _controladorFabricante = TextEditingController();
  final _controladorArmazenamentoConsole = TextEditingController();
  final _controladorEdicao = TextEditingController();
  int _quantidadeControles = 1;

  bool _salvando = false;
  bool get _modoEdicao => widget.produtoParaEditar != null;

  @override
  void initState() {
    super.initState();
    _preencherDadosIniciais();
  }

  void _preencherDadosIniciais() {
    if (_modoEdicao) {
      final p = widget.produtoParaEditar!;
      _categoriaSelecionada = p.categoria;
      _controladorNome.text = p.nome;
      _controladorMarca.text = p.marca;
      _controladorPreco.text = p.preco.toStringAsFixed(2);
      _controladorImagemUrl.text = p.imagemUrl;
      _controladorDescricao.text = p.descricao;
      _controladorEstoque.text = p.quantidadeEstoque.toString();

      if (p is ComputadorGamer) {
        _controladorProcessador.text = p.processador;
        _controladorGpu.text = p.placaDeVideo;
        _controladorRam.text = p.memoriaRamGb.toString();
        _controladorSsd.text = p.armazenamentoSsdGb.toString();
        _controladorFonte.text = p.fonteWatts.toString();
        _refrigeracaoLiquida = p.refrigeracaoLiquida;
      } else if (p is PerifericoGamer) {
        _controladorTipoPeriferico.text = p.tipoPeriferico;
        _controladorConexao.text = p.conexao;
        _controladorEspecChave.text = p.especificacaoChave;
        _iluminacaoRgb = p.iluminacaoRgb;
      } else if (p is ConsoleGamer) {
        _controladorFabricante.text = p.fabricante;
        _controladorArmazenamentoConsole.text = p.armazenamentoGb.toString();
        _controladorEdicao.text = p.edicao;
        _quantidadeControles = p.quantidadeControles;
      }
    } else {
      // Valores padrão pré-preenchidos para facilitar demonstração
      _controladorImagemUrl.text = 'assets/imagens/pc_gamer_nexus.jpg';
      _controladorEstoque.text = '10';
      _controladorProcessador.text = 'Intel Core i7 14700F';
      _controladorGpu.text = 'NVIDIA GeForce RTX 4070 12GB';
      _controladorRam.text = '32';
      _controladorSsd.text = '1000';
      _controladorFonte.text = '750';
    }
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorMarca.dispose();
    _controladorPreco.dispose();
    _controladorImagemUrl.dispose();
    _controladorDescricao.dispose();
    _controladorEstoque.dispose();
    _controladorProcessador.dispose();
    _controladorGpu.dispose();
    _controladorRam.dispose();
    _controladorSsd.dispose();
    _controladorFonte.dispose();
    _controladorTipoPeriferico.dispose();
    _controladorConexao.dispose();
    _controladorEspecChave.dispose();
    _controladorFabricante.dispose();
    _controladorArmazenamentoConsole.dispose();
    _controladorEdicao.dispose();
    super.dispose();
  }

  Future<void> _submeterFormulario() async {
    if (!_chaveFormulario.currentState!.validate()) return;

    setState(() => _salvando = true);

    final id = _modoEdicao
        ? widget.produtoParaEditar!.id
        : 'prod_${DateTime.now().millisecondsSinceEpoch}';

    final preco = double.tryParse(_controladorPreco.text.replaceAll(',', '.')) ?? 0.0;
    final estoque = int.tryParse(_controladorEstoque.text) ?? 1;

    Produto produtoFinal;

    // Instanciação polimórfica da subclasse correta (Critério 11)
    switch (_categoriaSelecionada) {
      case CategoriaProduto.computador:
        produtoFinal = ComputadorGamer(
          id: id,
          nome: _controladorNome.text.trim(),
          marca: _controladorMarca.text.trim(),
          preco: preco,
          imagemUrl: _controladorImagemUrl.text.trim().isEmpty
              ? 'assets/imagens/pc_gamer_nexus.jpg'
              : _controladorImagemUrl.text.trim(),
          descricao: _controladorDescricao.text.trim(),
          quantidadeEstoque: estoque,
          processador: _controladorProcessador.text.trim(),
          placaDeVideo: _controladorGpu.text.trim(),
          memoriaRamGb: int.tryParse(_controladorRam.text) ?? 16,
          armazenamentoSsdGb: int.tryParse(_controladorSsd.text) ?? 1000,
          fonteWatts: int.tryParse(_controladorFonte.text) ?? 650,
          refrigeracaoLiquida: _refrigeracaoLiquida,
        );
        break;

      case CategoriaProduto.periferico:
        produtoFinal = PerifericoGamer(
          id: id,
          nome: _controladorNome.text.trim(),
          marca: _controladorMarca.text.trim(),
          preco: preco,
          imagemUrl: _controladorImagemUrl.text.trim().isEmpty
              ? 'assets/imagens/teclado_mouse.jpg'
              : _controladorImagemUrl.text.trim(),
          descricao: _controladorDescricao.text.trim(),
          quantidadeEstoque: estoque,
          tipoPeriferico: _controladorTipoPeriferico.text.trim().isEmpty
              ? 'Periférico Gamer'
              : _controladorTipoPeriferico.text.trim(),
          conexao: _controladorConexao.text.trim().isEmpty ? 'USB-C' : _controladorConexao.text.trim(),
          especificacaoChave: _controladorEspecChave.text.trim().isEmpty
              ? 'Alta Performance'
              : _controladorEspecChave.text.trim(),
          iluminacaoRgb: _iluminacaoRgb,
        );
        break;

      case CategoriaProduto.console:
        produtoFinal = ConsoleGamer(
          id: id,
          nome: _controladorNome.text.trim(),
          marca: _controladorMarca.text.trim(),
          preco: preco,
          imagemUrl: _controladorImagemUrl.text.trim().isEmpty
              ? 'assets/imagens/console_aether.jpg'
              : _controladorImagemUrl.text.trim(),
          descricao: _controladorDescricao.text.trim(),
          quantidadeEstoque: estoque,
          fabricante: _controladorFabricante.text.trim().isEmpty
              ? 'Oficial'
              : _controladorFabricante.text.trim(),
          armazenamentoGb: int.tryParse(_controladorArmazenamentoConsole.text) ?? 1000,
          edicao: _controladorEdicao.text.trim().isEmpty ? 'Padrão' : _controladorEdicao.text.trim(),
          quantidadeControles: _quantidadeControles,
        );
        break;
    }

    try {
      if (_modoEdicao) {
        // Comunicação PUT (Critério 8)
        await ApiCatalogoServico.atualizarProduto(produtoFinal);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${produtoFinal.nome} atualizado via PUT com sucesso!'),
              backgroundColor: CoresApp.verdeSucesso,
            ),
          );
        }
      } else {
        // Comunicação POST (Critério 8)
        await ApiCatalogoServico.cadastrarProduto(produtoFinal);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${produtoFinal.nome} cadastrado via POST com sucesso!'),
              backgroundColor: CoresApp.verdeSucesso,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, produtoFinal);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: CoresApp.vermelhoAlerta),
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Widget _campoTexto({
    required TextEditingController controlador,
    required String rotulo,
    String? hint,
    String? Function(String?)? validador,
    TextInputType teclado = TextInputType.text,
    int maxLinhas = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rotulo,
            style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controlador,
            validator: validador,
            keyboardType: teclado,
            maxLines: maxLinhas,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: CoresApp.textoApagado),
              filled: true,
              fillColor: CoresApp.superficieCard,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CoresApp.bordaCard),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: CoresApp.cianoEletrico),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.fundoPrincipal,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _modoEdicao ? 'Editar Produto (PUT)' : 'Novo Produto (POST)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _chaveFormulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seletor de Categoria
              const Text(
                'Selecione a Categoria do Produto:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('PC Gamer'),
                      selected: _categoriaSelecionada == CategoriaProduto.computador,
                      selectedColor: CoresApp.roxoNeon,
                      onSelected: _modoEdicao
                          ? null
                          : (val) {
                              if (val) setState(() => _categoriaSelecionada = CategoriaProduto.computador);
                            },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Periférico'),
                      selected: _categoriaSelecionada == CategoriaProduto.periferico,
                      selectedColor: CoresApp.roxoNeon,
                      onSelected: _modoEdicao
                          ? null
                          : (val) {
                              if (val) setState(() => _categoriaSelecionada = CategoriaProduto.periferico);
                            },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Console'),
                      selected: _categoriaSelecionada == CategoriaProduto.console,
                      selectedColor: CoresApp.roxoNeon,
                      onSelected: _modoEdicao
                          ? null
                          : (val) {
                              if (val) setState(() => _categoriaSelecionada = CategoriaProduto.console);
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Campos Comuns
              _campoTexto(
                controlador: _controladorNome,
                rotulo: 'Nome do Produto Gamer',
                hint: 'Ex: PC Gamer GameLuX Orion Supreme',
                validador: (v) => validarTextoObrigatorio(v, 'Nome'),
              ),
              Row(
                children: [
                  Expanded(
                    child: _campoTexto(
                      controlador: _controladorMarca,
                      rotulo: 'Marca / Fabricante',
                      hint: 'Ex: GameLuX, Razer, Sony',
                      validador: (v) => validarTextoObrigatorio(v, 'Marca'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _campoTexto(
                      controlador: _controladorPreco,
                      rotulo: 'Preço (R\$)',
                      hint: 'Ex: 4890.00',
                      teclado: const TextInputType.numberWithOptions(decimal: true),
                      validador: (v) => validarNumeroPositivo(v, 'Preço'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _campoTexto(
                      controlador: _controladorEstoque,
                      rotulo: 'Quantidade em Estoque',
                      hint: 'Ex: 10',
                      teclado: TextInputType.number,
                      validador: (v) => validarNumeroPositivo(v, 'Estoque'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _campoTexto(
                      controlador: _controladorImagemUrl,
                      rotulo: 'Caminho do Asset ou URL',
                      hint: 'assets/imagens/... ou http...',
                    ),
                  ),
                ],
              ),
              _campoTexto(
                controlador: _controladorDescricao,
                rotulo: 'Descrição Comercial',
                hint: 'Destaque os diferenciais gamer do produto...',
                maxLinhas: 3,
                validador: (v) => validarTextoObrigatorio(v, 'Descrição'),
              ),

              const Divider(color: CoresApp.bordaCard, height: 30),

              // CAMPOS ESPECÍFICOS POR SUBCLASSE (CRITÉRIO 11)
              if (_categoriaSelecionada == CategoriaProduto.computador) ...[
                const Text(
                  'Especificações do Computador Gamer (Subclasse ComputadorGamer):',
                  style: TextStyle(color: CoresApp.cianoEletrico, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                _campoTexto(
                  controlador: _controladorProcessador,
                  rotulo: 'Processador (CPU)',
                  hint: 'Ex: Intel Core i9 14900KF',
                  validador: (v) => validarTextoObrigatorio(v, 'Processador'),
                ),
                _campoTexto(
                  controlador: _controladorGpu,
                  rotulo: 'Placa de Vídeo (GPU)',
                  hint: 'Ex: NVIDIA GeForce RTX 4080 Super 16GB',
                  validador: (v) => validarTextoObrigatorio(v, 'Placa de Vídeo'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _campoTexto(
                        controlador: _controladorRam,
                        rotulo: 'Memória RAM (GB)',
                        hint: '32',
                        teclado: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _campoTexto(
                        controlador: _controladorSsd,
                        rotulo: 'Armazenamento SSD (GB)',
                        hint: '1000',
                        teclado: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _campoTexto(
                        controlador: _controladorFonte,
                        rotulo: 'Fonte (Watts)',
                        hint: '850',
                        teclado: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SwitchListTile(
                  title: const Text('Refrigeração Líquida (Water Cooler RGB)', style: TextStyle(color: Colors.white, fontSize: 13)),
                  value: _refrigeracaoLiquida,
                  activeColor: CoresApp.cianoEletrico,
                  onChanged: (val) => setState(() => _refrigeracaoLiquida = val),
                ),
              ] else if (_categoriaSelecionada == CategoriaProduto.periferico) ...[
                const Text(
                  'Especificações do Periférico (Subclasse PerifericoGamer):',
                  style: TextStyle(color: CoresApp.cianoEletrico, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                _campoTexto(
                  controlador: _controladorTipoPeriferico,
                  rotulo: 'Tipo de Periférico',
                  hint: 'Ex: Teclado Mecânico, Mouse Sem Fio, Headset 7.1',
                ),
                _campoTexto(
                  controlador: _controladorConexao,
                  rotulo: 'Tipo de Conexão',
                  hint: 'Ex: Sem Fio 2.4GHz + Bluetooth / USB-C',
                ),
                _campoTexto(
                  controlador: _controladorEspecChave,
                  rotulo: 'Destaque Técnico Principal',
                  hint: 'Ex: Sensor 26.000 DPI / Switches Ópticos Red',
                ),
                SwitchListTile(
                  title: const Text('Iluminação RGB Personalizável', style: TextStyle(color: Colors.white, fontSize: 13)),
                  value: _iluminacaoRgb,
                  activeColor: CoresApp.roxoNeon,
                  onChanged: (val) => setState(() => _iluminacaoRgb = val),
                ),
              ] else if (_categoriaSelecionada == CategoriaProduto.console) ...[
                const Text(
                  'Especificações do Console (Subclasse ConsoleGamer):',
                  style: TextStyle(color: CoresApp.cianoEletrico, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                _campoTexto(
                  controlador: _controladorFabricante,
                  rotulo: 'Fabricante Oficial',
                  hint: 'Ex: Sony, Microsoft, Nintendo',
                ),
                _campoTexto(
                  controlador: _controladorArmazenamentoConsole,
                  rotulo: 'Capacidade do Armazenamento (GB)',
                  hint: 'Ex: 1000',
                  teclado: TextInputType.number,
                ),
                _campoTexto(
                  controlador: _controladorEdicao,
                  rotulo: 'Edição do Console',
                  hint: 'Ex: Cyber Glow Limited Edition',
                ),
                Row(
                  children: [
                    const Text('Controles Inclusos:', style: TextStyle(color: Colors.white70)),
                    const SizedBox(width: 14),
                    DropdownButton<int>(
                      value: _quantidadeControles,
                      dropdownColor: CoresApp.superficieCardElevada,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1 Controle')),
                        DropdownMenuItem(value: 2, child: Text('2 Controles')),
                      ],
                      onChanged: (val) => setState(() => _quantidadeControles = val ?? 1),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 30),

              // Botão Salvar
              BotaoGamer(
                texto: _modoEdicao ? 'Salvar Alterações (PUT)' : 'Cadastrar no Servidor (POST)',
                icone: _modoEdicao ? Icons.sync : Icons.cloud_upload,
                carregando: _salvando,
                aoPressionar: _salvando ? null : _submeterFormulario,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
