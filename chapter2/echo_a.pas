{ complete echo }
program echo (input, output);
const
    ENDSTR = 0;
    MAXSTR = 1024;
    ENDFILE = -1;
    NEWLINE = 10;   { ASCII value }
    BLANK = 32;
type
    character = -1..127;    { ASCII, plus ENDFILE }
    string = array [1..MAXSTR] of character;

{ putc -- put one character on standard output }
procedure putc (c : character);
begin
    if (c = NEWLINE) then
        writeln
    else
        write(chr(c))
end;

{ length -- compute length of string }
function length (var s : string) : integer;
var
    n : integer;
begin
    n := 1;
    while (s[n] <> ENDSTR) do
        n := n + 1;
    length := n - 1
end;

{ getarg -- copy n-th command line argument into s }
{   uses the function paramstr(n), which returns the nth argument }
function getarg (n : integer; var s : string; maxs : integer) : boolean;
var
    arg : array [1..MAXSTR] of char;
    i, lnb : integer;
begin
    lnb := 0;
    if (n >= 0) and (n <= paramcount) then begin   { in the list }
        arg := paramstr(n);     { get the argument}
        for i := 1 to MAXSTR-1 do begin
            s[i] := ord(arg[i]);
            if arg[i] <> ' ' then
                lnb := i
        end;
        getarg := true
    end
    else
        getarg := false;
    s[lnb+1] := ENDSTR
end;

{ nargs -- get number of arguments, implemented as non-primitive }
function nargs : integer;
var
    i : integer;
    s : string;
begin
    i := 1;
    while (getarg(i, s, MAXSTR)) do
        i := i + 1;
    nargs := i - 1
end;

{ echo -- echo command line arguments to output }
procedure echo;
var
    i, j : integer;
    argstr : string;
begin
    for i := 1 to nargs() do begin
        getarg(i, argstr, MAXSTR);
        if (i > 1) then
            putc(BLANK);
        for j := 1 to length(argstr) do
            putc(argstr[j]);
    end;
    if (i >= 1) then
        putc(NEWLINE)
end;

begin   { main program }
    echo
end.
