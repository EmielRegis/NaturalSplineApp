unit EAN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IntervalArithmetic, System.Generics.Collections,
  SplineFunctions, Vcl.ComCtrls, Vcl.ExtCtrls;


type
  TMainForm = class(TForm)
    AddNodeB: TButton;
    XValueAE: TEdit;
    FValueAE: TEdit;
    FValueL: TLabel;
    XValueL: TLabel;
    AddNodeL: TLabel;
    Label4: TLabel;
    ValueAtAE: TEdit;
    ModeSelectionRG: TRadioGroup;
    ValueAtL: TLabel;
    HeaderL: TLabel;
    XValueBE: TEdit;
    FValueBE: TEdit;
    ValueAtBE: TEdit;
    RemoveNodeB: TButton;
    CalculateResultsB: TButton;
    ResultsLB: TListBox;
    PointsListLB: TListBox;
    PointsListL: TLabel;
    NumberOfPointsL: TLabel;
    GraphL: TLabel;
    FooterL: TLabel;
    ClearAllB: TButton;
    procedure initialize();
    procedure clearAllData();
    procedure drawCoordinateSystem();
    procedure drawSplineGraphNormal();
    procedure drawSplineGraphInterval();
    procedure drawPointsNormal();
    procedure drawPointsInterval();
    procedure drawSearchedValueNormal();
    procedure drawSearchedValueInterval();
    procedure switchToNormalMode();
    procedure switchToAutomaticIntervalMode();
    procedure switchToCustomIntervalMode();
    procedure addNodeNormalMode();
    procedure addNodeAutomaticIntervalMode();
    procedure addNodeCustomIntervalMode();
    procedure removeNodeNormalMode();
    procedure removeNodeAutomaticIntervalMode();
    procedure removeNodeCustomIntervalMode();
    procedure clearInputsNormalMode();
    procedure clearInputsAutomaticIntervalMode();
    procedure clearInputsCustomIntervalMode();
    procedure calculateResultsNormalMode();
    procedure calculateResultsAutomaticIntervalMode();
    procedure calculateResultsCustomIntervalMode();
    procedure FormCreate(Sender: TObject);
    procedure AddNodeBClick(Sender: TObject);
    procedure CalculateResultsBClick(Sender: TObject);
    procedure ModeSelectionRGClick(Sender: TObject);
    procedure RemoveNodeBClick(Sender: TObject);
    procedure XValueAEKeyPress(Sender: TObject; var Key: Char);
    procedure checkInput(var edit : TEdit; var Key : char);
    procedure XValueBEKeyPress(Sender: TObject; var Key: Char);
    procedure FValueAEKeyPress(Sender: TObject; var Key: Char);
    procedure ClearAllBClick(Sender: TObject);
    procedure ValueAtAEKeyPress(Sender: TObject; var Key: Char);
    procedure ValueAtBEKeyPress(Sender: TObject; var Key: Char);


  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  MainForm: TMainForm;

  mode : char;

  movX, movY, centreX, centreY, graphLength : integer;

  xValueNorm : Extended;
  xValueAutInt, xValueCustInt : interval;

  fValueNorm : Extended;
  fValueAutInt, fValueCustInt : interval;

  nodeNormList, functionNormList : TList<Extended>;
  nodeAutIntList, nodeCustIntList, functionAutIntList, functionCustIntList : TList<interval>;

  coeffsNormMatrix : TList<TList<extended>>;
  coeffsAutIntMatrix, coeffsCustIntMatrix, coeffsIntMatrix : TList<TList<interval>>;

  pointsCount : integer;





implementation


{$R *.dfm}

procedure TMainForm.initialize();
var
  i : integer;

begin
  nodeNormList := TList<Extended>.Create;
  functionNormList := TList<Extended>.Create;
  nodeAutIntList := TList<interval>.Create;
  nodeCustIntList := TList<interval>.Create;
  functionAutIntList := TList<interval>.Create;
  functionCustIntList := TList<interval>.Create;

  coeffsNormMatrix := TList<TList<extended>>.Create;
  coeffsAutIntMatrix := TList<TList<interval>>.Create;
  coeffsCustIntMatrix := TList<TList<interval>>.Create;
  coeffsIntMatrix := TList<TList<interval>>.Create;

  for i := 0 to 3 do
  begin
      coeffsNormMatrix.Add(TList<extended>.Create);
      coeffsAutIntMatrix.Add(TList<interval>.Create);
      coeffsCustIntMatrix.Add(TList<interval>.Create);
      coeffsIntMatrix.Add(TList<interval>.Create);

  end;

  pointsCount := 0;

  switchToNormalMode();

  movX := 465;
  movY := 110;
  centreX := 665;
  centreY := 310;
  graphLength := 400;

