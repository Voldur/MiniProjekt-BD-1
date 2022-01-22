PROMPT
SET ECHO ON
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
SET ECHO OFF
PROMPT