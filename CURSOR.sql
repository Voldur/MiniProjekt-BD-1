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


Create or replace function cursor2
RETURN NUMBER
IS
CURSOR cur2 IS
    SELECT osoba.imie, osoba.nazwisko, pracownik.pensja from osoba
    inner join pracownik on osoba.id_osoby=pracownik.id_osoba
    Where pracownik.id_stanowisko=1;
l_prac NUMBER :=0;
buffor cur2%rowtype;
BEGIN
OPEN cur2;
LOOP
    FETCH cur2 INTO buffor;
    EXIT WHEN cur2%NOTFOUND;
    l_prac := l_prac + 1;
    UPDATE pracownik SET pensja=pensja*2 WHERE id_stanowisko=1;
END LOOP;
CLOSE cur2;
RETURN l_prac;
END;
/

Create or replace function cursor3
RETURN NUMBER
IS
CURSOR cur3 IS
    SELECT osoba.imie, osoba.nazwisko, pracownik.pensja from osoba
    inner join pracownik on osoba.id_osoby=pracownik.id_osoba
    Where pracownik.id_stanowisko=5;
l_prac NUMBER :=0;
buffor cur3%rowtype;
BEGIN
OPEN cur3;
LOOP
    FETCH cur3 INTO buffor;
    EXIT WHEN cur3%NOTFOUND;
    l_prac := l_prac + 1;
    UPDATE pracownik SET pensja=pensja/2 WHERE id_stanowisko=5;
END LOOP;
CLOSE cur3;
RETURN l_prac;
END;
/

Create or replace function cursor4
RETURN NUMBER
IS
CURSOR cur4 IS
    SELECT osoba.imie, osoba.nazwisko, pracownik.pensja from osoba
    inner join pracownik on osoba.id_osoby=pracownik.id_osoba
    Where pracownik.id_pojazd=1;
l_prac NUMBER :=0;
buffor cur4%rowtype;
BEGIN
OPEN cur4;
LOOP
    FETCH cur4 INTO buffor;
    EXIT WHEN cur4%NOTFOUND;
    l_prac := l_prac + 1;
    UPDATE pracownik SET pensja=pensja+1000 WHERE id_pojazd=1;
END LOOP;
CLOSE cur4;
RETURN l_prac;
END;
/