end;


procedure TMainForm.clearAllData();
var
  i : integer;

begin
    PointsListLB.Clear();
    ResultsLB.Clear();

    nodeNormList.Clear();
    nodeAutIntList.Clear();
    nodeCustIntList.Clear();

    functionNormList.Clear();
    functionAutIntList.Clear();
    functionCustIntList.Clear();

  for i := 0 to 3 do
  begin
      coeffsNormMatrix[i].Clear();
      coeffsAutIntMatrix[i].Clear();
      coeffsCustIntMatrix[i].Clear();
      coeffsIntMatrix[i].Clear();
  end;

  pointsCount := 0;
    NumberOfPointsL.Caption := 'Number of nodes:   ' + intToStr(pointsCount);

    XValueAE.Clear();
    FValueAE.Clear();
    ValueAtAE.Clear();
    if (mode = 'c') then
    begin
      XValueBE.Clear();
      FValueBE.Clear();
      ValueAtBE.Clear();
    end;

    drawCoordinateSystem();

   { x := inew('7.28');
    str(x.a, s);
    ResultsLB.items.add(string(s));
    str(x.b, s);
    ResultsLB.items.add(string(s));  }

    ResultsLB.Clear();

end;

procedure TMainForm.drawCoordinateSystem();
begin
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Color := RGB(255,255, 255);
  Canvas.Rectangle(movX-3, movY-3, movX + graphLength+3, movY + graphLength+3);

  Canvas.Brush.Color := RGB(0,0,0);
  Canvas.MoveTo(centreX, movY);
  Canvas.LineTo(centreX, movY + graphLength);
  Canvas.MoveTo(movX, centreY);
  Canvas.LineTo(movX + graphLength, centreY);

  Canvas.MoveTo(centreX, movY);
  Canvas.LineTo(centreX - 7 , movY + 12);
  Canvas.MoveTo(centreX, movY);
  Canvas.LineTo(centreX + 7 , movY + 12);
  Canvas.MoveTo(centreX + round(graphLength/2), centreY);
  Canvas.LineTo(centreX + round(graphLength/2) - 12, centreY - 7);
  Canvas.MoveTo(centreX + round(graphLength/2), centreY);
  Canvas.LineTo(centreX + round(graphLength/2) - 12, centreY + 7);

