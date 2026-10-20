# ESCOLA E FACULDADE DE TECNOLOGIA SENAI "ROBERTO MANGE"
## CURSO TÉCNICO EM DESENVOLVIMENTO DE SISTEMAS
### PROGRAMAÇÃO PARA DISPOSITIVOS MÓVEIS (PPDM) - 4º TERMO

---

# RELATÓRIO TÉCNICO DA SITUAÇÃO DE APRENDIZAGEM
## Situação Desafiadora: "Da Tela Ao App Integrado"

- **Estudante / Desenvolvedor:** Lucas Moreira Gomes
- **Usuário GitHub:** `Lucasmoreirag3`
- **Email:** `lucasmoreiragomes2@gmail.com`
- **Agência Digital Simulada:** Digital Horizon
- **Comerciante Escolhido:** GameLuX Store (Comércio de Hardware, PCs Gamer, Periféricos e Consoles)
- **Data:** Outubro de 2026

---

## 1. CONTEXTUALIZAÇÃO E ESCOLHA DO ESTABELECIMENTO

A agência digital **Digital Horizon** lançou a campanha de fortalecimento do comércio local. Fui selecionado como Desenvolvedor Mobile Júnior para idealizar, projetar e implementar uma solução mobile completa para um estabelecimento comercial da cidade.

Escolhi a **GameLuX Store**, uma loja especializada no universo gamer que atende desde jogadores casuais até atletas de e-Sports e criadores de conteúdo que necessitam de computadores de alto rendimento. O objetivo do app é oferecer uma vitrine moderna, interativa e fluida, permitindo aos clientes consultar fichas técnicas avançadas, calcular frete em tempo real, acompanhar a cotação internacional de peças e gerenciar suas compras com total segurança.

---

## 2. DECISÕES DE ARQUITETURA E SEGURANÇA DA INFORMAÇÃO

Conforme exigido nas diretrizes da Situação de Aprendizagem, realizei uma análise criteriosa para segregar as informações públicas das informações sensíveis:

### 2.1 Informações Públicas (Banco de Dados Externo e Serviços RESTful)
- **Catálogo de Produtos:** Títulos, descrições, imagens, preços, categorias e especificações de hardware.
- **Promoções e Banners:** Campanhas sazonais da loja.
- **Tratamento Técnico:** Dados hospedados remotamente e sincronizados via comunicação HTTP RESTful (**GET, POST, PUT, DELETE**). Para garantir resiliência (pensamento analítico), estruturei uma camada de **Cache Local com TTL (Time-To-Live)** que armazena os produtos no dispositivo para carregamento instantâneo e funcionamento offline.

### 2.2 Informações Sensíveis (Armazenamento Interno Protegido)
- **Dados do Cliente:** Nome completo, e-mail, nick gamer, CEP de entrega padrão e saldo de pontos.
- **Carrinho de Compras e Histórico de Pedidos:** Informações privadas de transação do usuário.
- **Tratamento Técnico:** Persistidos exclusivamente na sandbox interna privada do dispositivo através da classe `ArmazenamentoInternoServico`, garantindo que aplicativos de terceiros não tenham acesso a esses dados confidenciais.

---

## 3. COMPROVAÇÃO DETALHADA DOS CRITÉRIOS DE AVALIAÇÃO

### Capacidade Técnica 6: Implementar o código respeitando as características da linguagem na plataforma mobile
- **[Crítico] Implementando estruturas da lógica na linguagem Dart:**
  - Aplicação rigorosa de *Null Safety* (`String?`, `late`, `required`).
  - Utilização de recursos assíncronos (`async`, `await`, `Future`) para consumo de rede não bloqueante.
  - Implementação de *Pattern Matching* e *Switch Expressions* nas regras de status e categorias.
  - Arquivos: `lib/modelos/produto.dart`, `lib/servicos/api_catalogo_servico.dart`.
- **[Desejável] Diferenciando características de outras linguagens:**
  - Uso de **Mixins** (`ValidadorFormularioMixin`) para reutilização de comportamento em formulários sem necessidade de herança múltipla.
  - Uso de **Extension Methods** (`FormatadorPreco` no tipo primitivo `double`), permitindo chamar `.paraReal()` e `.emAte12x()` diretamente sobre valores numéricos.
  - Construtores *Factory* (`Produto.fromJson`) com polimorfismo dinâmico na deserialização.
  - Arquivo: `lib/utilitarios/formatadores.dart`.

