const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const dbPath = path.join(__dirname, 'db.json');

app.use(cors());
app.use(express.json());

function lerProdutos() {
  try {
    const conteudo = fs.readFileSync(dbPath, 'utf8');
    return JSON.parse(conteudo);
  } catch (error) {
    return [];
  }
}

function salvarProdutos(produtos) {
  fs.writeFileSync(dbPath, JSON.stringify(produtos, null, 2), 'utf8');
}

app.get('/', (req, res) => {
  res.json({
    mensagem: 'GameLuX Store API funcionando.',
    status: 'online',
    endpoints: ['/health', '/produtos', '/produtos/:id'],
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.get('/produtos', (req, res) => {
  const produtos = lerProdutos();
  res.json(produtos);
});

app.get('/produtos/:id', (req, res) => {
  const produtos = lerProdutos();
  const produto = produtos.find((item) => item.id === req.params.id);

  if (!produto) {
    return res.status(404).json({ erro: 'Produto não encontrado.' });
  }

  return res.json(produto);
});

app.post('/produtos', (req, res) => {
  const produtos = lerProdutos();
  const { nome, marca, preco, imagemUrl, descricao, quantidadeEstoque, avaliacao, emDestaque, tipo_categoria } = req.body;

  if (!nome || !marca || !preco || !tipo_categoria) {
    return res.status(400).json({ erro: 'Campos obrigatórios ausentes.' });
  }

  const novoProduto = {
    id: String(Date.now()),
    nome,
    marca,
    preco: Number(preco),
    imagemUrl: imagemUrl || 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=500',
    descricao: descricao || 'Produto da GameLuX Store.',
    quantidadeEstoque: Number(quantidadeEstoque || 0),
    avaliacao: Number(avaliacao || 5),
    emDestaque: Boolean(emDestaque),
    ...req.body,
  };

  produtos.push(novoProduto);
  salvarProdutos(produtos);
  return res.status(201).json(novoProduto);
});

app.put('/produtos/:id', (req, res) => {
  const produtos = lerProdutos();
  const index = produtos.findIndex((item) => item.id === req.params.id);

  if (index === -1) {
    return res.status(404).json({ erro: 'Produto não encontrado.' });
  }

  produtos[index] = {
    ...produtos[index],
    ...req.body,
    id: req.params.id,
  };

  salvarProdutos(produtos);
  return res.json(produtos[index]);
});

app.delete('/produtos/:id', (req, res) => {
  const produtos = lerProdutos();
  const produtoIndex = produtos.findIndex((item) => item.id === req.params.id);

  if (produtoIndex === -1) {
    return res.status(404).json({ erro: 'Produto não encontrado.' });
  }

  produtos.splice(produtoIndex, 1);
  salvarProdutos(produtos);
  return res.status(200).json({ mensagem: 'Produto excluído com sucesso.' });
});

app.listen(PORT, () => {
  console.log(`API rodando na porta ${PORT}`);
});
