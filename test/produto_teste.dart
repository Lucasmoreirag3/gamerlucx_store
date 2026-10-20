import 'package:flutter_test/flutter_test.dart';
import 'package:gamelucx_store/modelos/produto.dart';
import 'package:gamelucx_store/modelos/computador_gamer.dart';
import 'package:gamelucx_store/modelos/periferico_gamer.dart';
import 'package:gamelucx_store/modelos/console_gamer.dart';
import 'package:gamelucx_store/utilitarios/formatadores.dart';

void main() {
  group('Testes Unitários de POO e Polimorfismo (Critério 11)', () {
    test('ComputadorGamer deve calcular 12% de desconto no PIX', () {
      const pc = ComputadorGamer(
        id: 'pc_teste',
        nome: 'PC Teste RTX',
        marca: 'GameLuX',
        preco: 10000.0,
        imagemUrl: 'assets/imagens/pc_gamer_nexus.jpg',
        descricao: 'PC para testes unitários',
        quantidadeEstoque: 5,
        processador: 'Intel Core i9',
        placaDeVideo: 'RTX 4080',
        memoriaRamGb: 32,
        armazenamentoSsdGb: 1000,
        fonteWatts: 850,
      );

      expect(pc.calcularDescontoPix(), equals(8800.0));
      expect(pc.obterDescricaoTecnica().contains('Intel Core i9'), isTrue);
      expect(pc.categoria, equals(CategoriaProduto.computador));
    });

    test('PerifericoGamer deve calcular 10% de desconto no PIX', () {
      const periferico = PerifericoGamer(
        id: 'perif_teste',
        nome: 'Teclado Teste',
        marca: 'GameLuX Gear',
        preco: 500.0,
        imagemUrl: 'assets/imagens/teclado_mouse.jpg',
        descricao: 'Teclado para testes',
        quantidadeEstoque: 10,
        tipoPeriferico: 'Teclado Mecânico',
        conexao: 'USB-C',
        especificacaoChave: 'Switch Red',
      );

      expect(periferico.calcularDescontoPix(), equals(450.0));
      expect(periferico.obterDescricaoTecnica().contains('Switch Red'), isTrue);
      expect(periferico.categoria, equals(CategoriaProduto.periferico));
    });

    test('ConsoleGamer deve calcular 8% de desconto no PIX', () {
      const console = ConsoleGamer(
        id: 'console_teste',
        nome: 'Console Teste',
        marca: 'Sony',
        preco: 4000.0,
        imagemUrl: 'assets/imagens/console_aether.jpg',
        descricao: 'Console para testes',
        quantidadeEstoque: 3,
        fabricante: 'Sony',
        armazenamentoGb: 1000,
        edicao: 'Slim',
      );

      expect(console.calcularDescontoPix(), equals(3680.0));
      expect(console.categoria, equals(CategoriaProduto.console));
    });

    test('Factory Constructor Produto.fromJson deve instanciar a subclasse correta', () {
      final jsonPc = {
        'id': 'pc_json',
        'nome': 'PC JSON',
        'marca': 'GameLuX',
        'preco': 8000.0,
        'tipo_categoria': 'computador',
        'processador': 'Ryzen 7',
        'placaDeVideo': 'RTX 4070',
        'memoriaRamGb': 32,
        'armazenamentoSsdGb': 1000,
        'fonteWatts': 750,
      };

      final produtoInstanciado = Produto.fromJson(jsonPc);
      expect(produtoInstanciado is ComputadorGamer, isTrue);
      expect((produtoInstanciado as ComputadorGamer).processador, equals('Ryzen 7'));
    });
  });

  group('Testes de Utilitários e Extensions (Critério 6)', () {
    test('Extensão paraReal deve formatar double em formato monetário', () {
      const preco = 4890.50;
      final formatado = preco.paraReal();
      expect(formatado.contains('R\$'), isTrue);
    });
  });
}