---

### Capacidade Técnica 7: Persistir dados em dispositivos móveis
- **[Crítico] Persistindo dados localmente no cache do aplicativo:**
  - A classe `CacheLocalServico` gerencia o cache em memória e em disco (SharedPreferences) com expiração temporal (30 minutos) e controle de produtos favoritos.
  - Arquivo: `lib/servicos/cache_local_servico.dart`.
- **[Crítico] Persistindo dados no armazenamento externo:**
  - A classe `ArmazenamentoExternoServico` utiliza a biblioteca `path_provider` para gravar e ler arquivos no armazenamento acessível do dispositivo:
    1. Exportação do catálogo completo em arquivo físico JSON (`catalogo_produtos_gamelux.json`) para backup.
    2. Importação e restauração do catálogo a partir do arquivo JSON.
    3. Geração de comprovante fiscal e recibo detalhado em arquivo `.txt` (`recibo_pedido_PED-XXXX.txt`) para que o cliente possa guardar ou compartilhar.
  - Arquivo: `lib/servicos/armazenamento_externo_servico.dart`.
- **[Desejável] Persistindo modificações no armazenamento interno:**
  - A classe `ArmazenamentoInternoServico` grava na área privada da aplicação: perfil do usuário, lista de itens do carrinho de compras e o histórico consolidado de pedidos.
  - Arquivo: `lib/servicos/armazenamento_interno_servico.dart`.

---

### Capacidade Técnica 8: Realizar a integração de dispositivos móveis aos serviços web
- **[Crítico] Realizando comunicação GET:**
  - `ApiCatalogoServico.obterProdutos()`: Realiza requisições `http.get` para obter o catálogo remoto.
- **[Crítico] Realizando comunicação POST:**
  - `ApiCatalogoServico.cadastrarProduto()`: Envia novos produtos com cabeçalho `application/json` e payload via `http.post`.
- **[Crítico] Realizando comunicação PUT:**
  - `ApiCatalogoServico.atualizarProduto()`: Atualiza dados de produtos existentes via `http.put`.
- **[Crítico] Realizando comunicação DELETE:**
  - `ApiCatalogoServico.excluirProduto()`: Remove itens do catálogo remoto via `http.delete`.
  - Arquivo: `lib/servicos/api_catalogo_servico.dart`.
- **[Desejável] Realizando integração de múltiplas APIs:**
  - **API 1 (Catálogo REST):** Serviço RESTful do catálogo de produtos.
  - **API 2 (ViaCEP):** Consumo da API pública dos Correios (`https://viacep.com.br/ws/{cep}/json/`) para autopreenchimento de logradouro, bairro, cidade/UF e cálculo automatizado de frete gamer (`lib/servicos/api_cep_servico.dart`).
  - **API 3 (AwesomeAPI):** Consumo da API de cotação econômica em tempo real (`https://economia.awesomeapi.com.br/last/USD-BRL`) para conversão instantânea do valor dos produtos em Dólar comercial (`lib/servicos/api_cotacao_servico.dart`).

---

### Capacidade Técnica 10: Publicar aplicativos para a plataforma mobile
- **[Crítico] Exportando arquivo APK:**
  - Configuração nativa no `android/app/build.gradle.kts` com namespace `com.senai.gamelucx_store`, permissões de rede e armazenamento no `AndroidManifest.xml` e script automatizado `exportar_apk.bat` para compilar o APK Release.
- **[Crítico] Instalando arquivo no dispositivo:**
  - Script `instalar_no_celular.bat` automatizado para instalação via ADB (`adb install -r`), além de orientações para instalação manual via habilitar "Fontes Desconhecidas" no Android.

---

### Capacidade Técnica 11: Utilizar os elementos da programação orientada a objetos em aplicações para dispositivos móveis
- **[Crítico] Utilizando classes para a resolução do problema:**
  - Modelagem rica com entidades bem definidas: `Produto`, `ItemCarrinho`, `Pedido`, `UsuarioCliente`, `EnderecoCep`, `CotacaoMoeda`.
