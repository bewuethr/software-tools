{ complete detab -- accepts list of tab stops arguments }
program detabprog (input, output);
const
    ENDSTR = 0;
    ENDFILE = -1;
    MAXSTR = 1024;
    NEWLINE = 10;   { ASCII value }
    BLANK = 32;
    PLUS = 43;
    MINUS = 45;
    BACKSPACE = 8;
    TAB = 9;
type
    character = -1..127;    { ASCII, plus ENDFILE }
    string = array [1..MAXSTR] of character;

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

{ nargs -- return number of arguments }
function nargs : integer;
begin
    nargs := paramcount
end;

{ getarg -- copy n-th command line argument into s }
{   uses the function paramstr(n), which returns the nth argument }
function getarg (n : integer; var s : string; maxs : integer) : boolean;
var
    arg : array [1..MAXSTR] of char;
    i, lnb : integer;
begin
    lnb := 0;
    if (n >= 0) and (n <= paramcount) then begin   { in the list }
        arg := paramstr(n);     { get the argument}
        for i := 1 to MAXSTR-1 do begin
            s[i] := ord(arg[i]);
            if arg[i] <> ' ' then
                lnb := i
        end;
        getarg := true
    end
    else
        getarg := false;
    s[lnb+1] := ENDSTR
end;

{ isdigit -- true if c is a digit }
function isdigit (c : character) : boolean;
begin
    isdigit := c in [ord('0')..ord('9')]
end;

{ ctoi -- convert string at s[i] to integer, increment i }
function ctoi (var s : string; var i : integer) : integer;
var
    n, sign : integer;
begin
    while (s[i] = BLANK) or (s[i] = TAB) do
        i := i + 1;
    if (s[i] = MINUS) then
        sign := -1
    else
        sign := 1;
    if (s[i] = PLUS) or (s[i] = MINUS) then
        i := i + 1;
    n := 0;
    while (isdigit(s[i])) do begin
        n := 10 * n + s[i] - ord('0');
        i := i + 1;
    end;
    ctoi := sign * n
end;

{ detab -- convert tabs to equivalent number of blanks }
procedure detab;
const
    MAXLINE = 16000;
type
    tabtype = array [1..MAXLINE] of boolean;
var
    c : character;
    col : integer;
    tabstops : tabtype;

{ tabpos -- return true if col is a tab stop }
function tabpos (col : integer; var tabstops : tabtype) : boolean;
begin
    if (col > MAXLINE) then
        tabpos := true
    else
        tabpos := tabstops[col]
end;

{ settabs -- set initial tab stops }
procedure settabs (var tabstops : tabtype);
const
    TABSPACE = 4;   { 4 spaces per tab }
var
    i, k : integer;
    argstr : string;
begin
    if (nargs() > 0) then begin
        for i := 1 to MAXLINE do
            tabstops[i] := false;
        i := 1;
        while (getarg(i, argstr, MAXSTR)) do begin
            k := 1;
            tabstops[ctoi(argstr, k)] := true;
            i := i + 1
        end
    end
    else
        for i := 1 to MAXLINE do
            tabstops[i] := (i mod TABSPACE = 1)
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
