PROMPT
SET ECHO ON
Create or replace function cursor2
RETURN NUMBER
IS
CURSOR cur2 IS
    SELECT pracownik.pensja, adres.miasto from pracownik
    inner join osoba on pracownik.id_osoba = osoba.id_osoby
    inner join adres on adres.id_adres = osoba.id_adres
    Where adres.miasto='Warszawa';
srednia NUMBER :=0;
l_prac NUMBER :=0;
buffor cur2%rowtype;
BEGIN
OPEN cur2;
LOOP
    FETCH cur2 INTO buffor;
    EXIT WHEN cur1%NOTFOUND;
    l_prac := l_prac + 1;
    srednia := srednia + buffor.pensja;
END LOOP;
CLOSE cur2;
RETURN srednia/l_prac;
END;
/
SET ECHO OFF
PROMPT