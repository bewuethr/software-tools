{ complete wordcount }
program wordcountprog (input, output);
const
    ENDFILE = -1;
    NEWLINE = 10;   { ASCII value }
    BLANK = 32;
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

{ wordcount -- count words in standard input }
procedure wordcount;
var
    nw : integer;
    c : character;
    inword : boolean;
begin
    nw := 0;
    inword := false;
    while (getc(c) <> ENDFILE) do
        if (c = BLANK) or (c = NEWLINE) or (c = TAB) then
            inword := false
        else if (not inword) then begin
            inword := true;
            nw := nw + 1
        end;
    putdec(nw, 1);
    putc(NEWLINE);
end;

begin   { main program }
    wordcount
end.
