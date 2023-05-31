-- DELETANDO O BANCO DE DADOS E USUÁRIO "uvv" E "dennys" CASO EXISTAM:

DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS dennys;

-- CRIANDO MEU USUÁRIO:

CREATE USER dennys
WITH CREATEDB
CREATEROLE
ENCRYPTED PASSWORD '0403';


-- CRIANDO O BANCO DE DADOS "uvv":

CREATE DATABASE uvv
WITH OWNER = dennys
TEMPLATE = template0
ENCODING = "UTF8"
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE = 'pt_BR.UTF-8'
ALLOW_CONNECTIONS = "true";

-- ME CONECTANDO AO BANCO DE DADOS RECÉM CRIADO JÁ COM O USUÁRIO "dennys" E UTILIZANDO A SENHA DE MANEIRA AUTOMATIZADA: 

/* Esta etapa foi feita com a ajuda dos colegas de sala durante as aulas do PSET1 */

\c "dbname=uvv user=dennys password=0403"

-- CRIANDO O ESQUEMA "lojas" E DANDO AO USUÁRIO "dennys" AUTORIZAÇÃO PARA A MANIPULAÇÃO:

CREATE SCHEMA lojas
AUTHORIZATION dennys;

-- CONFERINDO QUAL O ESQUEMA PADRÃO QUE ESTÁ SENDO UTILIZADO PELO POSTGRESQL:

SELECT CURRENT_SCHEMA();

-- MODIFICAR O ESQUEMA PADRÃO PARA "lojas" DE MANEIRA PERMANENTE UTILIZANDO O ALTER USER:

ALTER USER dennys
SET SEARCH_PATH TO lojas, "$user", public;

-- CONFERINDO SE O SEARCH_PATH FOI ALTERADO PARA O QUE FOI DEFINIDO ACIMA:

SHOW SEARCH_PATH;

-- ATRIBUINDO O USUÁRIO "dennys" COMO DONO DO ESQUEMA:
ALTER SCHEMA lojas 
OWNER TO dennys;


-- CRIANDO A TABELA "produtos" E ATRIBUINDO À COLUNA "produto_id" O PAPEL DE PK:

CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);

-- COMENTANDO A TABELA "produtos":

COMMENT ON TABLE lojas.produtos IS 'Tabela que contém os produtos disponíveis para venda.';

-- COMENTANDO AS COLUNAS DA TABELA "produtos":

COMMENT ON COLUMN lojas.produtos.produto_id IS 'Número de identificação do produto.';
COMMENT ON COLUMN lojas.produtos.nome IS 'Nome do produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'Preço por unidade do produto.';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'Detalhes sobre o produto.';
COMMENT ON COLUMN lojas.produtos.imagem IS 'Imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'Indicador da natureza/formato da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'Arquivo da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'Charset da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Data da última atualização da imagem do produto.';


-- CRIANDO A TABELA "lojas" E ATRIBUINDO "loja_id" COMO PK:


CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT pk_lojas PRIMARY KEY (loja_id)
);

-- COMENTANDO A TABELA "lojas":

COMMENT ON TABLE lojas.lojas IS 'Tabela para registro das lojas que irão vender os produtos em estoque.';

-- COMENTANDO AS COLUNAS DA TABELA "lojas":

COMMENT ON COLUMN lojas.lojas.loja_id IS 'Número de identificação da loja.';
COMMENT ON COLUMN lojas.lojas.nome IS 'Nome da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'Endereço WEB (site) da loja. Este ou o endereço físico precisam estar preenchidos';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'Endereço físico da loja. Este ou o endereço web precisam estar preenchidos';
COMMENT ON COLUMN lojas.lojas.latitude IS 'Valor de latitudinal da localização da loja. Entre -90 e 90';
COMMENT ON COLUMN lojas.lojas.longitude IS 'Valor longitudinal da localização da loja. Entre -180 e 180';
COMMENT ON COLUMN lojas.lojas.logo IS 'Logomarca da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'Indicador da natureza/formato do arquivo da logo.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'Arquivo da logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'Conjunto de caracteres da logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Data da ultima atualizacao da logo.';


-- CRIANDO A TABELA "estoques" E ATRIBUINDO "estoque_id" COMO A PK:

CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoques PRIMARY KEY (estoque_id)
);

-- COMENTANDO A TABELA "estoques":

COMMENT ON TABLE lojas.estoques IS 'Tabela contendo os dados sobre os estoques dos produtos.';

-- COMENTANDO AS COLUNAS DA TABELA "estoques":

COMMENT ON COLUMN lojas.estoques.estoque_id IS 'Número de identificação do estoque do produto.';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'ID da loja.';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'ID do produto.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Quantidade do produto em estoque. Precisa ser maior ou igual a 0';


-- CRIANDO A TABELA "clientes" E ATRIBUINDO "cliente_id" COMO A PK:

CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                email VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT pk_clientes PRIMARY KEY (cliente_id)
);

-- COMENTANDO A TABELA "clientes":

COMMENT ON TABLE lojas.clientes IS 'Tabela que contém os dados dos clientes cadastrados.';

-- COMENTANDO AS COLUNAS DA TABELA clientes":

COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Número de identificação do cliente.';
COMMENT ON COLUMN lojas.clientes.nome IS 'Nome do cliente.';
COMMENT ON COLUMN lojas.clientes.email IS 'Email do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'Telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'Telefone número 2 do cliente, se houver.';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'Telefone número 3 do cliente, se houver.';