- **[Crítico] Utilizando subclasses para objetos diferentes:**
  - Implementação de herança direta e polimorfismo a partir da classe base abstrata `Produto`:
    1. Subclasse `ComputadorGamer`: Atributos exclusivos (processador, placa de vídeo, memória RAM, SSD, fonte, refrigeração líquida) e desconto PIX de 12%.
    2. Subclasse `PerifericoGamer`: Atributos exclusivos (tipo de periférico, tipo de conexão, especificações de sensor/switch, iluminação RGB) e desconto PIX de 10%.
    3. Subclasse `ConsoleGamer`: Atributos exclusivos (fabricante, armazenamento interno, edição especial, quantidade de controles) e desconto PIX de 8%.
  - Sobrescrita de métodos polimórficos `@override`: `obterDescricaoTecnica()`, `calcularDescontoPix()`, `obterResumoEspecificacoes()` e `toJson()`.
  - Arquivos: `lib/modelos/computador_gamer.dart`, `lib/modelos/periferico_gamer.dart`, `lib/modelos/console_gamer.dart`.
- **[Desejável] Otimizando código através de componentização:**
  - Criação de componentes visuais isolados e altamente reutilizáveis:
    - `CartaoProduto`: Card do catálogo com tratamento de imagens locais e remotas.
    - `BarraPesquisa`: Campo de busca dinâmico.
    - `SeletorCategorias`: Chips horizontais com estilo neon.
    - `BannerPromocoes`: Banner promocional em formato hero.
    - `SimuladorFreteWidget`: Componente desacoplado de cálculo de frete ViaCEP.
    - `ConversorMoedaWidget`: Componente desacoplado de cotação AwesomeAPI.
    - `BotaoGamer`: Botão com gradiente neon padronizado.
  - Arquivos em: `lib/componentes/`.

---

## 4. DEMONSTRAÇÃO DAS COMPETÊNCIAS SOCIOEMOCIONAIS

### 1. Autogestão
- **Postando atividades e entregando dentro do prazo:**
  Planejei o desenvolvimento em etapas: modelagem de dados, camada de serviços e persistência, elaboração dos componentes de interface e finalização com testes unitários e scripts de build. As entregas foram organizadas com commits claros e documentação completa dentro do prazo estipulado.

### 2. Pensamento Analítico
- **Identificação de problemas e diferentes abordagens de solução:**
  Identifiquei previamente o risco de instabilidade de rede ou queda de servidores remotos durante avaliações práticas. Para contornar esse problema de forma elegante, arquitetei uma estratégia *Offline-First* com três níveis de fallback: (1) Leitura de API remota -> (2) Leitura de cache local -> (3) Catálogo inicial semente. Dessa forma, o app nunca apresenta tela em branco ou encerra inesperadamente.

### 3. Inteligência Emocional
- **Lidando com desafios e frustrações:**
  Durante a integração assíncrona com múltiplas APIs simultâneas (REST, ViaCEP e AwesomeAPI), surgiram desafios como diferenças de formato de dados e timeouts de requisições. Mantive a calma, utilizei blocos `try/catch` com tratamento granular de exceções e desenvolvi componentes visuais que informam o usuário sobre o status de forma transparente e amigável.

### 4. Autonomia
- **Pesquisa de soluções e proposição de melhorias:**
  Pesquisei na documentação oficial do Dart e do Flutter sobre as novidades do Dart 3 (Extension Methods, Records e Switch Expressions) e pesquisei APIs abertas brasileiras (ViaCEP e AwesomeAPI) para agregar valor comercial real à loja, transformando um app de e-commerce comum em uma experiência imersiva e completa para o cliente gamer.

---

## 5. AUTOAVALIAÇÃO E NÍVEL DE DESEMPENHO

| Grupo de Critérios | Critérios Críticos | Critérios Desejáveis |
|---|:---:|:---:|
| **Capacidades Técnicas (6, 7, 8, 10, 11)** | 11 / 11 atingidos | 5 / 5 atingidos |
| **Competências Socioemocionais (1, 2, 3, 4)** | 5 / 5 atingidos | 4 / 4 atingidos |
| **TOTAL CONSOLIDADO** | **16 de 16 Críticos** | **09 de 09 Desejáveis** |

Conforme a **Tabela de Níveis de Desempenho** da folha de avaliação:
- **Critérios Atingidos:** Todos os 16 critérios críticos e todos os 09 desejáveis.
- **Nível de Desempenho:** **30**
- **Conversão em Notas:** **100 (Nota Máxima)**

---

*Relatório elaborado por Lucas Moreira Gomes — SENAI Roberto Mange, 2026.*
