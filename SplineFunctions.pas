unit SplineFunctions;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  IntervalArithmetic, System.Generics.Collections;

  function naturalSplineValueNormal (n : integer; x,fx : TList<extended>; valueAt : Extended; var err : integer) : extended;
  function naturalSplineValueInterval (n : integer; x,fx : TList<interval>; valueAt : interval; var err : integer) : interval;
  procedure naturalSplineCoeffsNormal (n : integer; x,fx : TList<extended>; var coeffs : TList<TList<extended>>; var err : integer);
  procedure naturalSplineCoeffsInterval (n : integer; x,fx : TList<interval>; var coeffs : TList<TList<interval>>; var err : integer);
  function cubicFunctionValueNormal (x, a, b, c, d : extended) : extended;
  function cubicFunctionValueInterval (x, a, b, c, d : interval) : interval;

implementation

// natural spline value in extended (normal) mode
function naturalSplineValueNormal (n : integer; x,fx : TList<extended>; valueAt : Extended; var err : integer) : extended;
var
  a : array [0..3] of extended;
  b,c,d : array of extended;
  temp ,h,hp,t : extended;
  i,j   : integer;
  fnd : boolean;

begin
  if n < 1 then err := 1 // tylko jedna liczba - za malo by wyliczac funkcje
  else if (valueAt<x[0]) or (valueAt>x[n]) then err := 3 // jezeli szukana wartosc jest poza przedzialem - zwroc err = 3
  else begin // w przeciwnym wypadku
    err := 0; // err = 0 - zakladamy ze funckja ma prawidlowe dane wejsciowe
    i := 0;
    while (i = n-1) or (err = 2) do begin // petla sprawdzajaca wezly
      i := i+1;
      for j := i+1 to n do begin
        if x[i] = x[j] then err := 2 // jezeli wezly powtarzaja sie - mamy blad - err = 2
      end;
    end;
  end;

  if (err = 0) then begin // jezeli nie ma bledu
    setLength(b, n+1); // ustawienie dlugosci tablic
    setLength(c, n+1);
    setLength(d, n+1);

    d[0] := 0;      // Mz = Mn = 0
    d[n] := 0;

    if (n>1) then begin
    // wyliczanie wspolczynnikow lambda, mikro, delta

      // dla pierwszego rownania
      h := x[1] - x[0];
      hp := x[2] - x[1];
      b[1] := hp / (hp + h);
      d[1] := 6 * ((fx[2] - fx[1])/hp - (fx[1] - fx[0])/h) / (hp + h);

      // dla ostatniego rownania
      h := x[n-1] - x[n-2];
      hp := x[n] - x[n-1];
      c[n-1] := 1 - hp / (hp + h);
      d[n-1] := 6 * ((fx[n] - fx[n-1])/hp - (fx[n-1] - fx[n-2])/h) / (hp + h);

      // dla pozostalych przedzialow
      for i := 2 to n-2 do begin
        h := x[i] - x[i-1];
        hp := x[i+1] - x[i];
        b[i] := hp / (hp + h);
        c[i] := 1 - b[i];
        d[i] := 6 * ((fx[i+1] - fx[i])/hp - (fx[i] - fx[i-1])/h) / (hp + h)
      end;

      // Wyliczanie M
      temp :=2;
      d[1] := d[1]/temp;

      if (n>2) then begin
        for i := 1 to n-2 do begin
          b[i] := b[i]/temp;
          temp :=  2 - b[i] * c[i+1];
          d[i+1] := (d[i+1] - d[i]*c[i+1])/temp;
        end;
      end;

    end;

    temp := d[n-1];

    for i := n-2 downto 1 do begin
      temp := d[i] - temp*b[i];
      d[i] := temp
    end;

    // szukanie odpowiedniego przedzialu do wyliczenia wartosci funkcji sklejanej stopnia trzeciego
    fnd :=False;
    i:=-1;
    repeat
      i:=i+1;
      if (valueAt>=x[i]) and (valueAt<=x[i+1]) then fnd:=True
    until fnd;

    // wyliczanie wspolczynnikow rownania funkcji sklejanej w wybranym przedziale
    hp := x[i+1] - x[i];
    a[0] := fx[i];
    a[1] := (fx[i+1]-fx[i])/hp - (2* d[i] + d[i+1])*hp/6;
    a[2] := d[i]/2;
    a[3] := (d[i+1] - d[i]) / (6*hp);

    // tworzenie zmiennej t - rownanie w przedziale
    t := valueAt - x[i];

    // ostateczne wyliczenie wartosci
    naturalSplineValueNormal:= a[3]*t*t*t + a[2]*t*t + a[1]*t + a[0];
  end
  else begin
    naturalSplineValueNormal := low(integer);
  end;
