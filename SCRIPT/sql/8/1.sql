PROMPT
SET ECHO ON
CREATE OR REPLACE TRIGGER pracownik_add
BEFORE INSERT ON pracownik FOR EACH ROW 
DECLARE
i NUMBER;
BEGIN
    SELECT MIN(id_stanowisko) INTO i FROM pracownik;
    if(i = :NEW.ID_stanowisko)
    then
    RAISE_APPLICATION_ERROR(-2000, 'Komendant moze byc tylko jeden');
END IF;
END;
SET ECHO OFF
PROMPT