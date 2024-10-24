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
    procedure initForm(JSON: TJSONObject);
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
  edtCodigo.Text := MainObject.Codigo.ToString;
  MainObject.CEP := StringReplace(edtCep.Text, '', '-', []);
  MainObject.Logradouro := edtLogradouro.Text;
  MainObject.Complemento := edtComplemento.Text;
  MainObject.Bairro := edtBairro.Text;
  MainObject.Localidade := edtLocalidade.Text;
  MainObject.UF := edtUf.Text;

  TEnderecoController.save(MainObject, dmPrincipal.FDConnection1);
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
    form.initForm(JSON);
    form.ShowModal;
  finally
    FreeAndNil(form);
  end;
end;

procedure TfrmCadastro.initForm(JSON: TJSONObject);
var
  vCEP: String;
begin
  Self.MainObject := TEndereco.Create(JSON);

  edtCodigo.Text := MainObject.Codigo.ToString;
  edtCep.Text := StringReplace(MainObject.CEP, '-', '', []);
  edtLogradouro.Text := MainObject.Logradouro;
  edtComplemento.Text := MainObject.Complemento;
  edtBairro.Text := MainObject.Bairro;
  edtLocalidade.Text := MainObject.Localidade;
  edtUf.Text := MainObject.UF;
end;

end.
