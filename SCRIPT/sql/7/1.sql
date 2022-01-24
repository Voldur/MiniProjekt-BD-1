PROMPT
SET ECHO ON
Create or replace function cursor1
RETURN NUMBER
IS
CURSOR cur1 IS
    SELECT pracownik.pensja, adres.miasto from pracownik
    inner join osoba on pracownik.id_osoba = osoba.id_osoby
    inner join adres on adres.id_adres = osoba.id_adres
    Where adres.miasto='Kielce';
srednia NUMBER :=0;
l_prac NUMBER :=0;
buffor cur1%rowtype;
BEGIN
OPEN cur1;
LOOP
    FETCH cur1 INTO buffor;
    EXIT WHEN cur1%NOTFOUND;
    l_prac := l_prac + 1;
    srednia := srednia + buffor.pensja;
END LOOP;
CLOSE cur1;
RETURN srednia/l_prac;
END;
/
SET ECHO OFF
PROMPT