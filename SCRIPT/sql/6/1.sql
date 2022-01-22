PROMPT
SET ECHO ON
CREATE OR REPLACE VIEW pojazd1 AS
SELECT osoba.imie,osoba.nazwisko,pojazd.model,pojazd.rejestracja FROM pojazd
INNER JOIN pracownik ON pojazd.id_pojazd=pracownik.id_pojazd
INNER JOIN osoba ON osoba.id_osoby=pracownik.id_osoba
WHERE pojazd.id_pojazd=1
WITH READ ONLY;
SET ECHO OFF
PROMPT