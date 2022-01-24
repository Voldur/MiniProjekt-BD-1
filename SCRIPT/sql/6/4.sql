PROMPT
SET ECHO ON
CREATE OR REPLACE VIEW zgloszenie1 AS
SELECT zgloszenie.id_zgloszenie, osoba.imie, osoba.nazwisko, rodzaj.nazwa, rodzaj.opis FROM zgloszenie
INNER JOIN rodzaj ON zgloszenie.id_rodzaj=rodzaj.id_rodzaj
INNER JOIN osoba ON osoba.id_osoby=zgloszenie.id_osoba
WHERE rodzaj.id_rodzaj NOT LIKE '15'
WITH READ ONLY;
SET ECHO OFF
PROMPT