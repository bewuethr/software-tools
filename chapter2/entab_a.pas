{ complete entab, handles backspaces and minimizes number of output characters }
program entabprog (input, output);
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

{ entab -- replace blanks by tabs and blanks }
procedure entab;
const
    MAXLINE = 16000;
type
    tabtype = array [1..MAXLINE] of boolean;
var
    c : character;
    col, newcol, idx : integer;
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
    i : integer;
begin
    for i := 1 to MAXLINE do
        tabstops[i] := (i mod TABSPACE = 1)
end;

begin
    settabs(tabstops);  { set initial tab stops }
    col := 1;
    repeat
        newcol := col;
        while (getc(c) >= 0) and ((c = BLANK) or (c = TAB) or (c = BACKSPACE)) do begin    { collect blanks }
            if (c = TAB) then begin
                repeat
                    newcol := newcol + 1
                until (tabpos(newcol, tabstops))
            end
            else if (c = BACKSPACE) then begin
                if (newcol > 1) then
                    newcol := newcol - 1
            end
            else    { it's a blank }
                newcol := newcol + 1
        end;

        if (newcol < col) then begin    { need to insert backspaces }
            for idx := col to newcol do
                putc(BACKSPACE);
            col := newcol
        end
        else if (newcol > col) then begin
            for idx := col + 1 to newcol do begin
                if (tabpos(idx, tabstops)) then begin
                    putc(TAB);
                    col := idx
                end
            end
        end;
        while (col < newcol) do begin
            putc(BLANK);    { output leftover blanks }
            col := col + 1
        end;
        if (c <> ENDFILE) then begin
            putc(c);
            if (c = NEWLINE) then
                col := 1
            else
                col := col + 1
        end
    until (c = ENDFILE)
end;

begin   { main program }
    entab
end.
