PROMPT
SET ECHO ON
CREATE OR REPLACE VIEW jurysdykcje1 AS
SELECT jurysdykcja.id_teren, jurysdykcja.powieszchnia, adres.miasto, jednostka.nazwa FROM jurysdykcja
INNER JOIN jednostka ON jurysdykcja.id_jednostka=jednostka.id_jednostka
INNER JOIN adres ON jednostka.id_adres=adres.id_adres
ORDER BY adres.miasto 
WITH READ ONLY;
SET ECHO OFF
PROMPT