-- CRIANDO A TABELA "envios" E ATRIBUINDO "envio_id" COMO A PK:

CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT pk_envios PRIMARY KEY (envio_id)
);

-- COMENTANDO A TABELA "envios":

COMMENT ON TABLE lojas.envios IS 'Tabela contendo os dados dos envios dos pedidos para entrega.';

-- COMENTANDO AS COLUNAS DA TABELA "envios":

COMMENT ON COLUMN lojas.envios.envio_id IS 'Número de identificação do envio.';
COMMENT ON COLUMN lojas.envios.loja_id IS 'Número de identificação da loja.';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'Número de identificação do cliente.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Endereço fornecido pelo cliente para a entrega do pedido.';
COMMENT ON COLUMN lojas.envios.status IS 'Situação da entrega do pedido. Selecione entre: CRIADO, ENVIADO, TRANSITO e ENTREGUE.';


-- CRIANDO A TABELA "pedidos" E ATRIBUINDO "pedido_id" COMO A PK:

CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id)
);

-- COMENTANDO A TABELA "pedidos":

COMMENT ON TABLE lojas.pedidos IS 'Tabela contendo os dados dos pedidos feitos pelos clientes.';

-- COMENTANDO AS COLUNAS DA TABELA "pedidos":

COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'Número de identificação do pedido.';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'Dia e hora em que o pedido foi realizado.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Número de identificação do cliente.';
COMMENT ON COLUMN lojas.pedidos.status IS 'Situação do pedido. Selecione entre: CANCELADO, COMPLETO, ABERTO, PAGO, REEMBOLSADO e
ENVIADO';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'Número de identificação da loja em que foi feito o pedido.';


-- CRIANDO A TABELA "pedidos_itens" E ATRIBUINDO "pedido_id, produto_id" COMO A PK:

CREATE TABLE lojas.pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);

-- COMENTANDO A TABELA "pedidos_itens":

COMMENT ON TABLE lojas.pedidos_itens IS 'Dados referentes aos itens envolvidos nos pedidos.';

-- COMENTANDO AS COLUNAS DA TABELA "pedidos_itens":

COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'Número de identificação do pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'Número de identificação do produto.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Numero da linha (de produção) do produto.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'Preço unitário do produto. Precisa ser maior ou igual a 0.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'Quantidade de itens que serão enviados. Precisa ser maior ou igual a 0.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'Número de identificação do envio (entrega).';

-- ESTABELECENDO AS FKS PARA CRIAR AS RELAÇÕES:

/* A COLUNA SELECIONADA PARA SER A FK PODE SER CONFERIDA NA QUARTA LINHA DE CADA COMANDO: 
  
  REFERENCES lojas.tabela (coluna_fk)  

*/

-- estoques X produtos:

ALTER TABLE lojas.estoques 
ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- pedidos_itens X produtos:

ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- pedidos X lojas:

ALTER TABLE lojas.pedidos 
ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- envios X lojas

ALTER TABLE lojas.envios 
ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- estoques X lojas

ALTER TABLE lojas.estoques 
ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- pedidos X clientes

ALTER TABLE lojas.pedidos 
ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- envios X clientes

ALTER TABLE lojas.envios 
ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- pedidos_itens X envios

ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- pedidos_itens X pedidos

ALTER TABLE lojas.pedidos_itens 
ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- ADICIONANDO AS CHECKS NECESSÁRIAS:

-- STATUS DO PEDIDO:

ALTER TABLE lojas.pedidos
ADD CONSTRAINT cc_pedidos_status
CHECK (lojas.pedidos.status IN('CANCELADO','COMPLETO','ABERTO','PAGO','REEMBOLSADO','ENVIADO'));

-- STATUS DO ENVIO:

ALTER TABLE lojas.envios
ADD CONSTRAINT cc_envios_status
CHECK (lojas.envios.status IN ('CRIADO','ENVIADO','TRANSITO','ENTREGUE'));

-- UM DOS ENDEREÇOS PREENCHIDOS:
/* Um dos dois endereços deve estar preenchido para o funcionamento correto do cadastro */

ALTER TABLE lojas.lojas
ADD CONSTRAINT cc_endereco
CHECK (endereco_fisico IS NOT NULL OR endereco_web IS NOT NULL);

-- LATITUDE E LONGITUDE EM SEUS VALORES CORRETOS:
/* A latitude pode variar entre -90 e 90, enquanto a longitude pode variar entre -180 e 180 */

ALTER TABLE lojas.lojas
ADD CONSTRAINT cc_latitude
CHECK (latitude BETWEEN -90 and 90);


ALTER TABLE lojas.lojas
ADD CONSTRAINT cc_longitude
CHECK (longitude BETWEEN -180 and 180);

-- QUANTIDADES NÃO PODEM SER NEGATIVAS:
/* Mudanças feitas nas tabelas estoques e pedidos_itens */

ALTER TABLE lojas.estoques
ADD CONSTRAINT cc_quantidade
CHECK (quantidade >= 0);

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT cc_quantidade_pi
CHECK (quantidade >= 0);



-- PREÇOS NÃO PODEM SER NEGATIVOS:
/* Mudanças feitas nas tabelas produtos e pedidos_itens */

ALTER TABLE lojas.produtos
ADD CONSTRAINT cc_preco_unitario
CHECK (preco_unitario >= 0);

ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT cc_preco_unitario_pi
CHECK (preco_unitario >= 0);

--FIM






