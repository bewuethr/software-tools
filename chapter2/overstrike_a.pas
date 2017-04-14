{ complete overstrike, don't limit backspacing to first column }
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

{ overstrike -- convert backspaces into multiple lines }
procedure overstrike;
const
    SKIP = BLANK;
    NOSKIP = PLUS;
var
    c : character;
    col, newcol, i : integer;
    ccflag : boolean;
begin
    col := 1;
    ccflag := false;
    repeat
        newcol := col;
        while (getc(c) = BACKSPACE) do  { eat backspaces }
            newcol := newcol - 1;
        if (newcol < col) then begin
            putc(NEWLINE);  { start overstrike line }
            putc(NOSKIP);
            if (newcol > 1) then
                for i := 1 to newcol-1 do
                    putc(BLANK);
            col := newcol
        end
        else if (col = 1) and (c <> ENDFILE) and not (ccflag) then begin
            putc(SKIP); { normal line}
            ccflag := true
        end;
        { else middle of line }
        if (c <> ENDFILE) then begin
            if (col >= 1) or (c = NEWLINE) then
                putc(c);    { normal character}
            if (c = NEWLINE) then begin
                col := 1;
                ccflag := false
            end
            else
                col := col + 1
        end
    until (c = ENDFILE)
end;

begin   { main program }
    overstrike
end.
