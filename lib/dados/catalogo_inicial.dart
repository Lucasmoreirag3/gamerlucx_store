import '../modelos/produto.dart';
import '../modelos/computador_gamer.dart';
import '../modelos/periferico_gamer.dart';
import '../modelos/console_gamer.dart';

/// Catálogo inicial com produtos gamers de alta tecnologia.
/// Serve como semente (seed) do banco de dados local e fallback offline imediato.
class CatalogoInicial {
  static List<Produto> obterProdutosIniciais() {
    return [
      // 1. Computadores Gamers
      const ComputadorGamer(
        id: 'pc_01',
        nome: 'PC Gamer GameLuX Orion Supreme',
        marca: 'GameLuX Custom Rig',
        preco: 14890.00,
        imagemUrl: 'assets/imagens/pc_gamer_nexus.jpg',
        descricao:
            'A máquina definitiva para jogos em 4K no ultra e produtividade pesada. Equipado com refrigeração líquida personalizada, gabinete aquário panorâmico e iluminação ARGB sincronizada.',
        quantidadeEstoque: 5,
        avaliacao: 5.0,
        emDestaque: true,
        processador: 'Intel Core i9 14900KF (24 Cores / 32 Threads)',
        placaDeVideo: 'NVIDIA GeForce RTX 4080 Super 16GB GDDR6X',
        memoriaRamGb: 64,
        armazenamentoSsdGb: 2000,
        fonteWatts: 1000,
        refrigeracaoLiquida: true,
      ),
      const ComputadorGamer(
        id: 'pc_02',
        nome: 'PC Gamer GameLuX Nebula AMD Edition',
        marca: 'GameLuX Custom Rig',
        preco: 9450.00,
        imagemUrl: 'assets/imagens/pc_gamer_nexus.jpg',
        descricao:
            'Equilíbrio supremo para jogos competitivos com alta taxa de quadros e renderização 3D. Processador campeão de eficiência com tecnologia 3D V-Cache.',
        quantidadeEstoque: 8,
        avaliacao: 4.9,
        emDestaque: true,
        processador: 'AMD Ryzen 7 7800X3D (Melhor CPU Gamer)',
        placaDeVideo: 'AMD Radeon RX 7800 XT 16GB',
        memoriaRamGb: 32,
        armazenamentoSsdGb: 1000,
        fonteWatts: 850,
        refrigeracaoLiquida: true,
      ),
      const ComputadorGamer(
        id: 'pc_03',
        nome: 'PC Gamer GameLuX Apex Start',
        marca: 'GameLuX Entry Line',
        preco: 4799.00,
        imagemUrl: 'assets/imagens/pc_gamer_nexus.jpg',
        descricao:
            'Entrada triunfal no mundo dos jogos para rodar GTA V, CS2, Valorant, Warzone e Fortnite com altíssima taxa de quadros em 1080p.',
        quantidadeEstoque: 12,
        avaliacao: 4.8,
        emDestaque: false,
        processador: 'AMD Ryzen 5 5600 6-Core',
        placaDeVideo: 'NVIDIA GeForce RTX 4060 8GB GDDR6',
        memoriaRamGb: 16,
        armazenamentoSsdGb: 1000,
        fonteWatts: 650,
        refrigeracaoLiquida: false,
      ),

      // 2. Periféricos Gamers
      const PerifericoGamer(
        id: 'perif_01',
        nome: 'Kit Pro GameLuX Phantom: Teclado Mecânico + Mouse 26K',
        marca: 'GameLuX Gear',
        preco: 589.90,
        imagemUrl: 'assets/imagens/teclado_mouse.jpg',
        descricao:
            'Combo completo gamer profissional sem fio com latência ultrabaixa de 1ms, iluminação RGB sob as teclas e cabo paracord de brinde.',
        quantidadeEstoque: 25,
        avaliacao: 5.0,
        emDestaque: true,
        tipoPeriferico: 'Combo Teclado & Mouse',
        conexao: 'Sem Fio 2.4GHz + Bluetooth 5.2 + USB-C',
        especificacaoChave: 'Sensor PixArt 3395 26.000 DPI + Switches Red Lubrificados',
        iluminacaoRgb: true,
      ),
      const PerifericoGamer(
        id: 'perif_02',
        nome: 'Teclado Mecânico Gamer Eclipse 75% Custom',
        marca: 'GameLuX Gear',
        preco: 429.00,
        imagemUrl: 'assets/imagens/teclado_mouse.jpg',
        descricao:
            'Layout compacto de 75% com Knob de volume giratório em alumínio, isolamento acústico em silicone foam e teclas PBT double-shot resistentes a desgaste.',
        quantidadeEstoque: 18,
        avaliacao: 4.9,
        emDestaque: false,
        tipoPeriferico: 'Teclado Mecânico',
        conexao: 'USB-C Trançado Destacável',
        especificacaoChave: 'Switches Gateron Pro Yellow Hot-Swappable',
        iluminacaoRgb: true,
      ),
      const PerifericoGamer(
        id: 'perif_03',
        nome: 'Headset Gamer Sem Fio Vortex 7.1 Espacial',
        marca: 'GameLuX Gear',
        preco: 499.00,
        imagemUrl: 'assets/imagens/banner_promocao.jpg',
        descricao:
            'Imersão acústica total para localizar passos dos adversários. Drivers de 50mm em titânio e microfone retrátil com inteligência artificial para cancelamento de ruído.',
        quantidadeEstoque: 14,
        avaliacao: 4.8,
        emDestaque: false,
        tipoPeriferico: 'Headset 7.1 Surround',
        conexao: 'Wireless 2.4GHz + P3 3.5mm',
        especificacaoChave: 'Bateria para até 48 horas de jogo contínuo',
        iluminacaoRgb: true,
      ),

      // 3. Videogames & Consoles
      const ConsoleGamer(
        id: 'cons_01',
        nome: 'Console Aether-X Gamer Cyber Edition 1TB',
        marca: 'Aether Gaming',
        preco: 4399.00,
        imagemUrl: 'assets/imagens/console_aether.jpg',
        descricao:
            'A evolução dos consoles de mesa com processador gráfico híbrido de 12 Teraflops, suporte a taxa de atualização de até 144Hz e controle pro customizado.',
        quantidadeEstoque: 7,
        avaliacao: 5.0,
        emDestaque: true,
        fabricante: 'Aether Technologies',
        armazenamentoGb: 1000,
        edicao: 'Cyber Glow Limited Edition',
        quantidadeControles: 2,
      ),
      const ConsoleGamer(
        id: 'cons_02',
        nome: 'PlayStation 5 Slim 1TB + 2 Controles DualSense',
        marca: 'Sony Interactive',
        preco: 3899.00,
        imagemUrl: 'assets/imagens/console_aether.jpg',
        descricao:
            'Design renovado mais leve e elegante com 1TB de armazenamento interno SSD de altíssima velocidade. Sinta a imersão com gatilhos adaptáveis.',
        quantidadeEstoque: 9,
        avaliacao: 4.9,
        emDestaque: true,
        fabricante: 'Sony',
        armazenamentoGb: 1000,
        edicao: 'Slim Branco & Preto',
        quantidadeControles: 2,
      ),
      const ConsoleGamer(
        id: 'cons_03',
        nome: 'Nintendo Switch OLED 64GB Special Edition',
        marca: 'Nintendo',
        preco: 2199.00,
        imagemUrl: 'assets/imagens/console_aether.jpg',
        descricao:
            'Tela OLED vibrante de 7 polegadas com cores vívidas e contraste nítido para jogar onde e quando você quiser.',
        quantidadeEstoque: 11,
        avaliacao: 4.7,
        emDestaque: false,
        fabricante: 'Nintendo',
        armazenamentoGb: 64,
        edicao: 'OLED White Edition',
        quantidadeControles: 2,
      ),
    ];
  }
}
