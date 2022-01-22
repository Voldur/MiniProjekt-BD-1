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

