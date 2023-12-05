-- Create the database if it does not exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'RadNET')
BEGIN
    CREATE DATABASE RadNET; -- Replace 'YourDatabaseName' with your desired database name
    PRINT 'Database created successfully.';
END
ELSE
BEGIN
    PRINT 'Database already exists.';
END

GO -- End the batch to execute the previous statements

USE RadNET; -- Switch to the newly created database or your existing database

-- Os tipos de dados foram pensados de modo a ocupar o menor espaço possível na bd (memória)

CREATE TABLE TipoEstacao
(
  id INT NOT NULL IDENTITY(1,1),
  descricao VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE FrequenciaLeitura
(
  id INT NOT NULL IDENTITY(1,1),
  frequencia VARCHAR(60) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Caracteristicas
(
  id INT NOT NULL IDENTITY(1,1),
  descricao_caracteristica VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE TipoSensor
(
  id INT NOT NULL IDENTITY(1,1),
  descricao_tipo VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE NivelRadiacao
(
  id INT NOT NULL IDENTITY(1,1),
  descricao_nivel VARCHAR(60) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE NiveisAlerta
(
  id INT NOT NULL IDENTITY(1,1),
  nivel INT NOT NULL,
  descricao VARCHAR(60) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE TipoAlerta
(
  id INT NOT NULL IDENTITY(1,1),
  descricao_alerta VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Accao
(
  id INT NOT NULL IDENTITY(1,1),
  descricao_accao VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Estacao
(
  id INT NOT NULL IDENTITY(1,1),
  localizacao_coordenada_lat VARCHAR(20) NOT NULL,
  localizacao_coordenada_lon VARCHAR(20) NOT NULL,
  data_instalacao DATE NOT NULL,
  tipo_estacao INT NOT NULL,
  frequencia_requisicao_dados INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (tipo_estacao) REFERENCES TipoEstacao(id),
  FOREIGN KEY (frequencia_requisicao_dados) REFERENCES FrequenciaLeitura(id)
);

CREATE TABLE Sensor
(
  id INT NOT NULL IDENTITY(1,1),
  limite_minimo FLOAT NOT NULL,
  limite_maximo FLOAT NOT NULL,
  gamas_detecao_min FLOAT NOT NULL,
  gamas_detecao_max FLOAT NOT NULL,
  estacao INT NOT NULL,
  tipo_sensor INT NOT NULL,
  frequencia_leitura INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (estacao) REFERENCES Estacao(id),
  FOREIGN KEY (tipo_sensor) REFERENCES TipoSensor(id),
  FOREIGN KEY (frequencia_leitura) REFERENCES FrequenciaLeitura(id)
);

CREATE TABLE PossuiCaracteristicas
(
  id INT NOT NULL IDENTITY(1,1),
  estacao INT NOT NULL,
  caracteristica INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (estacao) REFERENCES Estacao(id),
  FOREIGN KEY (caracteristica) REFERENCES Caracteristicas(id)
);

CREATE TABLE Leitura
(
  id INT NOT NULL IDENTITY(1,1),
  valor_msv INT NOT NULL,
  data_hora INT NOT NULL,
  sensor INT NOT NULL,
  nivel_radicao INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (sensor) REFERENCES Sensor(id),
  FOREIGN KEY (nivel_radicao) REFERENCES NivelRadiacao(id)
);

CREATE TABLE Alerta
(
  id INT NOT NULL IDENTITY(1,1),
  id_leitura INT NOT NULL,
  nivel_alerta INT NOT NULL,
  tipo_alerta INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_leitura) REFERENCES Leitura(id),
  FOREIGN KEY (nivel_alerta) REFERENCES NiveisAlerta(id),
  FOREIGN KEY (tipo_alerta) REFERENCES TipoAlerta(id)
);

CREATE TABLE AcoesTomar
(
  id INT NOT NULL IDENTITY(1,1),
  nivel_alerta INT NOT NULL,
  accao INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (nivel_alerta) REFERENCES NiveisAlerta(id),
  FOREIGN KEY (accao) REFERENCES Accao(id)
);