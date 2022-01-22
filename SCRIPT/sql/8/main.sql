$CLS
PROMPT Menu:
PROMPT 1. Wyzwalacz pracownik_add;
PROMPT 2. Wyzwalacz status_date;
PROMPT 3. Wyzwalacz pojazd_miejsca;
ACCEPT tmp CHAR FORMAT 'A1' DEFAULT '0' PROMPT '> '
$CLS
DEFINE CURR_DIR=&1
PROMPT tmp = &tmp
@&CURR_DIR\&tmp.sql
PROMPT # ENTER #
PAUSE
@main.sql