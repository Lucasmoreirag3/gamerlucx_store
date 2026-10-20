# 🎮 GameLuX Store - E-commerce Mobile Gamer

> **Situação de Aprendizagem:** Da Tela Ao App Integrado  
> **Instituição:** Escola e Faculdade de Tecnologia SENAI "Roberto Mange"  
> **Curso:** Técnico em Desenvolvimento de Sistemas (PPDM - 4º Termo)  
> **Aluno / Desenvolvedor:** Lucas Moreira Gomes (`Lucasmoreirag3`)  
> **Campanha:** Agência Digital Horizon  

---

## 📌 Sobre o Projeto

A **GameLuX Store** é um aplicativo mobile completo de comércio eletrônico focado no público gamer e entusiastas de hardware de alto desempenho. O projeto foi desenvolvido para atender com nota máxima todos os **16 critérios críticos** e **09 critérios desejáveis** da Situação de Aprendizagem de Programação Para Dispositivos Móveis (PPDM).

A plataforma comercializa:
- 💻 **PCs Gamer:** Máquinas montadas e configuradas com refrigeração líquida, placas GeForce RTX e processadores de última geração.
- ⌨️ **Periféricos de Alto Desempenho:** Teclados mecânicos custom, mouses ultraleves de alta precisão, headsets com áudio espacial 7.1 e monitores de alta taxa de quadros.
- 🎮 **Videogames e Consoles:** Consoles de última geração (Aether-X, PlayStation 5, Xbox Series X, Nintendo Switch OLED) e acessórios oficiais.

---

## 💎 Identidade Visual e Experiência do Usuário (UI/UX)

Seguindo o padrão de excelência visual, a aplicação utiliza:
- **Tema Gamer Dark Mode:** Fundo escuro imersivo (`#0B0E17` e `#151926`) que reduz a fadiga visual e destaca as artes dos produtos.
- **Acentos Neon:** Roxo Cyber (`#8B5CF6`) e Ciano Elétrico (`#06B6D4`), transmitindo tecnologia, velocidade e modernidade.
- **Microinterações:** Feedback tátil e visual ao favoritar, adicionar ao carrinho e calcular frete.
- **Fotografias em Alta Resolução:** Banners promocionais e produtos renderizados em padrão comercial.

---

## 🏛️ Arquitetura e Organização das Pastas

Toda a estrutura do projeto foi organizada em português claro, modular e desacoplado:

```
gamelucx_store/
├── android/                             # Configurações nativas do Android e Gradle
├── assets/
│   └── imagens/                         # Banners promocionais, logo e fotos dos produtos
├── lib/
│   ├── main.dart                        # Ponto de entrada e configuração do tema/rotas
│   ├── constantes/
│   │   ├── cores_app.dart               # Paleta de cores oficial da GameLuX Store
│   │   └── rotas_app.dart               # Constantes de rotas nomeadas
│   ├── modelos/                         # Modelagem POO com Classes e Subclasses
│   │   ├── produto.dart                 # Classe base abstrata com Factory Constructor
│   │   ├── computador_gamer.dart        # Subclasse concreta com atributos de hardware
│   │   ├── periferico_gamer.dart        # Subclasse concreta de periféricos
│   │   ├── console_gamer.dart           # Subclasse concreta de videogames
│   │   ├── item_carrinho.dart           # Item do carrinho e regras de subtotal
│   │   ├── pedido.dart                  # Entidade de pedido concluído
│   │   ├── usuario_cliente.dart         # Dados sensíveis do cliente (armazenamento interno)
│   │   ├── endereco_cep.dart            # Mapeamento do ViaCEP e regras de frete
│   │   └── cotacao_moeda.dart           # Mapeamento da AwesomeAPI (cotação do Dólar)
│   ├── servicos/                        # Integração RESTful e Persistência
│   │   ├── api_catalogo_servico.dart    # CRUD RESTful completo (GET, POST, PUT, DELETE)
│   │   ├── api_cep_servico.dart         # API 2: Integração com ViaCEP
│   │   ├── api_cotacao_servico.dart     # API 3: Integração com AwesomeAPI (Dólar em tempo real)
│   │   ├── cache_local_servico.dart     # Persistência de cache local no app com TTL
│   │   ├── armazenamento_interno_servico.dart # Persistência de dados sensíveis e carrinho
│   │   └── armazenamento_externo_servico.dart # Exportação/importação de backups e recibos
│   ├── utilitarios/
│   │   └── formatadores.dart            # Extension Methods Dart e Mixins de validação
│   ├── dados/
│   │   └── catalogo_inicial.dart        # Dados semente e fallback offline-first
│   ├── componentes/                     # Widgets modulares e reutilizáveis
│   │   ├── cartao_produto.dart          # Card do produto com polimorfismo e favoritos
│   │   ├── barra_pesquisa.dart          # Busca em tempo real com limpeza rápida
│   │   ├── seletor_categorias.dart      # Filtros rápidos por chip com gradiente
│   │   ├── banner_promocoes.dart        # Banner promocional hero de destaque
│   │   ├── simulador_frete_widget.dart  # Consulta ViaCEP interativa
│   │   ├── conversor_moeda_widget.dart  # Cotação internacional USD/BRL
│   │   └── botao_gamer.dart             # Botão estilizado com gradiente neon
│   └── telas/
│       ├── tela_catalogo_inicio.dart    # Vitrine principal e navegação por abas
│       ├── tela_detalhes_produto.dart   # Ficha técnica polimórfica e frete
│       ├── tela_carrinho_compras.dart   # Gerenciamento de itens e subtotais
│       ├── tela_checkout_pedido.dart    # Conclusão de compra e exportação de recibo
│       ├── tela_gerenciar_produtos.dart # Painel do lojista (CRUD RESTful)
│       ├── tela_formulario_produto.dart # Formulário para POST e PUT
│       └── tela_perfil_usuario.dart     # Perfil, histórico e painel de evidências SA
├── test/
│   └── produto_teste.dart               # Testes unitários de POO, polimorfismo e extensions
├── exportar_apk.bat                     # Script de compilação do APK Release
├── instalar_no_celular.bat              # Script de instalação do APK via ADB
├── pubspec.yaml                         # Dependências e assets do Flutter
├── README.md                            # Guia completo da aplicação
└── RELATORIO_SITUACAO_APRENDIZAGEM.md   # Relatório oficial acadêmico para o SENAI
```

