
-- =====================================================
-- PROJETO: GESTAO DE SESSOES TERAPEUTICAS
-- DISCIPLINA: BANCO DE DADOS II
-- BANCO DE DADOS: clinica_terapeutica
-- =====================================================

USE clinica_terapeutica;

-- =====================================================
-- PROCEDURE 1: APLICAR DESCONTO NA SESSAO
-- =====================================================

DROP PROCEDURE IF EXISTS aplicar_desconto_sessao;

DELIMITER $$

CREATE PROCEDURE aplicar_desconto_sessao(
    IN p_sessao_id INT,
    IN p_percentual DECIMAL(5,2)
)
BEGIN
    DECLARE v_valor DECIMAL(10,2);
    DECLARE v_status VARCHAR(20);
    DECLARE v_valor_final DECIMAL(10,2);

    -- Validar percentual
    IF p_percentual IS NULL
       OR p_percentual < 1
       OR p_percentual > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Percentual deve estar entre 1 e 100';
    END IF;

    -- Verificar se a sessao existe
    IF NOT EXISTS (
        SELECT 1 FROM sessoes
        WHERE id = p_sessao_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sessao nao encontrada';
    END IF;

    -- Buscar valor e status
    SELECT valor, status
    INTO v_valor, v_status
    FROM sessoes
    WHERE id = p_sessao_id;

    -- Verificar status da sessao
    IF v_status <> 'agendada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'So e permitido desconto em sessoes agendadas';
    END IF;

    -- Calcular desconto
    SET v_valor_final =
        v_valor * (1 - p_percentual / 100);

    -- Validar valor minimo
    IF v_valor_final < 50 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'O valor final nao pode ser menor que R$ 50,00';
    END IF;

    -- Atualizar valor da sessao
    UPDATE sessoes
    SET valor = v_valor_final
    WHERE id = p_sessao_id;

END$$


-- =====================================================
-- PROCEDURE 2: CADASTRAR NOVA SESSAO
-- =====================================================

DROP PROCEDURE IF EXISTS cadastrar_sessao;

CREATE PROCEDURE cadastrar_sessao(
    IN p_paciente_id INT,
    IN p_terapeuta_id INT,
    IN p_sala_id INT,
    IN p_data_hora DATETIME,
    IN p_valor DECIMAL(10,2)
)
BEGIN

    -- Verificar se o paciente existe
    IF NOT EXISTS (
        SELECT 1 FROM pacientes
        WHERE id = p_paciente_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Paciente nao encontrado';
    END IF;

    -- Verificar se o terapeuta existe
    IF NOT EXISTS (
        SELECT 1 FROM terapeutas
        WHERE id = p_terapeuta_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Terapeuta nao encontrado';
    END IF;

    -- Verificar se a sala existe
    IF NOT EXISTS (
        SELECT 1 FROM salas
        WHERE id = p_sala_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sala nao encontrada';
    END IF;

    -- Verificar data e hora
    IF p_data_hora IS NULL
       OR p_data_hora < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'A data e hora nao podem ser anteriores ao momento atual';
    END IF;

    -- Verificar valor
    IF p_valor IS NULL OR p_valor <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'O valor deve ser maior que zero';
    END IF;

    -- Inserir nova sessao
    INSERT INTO sessoes (
        paciente_id,
        terapeuta_id,
        sala_id,
        data_hora,
        valor,
        status
    )
    VALUES (
        p_paciente_id,
        p_terapeuta_id,
        p_sala_id,
        p_data_hora,
        p_valor,
        'agendada'
    );

END$$


-- =====================================================
-- PROCEDURE 3: TROCAR CONVENIO DO PACIENTE
-- =====================================================

DROP PROCEDURE IF EXISTS trocar_convenio;

CREATE PROCEDURE trocar_convenio(
    IN p_paciente_id INT,
    IN p_convenio_novo_id INT
)
BEGIN

    -- Verificar se o paciente existe
    IF NOT EXISTS (
        SELECT 1 FROM pacientes
        WHERE id = p_paciente_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Paciente nao encontrado';
    END IF;

    -- Verificar se o novo convenio existe
    IF NOT EXISTS (
        SELECT 1 FROM convenios
        WHERE id = p_convenio_novo_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Convenio nao encontrado';
    END IF;

    -- Verificar se ja possui o convenio
    IF EXISTS (
        SELECT 1 FROM pacientes
        WHERE id = p_paciente_id
        AND convenio_id = p_convenio_novo_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Paciente ja possui esse convenio';
    END IF;

    -- Atualizar convenio do paciente
    UPDATE pacientes
    SET convenio_id = p_convenio_novo_id
    WHERE id = p_paciente_id;

END$$

DELIMITER ;

-- =====================================================
-- FIM DO PROJETO professor, fiz com a ajuda da ia, pra entender como faz.
-- =====================================================
