{ complete translit }
program translitprog (input, output);
label 9999;
const
    ENDFILE = -1;
    ENDSTR = 0;
    TAB = 9;
    NEWLINE = 10;   { ASCII value }
    DASH = 45;
    ATSIGN = 64;    { @ }
    ESCAPE = ATSIGN;
    CARET = 94;
    TILDE = 126;
    MAXSTR = 1024;
type
    character = -1..127;    { ASCII, plus ENDFILE }
    string = array [1..MAXSTR] of character;


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

{ index -- find position of character c in string s }
function index (var s : string; c : character) : integer;
var
    i : integer;
begin
    i := 1;
    while (s[i] <> c) and (s[i] <> ENDSTR) do
        i := i + 1;
    if (s[i] = ENDSTR) then
        index := 0
    else
        index := i
end;

{ error -- once we know how to write it }

{ addstr -- put c in outset[j] if it fits, increment j }
function addstr (c : character; var outset : string; var j : integer; maxset : integer) : boolean;
begin
    if (j > maxset) then
        addstr := false
    else begin
        outset[j] := c;
        j := j + 1;
        addstr := true
    end
end;

{ isalphanum -- true if c is letter or digit }
function isalphanum (c : character) : boolean;
begin
    isalphanum := c in
        [ord('a')..ord('z'),
         ord('A')..ord('Z'),
         ord('0')..ord('9')]
 end;

 { esc -- map s[i] into escaped character, increment i }
 function esc (var s : string; var i : integer) : character;
 begin
     if (s[i] <> ESCAPE) then
         esc := s[i]
     else if (s[i+1] = ENDSTR) then { @ not special at end }
        esc := ESCAPE
    else begin
        i := i + 1;
        if (s[i] = ord('n')) then
            esc := NEWLINE
        else if (s[i] = ord('t')) then
            esc := TAB
        else esc := s[i]
    end
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

{ translit -- map characters }
procedure translit;
const
    NEGATE = CARET; { ^ }
var
    arg, fromset, toset : string;
    c : character;
    i, lastto : 0..MAXSTR;
    allbut, squash : boolean;

{ makeset -- make set from inset[k] in outset }
function makeset (var inset : string; k : integer; var outset : string; maxset : integer) : boolean;
var
    j : integer;

{ dodash -- expand set at src[i] into dest[j], stop at delim }
procedure dodash (delim : character; var src : string; var i : integer; var dest : string;
        var j : integer; maxset : integer);
var
    k : integer;
    junk : boolean;
begin
    while (src[i] <> delim) and (src[i] <> ENDSTR) do begin
        if (src[i] = ESCAPE) then
            junk := addstr(esc(src, i), dest, j, maxset)
        else if (src[i] <> DASH) then
            junk := addstr(src[i], dest, j, maxset)
        else if (j <= 1) or (src[i+1] = ENDSTR) then
            junk := addstr(DASH, dest, j, maxset)   { literal - }
        else if (isalphanum(src[i+1]))
          and (isalphanum(src[i-1]))
          and (src[i-1] <= src[i+1]) then begin
            for k := src[i-1]+1 to src[i+1] do
                junk := addstr(k, dest, j, maxset);
            i := i + 1
        end
        else
            junk := addstr(DASH, dest, j, maxset);
        i := i + 1
    end
end;

begin
    j := 1;
    dodash(ENDSTR, inset, k, outset, j, maxset);
    makeset := addstr(ENDSTR, outset, j, maxset)
end;

{ xindex -- conditionally invert value from index }
function xindex (var inset : string; c : character; allbut : boolean; lastto : integer) : integer;
begin
    if (c = ENDFILE) then
        xindex := 0
    else if (not allbut) then
        xindex := index(inset, c)
    else if (index(inset, c) > 0) then
        xindex := 0
    else
        xindex := lastto + 1
end;

begin
    if (not getarg(1, arg, MAXSTR)) then begin
        writeln('usage: translit from to');
        goto 9999   { branch to end of program }
    end;
    allbut := (arg[1] = NEGATE);
    if (allbut) then
        i := 2
    else
        i := 1;
    if (not makeset(arg, i, fromset, MAXSTR)) then begin
        writeln('translit: "from" set too large');
        goto 9999   { branch to end of program }
    end;
    if (not getarg(2, arg, MAXSTR)) then
        toset[1] := ENDSTR
    else if (not makeset(arg, 1, toset, MAXSTR)) then begin
        writeln('translit: "to" set too large');
        goto 9999   { branch to end of program }
    end
    else if (length(fromset) < length(toset)) then begin
        writeln('translit: "from" shorter than "to"');
        goto 9999   { branch to end of program }
    end;

    lastto := length(toset);
    squash := (length(fromset) > lastto) or (allbut);
    repeat
        i := xindex(fromset, getc(c), allbut, lastto);
        if (squash) and (i >= lastto) and (lastto > 0) then begin
            putc(toset[lastto]);
            repeat
                i := xindex(fromset, getc(c), allbut, lastto)
            until (i < lastto)
        end;
        if (c <> ENDFILE) then begin
            if (i > 0) and (lastto > 0) then    { translate }
                putc(toset[i])
            else if (i = 0) then    { copy }
                putc(c)
            { else delete }
        end
    until (c = ENDFILE)
end;

begin   { main program }
    translit;
    9999:
end.
