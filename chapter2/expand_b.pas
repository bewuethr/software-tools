{ complete expand -- modified getc and putc to deal with end of file }
program expand (input, output);
const
    ENDFILE = -1;
    NEWLINE = 10;   { ASCII value }
    TILDE = 126;
type
    character = -1..127;    { ASCII, plus ENDFILE }

{ getc -- get one character from standard input, set end of file flag if eof }
function getc (var c : character; var eofflag: boolean) : character;
var
    ch : char;
begin
    if (eofflag) then
        exit
    else if (eof) then begin
        c := ENDFILE;
        eofflag := true
    end
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

{ putc -- put one character on standard output if not past end of file }
procedure putc (c : character; eofflag : boolean);
begin
    if (eofflag) then
        exit
    else if (c = NEWLINE) then
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
    eofflag : boolean;
begin
    eofflag := false;
    while (getc(c, eofflag) <> ENDFILE) do
        if (c <> WARNING) then
            putc(c, eofflag)
        else if (isupper(getc(c, eofflag))) then begin
            n := c - ord('A') + 1;
            getc(c, eofflag);
            if (not eofflag) then
                for n := n downto 1 do
                    putc(c, eofflag)
            else begin
                eofflag := false;   { we want to print after all }
                putc(WARNING, eofflag);
                putc(n + ord('A') -1, eofflag);
                break
            end
        end
        else begin
            putc(WARNING, eofflag);
            putc(c, eofflag)
        end
end;

begin   { main program }
    expand
end.