---

## 🎯 Atendimento Integral aos Critérios de Avaliação (SENAI Roberto Mange)

| Critério | Descrição | Status | Onde Encontrar no Código |
|---|---|:---:|---|
| **6.1 (Crítico)** | Implementando estruturas de lógica na linguagem Dart | ✅ Atingido | `lib/utilitarios/formatadores.dart`, `lib/modelos/produto.dart` (Null safety, switch expressions, async/await) |
| **6.2 (Desejável)** | Diferenciando características de outras linguagens | ✅ Atingido | `lib/utilitarios/formatadores.dart` (Mixins `ValidadorFormularioMixin`, Extensions no tipo `double`, Factory Constructors) |
| **7.1 (Crítico)** | Persistindo dados localmente no cache do aplicativo | ✅ Atingido | `lib/servicos/cache_local_servico.dart` (Cache SharedPreferences com validade temporal TTL e favoritos) |
| **7.2 (Crítico)** | Persistindo dados no armazenamento externo | ✅ Atingido | `lib/servicos/armazenamento_externo_servico.dart` (Exporta e importa arquivos `.json` de catálogo e comprovantes `.txt`) |
| **7.3 (Desejável)** | Persistindo modificações no armazenamento interno | ✅ Atingido | `lib/servicos/armazenamento_interno_servico.dart` (Dados sensíveis do usuário, carrinho e pedidos) |
| **8.1 (Crítico)** | Realizando comunicação GET | ✅ Atingido | `lib/servicos/api_catalogo_servico.dart` (`obterProdutos()`) |
| **8.2 (Crítico)** | Realizando comunicação POST | ✅ Atingido | `lib/servicos/api_catalogo_servico.dart` (`cadastrarProduto()`) |
| **8.3 (Crítico)** | Realizando comunicação PUT | ✅ Atingido | `lib/servicos/api_catalogo_servico.dart` (`atualizarProduto()`) |
| **8.4 (Crítico)** | Realizando comunicação DELETE | ✅ Atingido | `lib/servicos/api_catalogo_servico.dart` (`excluirProduto()`) |
| **8.5 (Desejável)** | Realizando integração de múltiplas APIs | ✅ Atingido | Integração com **3 APIs**: API REST Catálogo + **ViaCEP** (`api_cep_servico.dart`) + **AwesomeAPI** (`api_cotacao_servico.dart`) |
| **10.1 (Crítico)** | Exportando arquivo APK | ✅ Atingido | `exportar_apk.bat` e configuração `android/app/build.gradle.kts` |
| **10.2 (Crítico)** | Instalando arquivo no dispositivo | ✅ Atingido | `instalar_no_celular.bat` e manual passo a passo |
| **11.1 (Crítico)** | Utilizando classes para resolução do problema | ✅ Atingido | `lib/modelos/` (`Produto`, `ItemCarrinho`, `Pedido`, etc.) |
| **11.2 (Crítico)** | Utilizando subclasses para objetos diferentes | ✅ Atingido | `ComputadorGamer`, `PerifericoGamer`, `ConsoleGamer` herdando de `Produto` com métodos polimórficos `@override` |
| **11.3 (Desejável)** | Otimizando código através de componentização | ✅ Atingido | `lib/componentes/` (`CartaoProduto`, `BarraPesquisa`, `SeletorCategorias`, `BotaoGamer`, etc.) |

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK instalado (versão 3.5.0 ou superior)
- Dispositivo Android (ou emulador) ou navegador Web

### Passos
1. Abra o terminal na pasta do projeto:
```bash
cd gamelucx_store
```

2. Obtenha as dependências:
```bash
flutter pub get
```

3. Execute os testes unitários:
```bash
flutter test
```

4. Execute o aplicativo:
```bash
flutter run
```

### Gerando o APK para Celular (Critério 10)
Execute no terminal ou dê dois cliques no arquivo:
```bash
.\exportar_apk.bat
```
O arquivo APK pronto para instalação será gerado em:
`build\app\outputs\flutter-apk\app-release.apk`

Para instalar no celular com cabo USB conectado:
```bash
.\instalar_no_celular.bat
```

---

## 🛡️ Tratamento de Segurança e Dados (Situação Desafiadora)
Conforme orientado no enunciado da Situação de Aprendizagem:
- **Dados Públicos:** Catálogo de produtos, imagens, promoções e especificações técnicas são consumidos de servidores web através de serviços RESTful.
- **Dados Sensíveis:** Nome completo do cliente, endereço residencial particular, email e dados do carrinho de compras são armazenados com segurança localmente no dispositivo via `ArmazenamentoInternoServico`.
- **Modo Offline-First:** Caso o dispositivo perca a conexão ou a API web oscile, o aplicativo utiliza o cache inteligente para manter a loja 100% funcional sem travar.
