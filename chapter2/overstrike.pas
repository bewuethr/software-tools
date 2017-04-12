{ complete overstrike }
program overstrike (input, output);
const
    ENDFILE = -1;
    NEWLINE = 10;   { ASCII value }
    BLANK = 32;
    BACKSPACE = 8;
    PLUS = 43;
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

{ max -- compute maximum of two integers }
function max (x, y : integer) : integer;
begin
    if (x > y) then
        max := x
    else
        max := y
end;

{ overstrike -- convert backspaces into multiple lines }
procedure overstrike;
const
    SKIP = BLANK;
    NOSKIP = PLUS;
var
    c : character;
    col, newcol, i : integer;
begin
    col := 1;
    repeat
        newcol := col;
        while (getc(c) = BACKSPACE) do  { eat backspaces }
            newcol := max(newcol-1, 1);
        if (newcol < col) then begin
            putc(NEWLINE);  { start overstrike line }
            putc(NOSKIP);
            for i := 1 to newcol-1 do
                putc(BLANK);
            col := newcol
        end
        else if (col = 1) and (c <> ENDFILE) then
            putc(SKIP); { normal line}
        { else middle of line }
        if (c <> ENDFILE) then begin
            putc(c);    { normal character}
            if (c = NEWLINE) then
                col := 1
            else
                col := col + 1
        end
    until (c = ENDFILE)
end;

begin   { main program }
    overstrike
end.