end;


// natural spline value in interval mode
function naturalSplineValueInterval (n : integer; x,fx : TList<interval>; valueAt : interval; var err : integer) : interval;
var
  a : array [0..3] of interval;
  b,c,d : array of interval;
  temp ,h,hp,t : interval;
  i,j   : integer;
  fnd : boolean;

begin
  if n < 1 then err := 1 // tylko jedna liczba - za malo by wyliczac funkcje
  else if (valueAt<x[0]) or (valueAt>x[n]) then err := 3 // jezeli szukana wartosc jest poza przedzialem - zwroc err = 3
  else begin // w przeciwnym wypadku
    err := 0; // err = 0 - zakladamy ze funckja ma prawidlowe dane wejsciowe
    i := 0;
    while (i = n-1) or (err = 2) do begin // petla sprawdzajaca wezly
      i := i+1;
      for j := i+1 to n do begin
        if x[i] = x[j] then err := 2 // jezeli wezly powtarzaja sie - mamy blad - err = 2
      end;
    end;
  end;

  if (err = 0) then begin // jezeli nie ma bledu
    setLength(b, n+1); // ustawienie dlugosci tablic
    setLength(c, n+1);
    setLength(d, n+1);

    d[0] := inew('0');      // Mz = Mn = 0
    d[n] := inew('0');

    if (n>1) then begin
    // wyliczanie wspolczynnikow lambda, mikro, delta

      // dla pierwszego rownania
      h := x[1] - x[0];
      hp := x[2] - x[1];
      b[1] := hp / (hp + h);
      d[1] := inew('6') * ((fx[2] - fx[1])/hp - (fx[1] - fx[0])/h) / (hp + h);

      // dla ostatniego rownania
      h := x[n-1] - x[n-2];
      hp := x[n] - x[n-1];
      c[n-1] := inew('1') - hp / (hp + h);
      d[n-1] := inew('6') * ((fx[n] - fx[n-1])/hp - (fx[n-1] - fx[n-2])/h) / (hp + h);

      // dla pozostalych przedzialow
      for i := 2 to n-2 do begin
        h := x[i] - x[i-1];
        hp := x[i+1] - x[i];
        b[i] := hp / (hp + h);
        c[i] := inew('1') - b[i];
        d[i] := inew('6') * ((fx[i+1] - fx[i])/hp - (fx[i] - fx[i-1])/h) / (hp + h)
      end;

      // Wyliczanie M
      temp := inew('2');
      d[1] := d[1]/temp;

      if (n>2) then begin
        for i := 1 to n-2 do begin
          b[i] := b[i]/temp;
          temp :=  inew('2') - b[i] * c[i+1];
          d[i+1] := (d[i+1] - d[i]*c[i+1])/temp;
        end;
      end;

    end;

    temp := d[n-1];

    for i := n-2 downto 1 do begin
      temp := d[i] - temp*b[i];
      d[i] := temp
    end;

    // szukanie odpowiedniego przedzialu do wyliczenia wartosci funkcji sklejanej stopnia trzeciego
    fnd :=False;
    i:=-1;
    repeat
      i:=i+1;
      if (valueAt>=x[i]) and (valueAt<=x[i+1]) then fnd:=True
    until fnd;

    // wyliczanie wspolczynnikow rownania funkcji sklejanej w wybranym przedziale
    hp := x[i+1] - x[i];
    a[0] := fx[i];
    a[1] := (fx[i+1]-fx[i])/hp - (inew('2')* d[i] + d[i+1])*hp/inew('6');
    a[2] := d[i]/inew('2');
    a[3] := (d[i+1] - d[i]) / (inew('6')*hp);

    // tworzenie zmiennej t - rownanie w przedziale
    t := valueAt - x[i];

    // ostateczne wyliczenie wartosci
    naturalSplineValueInterval:= a[3]*t*t*t + a[2]*t*t + a[1]*t + a[0];
  end
  else begin
    naturalSplineValueInterval.a := low(integer);
    naturalSplineValueInterval.b := low(integer);
  end;
