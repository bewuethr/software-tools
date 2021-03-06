{ complete expand minus all the error checks }
program expand (input, output);
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

{ isupper -- true if c is upper case letter }
function isupper (c : character) : boolean;
begin
    isupper := c in [ord('A')..ord('Z')]
end;

{ expand -- uncompress standard input }
procedure expand;
const
    WARNING = TILDE;    { ~ }
var
    c : character;
    n : integer;
begin
    while (getc(c) <> ENDFILE) do
        if (c <> WARNING) then
            putc(c)
        else begin
            getc(c);
            n := c - ord('A') + 1;
            getc(c);
            for n := n downto 1 do
                putc(c)
        end
end;

begin   { main program }
    expand
end.