end;

    procedure TMainForm.drawSplineGraphNormal();
    var
      coef, maxVal, graphHalfLength, xf, yf, ei, di, j, a, b : extended;
      i, x,y : integer;
    begin
      if(pointsCount > 1) then
      begin
        maxVal := 0;

        for i := 0 to pointsCount-1 do
        begin
          if (abs(nodeNormList[i]) > maxVal) then
          begin
            maxVal := abs(nodeNormList[i]);
          end;

          if (abs(functionNormList[i]) > maxVal) then
          begin
            maxVal := abs(functionNormList[i]);
          end;
        end;

        graphHalfLength := 200.0;
        coef := graphHalfLength / maxVal;

        for i := 0 to pointsCount-2 do
        begin
          a := abs(nodeNormList[i+1] * coef - nodeNormList[i] * coef);
          b := abs(functionNormList[i+1] * coef - functionNormList[i] * coef);
          if (a > b) then
          begin
            ei := a;
          end
          else
          begin
            ei := b;
          end;
          di := (nodeNormList[i+1] - nodeNormList[i]) / ei;

          j := nodeNormList[i];
          while j < nodeNormList[i+1] do
          begin
            xf := j * coef;
            yf := cubicFunctionValueNormal(j,coeffsNormMatrix[3][i],coeffsNormMatrix[2][i],coeffsNormMatrix[1][i],coeffsNormMatrix[0][i]) * coef;
            x := round(xf);
            y := round(yf);

            Canvas.Pen.Style:= psClear;
            Canvas.Brush.Color := RGB(0, 0, 255);

            Canvas.Rectangle(centreX + x -1, centreY - y - 1, centreX +x + 2, centreY - y  + 2);

            j := j + di;
          end;
        end;
      end;
    end;

    procedure TMainForm.drawSplineGraphInterval();
    var
      a,b,coef, maxVal, graphHalfLength,xfa,xfb,yfa,yfb,  ei, di : extended;
      i,xa,xb,ya,yb : integer;
      j, va : interval;
    begin
      if(pointsCount > 1) then
      begin
        maxVal := 0;

        for i := 0 to pointsCount-1 do
        begin
          if (abs(nodeAutIntList[i].a) > maxVal) then
          begin
            maxVal := abs(nodeAutIntList[i].a);
          end;
          if (abs(nodeAutIntList[i].b) > maxVal) then
          begin
            maxVal := abs(nodeAutIntList[i].b);
          end;

          if (abs(functionAutIntList[i].a) > maxVal) then
          begin
            maxVal := abs(functionAutIntList[i].a);
          end;
          if (abs(functionAutIntList[i].b) > maxVal) then
          begin
            maxVal := abs(functionAutIntList[i].b);
          end;
        end;

        FooterL.Caption := (floattostr(maxVal));

        graphHalfLength := 200.0;
        coef := graphHalfLength / maxVal;


        for i := 0 to pointsCount-2 do
        begin
          a := abs(nodeAutIntList[i+1].b * coef - nodeAutIntList[i].a * coef);
          b := abs(functionAutIntList[i+1].b * coef - functionAutIntList[i].a * coef);
          if (a > b) then
          begin
            ei := a;
          end
          else
          begin
            ei := b;
          end;
          di := (nodeAutIntList[i+1].b - nodeAutIntList[i].a) / ei;

          j := nodeAutIntList[i];
          while j.b < nodeAutIntList[i+1].b do
          begin
            xfa := j.a * coef;
            xfb := j.b * coef;
            va := cubicFunctionValueInterval(j,coeffsIntMatrix[3][i],coeffsIntMatrix[2][i],coeffsIntMatrix[1][i],coeffsIntMatrix[0][i]);
            yfa := va.a * coef;
            yfb := va.b * coef;

            xa := round(xfa);
            xb := round(xfb);
            ya := round(yfa);
            yb := round(yfb);

            Canvas.Pen.Style:= psClear;
            Canvas.Brush.Color := RGB(0, 0, 255);

            Canvas.Rectangle(centreX + xa -1, centreY - ya - 1, centreX +xb + 2, centreY - yb  + 2);

            j.a := j.a + di;
            j.b := j.b + di;
          end;
        end;


      end;
    end;

    procedure TMainForm.drawPointsNormal();
    var
      coef, maxVal, graphHalfLength, xf, yf : extended;
      i, x,y : integer;
    begin
      if(pointsCount > 1) then
      begin
        maxVal := 0;

        for i := 0 to pointsCount-1 do
        begin
          if (abs(nodeNormList[i]) > maxVal) then
          begin
            maxVal := abs(nodeNormList[i]);
          end;

          if (abs(functionNormList[i]) > maxVal) then
          begin
            maxVal := abs(functionNormList[i]);
          end;
        end;

        graphHalfLength := 200.0;
        coef := graphHalfLength / maxVal;

        for i := 0 to pointsCount-1 do     // petla for przechodzaca przez wszystkie punkty na liscie dodanych punktow
        begin
          xf := nodeNormList[i] * coef;           // przypisanie wartosci pod zmienne x i y
          yf := functionNormList[i] * coef;
          x := round(xf);
          y := round(yf);

      //Canvas.MoveTo(centreX, centreY);     // ustawienie poczatkowe do rysowania
          Canvas.Pen.Style := psSolid;
          Canvas.Brush.Color := RGB(255, 0, 0);     // ustawienie koloru na czerwony

          Canvas.Rectangle(centreX + x -2, centreY - y - 2, centreX +x + 2, centreY - y  + 2);        // rysowanie punktu na ukladzie wspolrzedncyh
        end;
      end;
    end;

    procedure TMainForm.drawPointsInterval();
    var
      coef, maxVal, graphHalfLength,xfa,xfb,yfa,yfb : extended;
      i,xa,xb,ya,yb : integer;
    begin
      if(pointsCount > 1) then
      begin
        maxVal := 0;

        for i := 0 to pointsCount-1 do
        begin
          if (abs(nodeAutIntList[i].a) > maxVal) then
          begin
            maxVal := abs(nodeAutIntList[i].a);
          end;
          if (abs(nodeAutIntList[i].b) > maxVal) then
          begin
            maxVal := abs(nodeAutIntList[i].b);
          end;

          if (abs(functionAutIntList[i].a) > maxVal) then
          begin
            maxVal := abs(functionAutIntList[i].a);
          end;
          if (abs(functionAutIntList[i].b) > maxVal) then
          begin
            maxVal := abs(functionAutIntList[i].b);
          end;
        end;

        graphHalfLength := 200.0;
        coef := graphHalfLength / maxVal;

        for i := 0 to pointsCount-1 do     // petla for przechodzaca przez wszystkie punkty na liscie dodanych punktow
        begin
          xfa := nodeAutIntList[i].a * coef;
        xfb := nodeAutIntList[i].b * coef;           // przypisanie wartosci pod zmienne x i y
        yfa := functionAutIntList[i].a * coef;
        yfb := functionAutIntList[i].b * coef;
        xa := round(xfa);
        ya := round(yfa);
        xb := round(xfb);
        yb := round(yfb);

      //Canvas.MoveTo(centreX, centreY);     // ustawienie poczatkowe do rysowania
          Canvas.Pen.Style := psSolid;
          Canvas.Brush.Color := RGB(255, 0, 0);     // ustawienie koloru na czerwony

          Canvas.Rectangle(centreX + xa -2, centreY - ya - 2, centreX +xb + 2, centreY - yb  + 2);        // rysowanie punktu na ukladzie wspolrzedncyh
        end;
      end;
    end;

    procedure TMainForm.drawSearchedValueNormal();
    var
      coef, maxVal, graphHalfLength, xf, yf: extended;
      i, x,y : integer;
    begin
      if(pointsCount > 1) then
      begin
        maxVal := 0;

        for i := 0 to pointsCount-1 do
        begin
          if (abs(nodeNormList[i]) > maxVal) then
          begin
            maxVal := abs(nodeNormList[i]);
          end;

          if (abs(functionNormList[i]) > maxVal) then
          begin
            maxVal := abs(functionNormList[i]);
          end;
        end;

        graphHalfLength := 200.0;
        coef := graphHalfLength / maxVal;

        xf := xValueNorm * coef;           // przypisanie wartosci pod zmienne x i y
        yf := fValueNorm * coef;
        x := round(xf);
        y := round(yf);

      //Canvas.MoveTo(centreX, centreY);     // ustawienie poczatkowe do rysowania
        Canvas.Pen.Style := psSolid;
        Canvas.Brush.Color := RGB(0, 255, 0);     // ustawienie koloru na zielony

        Canvas.Rectangle(centreX + x -2, centreY - y - 2, centreX +x + 2, centreY - y  + 2);
      end;
    end;

    procedure TMainForm.drawSearchedValueInterval();
    var
      coef, maxVal, graphHalfLength,xfa,xfb,yfa,yfb : extended;
      i,xa,xb,ya,yb : integer;
    begin
      if(pointsCount > 1) then
      begin
        maxVal := 0;

        for i := 0 to pointsCount-1 do
        begin
          if (abs(nodeAutIntList[i].a) > maxVal) then
          begin
            maxVal := abs(nodeAutIntList[i].a);
          end;
          if (abs(nodeAutIntList[i].b) > maxVal) then
          begin
            maxVal := abs(nodeAutIntList[i].b);
          end;

          if (abs(functionAutIntList[i].a) > maxVal) then
          begin
            maxVal := abs(functionAutIntList[i].a);
          end;
          if (abs(functionAutIntList[i].b) > maxVal) then
          begin
            maxVal := abs(functionAutIntList[i].b);
          end;
        end;

        graphHalfLength := 200.0;
        coef := graphHalfLength / maxVal;

        xfa := xValueAutInt.a * coef;
        xfb := xValueAutInt.b * coef;           // przypisanie wartosci pod zmienne x i y
        yfa := fValueAutInt.a * coef;
        yfb := fValueAutInt.b * coef;
        xa := round(xfa);
        ya := round(yfa);
        xb := round(xfb);
        yb := round(yfb);

      //Canvas.MoveTo(centreX, centreY);     // ustawienie poczatkowe do rysowania
        Canvas.Pen.Style := psSolid;
        Canvas.Brush.Color := RGB(0, 255, 0);     // ustawienie koloru na zielony

        Canvas.Rectangle(centreX + xa -2, centreY - ya - 2, centreX +xb + 2, centreY - yb  + 2);
      end;
    end;