end;



// natural spline coefficients in extended (normal) mode
procedure naturalSplineCoeffsNormal (n : integer; x,fx : TList<extended>; var coeffs : TList<TList<extended>>; var err : integer);
var
  i,j : integer;
  temp, temp2, temp3, h,hp,t : Extended;
  b,c,d : array of extended;

begin
  if n < 1 then err := 1 // tylko jedna liczba - za malo by wyliczac funkcje
  else begin // w przeciwnym wypadku
    err := 0; // err = 0 - zakladamy ze funckja ma prawidlowe dane wejsciowe
    i := 0;
    while (i = n-1) or (err = 2) do begin // petla sprawdzajaca wezly
      i := i+1;
      for j := i+1 to n do begin
        if x[i] = x[j] then err := 2 // jezeli wezly powtarzaja sie - mamy blad - err = 2
      end;
    end;
  end;

  if (err = 0) then begin // jezeli nie ma bledu
    setLength(b, n+1); // ustawienie dlugosci tablic
    setLength(c, n+1);
    setLength(d, n+1);

    d[0] := 0;      // Mz = Mn = 0
    d[n] := 0;

    if (n>1) then begin
    // wyliczanie wspolczynnikow lambda, mikro, delta

      // dla pierwszego rownania
      h := x[1] - x[0];
      hp := x[2] - x[1];
      b[1] := hp / (hp + h);
      d[1] := 6 * ((fx[2] - fx[1])/hp - (fx[1] - fx[0])/h) / (hp + h);

      // dla ostatniego rownania
      h := x[n-1] - x[n-2];
      hp := x[n] - x[n-1];
      c[n-1] := 1 - hp / (hp + h);
      d[n-1] := 6 * ((fx[n] - fx[n-1])/hp - (fx[n-1] - fx[n-2])/h) / (hp + h);

      // dla pozostalych przedzialow
      for i := 2 to n-2 do begin
        h := x[i] - x[i-1];
        hp := x[i+1] - x[i];
        b[i] := hp / (hp + h);
        c[i] := 1 - b[i];
        d[i] := 6 * ((fx[i+1] - fx[i])/hp - (fx[i] - fx[i-1])/h) / (hp + h)
      end;

      // Wyliczanie M
      temp :=2;
      d[1] := d[1]/temp;

      if (n>2) then begin
        for i := 1 to n-2 do begin
          b[i] := b[i]/temp;
          temp :=  2 - b[i] * c[i+1];
          d[i+1] := (d[i+1] - d[i]*c[i+1])/temp;
        end;
      end;

    end;

    temp := d[n-1];

    for i := n-2 downto 1 do begin
      temp := d[i] - temp*b[i];
      d[i] := temp
    end;

    //wyliczanie wspolczynnikow dla wszystkich przedzialow
    for i:=0 to n-1 do begin
      hp := x[i+1] - x[i];
      temp2 := (fx[i+1] - fx[i])/hp - (2*d[i] + d[i+1])*hp/6;
      temp3:=(d[i+1]- d[i]) / (6*hp);

      coeffs[0][i]:=((-temp3*x[i]+ d[i]/2)*x[i]-temp2)*x[i]+ fx[i];
      temp:=3*temp3*x[i];
      coeffs[1][i]:=(temp - d[i])*x[i]+temp2;
      coeffs[2][i]:= d[i]/2 - temp;
      coeffs[3][i]:=temp3;
    end
  end
