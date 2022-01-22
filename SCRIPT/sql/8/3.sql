PROMPT
SET ECHO ON
CREATE OR REPLACE TRIGGER pojazd_miejsca
BEFORE INSERT ON pojazd FOR EACH ROW 
DECLARE
max_poja NUMBER;
prac_sel NUMBER;
poja_sel NUMBER;
i NUMBER;
BEGIN
LOOP
SELECT MAX(pojazd.id_pojazd) into max_poja FROM pojazd;
    EXIT WHEN i > max_poja;
    SELECT COUNT(id_pojazd) INTO prac_sel from pracownik WHERE id_pojazd=i;
    SELECT miejsca INTO poja_sel FROM pojazd WHERE id_pojazd=i;
    IF (prac_sel>poja_sel)
        THEN
        RAISE_APPLICATION_ERROR(-2002, 'Cos za duzo tych osob w tym pojezdzie');
    END IF;
    i := i + 1;
END LOOP;
END;
SET ECHO OFF
PROMPT