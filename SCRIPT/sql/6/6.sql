PROMPT
SET ECHO ON
CREATE OR REPLACE VIEW komendanci AS
SELECT stanowisko.nazwa, osoba.imie, osoba.nazwisko, pracownik.id_jednostka FROM stanowisko
INNER JOIN pracownik ON stanowisko.id_stanowisko=pracownik.id_stanowisko
INNER JOIN osoba ON osoba.id_osoby=pracownik.id_osoba
INNER JOIN jednostka ON jednostka.id_jednostka=pracownik.id_jednostka
WHERE stanowisko.id_stanowisko LIKE '1'
WITH READ ONLY;
SET ECHO OFF
PROMPT