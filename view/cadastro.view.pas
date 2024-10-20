unit cadastro.view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, XMLDoc, Xml.XMLIntf,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, dtPrincipal,
  System.JSON, endereco.model, endereco.controller;

type
  TfrmCadastro = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    edtUf: TEdit;
    GroupBox2: TGroupBox;
    edtCep: TEdit;
    GroupBox3: TGroupBox;
    edtLogradouro: TEdit;
    GroupBox4: TGroupBox;
    edtComplemento: TEdit;
    GroupBox5: TGroupBox;
    edtBairro: TEdit;
    Button1: TButton;
    GroupBox7: TGroupBox;
    edtLocalidade: TEdit;
    GroupBox6: TGroupBox;
    edtCodigo: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    FMainObject: TEndereco;
    procedure setFields(JSON: TJSONObject);
    function getFields: TJSONObject;
    property MainObject: TEndereco read FMainObject write FMainObject;
    { Private declarations }
  public
    { Public declarations }

    class procedure Execute(); overload;
    class procedure Execute(JSON: TJSONObject); overload;
  end;

var
  frmCadastro: TfrmCadastro;

implementation

{$R *.dfm}
{ TfrmCadastroEndereco }

procedure TfrmCadastro.Button1Click(Sender: TObject);
begin
  TEnderecoController.save(Self.getFields);
  Self.Close;
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

class procedure TfrmCadastro.Execute;
var
  form: TfrmCadastro;
begin
  form := TfrmCadastro.Create(nil);

  try
    form.MainObject := TEndereco.Create;
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
begin
  edtCodigo.Text := JSON.GetValue<String>('codigo');
  edtCep.Text := JSON.GetValue<String>('cep');
  edtLogradouro.Text := JSON.GetValue<String>('logradouro');
  edtComplemento.Text := JSON.GetValue<String>('complemento');
  edtBairro.Text := JSON.GetValue<String>('bairro');
  edtLocalidade.Text := JSON.GetValue<String>('localidade');
  edtUf.Text := JSON.GetValue<String>('uf');
end;

end.