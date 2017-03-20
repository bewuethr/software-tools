{ complete detab with tabstops containing number of columns to next tab, zero terminated }
program detabprog (input, output);
const
    ENDFILE = -1;
    NEWLINE = 10;   { ASCII value }
    BLANK = 32;
    BACKSPACE = 8;
    TAB = 9;
type
    character = -1..127;    { ASCII, plus ENDFILE }

{ getc -- get one character from standard input }
function getc (var c : character) : character;
var
    ch : char;
begin
    if (eof) then
        c := ENDFILE
    else if (eoln) then begin
        readln;
        c := NEWLINE
    end
    else begin
        read(ch);
        c := ord(ch)
    end;
    getc := c
end;

{ putc -- put one character on standard output }
procedure putc (c : character);
begin
    if (c = NEWLINE) then
        writeln
    else
        write(chr(c))
end;

{ detab -- convert tabs to equivalent number of blanks }
procedure detab;
const
    MAXLINE = 16000;
type
    tabtype = array [1..MAXLINE] of integer;
var
    c : character;
    col : integer;
    tabstops : tabtype;

{ tabpos -- return true if col is a tab stop }
function tabpos (col : integer; var tabstops : tabtype) : boolean;
var
    i, sum : integer;
begin
    if (col > MAXLINE) then begin
        tabpos := true;
        exit
    end
    else begin
        i := 1;
        sum := 0;
        while (tabstops[i] <> 0) do begin
            sum := sum + tabstops[i];
            if (sum = col) then begin
                tabpos := true;
                exit
            end;
            i := i + 1
        end
    end;
    tabpos := false
end;

{ settabs -- set initial tab stops }
procedure settabs (var tabstops : tabtype);
const
    TABSPACE = 4;   { 4 spaces per tab }
var
    i, pos : integer;
begin
    tabstops[1] := 1;
    i := 2;
    pos := tabstops[1] + TABSPACE;
    while (pos <= MAXLINE) do begin
        tabstops[i] := TABSPACE;
        i := i + 1;
        pos := pos + TABSPACE
    end;
    tabstops[i] := 0
end;

begin
    settabs(tabstops);  { set initial tab stops }
    col := 1;
    while (getc(c) <> ENDFILE) do
        if (c = TAB) then
            repeat
                putc(BLANK);
                col := col + 1
            until (tabpos(col, tabstops))
        else if (c = NEWLINE) then begin
            putc(NEWLINE);
            col := 1
        end
        else if (c = BACKSPACE) then begin
            putc(BACKSPACE);
            if (col > 1) then
                col := col - 1
        end
        else begin
            putc(c);
            col := col + 1
        end
end;

begin   { main program }
    detab
end.
