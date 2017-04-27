{ complete compress -- compress dictionary by taking advantage of common roots }
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

{ getl -- get one line from standard input }
function getl (var s : string) : string;
begin
    readln(s);
    getl := s
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
    l, lastl : string;
    n : integer;

{ countcommon -- count number of characters in common from te start between two strings }
function countcommon (str1 : string; str2 : string) : integer;
var
    i, ctr : integer;
begin
    ctr := 0;
    for i := 1 to length(str2) do 
        if (copy(str1, i, 1) = copy(str2, i, 1)) then
            ctr := ctr + 1;
    countcommon := ctr
end;

{ putline -- print counter(s) for common prefix and rest of line }
procedure putline (N : integer; s : string);
const
    MAXREP = 94;
var
    offset : integer;
begin
    offset := 1;
    while (N >= 0) do begin
        putc(min(N, MAXREP) + ord(' '));
        offset := offset + min(N, MAXREP);
        N := N - min(N, MAXREP);
        if (N = 0) then
            break;
    end;
    writeln(copy(s, offset, length(s) - offset + 1))
end;

begin
    n := 1;
    getl(lastl);
    writeln(lastl);
    while (getl(l) <> '') do begin
        n := countcommon(lastl, l);
        putline(n, l);
        lastl := l
    end
end;

begin   { main program }
    compress
end.
