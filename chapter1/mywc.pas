{ complete mywc }
program mywcprog (input, output);
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

{ mywc -- count characters, lines and words in standard input }
procedure mywc;
var
    nc, nl, nw : integer;
    c : character;
    inword : boolean;
begin
    nc := 0;
    nl := 0;
    nw := 0;
    inword := false;
    while (getc(c) <> ENDFILE) do begin
        nc := nc + 1;
        if (c = NEWLINE) then
            nl := nl + 1;
        if (c = BLANK) or (c = NEWLINE) or (c = TAB) then
            inword := false
        else if (not inword) then begin
            inword := true;
            nw := nw + 1
        end;
    end;
    putdec(nl, 1);
    putc(TAB);
    putdec(nw, 2);
    putc(TAB);
    putdec(nc, 3);
    putc(NEWLINE);
end;

begin   { main program }
    mywc
end.
