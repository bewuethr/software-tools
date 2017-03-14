{ complete charcount }
program charcountprog (input, output);
const
    ENDFILE = -1;
    NEWLINE = 10;   { ASCII value }
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

{ charcount -- count characters in standard input }
procedure charcount;
var
    nc : integer;
    c : character;
begin
    nc := 0;
    while (getc(c) <> ENDFILE) do
        nc := nc + 1;
    putdec(nc, 1);
    putc(NEWLINE);
end;

begin   { main program }
    charcount
end.
