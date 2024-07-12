-- ----------------------------------------------------------------
-- 1 Base de dados e criação de tabela
--escreva a sua solução aqui
CREATE TABLE tb_estudo(
    Cod_estudante SERIAL PRIMARY KEY,
    studentID VARCHAR(200),
    GRADE INT,
    MOTHER_EDU INT,
    FATHER_EDU INT,
    PREP_STUDY INT,
    PREP_EXAM INT,
    SALARY INT
);


-- ----------------------------------------------------------------
-- 2 Resultado em função da formação dos pais
--escreva a sua solução aqui
DO $$
DECLARE
cur_educ_pais REFCURSOR;
estudanteId VARCHAR(200);
BEGIN
OPEN cur_educ_pais FOR 
SELECT studentID FROM tb_estudo WHERE mother_edu = 6 OR father_edu = 6 AND grade > 0;
LOOP
FETCH cur_educ_pais INTO estudanteId;
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', estudanteId;
END LOOP;
CLOSE cur_educ_pais;
END;
$$

-- ----------------------------------------------------------------
-- 3 Resultado em função dos estudos
--escreva a sua solução aqui

DO $$
DECLARE
cur_educ_alone REFCURSOR;
estudante VARCHAR(200);
estudante_prep INT := 1;
BEGIN
OPEN cur_educ_alone FOR EXECUTE
format
(
'
SELECT
studentID
FROM
tb_estudo
WHERE prep_study = $1
'
)USING estudante_prep;

LOOP
FETCH cur_educ_alone INTO estudante;
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', estudante;
IF estudante IS NULL THEN RAISE NOTICE '-1';
END IF;
END LOOP;
CLOSE cur_educ_alone;
END;
$$
-- ----------------------------------------------------------------
-- 4 Salário versus estudos
--escreva a sua solução aqui

DO $$
DECLARE
cur_sal_prep REFCURSOR;
estudanteId VARCHAR(200);
BEGIN
OPEN cur_sal_prep FOR 
SELECT studentID FROM tb_estudo WHERE SALARY = 5 OR PREP_EXAM = 2 AND PREP_EXAM = 2;
LOOP
FETCH cur_sal_prep INTO estudanteId;
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', estudanteId;
END LOOP;
CLOSE cur_sal_prep;
END;
$$

------------------------------------------------------------------
-- 5. Limpeza de valores NULL
--escreva a sua solução aqui
DO $$
DECLARE
cur_educ_del REFCURSOR;
tupla RECORD;
BEGIN
OPEN cur_educ_del SCROLL FOR
SELECT
*
FROM
tb_estudo;
LOOP
FETCH cur_educ_del INTO tupla;
EXIT WHEN NOT FOUND;
IF tupla.studentID IS NULL THEN
DELETE FROM tb_estudo WHERE CURRENT OF cur_educ_del;
END IF;
END LOOP;
LOOP
FETCH BACKWARD FROM cur_educ_del INTO tupla;
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', tupla;
END LOOP;
CLOSE cur_educ_del;
END;
$$
-- ----------------------------------------------------------------