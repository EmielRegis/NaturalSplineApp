program EAN_PROJECT;

uses
  Vcl.Forms,
  EAN in 'EAN.pas' {MainForm},
  SplineFunctions in 'SplineFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
