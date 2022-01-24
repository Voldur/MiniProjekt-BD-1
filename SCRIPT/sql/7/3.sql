PROMPT
SET ECHO ON
Create or replace function cursor3
RETURN NUMBER
IS
CURSOR cur3 IS
    SELECT pracownik.pensja, adres.miasto from pracownik
    inner join osoba on pracownik.id_osoba = osoba.id_osoby
    inner join adres on adres.id_adres = osoba.id_adres
    Where adres.miasto='Radom';
srednia NUMBER :=0;
l_prac NUMBER :=0;
buffor cur3%rowtype;
BEGIN
OPEN cur3;
LOOP
    FETCH cur3 INTO buffor;
    EXIT WHEN cur1%NOTFOUND;
    l_prac := l_prac + 1;
    srednia := srednia + buffor.pensja;
END LOOP;
CLOSE cur3;
RETURN srednia/l_prac;
END;
/
SET ECHO OFF
PROMPT