procedure TMainForm.checkInput(var edit : TEdit; var Key : char);
begin
  if not (CharInSet(Key,  [#8, '0'..'9', '-', '.'] )) then
  //if not (Key in [#8, '0'..'9', '-', '.']) then
  begin
    //ShowMessage('Invalid key: ' + Key);
    Key := #0;
  end
  else if ((Key = '.') or (Key = '-')) and (Pos(Key, edit.Text) > 0) then
  begin
    //ShowMessage('Invalid Key: twice ' + Key);
    Key := #0;
  end
  else if (Key = '-') and (edit.SelStart <> 0) then
  begin
    //ShowMessage('Only allowed at beginning of number: ' + Key);
    Key := #0;
  end;
end;


procedure TMainForm.ClearAllBClick(Sender: TObject);
begin
  clearAllData();
end;

procedure TMainForm.XValueAEKeyPress(Sender: TObject; var Key: Char);
begin
    checkInput(XValueAE, Key);
end;

procedure TMainForm.XValueBEKeyPress(Sender: TObject; var Key: Char);
begin
  checkInput(XValueBE, Key);
end;


procedure TMainForm.switchToNormalMode();
begin
  mode := 'n';

  MainForm.Caption := 'Natural Cubic Spline - normal mode';

  MainForm.XValueAE.TextHint := 'x';
  MainForm.XValueBE.TextHint := 'n/a';
  MainForm.XValueBE.Text := 'n/a';
  MainForm.FValueAE.TextHint := 'f(x)';
  MainForm.FValueBE.TextHint := 'n/a';
  MainForm.FValueBE.Text := 'n/a';
  MainForm.ValueAtAE.TextHint := 'given x';
  MainForm.ValueAtBE.TextHint := 'n/a';
  MainForm.ValueAtBE.Text := 'n/a';

  MainForm.XValueBE.Enabled := false;
  MainForm.FValueBE.Enabled := false;
  MainForm.ValueAtBE.Enabled := false;
end;

procedure TMainForm.ValueAtAEKeyPress(Sender: TObject; var Key: Char);
begin
  checkInput(ValueAtAE, Key);
end;

procedure TMainForm.ValueAtBEKeyPress(Sender: TObject; var Key: Char);
begin
  checkInput(ValueAtBE, Key);
end;

procedure TMainForm.switchToAutomaticIntervalMode();
begin
   mode := 'a';

   MainForm.Caption := 'Natural Cubic Spline - automatic interval mode';

  MainForm.XValueAE.TextHint := 'x';
  MainForm.XValueBE.TextHint := 'n/a';
  MainForm.XValueBE.Text := 'n/a';
  MainForm.FValueAE.TextHint := 'f(x)';
  MainForm.FValueBE.TextHint := 'n/a';
  MainForm.FValueBE.Text := 'n/a';
  MainForm.ValueAtAE.TextHint := 'given x';
  MainForm.ValueAtBE.TextHint := 'n/a';
  MainForm.ValueAtBE.Text := 'n/a';

  MainForm.XValueBE.Enabled := false;
  MainForm.FValueBE.Enabled := false;
  MainForm.ValueAtBE.Enabled := false;

end;

procedure TMainForm.switchToCustomIntervalMode();
begin
  mode := 'c';

  MainForm.Caption := 'Natural Cubic Spline - custom interval mode';

  MainForm.XValueAE.TextHint := 'x.a';
  MainForm.XValueBE.TextHint := 'x.b';
  MainForm.XValueBE.Text := '';
  MainForm.FValueAE.TextHint := 'f(x).a';
  MainForm.FValueBE.TextHint := 'f(x).b';
  MainForm.FValueBE.Text := '';
  MainForm.ValueAtAE.TextHint := 'given x.a';
  MainForm.ValueAtBE.TextHint := 'given x.b';
  MainForm.ValueAtBE.Text := '';

   MainForm.XValueBE.Enabled := true;
  MainForm.FValueBE.Enabled := true;
  MainForm.ValueAtBE.Enabled := true;
end;

procedure TMainForm.addNodeNormalMode();
var
  x, fx : extended;
  err,i,j : integer;
begin

  if ((XValueAE.Text <> '') and (FValueAE.Text <> '')) then
  begin
    val(XValueAE.Text, x, err);
    val(FValueAE.Text, fx, err);

     j := 0;
     for i := 0 to pointsCount-1 do
     begin
       if x > nodeNormList[i] then
       begin
         j := j+1;
       end;

     end;


    if(pointsCount > 0) then
    begin
    PointsListLB.Items.Insert(j, 'q' + IntToStr(pointsCount) + '   x:' + XValueAE.Text + ',   f(x): ' + FValueAE.Text);

      nodeNormList.Insert(j,x);
      functionNormList.Insert(j, fx);
    end
    else
    begin
    PointsListLB.Items.Add( 'q' + IntToStr(pointsCount) + '   x:' + XValueAE.Text + ',   f(x): ' + FValueAE.Text);

      nodeNormList.Add(x);
      functionNormList.Add(fx);
    end;

    pointsCount := pointsCount + 1;
    NumberOfPointsL.Caption := 'Number of nodes:   ' + intToStr(pointsCount);



    clearInputsNormalMode();
  end;

   drawCoordinateSystem();
   drawPointsNormal();


end;

procedure TMainForm.addNodeAutomaticIntervalMode();
var
  x, fx : interval;
  i,j : integer;
begin

  if ((XValueAE.Text <> '') and (FValueAE.Text <> '')) then
  begin
    {val(XValueAE.Text, x.a, err);
    val(XValueAE.Text, x.b, err);
    val(FValueAE.Text, fx.a, err);
    val(FValueAE.Text, fx.b, err);}
    x := inew(XValueAE.Text);
    fx := inew(FValueAE.Text);

     j := 0;
     for i := 0 to pointsCount-1 do
     begin
       if x > nodeAutIntList[i] then
       begin
         j := j+1;
       end;

     end;


    if(pointsCount > 0) then
    begin
    PointsListLB.Items.Insert(j, 'q' + IntToStr(pointsCount) + '   x:[' + floattostr(x.a) + '-' + floattostr(x.b)+ ']   f(x):[' + floattostr(fx.a) +  '- ' + floattostr(fx.b) + ']');

      nodeAutIntList.Insert(j,x);
      functionAutIntList.Insert(j, fx);
    end
    else
    begin
     PointsListLB.Items.Add('q' + IntToStr(pointsCount) + '   x:[' + floattostr(x.a) + '-' + floattostr(x.b)+ ']   f(x):[' + floattostr(fx.a) +  '- ' + floattostr(fx.b) + ']');

      nodeAutIntList.Add(x);
      functionAutIntList.Add(fx);
    end;

    pointsCount := pointsCount + 1;
    NumberOfPointsL.Caption := 'Number of nodes:   ' + intToStr(pointsCount);



    clearInputsAutomaticIntervalMode();
  end;

   drawCoordinateSystem();
   drawPointsInterval();


end;

procedure TMainForm.addNodeCustomIntervalMode();
var
  x, fx : interval;
  i,j : integer;
begin

  if ((XValueAE.Text <> '') and (FValueAE.Text <> '')) then
  begin
    x := inew(XValueAE.Text, XValueBE.Text);
    fx := inew(FValueAE.Text, FValueBE.Text);

     j := 0;
     for i := 0 to pointsCount-1 do
     begin
       if x > nodeAutIntList[i] then
       begin
         j := j+1;
       end;

     end;


    if(pointsCount > 0) then
    begin
    PointsListLB.Items.Insert(j, 'q' + IntToStr(pointsCount) + '   x:[' + floattostr(x.a) + '-' + floattostr(x.b)+ ']   f(x):[' + floattostr(fx.a) +  '- ' + floattostr(fx.b) + ']');

      nodeAutIntList.Insert(j,x);
      functionAutIntList.Insert(j, fx);
    end
    else
    begin
     PointsListLB.Items.Add('q' + IntToStr(pointsCount) + '   x:[' + floattostr(x.a) + '-' + floattostr(x.b)+ ']   f(x):[' + floattostr(fx.a) +  '- ' + floattostr(fx.b) + ']');

      nodeAutIntList.Add(x);
      functionAutIntList.Add(fx);
    end;

    pointsCount := pointsCount + 1;
    NumberOfPointsL.Caption := 'Number of nodes:   ' + intToStr(pointsCount);



    clearInputsCustomIntervalMode();
  end;

   drawCoordinateSystem();
   drawPointsInterval();


end;

procedure TMainForm.removeNodeNormalMode();
var
  selected : integer;

begin
  selected := PointsListLB.ItemIndex;
  PointsListLB.DeleteSelected;

  nodeNormList.Delete(selected);
  functionNormList.Delete(selected);

  pointsCount := pointsCount - 1;
  NumberOfPointsL.Caption := 'Number of nodes:   ' + intToStr(pointsCount);

  drawCoordinateSystem();
  drawPointsNormal();
end;

procedure TMainForm.removeNodeAutomaticIntervalMode();
var
  selected : integer;

begin
  selected := PointsListLB.ItemIndex;
  PointsListLB.DeleteSelected;

  nodeAutIntList.Delete(selected);
  functionAutIntList.Delete(selected);

  pointsCount := pointsCount - 1;
  NumberOfPointsL.Caption := 'Number of nodes:   ' + intToStr(pointsCount);

  drawCoordinateSystem();
  drawPointsInterval();
end;

procedure TMainForm.removeNodeCustomIntervalMode();
var
  selected : integer;

begin
  selected := PointsListLB.ItemIndex;
  PointsListLB.DeleteSelected;

  nodeAutIntList.Delete(selected);
  functionAutIntList.Delete(selected);

  pointsCount := pointsCount - 1;
  NumberOfPointsL.Caption := 'Number of nodes:   ' + intToStr(pointsCount);

  drawCoordinateSystem();
  drawPointsInterval();
end;

procedure TMainForm.clearInputsNormalMode();
begin
  XValueAE.Clear();
  FValueAE.Clear();
end;

procedure TMainForm.clearInputsAutomaticIntervalMode();
begin
  XValueAE.Clear();
  FValueAE.Clear();
end;

procedure TMainForm.clearInputsCustomIntervalMode();
begin
  XValueAE.Clear();
  FValueAE.Clear();
  XValueBE.Clear();
  FValueBE.Clear();
end;


procedure TMainForm.calculateResultsNormalMode();
var
  err, err2, e, i,j : integer;
  valueAt, result : extended;
  coeffsString, resultString : shortstring;
begin
  drawCoordinateSystem();


  if ((ValueAtAE.Text <> '') and (pointsCount > 1)) then
  begin
    for i := 0 to 3 do
    begin
      for j := 0 to pointsCount -2 do
      begin
        coeffsNormMatrix[i].Add(0);
      end;
    end;

    naturalSplineCoeffsNormal(pointsCount -1, nodeNormList, functionNormList, coeffsNormMatrix, err2);
    ResultsLB.Items.Add(' coeffs function error:   ' + intToStr(err2));

    if err2 = 0 then
    begin
      drawSplineGraphNormal();

      for i := 0 to pointsCount-2 do
      begin
        for j := 0 to 3 do
        begin
          str(coeffsNormMatrix[j][i], coeffsString);
          ResultsLB.Items.Add('coefficient [' + intToStr(j) + '][' + intToStr(i) + '] :   ' + string(coeffsString));
        end;
      end;
    end;

    val(ValueATAE.Text, valueAt, e);
    val(ValueATAE.Text, xValueNorm, e);

    result := naturalSplineValueNormal(pointsCount - 1, nodeNormList, functionNormList, valueAt, err );
    fValueNorm := result;
    FooterL.Caption := floatToStr(result);

    str(result, resultString);

    ResultsLB.Items.Add(' value function error:   ' + intToStr(err));

    if err = 0 then
    begin
      ResultsLB.Items.Add('searched function value:   ' + string(resultString));
      drawSearchedValueNormal();
    end;

    drawPointsNormal();
  end
  else
  begin
    ;
  end;

end;

procedure TMainForm.calculateResultsAutomaticIntervalMode();
var
  err, err2, i,j : integer;
   result : interval;
  coeffsString, coeffsString2, resultString, resultString2 : shortstring;
begin
  drawCoordinateSystem();


  if ((ValueAtAE.Text <> '') and (pointsCount > 1)) then
  begin
    for i := 0 to 3 do
    begin
      for j := 0 to pointsCount -2 do
      begin
        coeffsIntMatrix[i].Add(inew('0'));
      end;
    end;

    naturalSplineCoeffsInterval(pointsCount -1, nodeAutIntList, functionAutIntList, coeffsIntMatrix, err2);
    ResultsLB.Items.Add(' coeffs function error:   ' + intToStr(err2));

    if err2 = 0 then
    begin
      drawSplineGraphInterval();

      for i := 0 to pointsCount-2 do
      begin
        for j := 0 to 3 do
        begin
          str(coeffsIntMatrix[j][i].a, coeffsString);
          str(coeffsIntMatrix[j][i].b, coeffsString2);
          ResultsLB.Items.Add('coefficient [' + intToStr(j) + '][' + intToStr(i) + '] :   [' + string(coeffsString) + '-' + string(coeffsString2) + ']');
        end;
      end;
    end;

    {val(ValueATAE.Text, valueAt, e);
    val(ValueATAE.Text, xValueNorm, e); }
    xValueAutInt :=  inew(ValueATAE.Text);


    result := naturalSplineValueInterval(pointsCount - 1, nodeAutIntList, functionAutIntList, xValueAutInt, err );
    fValueAutInt := result;
    //FooterL.Caption := floatToStr(result);

    str(result.a, resultString);
    str(result.b, resultString2);

    ResultsLB.Items.Add(' value function error:   ' + intToStr(err));

    if err = 0 then
    begin
      ResultsLB.Items.Add('searched function value:   [' + string(resultString) +','+ string(resultString2) +']');
      drawSearchedValueInterval();
    end;

    drawPointsInterval();
  end
  else
  begin
    ;
  end;

end;

procedure TMainForm.calculateResultsCustomIntervalMode();
var
  err, err2, i,j : integer;
   result : interval;
  coeffsString, coeffsString2, resultString, resultString2 : shortstring;
begin
  drawCoordinateSystem();


  if ((ValueAtAE.Text <> '') and (ValueAtBE.Text <> '') and (pointsCount > 1)) then
  begin
    for i := 0 to 3 do
    begin
      for j := 0 to pointsCount -2 do
      begin
        coeffsIntMatrix[i].Add(inew('0'));
      end;
    end;

    naturalSplineCoeffsInterval(pointsCount -1, nodeAutIntList, functionAutIntList, coeffsIntMatrix, err2);
    ResultsLB.Items.Add(' coeffs function error:   ' + intToStr(err2));

    if err2 = 0 then
    begin
      drawSplineGraphInterval();

      for i := 0 to pointsCount-2 do
      begin
        for j := 0 to 3 do
        begin
          str(coeffsIntMatrix[j][i].a, coeffsString);
          str(coeffsIntMatrix[j][i].b, coeffsString2);
          ResultsLB.Items.Add('coefficient [' + intToStr(j) + '][' + intToStr(i) + '] :   [' + string(coeffsString) + '-' + string(coeffsString2) + ']');
        end;
      end;
    end;


    xValueAutInt :=  inew(ValueATAE.Text, ValueATBE.Text);

    result := naturalSplineValueInterval(pointsCount - 1, nodeAutIntList, functionAutIntList, xValueAutInt, err );
    fValueAutInt := result;
    //FooterL.Caption := floatToStr(result);

    str(result.a, resultString);
    str(result.b, resultString2);

    ResultsLB.Items.Add(' value function error:   ' + intToStr(err));

    if err = 0 then
    begin
      ResultsLB.Items.Add('searched function value:   [' + string(resultString) +','+ string(resultString2) +']');
      drawSearchedValueInterval();
    end;

    drawPointsInterval();
  end
  else
  begin
    ;
  end;

end;

// Item action listeners


// Add node button listener
procedure TMainForm.AddNodeBClick(Sender: TObject);
begin
  if (mode = 'n') then
  begin
    addNodeNormalMode();
  end
  else if (mode = 'a') then
  begin
    addNodeAutomaticIntervalMode();
  end
  else if (mode = 'c') then
  begin
    addNodeCustomIntervalMode();
  end;
end;

// Remove node button listener
procedure TMainForm.RemoveNodeBClick(Sender: TObject);
begin
  if (mode = 'n') then
  begin
    removeNodeNormalMode();
  end
  else if (mode = 'a') then
  begin
    removeNodeAutomaticIntervalMode();
  end
  else if (mode = 'c') then
  begin
    removeNodeCustomIntervalMode();
  end;
end;

// Calculate results button click listener
procedure TMainForm.CalculateResultsBClick(Sender: TObject);
begin
  drawCoordinateSystem();

  if (mode = 'n') then
  begin
    calculateResultsNormalMode();
  end
  else if (mode = 'a') then
  begin
  calculateResultsAutomaticIntervalMode();
  end
  else if (mode = 'c') then
  begin
    calculateResultsCustomIntervalMode();
  end;
end;

// Radio button selection listener
procedure TMainForm.ModeSelectionRGClick(Sender: TObject);
var
  selected : integer;

begin
  clearAllData();

  selected := ModeSelectionRG.ItemIndex;

  if (selected = 0) then
  begin
    switchToNormalMode();
  end
  else if (selected = 1) then
  begin
    switchToAutomaticIntervalMode();
  end
  else if (selected = 2) then
  begin
    switchToCustomIntervalMode();
  end;
end;


// Form create procedure
procedure TMainForm.FormCreate(Sender: TObject);
begin
  initialize();

end;



procedure TMainForm.FValueAEKeyPress(Sender: TObject; var Key: Char);
begin
  checkInput(FValueAE, Key);
end;

end.
