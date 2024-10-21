unit cadastro.view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, XMLDoc, Xml.XMLIntf, System.RegularExpressions,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, dtPrincipal,
  System.JSON, endereco.model, endereco.controller, Vcl.Mask;

type
  TfrmCadastro = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    edtUf: TEdit;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    edtLogradouro: TEdit;
    GroupBox4: TGroupBox;
    edtComplemento: TEdit;
    GroupBox5: TGroupBox;
    edtBairro: TEdit;
    btnSalvar: TButton;
    GroupBox7: TGroupBox;
    edtLocalidade: TEdit;
    GroupBox6: TGroupBox;
    edtCodigo: TEdit;
    btnCancelar: TButton;
    edtCep: TMaskEdit;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtCepExit(Sender: TObject);
  private
    FMainObject: TEndereco;
    procedure setFields(JSON: TJSONObject);
    function getFields: TJSONObject;
    property MainObject: TEndereco read FMainObject write FMainObject;
    { Private declarations }
  public
    { Public declarations }
    class procedure Execute(JSON: TJSONObject);
  end;

var
  frmCadastro: TfrmCadastro;

implementation

{$R *.dfm}
{ TfrmCadastroEndereco }

procedure TfrmCadastro.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmCadastro.btnSalvarClick(Sender: TObject);
begin
  TEnderecoController.save(Self.getFields, dmPrincipal.FDConnection1);
  Self.Close;
end;

procedure TfrmCadastro.edtCepExit(Sender: TObject);
begin
  if (not SameText(edtCep.Text, EmptyStr)) and
    (not TRegEx.Match(edtCep.Text, '\d{5}-\d{3}').Success) then
  begin
    MessageDlg(Format('O CEP %s n�o � v�lido!', [edtCep.Text]), mtError,
      [mbOK], 0);

    edtCep.SetFocus;
  end;
end;

class procedure TfrmCadastro.Execute(JSON: TJSONObject);
var
  form: TfrmCadastro;
begin
  form := TfrmCadastro.Create(nil);

  try
    form.setFields(JSON);
    form.ShowModal;
  finally
    FreeAndNil(form);
  end;
end;

function TfrmCadastro.getFields: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('codigo', edtCodigo.Text);
  Result.AddPair('cep', edtCep.Text);
  Result.AddPair('logradouro', edtLogradouro.Text);
  Result.AddPair('complemento', edtComplemento.Text);
  Result.AddPair('bairro', edtBairro.Text);
  Result.AddPair('localidade', edtLocalidade.Text);
  Result.AddPair('uf', edtUf.Text);
end;

procedure TfrmCadastro.setFields(JSON: TJSONObject);
var
  vCEP: String;
begin
  try
    edtCodigo.Text := JSON.GetValue<String>('codigo');
  except
    edtCodigo.Text := EmptyStr;
  end;

  vCEP := varToStrDef(JSON.GetValue<String>('cep'), EmptyStr);

  edtCep.Text := StringReplace(vCEP, '-', '', [rfReplaceAll, rfIgnoreCase]);
  edtLogradouro.Text := JSON.GetValue<String>('logradouro');
  edtComplemento.Text := JSON.GetValue<String>('complemento');
  edtBairro.Text := JSON.GetValue<String>('bairro');
  edtLocalidade.Text := JSON.GetValue<String>('localidade');
  edtUf.Text := JSON.GetValue<String>('uf');
end;

end.
