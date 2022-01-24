$CLS
PROMPT Menu:
PROMPT 1. Kursor Kielce;
PROMPT 2. Kursor Warszawa;
PROMPT 3. Kursor Radom;
PROMPT 4. Kursor Choroszcz;
ACCEPT tmp CHAR FORMAT 'A1' DEFAULT '0' PROMPT '> '
$CLS
DEFINE CURR_DIR=&1
PROMPT tmp = &tmp
@&CURR_DIR\&tmp.sql
PROMPT # ENTER #
PAUSE
@main.sql