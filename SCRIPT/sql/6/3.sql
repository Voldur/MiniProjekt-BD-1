PROMPT
SET ECHO ON
CREATE OR REPLACE VIEW osoby1 AS
SELECT osoba.id_osoby, osoba.imie,osoba.nazwisko, pracownik.pensja, adres.miasto, adres.ulica, adres.nr FROM pracownik
INNER JOIN osoba ON pracownik.id_osoba=osoba.id_osoby
INNER JOIN adres ON osoba.id_adres=adres.id_adres
WITH READ ONLY;
SET ECHO OFF
PROMPT