$CLS
PROMPT Menu:
PROMPT 1. Test komendanta;
PROMPT 2. Test pensji;
PROMPT 3. Test miejsca w pojezdzie;
ACCEPT tmp CHAR FORMAT 'A1' DEFAULT '0' PROMPT '> '
$CLS
DEFINE CURR_DIR=&1
PROMPT tmp = &tmp
@&CURR_DIR\&tmp.sql
PROMPT # ENTER #
PAUSE
@main.sql