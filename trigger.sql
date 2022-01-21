--Trigger1--
create or replace trigger pracownik_add
BEFORE INSERT ON pracownik FOR EACH ROW DECLARE
licz NUMBER(10);
BEGIN
    SELECT MIN(id_stanowisko) INTO licz FROM pracownik;
    if(licz = :NEW.ID_stanowisko)
    then
    RAISE_APPLICATION_ERROR(-2000, 'Komendant moze byc tylko jeden');
END IF;
END;

--Trigger2--
CREATE SEQUENCE osoba_ad_seq
START WITH     31
INCREMENT BY   1;

CREATE OR REPLACE VIEW osoba_view AS 
SELECT id_osoby, imie, nazwisko, pesel, telefon, id_adres from osoba;

CREATE OR REPLACE TRIGGER osoba_trigger
INSTEAD OF INSERT ON osoba_view FOR EACH ROW
BEGIN
INSERT INTO Osoba VALUES(osoba_ad_seq.nextval, :NEW.imie, :NEW.nazwisko, :NEW.pesel, :NEW.telefon, :NEW.id_adres);
END;

--Trigger3--
CREATE SEQUENCE zgloszenie_seq
START WITH 4
INCREMENT BY 1;

CREATE OR REPLACE TRIGGER zgloszenia_up_trigger
before insert on zgloszenie for each row declare
data_obecna date;
BEGIN
select sysdate into data_obecna from dual;
insert into zgloszenie values (zgloszenie_seq.nextval, data_obecna, :NEW.id_status, :NEW.id_osoba, :NEW.id_rodzaj, :NEW.id_adres);
END;





