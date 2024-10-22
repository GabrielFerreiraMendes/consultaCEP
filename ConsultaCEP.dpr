program ConsultaCEP;

uses
  Vcl.Forms,
  dtPrincipal in 'data\dtPrincipal.pas' {dmPrincipal: TDataModule},
  files.interfaces in 'interface\files.interfaces.pas',
  endereco.model in 'model\endereco.model.pas',
  endereco.controller in 'controller\endereco.controller.pas',
  endereco.service in 'service\endereco.service.pas',
  pricipal.view in 'view\pricipal.view.pas' {frmPrincipal},
  cadastro.view in 'view\cadastro.view.pas' {frmCadastro},
  parametro.records in 'record\parametro.records.pas',
  viacep.records in 'record\viacep.records.pas',
  endereco.exceptions in 'exception\endereco.exceptions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmPrincipal, dmPrincipal);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmCadastro, frmCadastro);
  Application.Run;

end.
