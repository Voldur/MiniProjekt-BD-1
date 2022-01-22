------------DROP------------
DROP TABLE adres CASCADE CONSTRAINTS;
DROP TABLE stanowisko CASCADE CONSTRAINTS;
DROP TABLE zmiana CASCADE CONSTRAINTS;
DROP TABLE sprzet CASCADE CONSTRAINTS;
DROP TABLE jednostka CASCADE CONSTRAINTS;
DROP TABLE jurysdykcja CASCADE CONSTRAINTS;
DROP TABLE rodzaj CASCADE CONSTRAINTS;
DROP TABLE pojazd CASCADE CONSTRAINTS;
DROP TABLE wyposazenie CASCADE CONSTRAINTS;
DROP TABLE osoba CASCADE CONSTRAINTS;
DROP TABLE pracownik CASCADE CONSTRAINTS;
DROP TABLE status CASCADE CONSTRAINTS;
DROP TABLE zgloszenie CASCADE CONSTRAINTS;

------------CREATE------------

CREATE TABLE adres(
ID_adres INTEGER PRIMARY KEY NOT NULL,
miasto VARCHAR2(30) NOT NULL,
ulica VARCHAR2(30) NOT NULL,
nr INTEGER NOT NULL
);
CREATE TABLE stanowisko(
ID_stanowisko INTEGER PRIMARY KEY NOT NULL,
nazwa VARCHAR2(20) NOT NULL,
opis VARCHAR2(200)
);
CREATE TABLE zmiana(
ID_zmiana INTEGER PRIMARY KEY NOT NULL,
numer_zmiany INTEGER NOT NULL,
dzien DATE NOT NULL
);
CREATE TABLE sprzet(
ID_item INTEGER PRIMARY KEY NOT NULL,
nazwa VARCHAR2(30) NOT NULL,
opis VARCHAR2(200),
ilosc INTEGER
);
CREATE TABLE jednostka(
ID_jednostka INTEGER PRIMARY KEY NOT NULL,
nazwa VARCHAR2(200) NOT NULL,
ID_adres INTEGER,
CONSTRAINT ID_adres_jed
    FOREIGN KEY (ID_adres)
    REFERENCES adres(ID_adres)
);
CREATE TABLE jurysdykcja(
ID_teren INTEGER PRIMARY KEY NOT NULL,
powieszchnia VARCHAR2(25) NOT NULL,
ID_jednostka INTEGER,
CONSTRAINT ID_jednostka_jur
    FOREIGN KEY (ID_jednostka)
    REFERENCES jednostka(ID_jednostka)
);
CREATE TABLE rodzaj(
ID_rodzaj INTEGER PRIMARY KEY NOT NULL,
nazwa VARCHAR2(50) NOT NULL,
opis VARCHAR2(200)
);
CREATE TABLE pojazd(
ID_pojazd INTEGER PRIMARY KEY NOT NULL,
typ VARCHAR2(100) NOT NULL,
model VARCHAR2(40) NOT NULL,
rejestracja VARCHAR2(20) NOT NULL,
miejsca INTEGER NOT NULL
);
CREATE TABLE wyposazenie(
ID_wyposazenie INTEGER PRIMARY KEY NOT NULL,
ID_pojazd INTEGER,
ID_item INTEGER,
ilosc INTEGER NOT NULL,
CONSTRAINT ID_pojazd_wyp
    FOREIGN KEY (ID_pojazd)
    REFERENCES pojazd(ID_pojazd),
CONSTRAINT ID_item_wyp
    FOREIGN KEY (ID_item)
    REFERENCES sprzet(ID_item)
);
CREATE TABLE osoba(
ID_osoby INTEGER PRIMARY KEY NOT NULL,
imie VARCHAR2(20) NOT NULL,
nazwisko  VARCHAR2(20) NOT NULL,
pesel NVARCHAR2(11) UNIQUE,
telefon NVARCHAR2(12) UNIQUE,
ID_adres INTEGER,
CONSTRAINT ID_adres_oso
    FOREIGN KEY (ID_adres)
    REFERENCES adres(ID_adres)
);
CREATE TABLE pracownik(
ID_pracownik INTEGER PRIMARY KEY NOT NULL,
ID_osoba INTEGER,
ID_pojazd INTEGER,
ID_zmiana INTEGER,
ID_stanowisko INTEGER,
ID_jednostka INTEGER,
pensja INTEGER,
starz INTEGER,
CONSTRAINT ID_osoba_prac
    FOREIGN KEY (ID_osoba)
    REFERENCES osoba(ID_osoby),
CONSTRAINT ID_pojazd_prac
    FOREIGN KEY (ID_pojazd)
    REFERENCES pojazd(ID_pojazd),
CONSTRAINT ID_zmiana_prac
    FOREIGN KEY (ID_zmiana)
    REFERENCES zmiana(ID_zmiana),
CONSTRAINT ID_stanowisko_prac
    FOREIGN KEY (ID_stanowisko)
    REFERENCES stanowisko(ID_stanowisko),
CONSTRAINT ID_jednostka_prac
    FOREIGN KEY (ID_jednostka)
    REFERENCES jednostka(ID_jednostka)
);
CREATE TABLE status(
ID_status INTEGER PRIMARY KEY NOT NULL,
status_zgloszenia VARCHAR2(20) NOT NULL CONSTRAINT CHK_status CHECK (status_zgloszenia='W trakcie' OR status_zgloszenia='Zakonczony'),
data_rozpoczecia DATE,
data_zakonczenia DATE,
ID_pojazd INTEGER,
CONSTRAINT ID_pojazd_sta
    FOREIGN KEY (ID_pojazd)
    REFERENCES pojazd(ID_pojazd)
);
CREATE TABLE zgloszenie(
ID_zgloszenie INTEGER PRIMARY KEY NOT NULL,
data_zgloszenia DATE NOT NULL,
ID_status INTEGER,
ID_osoba INTEGER,
ID_rodzaj INTEGER,
ID_adres INTEGER,
CONSTRAINT ID_status_zgl
    FOREIGN KEY (ID_status)
    REFERENCES status(ID_status),
CONSTRAINT ID_osoba_zgl
    FOREIGN KEY (ID_osoba)
    REFERENCES osoba(ID_osoby),
CONSTRAINT ID_rodzaj_zgl
    FOREIGN KEY (ID_rodzaj)
    REFERENCES rodzaj(ID_rodzaj),
CONSTRAINT ID_adres_zgl
    FOREIGN KEY (ID_adres)
    REFERENCES adres(ID_adres)
);

------------TRIGGER------------

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
/

CREATE OR REPLACE TRIGGER status_date
BEFORE INSERT OR UPDATE ON status FOR EACH ROW 
DECLARE
i NUMBER;
max_stat NUMBER;
data_roz DATE;
data_zak DATE;
BEGIN
LOOP
SELECT MAX(status.id_status) into max_stat FROM status; 
    EXIT WHEN i > max_stat;
    SELECT data_rozpoczecia INTO data_roz FROM status;
    SELECT data_zakonczenia INTO data_zak FROM status;
    if(data_roz > data_zak)
    THEN
    RAISE_APPLICATION_ERROR(-2001, 'Co, zgloszenie sie skonczylo jeszcze zanim sie zaczelo?');
END IF;
    i := i + 1;
END LOOP;
END;
/

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
/
