SET ECHO ON
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

CREATE TABLE adres(
ID_adres INTEGER PRIMARY KEY NOT NULL,
miasto VARCHAR2(50) NOT NULL,
ulica VARCHAR2(50) NOT NULL,
nr INTEGER NOT NULL
);
CREATE TABLE stanowisko(
ID_stanowisko INTEGER PRIMARY KEY NOT NULL,
nazwa VARCHAR2(30) NOT NULL,
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
telefon NVARCHAR2(15) UNIQUE,
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

create or replace TRIGGER pracownik_add
BEFORE INSERT ON pracownik
DECLAREs
i NUMBER;
BEGIN
    SELECT COUNT(*) INTO i FROM Pracownik WHERE Pracownik.ID_stanowisko = 1;
    IF(i >= 1 AND NEW.ID_stanowisko = 1) THEN
    RAISE_APPLICATION_ERROR(-2000, 'Komendant moze byc tylko jeden');
END IF;
END;

CREATE OR REPLACE TRIGGER pensja
AFTER INSERT OR UPDATE ON pracownik FOR EACH ROW
DECLARE
pen NUMBER;
BEGIN
    Pen:=:New.pensja;
    if(pen<3500) THEN
        RAISE_APPLICATION_ERROR(-2001, 'Za malo placisz...');
END IF;
END;
/

create or replace TRIGGER pojazd_miejsca
BEFORE INSERT ON pracownik FOR EACH ROW
DECLARE
prac_sel NUMBER;
poja_sel NUMBER;
BEGIN
    SELECT COUNT(id_pojazd) INTO prac_sel FROM pracownik WHERE pracownik.id_pojazd =: NEW.id_pojazd;
    SELECT miejsca INTO poja_sel FROM pojazd WHERE pojazd.id_pojazd =: NEW.id_pojazd;

    IF (prac_sel>=poja_sel) THEN
        RAISE_APPLICATION_ERROR(-2002, 'Cos za duzo tych osob w tym pojezdzie');
    END IF;
END;
/

--ADRES--
----ID_ADRES, miasto, ulica, nr----
INSERT INTO adres VALUES(1, 'Kielce', 'Sandomierska', '1');
INSERT INTO adres VALUES(2, 'Warszawa', 'Jerozolimskie', '14');
INSERT INTO adres VALUES(3, 'Radom', 'Radomska', '1234');
INSERT INTO adres VALUES(4, 'Bydgoszcz', 'Bumsiowa', '23');
INSERT INTO adres VALUES(5, 'Krakow', 'Jana Pawła II', '53');
INSERT INTO adres VALUES(6, 'Pacanow', 'Kwasowa', '432');
INSERT INTO adres VALUES(7, 'Łomża', 'Bazaltowa', '35');
INSERT INTO adres VALUES(8, 'Nowy Sącz', 'Księciów Polskich', '60');
INSERT INTO adres VALUES(9, 'Piotrków', 'Piotrowska', '3');
INSERT INTO adres VALUES(10, 'Szczecin', 'Berlińska', '125');
INSERT INTO adres VALUES(11, 'Przemków', 'Piorunowa', '69');
INSERT INTO adres VALUES(12, 'Łódź', 'Gospody', '15');
INSERT INTO adres VALUES(13, 'Kielce', 'Domaszowice', '83');
INSERT INTO adres VALUES(14, 'Warszawa', 'Kobyłka', '93');
INSERT INTO adres VALUES(15, 'Radom', 'Packowa', '73');
INSERT INTO adres VALUES(16, 'Białystok', 'Szkolna', '17');
INSERT INTO adres VALUES(17, 'Choroszcz', 'plac Brodowicza','1');
INSERT INTO adres VALUES(18, 'Szydłowiec', 'Rynek Wielki','1');
INSERT INTO adres VALUES(19, 'Choroszcz', 'plac Brodowicza','1');
INSERT INTO adres VALUES(20, 'Radom', 'Mostowa','3');
INSERT INTO adres VALUES(21, 'Choroszcz', 'plac Brodowicza','1');
INSERT INTO adres VALUES(22, 'Jelenia Góra','Piłsudskiego','14');
INSERT INTO adres VALUES(23, 'Wejherowo', 'Rzeźnicka','12');
INSERT INTO adres VALUES(24, 'Zakopane', 'Stanisława Witkiewicza','8');
INSERT INTO adres VALUES(25, 'Warszawa', 'Jawornik','74');
INSERT INTO adres VALUES(26, 'Tarnów', 'Plac Kazimierza Wielkiego','3');
INSERT INTO adres VALUES(27, 'Białystok', 'Warszawska','59');
INSERT INTO adres VALUES(28, 'Sopot', 'Bohaterów Monte Cassino','17');
INSERT INTO adres VALUES(29, 'Wrocław', 'Ruska','62');
INSERT INTO adres VALUES(30, 'Lipinki Łużyckie', 'Główna','6');
INSERT INTO adres VALUES(31, 'Radom', 'Stanisława Wernera','10');
INSERT INTO adres VALUES(32, 'Radom', 'Żeromskiego','29');
INSERT INTO adres VALUES(33, 'Radom', 'Juliusza Słowackiego','10');
INSERT INTO adres VALUES(34, 'Radom', 'plac Jagielloński','8');
INSERT INTO adres VALUES(35, 'Radom', 'Malczewskiego','9');
INSERT INTO adres VALUES(36, 'Radom', 'Aleja Józefa','44');
INSERT INTO adres VALUES(37, 'Radom', 'Romualda Traugutta','42');
INSERT INTO adres VALUES(38, 'Radom', 'Bolesława Chrobrego','43');
INSERT INTO adres VALUES(39, 'Radom', 'Stanisława Żółkowskigeo','8');
INSERT INTO adres VALUES(40, 'Radom', 'Podwalna','22');
INSERT INTO adres VALUES(41, 'Radom', 'Jana Pawła','11');
INSERT INTO adres VALUES(42, 'Warszawa', 'Puławska','1');
INSERT INTO adres VALUES(43, 'Warszawa', 'Syreny','2');
INSERT INTO adres VALUES(44, 'Warszawa', 'Krzaka','3');
INSERT INTO adres VALUES(45, 'Warszawa', 'Matki Teresy','22');
INSERT INTO adres VALUES(46, 'Warszawa', 'Lecha Kaczyńskiego','14');
INSERT INTO adres VALUES(47, 'Warszawa', 'Św Judasza','44');
INSERT INTO adres VALUES(48, 'Warszawa', 'Judasza','13');
INSERT INTO adres VALUES(49, 'Warszawa', 'Myszki','44');
INSERT INTO adres VALUES(50, 'Warszawa', 'Klawiatury','22');
INSERT INTO adres VALUES(51, 'Warszawa', 'Ceplusplusa','100');
INSERT INTO adres VALUES(52, 'Warszawa', 'pythona','21');
INSERT INTO adres VALUES(53, 'Kielce', 'Waligóry','211');
INSERT INTO adres VALUES(55, 'Kielce', 'Lisowskiego','41');
INSERT INTO adres VALUES(56, 'Kielce', 'Wesoła','44');
INSERT INTO adres VALUES(57, 'Kielce', 'Niemiecka','43');
INSERT INTO adres VALUES(58, 'Kielce', 'Szczecińska','80');
INSERT INTO adres VALUES(59, 'Kielce', 'Judasza','37');
INSERT INTO adres VALUES(60, 'Kielce', 'Wrocławska','11');
INSERT INTO adres VALUES(61, 'Kielce', 'Radomska','1');
INSERT INTO adres VALUES(62, 'Kielce', 'Kielecka','4');
INSERT INTO adres VALUES(63, 'Kielce', 'Lekka','5');
INSERT INTO adres VALUES(64, 'Kielce', 'Niska','3');





--STANOWISKO--
---ID_STANOWISKO, NAZWA, OPIS
INSERT INTO stanowisko VALUES(1, 'Komendant', 'Komendant powiatowy strazy pożarnej');
INSERT INTO stanowisko VALUES(2, 'Jednostka ratownicza', 'Jednostka ratownicza z wykwalifikowanym personelem');
INSERT INTO stanowisko VALUES(3, 'Zastępca komendanta', 'Zastępca komendanta powiatowego straży pożarnej');
INSERT INTO stanowisko VALUES(4, 'Wydział szkoleniowy', 'Wydział szkoleniowy nowych jednostek straży pożarnej');
INSERT INTO stanowisko VALUES(5, 'Wydział kadrowy', 'Stanowisko kadrowe w straży pożarnej');

--ZMIANA--
---ID_ZMIANA, numer_zmiany, dzien---
INSERT INTO zmiana VALUES(1, 1, DATE'2020-12-31');
INSERT INTO zmiana VALUES(2, 2, DATE'2020-12-31');
INSERT INTO zmiana VALUES(3, 3, DATE'2020-12-31');
INSERT INTO zmiana VALUES(4, 1, DATE'2021-01-01');
INSERT INTO zmiana VALUES(5, 2, DATE'2021-01-01');
INSERT INTO zmiana VALUES(6, 3, DATE'2021-01-01');
INSERT INTO zmiana VALUES(7, 1, DATE'2021-01-02');
INSERT INTO zmiana VALUES(8, 2, DATE'2021-01-02');
INSERT INTO zmiana VALUES(9, 3, DATE'2021-01-02');
INSERT INTO zmiana VALUES(10, 1, DATE'2021-01-03');
INSERT INTO zmiana VALUES(11, 2, DATE'2021-01-03');
INSERT INTO zmiana VALUES(12, 3, DATE'2021-01-03');
INSERT INTO zmiana VALUES(13, 1, DATE'2021-01-04');
INSERT INTO zmiana VALUES(14, 2, DATE'2021-01-04');
INSERT INTO zmiana VALUES(15, 3, DATE'2012-01-04');

--SPRZET--
----ID_item, nazwa, opis, ilosc----
INSERT INTO sprzet VALUES(1, 'Gasnica', 'Słuzy do gaszenia pożarów', 4);
INSERT INTO sprzet VALUES(2, 'Siekiera', 'Używane podczas gaszenia pożarów', 6);
INSERT INTO sprzet VALUES(3, 'Hełm strażacki', 'Zapewnia bezpieczeństwo głowy', 8);
INSERT INTO sprzet VALUES(4, 'Kurtka strażacka', 'Zapewnia bezpieczeństwo tułowia', 8);
INSERT INTO sprzet VALUES(5, 'Spodnie strażackie', 'Zapewnia bezpieczeństwo nóg', 8);
INSERT INTO sprzet VALUES(6, 'Koc materialowy', 'Ogrzewa ciało', 3);
INSERT INTO sprzet VALUES(7, 'Koc termoizolacyjny', 'Wstrzymuje ciepło ciała', 6);
INSERT INTO sprzet VALUES(8, 'Rękawice strażackie', 'Zapewnia bezpieczeństwo dłoniom', 8);
INSERT INTO sprzet VALUES(9, 'Maska tlenowa', 'Pomaga oddychać gdy nie ma powietrza', 8);
INSERT INTO sprzet VALUES(10, 'Butla tlenowa', 'Trzyma tlen dla maski tlenowej', 8);
INSERT INTO sprzet VALUES(11, 'Filtr do maski', 'Filtr do maski gazowej', 8);
INSERT INTO sprzet VALUES(12, 'Drabina krótka', 'Drabina krótka 10m', 1);
INSERT INTO sprzet VALUES(13, 'Drabina długa', 'Drabina długa 30m', 1);
INSERT INTO sprzet VALUES(14, 'Plandeka', 'Łapie spadające ciała', 2);
INSERT INTO sprzet VALUES(15, 'Nożyce', 'Przecina metal', 3);

--JEDNOSTKA--
---ID_JEDNOSTKA, NAZWA, ID_ADRES
INSERT INTO jednostka VALUES(1, 'Pierwsza jednostka straży pożarnej w Kielcach', 1);
INSERT INTO jednostka VALUES(2, 'Pierwsza jednostka straży pożarnej w Warszawie', 2);
INSERT INTO jednostka VALUES(3, 'Piąta jednostka lotnicza Radom', 3);
INSERT INTO jednostka VALUES(4, 'Jednostka straży pożarnej im. Marka Bizona', 4);

--JURYSDYKCJA--
---ID_TEREN, POWIERZCHNIA, ID_JEDNOSTKA
INSERT INTO jurysdykcja VALUES(1, '100 km^', 1);
INSERT INTO jurysdykcja VALUES(2, '15 km', 2);
INSERT INTO jurysdykcja VALUES(3, '35 km', 3);
INSERT INTO jurysdykcja VALUES(4, '59 km', 4);

--RODZAJ--
----ID_RODZAJ, NAZWA, OPIS
INSERT INTO rodzaj VALUES(1, 'Pożar mały', 'Wybuch ognia w rejonie na jedną jednostkę straży');
INSERT INTO rodzaj VALUES(2, 'Pożar średni', 'Wybuch ognia w rejonie na dwie jednostki straży');
INSERT INTO rodzaj VALUES(3, 'Pożar duży', 'Wybuch ognia w rejonie na ponad dwie jednostki straży');
INSERT INTO rodzaj VALUES(4, 'Wyciek gazu', 'Wyciek gazu propan butan w rejonie');
INSERT INTO rodzaj VALUES(5, 'Wybuch gazu', 'Wybuch gazu propan butan w rejonie');
INSERT INTO rodzaj VALUES(6, 'Wypadek mały', 'Wypadek samochodowy z zapotrzebowaniem jednej jednostki straży');
INSERT INTO rodzaj VALUES(7, 'Wypadek duży', 'Duży wypadek samochodowy na dwie jednostki straży');
INSERT INTO rodzaj VALUES(8, 'Karambol', 'Wypadek samochodowy o dużej skali potencjalnych rannych');
INSERT INTO rodzaj VALUES(9, 'Kot na drzewie', 'Kot na drzewie o małym priorytecie ratowniczym');
INSERT INTO rodzaj VALUES(10, 'Pożar na polu', 'Pożar na polu spowodowany ogniem na suchej powierzchni');
INSERT INTO rodzaj VALUES(11, 'Pożar w lesie', 'Pożar w lesie');
INSERT INTO rodzaj VALUES(12, 'Alarm bombowy', 'Zgłoszenie bomby w miejscu publicznym');
INSERT INTO rodzaj VALUES(13, 'Wybuch bombowy', 'Wybuch materiałów wybuchowych w miejscu publicznym');
INSERT INTO rodzaj VALUES(14, 'Próba samobójcza', 'Zgłoszenie próby samobójczej w miejscu publicznym');
INSERT INTO rodzaj VALUES(15, 'Fałszywy alarm', 'Fałszywe wezwanie straży pożarnej');

--POJAZD--
----ID_POAJZD, TYP, MODEL, REJESTRACJA, MIEJSCA
INSERT INTO pojazd VALUES(1, 'Samochód ratowniczo – gaśniczy z autopompą', 'MANN', 'BD-12345', 7);
INSERT INTO pojazd VALUES(2, 'Samochód ratowniczo – gaśniczy z autopompą', 'SCANIA', 'BD-PL123', 12);
INSERT INTO pojazd VALUES(3, 'Samochód ratowniczo – gaśniczy z autopompą', 'SOLARIS', 'BD-7312A', 4);
INSERT INTO pojazd VALUES(4, 'Samochód ratowniczo – gaśniczy z autopompą', 'JELCZ', 'BD-420BC', 9);
INSERT INTO pojazd VALUES(5, 'Samochód ratowniczo – gaśniczy specjalny', 'MANN', 'BD-LEOPA', 2);
INSERT INTO pojazd VALUES(6, 'Samochód ratowniczo – gaśniczy specjalny', 'SCANIA', 'BD-WW213', 4);
INSERT INTO pojazd VALUES(7, 'Samochód ratowniczo – gaśniczy specjalny', 'MERCEDES BENZ', 'BD-38313', 8);
INSERT INTO pojazd VALUES(8, 'Samochód ratowniczo – gaśniczy specjalny', 'TOYOTA', 'BD-75058', 7);
INSERT INTO pojazd VALUES(9, 'Samochód z drabiną ilub podnośnikiem hydraulicznym', 'MANN', 'BD-PLOKS', 6);
INSERT INTO pojazd VALUES(10, 'Samochód z drabiną ilub podnośnikiem hydraulicznym', 'SOLARIS', 'BD-STONK', 3);
INSERT INTO pojazd VALUES(11, 'Drabina mechaniczna', 'MANN', 'BD-SZK17', 9);
INSERT INTO pojazd VALUES(12, 'Samochód zaopatrzeniowy', 'TOYOTA', 'BD-00007', 5);
INSERT INTO pojazd VALUES(13, 'Samochód zaopatrzeniowy', 'MANN', 'BD-BLA932', 4);
INSERT INTO pojazd VALUES(14, 'Samochód do przewozu osób', 'POLONEZ', 'BD-KIK23', 4);
INSERT INTO pojazd VALUES(15, 'Samochód ratownictwa technicznego', 'TOYOTA', 'BD-13484', 5);

--OSOBA--
----ID, IMIE, NAZWISKO, PESEL, TELEFON, ID_STANOWISKO, ID_ADRES----
INSERT INTO osoba VALUES(1, 'Szymon', 'Smiglarski', '09876543210', '48123123123', 1);
INSERT INTO osoba VALUES(2, 'Jacek', 'Placek', '05241857828', '6514024707', 2);
INSERT INTO osoba VALUES(3, 'Kacper', 'Wanatio', '69032896632', '38795315540', 3);
INSERT INTO osoba VALUES(4, 'Marek', 'Bizon', '86060762825', '103788939276', 4);
INSERT INTO osoba VALUES(5, 'Dobromir', 'Kaskada', '51070447976', '550538830484', 5);
INSERT INTO osoba VALUES(6, 'Dorota', 'Dorotowska', '94041577784', '369928071099', 6);
INSERT INTO osoba VALUES(7, 'Zbigniew', 'Lomnik', '82082186252', '14359049883638', 7);
INSERT INTO osoba VALUES(8, 'Wojciech', 'Suchodolski', '61051743955', '99857648647', 8);
INSERT INTO osoba VALUES(9, 'Adam', 'Wujek', '89081775434', '6636323302', 9);
INSERT INTO osoba VALUES(10, 'Piotr', 'Piotrowski', '62083088395', '75559634108973', 10);
INSERT INTO osoba VALUES(11, 'Ewa', 'Kowalska', '57071391542', '09926266999664', 11);
INSERT INTO osoba VALUES(12, 'Janusz', 'Polski', '00310412379', '76029877535', 12);
INSERT INTO osoba VALUES(13, 'Jerzy', 'Kiler', '75112146128', '44056717232', 13);
INSERT INTO osoba VALUES(14, 'Jakub', 'Konserwator', '51122341351', '5802977310', 14);
INSERT INTO osoba VALUES(15, 'Krzysztof', 'Kononowicz', '00321001821', '857191091', 15);
INSERT INTO osoba VALUES(16, 'Marcin', 'Gortat', '91073146861', '576897234', 16);
INSERT INTO osoba VALUES(17, 'Franek', 'Dolas', '71080537139', '435098123', 17);
INSERT INTO osoba VALUES(18, 'Kristoffer', 'Klauss', '00262866833', '187908765', 18);
INSERT INTO osoba VALUES(19, 'Justin', 'Hutzler', '58031767953', '187209567', 19);
INSERT INTO osoba VALUES(20, 'Lorenz', 'Moser', '59040624226', '1874428481', 20);
INSERT INTO osoba VALUES(21, 'Jan', 'Sobieski', '60021247139', '170616960', 21);
INSERT INTO osoba VALUES(22, 'Jadwiga', 'Jagiellonka', '79021538832', '140814311', 22);
INSERT INTO osoba VALUES(23, 'Andrzej', 'Lepper', '87020726332', '195420110', 23);
INSERT INTO osoba VALUES(24, 'Adam', 'Małysz', '81041099152', '197720221', 24);
INSERT INTO osoba VALUES(25, 'Kamil', 'Stoch', '71050278213', '198720221', 25);
INSERT INTO osoba VALUES(26, 'Dawid', 'Kubacki', '48022868134', '199020221', 26);
INSERT INTO osoba VALUES(27, 'Piotr', 'Żyła', '80020484598', '198720222', 27);
INSERT INTO osoba VALUES(28, 'Johann', 'Bach', '03261414373', '168517501', 28);
INSERT INTO osoba VALUES(29, 'Jan', 'Łośrodo', '68723518312', '197020201', 29);
INSERT INTO osoba VALUES(30, 'Jarosław', 'Mexicano', '6509313981', '789235711', 30);
INSERT INTO osoba VALUES(31, 'Jarosław', 'Jarząbkowski', '6522213981', '673824612', 31);
INSERT INTO osoba VALUES(32, 'Judasz', 'Niebieski', '65070671925', '62012415294', 32);
INSERT INTO osoba VALUES(33, 'Jan', 'Wons', '68063098237', '70052325954', 33);
INSERT INTO osoba VALUES(34, 'Jan', 'Jhons', '84010667435', '88083074169', 34);
INSERT INTO osoba VALUES(35, 'Krzysztof', 'Krzyż', '96041278153', '76121398517', 35);
INSERT INTO osoba VALUES(36, 'Ewa', 'Awans', '86022197258', '04301886484', 36);
INSERT INTO osoba VALUES(37, 'Sebastian', 'Nowy', '85111374631', '59051833468', 37);
INSERT INTO osoba VALUES(38, 'Jerzy', 'Jopek', '72062627549', '72100136323', 38);
INSERT INTO osoba VALUES(39, 'Kuba', 'Aligator', '58100656144', '71090941135', 39);
INSERT INTO osoba VALUES(40, 'Roman', 'Niewiadomski', '50121881819', '00312587981', 40);
INSERT INTO osoba VALUES(41, 'Szymon', 'Niewidomski', '50121883339', '00312584441', 41);
INSERT INTO osoba VALUES(42, 'Norbert', 'Trap', '53101327699', '94121913859', 42);
INSERT INTO osoba VALUES(43, 'Patrycja', 'Aneksowa', '97090151958', '58022714359', 43);
INSERT INTO osoba VALUES(44, 'Alicja', 'Asteroida', '04271334837', '98082098558', 44);
INSERT INTO osoba VALUES(45, 'Anna', 'Akrobata', '56112986378', '74060377839', 45);
INSERT INTO osoba VALUES(46, 'Asterix', 'Obelix', '74021736419', '57021195592', 46);
INSERT INTO osoba VALUES(47, 'Ksawery', 'Rower', '73102353714', '73020975821', 47);
INSERT INTO osoba VALUES(48, 'Ramses', 'Drugi', '98042849358', '84031037657', 48);
INSERT INTO osoba VALUES(49, 'Iga', 'Głosowa', '90050792813', '47072132848', 49);
INSERT INTO osoba VALUES(50, 'Artur', 'Kruk', '02322061644', '52110156551', 50);
INSERT INTO osoba VALUES(51, 'Rafał', 'Gil', '70012894849', '55040175878', 51);
INSERT INTO osoba VALUES(52, 'Kuba', 'Wrona', '85121922132', '01210634764', 52);
INSERT INTO osoba VALUES(53, 'Stanisław', 'Moniuszko', '74020575349', '78113036913', 53);
INSERT INTO osoba VALUES(54, 'Barbara', 'Kwarc', '96012694159', '93020974255', 54);
INSERT INTO osoba VALUES(55, 'Michał', 'Mroczek', '59111229314', '86100841563', 55);
INSERT INTO osoba VALUES(56, 'Judasz', 'Pazerny', '71030679326', '77110834678', 56);
INSERT INTO osoba VALUES(57, 'Bogdan', 'Boner', '75081876268', '05220379684', 57);
INSERT INTO osoba VALUES(58, 'Marcin', 'Syberian', '64042213738', '73012737695', 58);
INSERT INTO osoba VALUES(59, 'Jan', 'Polit', '84121592756', '75092374582', 59);
INSERT INTO osoba VALUES(60, 'Karol', 'Polip', '74011758393', '89092732392', 61);
INSERT INTO osoba VALUES(61, 'Agata', 'Fiata', '51070913466', '78041825191', 62);
INSERT INTO osoba VALUES(62, 'Iza', 'Matiza', '82060616133', '51081868247', 63);



--PRACOWNIK--
----PRACOWNIK, OSOBA, POJAZD, ZMIANA, STANOWISKO, JEDNOSTKA, PENSJA, STARZ
INSERT INTO pracownik VALUES(1, 1, 1, 1, 1, 1, 10000, 10);
INSERT INTO pracownik VALUES(2, 2, 2, 2, 2, 2, 3600, 5);
INSERT INTO pracownik VALUES(3, 3, 9, 3, 2, 3, 4200, 11);
INSERT INTO pracownik VALUES(4, 4, 12, 1, 2, 4, 4100, 5);
INSERT INTO pracownik VALUES(5, 5, 15, 2, 3, 1, 4900, 1);
INSERT INTO pracownik VALUES(6, 6, 1, 3, 3, 2, 4100, 2);
INSERT INTO pracownik VALUES(7, 7, 2, 2, 4, 3, 4100, 6);
INSERT INTO pracownik VALUES(8, 8, 2, 4, 4, 2, 4100, 2);
INSERT INTO pracownik VALUES(9, 31, 2, 4, 5, 3, 6000, 5);
INSERT INTO pracownik VALUES(10, 32, 3, 5, 2, 2, 3900, 5);
INSERT INTO pracownik VALUES(11, 33, 3, 2, 2, 3, 5000, 2);
INSERT INTO pracownik VALUES(12, 34, 4, 2, 5, 4, 4100, 3);
INSERT INTO pracownik VALUES(13, 43, 5, 2, 2, 1, 4100, 5);
INSERT INTO pracownik VALUES(14, 44, 5, 5, 2, 2, 4000, 5);
INSERT INTO pracownik VALUES(15, 45, 6, 4, 3, 3, 4200, 12);
INSERT INTO pracownik VALUES(16, 46, 6, 4, 3, 3, 4400, 4);
INSERT INTO pracownik VALUES(17, 57, 7, 1, 4, 4, 4700, 2);
INSERT INTO pracownik VALUES(18, 58, 7, 1, 4, 2, 5000, 1);
INSERT INTO pracownik VALUES(19, 56, 11, 3, 5, 4, 6000, 8);

--STATUS--
----ID_STATUS, STATUS_ZGLOSZENIA, DATA_ROZPOCZECIA, DATA_ZAKONCZENIA, ID_POAJZD
INSERT INTO status VALUES(1, 'Zakonczony', DATE'2020-12-30', DATE'2020-12-31', 1);
INSERT INTO status VALUES(2, 'Zakonczony', DATE'2020-01-31', DATE'2020-02-01', 1);
INSERT INTO status VALUES(3, 'Zakonczony', DATE'2001-09-11', DATE'2001-09-12', 1);
INSERT INTO status VALUES(4, 'Zakonczony', DATE'2020-10-24', DATE'2020-10-24', 1);
INSERT INTO status VALUES(5, 'Zakonczony', DATE'2020-06-30', DATE'2020-06-30', 1);
INSERT INTO status VALUES(6, 'Zakonczony', DATE'2019-12-30', DATE'2019-12-31', 1);
INSERT INTO status VALUES(7, 'Zakonczony', DATE'2016-05-04', DATE'2016-05-04', 1);
INSERT INTO status VALUES(8, 'Zakonczony', DATE'2018-12-30', DATE'2015-12-31', 1);
INSERT INTO status VALUES(9, 'Zakonczony', DATE'2013-02-17', DATE'2013-02-17', 1);
INSERT INTO status VALUES(10, 'Zakonczony', DATE'2021-09-01', DATE'2021-09-01', 1);
INSERT INTO status VALUES(11, 'Zakonczony', DATE'2017-07-24', DATE'2017-07-24', 1);
INSERT INTO status VALUES(12, 'Zakonczony', DATE'2021-12-31', DATE'2022-01-01', 1);
INSERT INTO status VALUES(13, 'W trakcie', DATE'2022-01-01', NULL, 1);
INSERT INTO status VALUES(14, 'W trakcie', DATE'2022-01-02', NULL, 1);
INSERT INTO status VALUES(15, 'W trakcie', DATE'2022-01-02', NULL, 1);

--ZGLOSZENIE--
----ID_ZGLOSZ, DATA, ID_STATUS, ID_OSOBA, ID_RODZAJ, ID_ADRES
INSERT INTO zgloszenie VALUES(1, DATE'2022-01-01', 13, 1, 15, 1);
INSERT INTO zgloszenie VALUES(2, DATE'2013-02-17', 9, 2, 2, 2);
INSERT INTO zgloszenie VALUES(3, DATE'2020-10-24', 4, 3, 15, 3);

--WYPOSAZENIE--
--ID_WYPOSAZENIE, ID_POJAZD, ID_ITEM, ILOSC
insert into wyposazenie values(1,1,1,1);
insert into wyposazenie values(2,2,2,1);
insert into wyposazenie values(3,3,3,1);
insert into wyposazenie values(4,4,4,1);
insert into wyposazenie values(5,5,5,1);
insert into wyposazenie values(6,6,6,1);
insert into wyposazenie values(7,7,7,1);
insert into wyposazenie values(8,8,8,1);
insert into wyposazenie values(9,9,9,1);
insert into wyposazenie values(10,10,10,1);
insert into wyposazenie values(11,11,11,1);
insert into wyposazenie values(12,12,12,1);
insert into wyposazenie values(13,13,13,1);
insert into wyposazenie values(14,14,14,1);
insert into wyposazenie values(15,15,15,1);

COMMIT;
SET ECHO OFF
