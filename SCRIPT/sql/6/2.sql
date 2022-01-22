PROMPT
SET ECHO ON
CREATE OR REPLACE VIEW pojazdy_strazy AS
SELECT pojazd.model, pojazd.rejestracja, jednostka.nazwa FROM pojazd
INNER JOIN pracownik ON pracownik.id_pojazd=pojazd.id_pojazd
INNER JOIN jednostka ON pracownik.id_jednostka=jednostka.id_jednostka
WHERE pojazd.model LIKE 'MANN'
WITH READ ONLY;
SET ECHO OFF
PROMPT