end;


// natural spline coefficients in interval mode
procedure naturalSplineCoeffsInterval (n : integer; x,fx : TList<interval>; var coeffs : TList<TList<interval>>; var err : integer);
var
  i,j : integer;
  temp, temp2, temp3, h,hp,t : interval;
  b,c,d : array of interval;

begin
  if n < 1 then err := 1 // tylko jedna liczba - za malo by wyliczac funkcje
  else begin // w przeciwnym wypadku
    err := 0; // err = 0 - zakladamy ze funckja ma prawidlowe dane wejsciowe
    i := 0;
    while (i = n-1) or (err = 2) do begin // petla sprawdzajaca wezly
      i := i+1;
      for j := i+1 to n do begin
        if x[i] = x[j] then err := 2 // jezeli wezly powtarzaja sie - mamy blad - err = 2
      end;
    end;
  end;

  if (err = 0) then begin // jezeli nie ma bledu
    setLength(b, n+1); // ustawienie dlugosci tablic
    setLength(c, n+1);
    setLength(d, n+1);

    d[0] := inew('0');      // Mz = Mn = 0
    d[n] := inew('0');

    if (n>1) then begin
    // wyliczanie wspolczynnikow lambda, mikro, delta

      // dla pierwszego rownania
      h := x[1] - x[0];
      hp := x[2] - x[1];
      b[1] := hp / (hp + h);
      d[1] := inew('6') * ((fx[2] - fx[1])/hp - (fx[1] - fx[0])/h) / (hp + h);

      // dla ostatniego rownania
      h := x[n-1] - x[n-2];
      hp := x[n] - x[n-1];
      c[n-1] := inew('1') - hp / (hp + h);
      d[n-1] := inew('6') * ((fx[n] - fx[n-1])/hp - (fx[n-1] - fx[n-2])/h) / (hp + h);

      // dla pozostalych przedzialow
      for i := 2 to n-2 do begin
        h := x[i] - x[i-1];
        hp := x[i+1] - x[i];
        b[i] := hp / (hp + h);
        c[i] := inew('1') - b[i];
        d[i] := inew('6') * ((fx[i+1] - fx[i])/hp - (fx[i] - fx[i-1])/h) / (hp + h)
      end;

      // Wyliczanie M
      temp := inew('2');
      d[1] := d[1]/temp;

      if (n>2) then begin
        for i := 1 to n-2 do begin
          b[i] := b[i]/temp;
          temp :=  inew('2') - b[i] * c[i+1];
          d[i+1] := (d[i+1] - d[i]*c[i+1])/temp;
        end;
      end;

    end;

    temp := d[n-1];

    for i := n-2 downto 1 do begin
      temp := d[i] - temp*b[i];
      d[i] := temp
    end;

    //wyliczanie wspolczynnikow dla wszystkich przedzialow
    for i:=0 to n-1 do begin
      hp := x[i+1] - x[i];
      temp2 := (fx[i+1] - fx[i])/hp - (inew('2') *d[i] + d[i+1])*hp/ inew('6');
      temp3:=(d[i+1]- d[i]) / (inew('6')*hp);

      coeffs[0][i]:=((-temp3*x[i]+ d[i]/inew('2'))*x[i]-temp2)*x[i]+ fx[i];
      temp:=inew('3')*temp3*x[i];
      coeffs[1][i]:=(temp - d[i])*x[i]+temp2;
      coeffs[2][i]:= d[i]/inew('2') - temp;
      coeffs[3][i]:=temp3;
    end
  end
end;



function cubicFunctionValueNormal (x, a, b, c, d : extended) : extended;
begin
  cubicFunctionValueNormal := a*x*x*x + b*x*x + c*x + d;
end;
function cubicFunctionValueInterval (x, a, b, c, d : interval) : interval;
var
  aa : interval;
begin
  cubicFunctionValueInterval := a*x*x*x + b*x*x + c*x + d;
end;


end.
