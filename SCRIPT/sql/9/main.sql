$CLS
PROMPT Menu:
PROMPT 1. Widok pojazd1;
PROMPT 2. Widok pojazdy_strazy;
PROMPT 3. Widok osoby1;
PROMPT 4. Widok zgloszenie1;
PROMPT 5. Widok jurysdykcje1;
PROMPT 6. Widok komendanci;
ACCEPT tmp CHAR FORMAT 'A1' DEFAULT '0' PROMPT '> '
$CLS
DEFINE CURR_DIR=&1
PROMPT tmp = &tmp
@&CURR_DIR\&tmp.sql
PROMPT # ENTER #
PAUSE
@main.sql