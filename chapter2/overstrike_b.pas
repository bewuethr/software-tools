{ complete overstrike, improved to print fewer lines }
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
    MAXLINE = 16000;
type
    linetype = array [1..MAXLINE] of character;
var
    c : character;
    col, printed, i : integer;
    overline : linetype;
    inover : boolean;

{ initline -- initialize overstrike line to null bytes }
procedure initline (var overline : linetype);
var
    i : integer;
begin
    for i := 1 to MAXLINE do
        overline[i] := 0
end;

{ isempty -- checks if argument contains any non-null characters }
function isempty (overline : linetype) : boolean;
var
    i : integer;
begin
    for i := 1 to MAXLINE do
        if (overline[i] <> 0) then begin
            isempty := false;
            exit
        end;
    isempty := true
end;

{ printline -- print overstrike line if applicable }
procedure printline (overline : linetype);
var
    i, j, nextchar : integer;
begin
    if (isempty(overline)) then { line is empty }
        exit;
    putc(NOSKIP);
    i := 1;
    nextchar := 1;
    while (true) do begin
        while (overline[nextchar] = 0) do begin
            nextchar := nextchar + 1;
            if (nextchar = MAXLINE) then begin
                { putc(NEWLINE); }
                exit
            end
        end;
        for j := i to nextchar-1 do
            putc(BLANK);
        putc(overline[nextchar]);
        nextchar := nextchar + 1;
        i := nextchar
    end
end;

begin
    initline(overline);
    col := 1;
    printed := 0;
    inover := false;
    repeat
        while (getc(c) = BACKSPACE) do  { eat backspaces }
            col := max(col - 1, 1);
        if (col > printed) and (c <> ENDFILE) then begin
            if (col = 1) and not (inover) then
                putc(SKIP);
            putc(c);
            printed := col
        end
        else if (overline[col] = 0) and (c <> NEWLINE) then
            overline[col] := c
        else if (overline[col] <> 0) and (c <> NEWLINE) then begin   { character is overstruck for the second time }
            putc(NEWLINE);
            printline(overline);
            initline(overline);
            putc(NEWLINE);  { start second overstrike line }
            putc(NOSKIP);
            for i := 1 to col-1 do
                putc(BLANK);
            putc(c);
            printed := col - 1;
            inover := true;
            continue
        end;
        if (c = NEWLINE) then begin
            if (col < printed) then
                putc(NEWLINE);
            col := 1;
            printed := 0;
            inover := false;
            printline(overline);
            initline(overline)
        end
        else
            col := col + 1
    until (c = ENDFILE)
end;

begin   { main program }
    overstrike
end.
