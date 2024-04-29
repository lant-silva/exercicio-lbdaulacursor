USE master
GO
DROP DATABASE excursor
GO

CREATE DATABASE excursor
GO
USE excursor
GO
CREATE TABLE curso(
codigo		INT		NOT NULL,
nome		VARCHAR(100)	NOT NULL,
duracao		INT				NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE disciplina(
codigo		CHAR(10)			NOT NULL,
nome		VARCHAR(100)		NOT NULL,
carga_horaria	INT			NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE disciplina_curso(
codigo_disciplina			CHAR(10)			NOT NULL,
codigo_curso				INT			NOT NULL
PRIMARY KEY(codigo_disciplina, codigo_curso)
FOREIGN KEY(codigo_disciplina) REFERENCES disciplina(codigo),
FOREIGN KEY(codigo_curso) REFERENCES curso(codigo)
)
GO
INSERT INTO curso VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logística', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600)
GO
INSERT INTO disciplina VALUES
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Fisico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80)
GO
INSERT INTO disciplina_curso VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94)
GO
CREATE FUNCTION fn_cursodisciplinas(@codigo INT)
RETURNS @tabela TABLE(
codigo_disciplina	CHAR(10),
nome_disciplina	VARCHAR(100),
carga_horaria_disciplina	INT,
nome_curso	VARCHAR(100)
)
AS
BEGIN
	DECLARE @codigodisciplina CHAR(10),
			@codigocurso INT,
			@nomedisciplina	VARCHAR(100),
			@cargahorariadisciplina INT,
			@nomecurso VARCHAR(100)
	DECLARE cur CURSOR FOR
		SELECT d.codigo, c.codigo, d.nome, d.carga_horaria, c.nome 
		FROM curso c, disciplina d, disciplina_curso dc
		WHERE c.codigo = dc.codigo_curso
			AND d.codigo = dc.codigo_disciplina
	OPEN cur
	FETCH NEXT FROM cur INTO
		@codigodisciplina, @codigocurso, @nomedisciplina, @cargahorariadisciplina, @nomecurso
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(@codigocurso = @codigo)
		BEGIN
			INSERT INTO @tabela VALUES
			(@codigodisciplina, @nomedisciplina, @cargahorariadisciplina, @nomecurso)
		END
	FETCH NEXT FROM cur INTO
		@codigodisciplina, @codigocurso, @nomedisciplina, @cargahorariadisciplina, @nomecurso
	END
	CLOSE cur
	DEALLOCATE cur
	RETURN
END
GO
