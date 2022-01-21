CREATE OR REPLACE VIEW pojazd1 AS
SELECT osoba.imie,osoba.nazwisko,pojazd.model,pojazd.rejestracja FROM pojazd
INNER JOIN pracownik ON pojazd.id_pojazd=pracownik.id_pojazd
INNER JOIN osoba ON osoba.id_osoby=pracownik.id_osoba
WHERE pojazd.id_pojazd=1
WITH READ ONLY;

CREATE OR REPLACE VIEW pojazd2 AS
SELECT osoba.imie,osoba.nazwisko,pojazd.model,pojazd.rejestracja FROM pojazd
INNER JOIN pracownik ON pojazd.id_pojazd=pracownik.id_pojazd
INNER JOIN osoba ON osoba.id_osoby=pracownik.id_osoba
WHERE pojazd.id_pojazd=2
WITH READ ONLY;

CREATE OR REPLACE VIEW pojazd3 AS
SELECT osoba.imie,osoba.nazwisko,pojazd.model,pojazd.rejestracja FROM pojazd
INNER JOIN pracownik ON pojazd.id_pojazd=pracownik.id_pojazd
INNER JOIN osoba ON osoba.id_osoby=pracownik.id_osoba
WHERE pojazd.id_pojazd=3
WITH READ ONLY;

CREATE OR REPLACE VIEW pojazd4 AS
SELECT osoba.imie,osoba.nazwisko,pojazd.model,pojazd.rejestracja FROM pojazd
INNER JOIN pracownik ON pojazd.id_pojazd=pracownik.id_pojazd
INNER JOIN osoba ON osoba.id_osoby=pracownik.id_osoba
WHERE pojazd.id_pojazd=4
WITH READ ONLY;

CREATE OR REPLACE VIEW pojazd5 AS
SELECT osoba.imie,osoba.nazwisko,pojazd.model,pojazd.rejestracja FROM pojazd
INNER JOIN pracownik ON pojazd.id_pojazd=pracownik.id_pojazd
INNER JOIN osoba ON osoba.id_osoby=pracownik.id_osoba
WHERE pojazd.id_pojazd=5
WITH READ ONLY;

CREATE OR REPLACE VIEW pojazd6 AS
SELECT osoba.imie,osoba.nazwisko,pojazd.model,pojazd.rejestracja FROM pojazd
INNER JOIN pracownik ON pojazd.id_pojazd=pracownik.id_pojazd
INNER JOIN osoba ON osoba.id_osoby=pracownik.id_osoba
WHERE pojazd.id_pojazd=6
WITH READ ONLY;

CREATE OR REPLACE VIEW osoby1 AS
SELECT osoba.id_osoby, osoba.imie,osoba.nazwisko, pracownik.pensja, adres.miasto, adres.ulica, adres.nr FROM pracownik
INNER JOIN osoba ON pracownik.id_osoba=osoba.id_osoby
INNER JOIN adres ON osoba.id_adres=adres.id_adres
WITH READ ONLY;

CREATE OR REPLACE VIEW zgloszenie1 AS
SELECT zgloszenie.id_zgloszenie, osoba.imie, osoba.nazwisko, rodzaj.nazwa, rodzaj.opis FROM zgloszenie
INNER JOIN rodzaj ON zgloszenie.id_rodzaj=rodzaj.id_rodzaj
INNER JOIN osoba ON osoba.id_osoby=zgloszenie.id_osoba
WHERE rodzaj.id_rodzaj NOT LIKE '15'
WITH READ ONLY;

CREATE OR REPLACE VIEW jurysdykcje1 AS
SELECT jurysdykcja.id_teren, jurysdykcja.powieszchnia, adres.miasto, jednostka.nazwa FROM jurysdykcja
INNER JOIN jednostka ON jurysdykcja.id_jednostka=jednostka.id_jednostka
INNER JOIN adres ON jednostka.id_adres=adres.id_adres
ORDER BY adres.miasto 
WITH READ ONLY;

CREATE OR REPLACE VIEW komendanci AS
SELECT stanowisko.nazwa, osoba.imie, osoba.nazwisko, pracownik.id_jednostka FROM stanowisko
INNER JOIN pracownik ON stanowisko.id_stanowisko=pracownik.id_stanowisko
INNER JOIN osoba ON osoba.id_osoby=pracownik.id_osoba
INNER JOIN jednostka ON jednostka.id_jednostka=pracownik.id_jednostka
WHERE stanowisko.id_stanowisko LIKE '1'
WITH READ ONLY;
SELECT * FROM komendanci;

SELECT * FROM jurysdykcje1;
SELECT * FROM zgloszenie1;
SELECT * FROM pojazd1;
SELECT * FROM pojazd2;
SELECT * FROM pojazd3;
SELECT * FROM pojazd4;
SELECT * FROM pojazd5;
SELECT * FROM pojazd6;
SELECT * FROM osoby1;
