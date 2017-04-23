{ complete compress }
program compressprog (input, output);
const
    ENDFILE = -1;
    NEWLINE = 10;   { ASCII value }
    TILDE = 126;
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

{ min -- compute minimum of two integers }
function min(x, y : integer) : integer;
begin
    if (x < y) then
        min := x
    else
        min := y
end;

{ compress -- compress standard input }
procedure compress;
const
    WARNING = TILDE;    { ~ }
var
    c, lastc : character;
    n : integer;

{ putrep -- put out representation of run of n 'c's }
procedure putrep (N : integer; c : character);
const
    MAXREP = 26;    { assuming 'A'..'Z' }
    THRESH = 4;
begin
    while (n >= THRESH) or ((c = WARNING) and (n > 0)) do begin
        putc(WARNING);
        putc(min(n, MAXREP) - 1 + ord('A'));
        putc(c);
        n := n - MAXREP
    end;
    for n := n downto 1 do
        putc(c)
end;

begin
    n := 1;
    lastc := getc(lastc);
    while (lastc <> ENDFILE) do begin
        if (getc(c) = ENDFILE) then begin
            if (n > 1) or (lastc = WARNING) then
                putrep(n, lastc)
            else
                putc(lastc)
        end
        else if (c = lastc) then
            n := n + 1
        else if (n > 1) or (lastc = WARNING) then begin
            putrep(n, lastc);
            n := 1
        end
        else
            putc(lastc);
        lastc := c
    end
end;

begin   { main program }
    compress
end.
