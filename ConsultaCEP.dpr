program ConsultaCEP;

uses
  Vcl.Forms,
  dtPrincipal in 'data\dtPrincipal.pas' {dmPrincipal: TDataModule},
  files.interfaces in 'interface\files.interfaces.pas',
  endereco.model in 'model\endereco.model.pas',
  endereco.controller in 'controller\endereco.controller.pas',
  endereco.service in 'service\endereco.service.pas',
  pricipal.view in 'view\pricipal.view.pas' {Form1},
  cadastro.view in 'view\cadastro.view.pas' {frmCadastro};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmPrincipal, dmPrincipal);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmCadastro, frmCadastro);
  Application.Run;
end.