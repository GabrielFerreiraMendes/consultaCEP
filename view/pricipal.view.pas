unit pricipal.view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.MaskUtils, endereco.controller,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, dtPrincipal, System.JSON, cadastro.view,
  parametro.records, XMLDoc, Xml.XMLIntf;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    dbgEndereco: TDBGrid;
    GroupBox1: TGroupBox;
    edtChave: TEdit;
    btnConsultar: TButton;
    rgChave: TRadioGroup;
    rgRetornoConsulta: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure rgChaveClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
  private
    procedure ApplyBestFit;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

const
  KEY_CEP_TEXT: String = 'Informe o CEP sem os pontos (Exp: 01001000)';
  KEY_END_TEXT
    : String = 'Informe a UF, Cidade e logradouro (Exp: UF/CIDADE/LOGRADOURO)';

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnConsultarClick(Sender: TObject);
var
  param: TParametroRecord;
  JSON: TJSONObject;
  errorMessage: String;
begin
  try
    param.RequisitionType := rgChave.ItemIndex;
    param.ResultType := rgRetornoConsulta.ItemIndex;
    param.Connection := dmPrincipal.FDConnection1;
    param.Key := edtChave.Text;

    JSON := TEnderecoController.findEncereco(param);

    if Assigned(JSON) then
    begin
      TfrmCadastro.Execute(JSON);
      dmPrincipal.FDQuery1.Refresh;
      Self.ApplyBestFit;
      dbgEndereco.SetFocus;
    end;
  finally
    JSON.Free;
  end;
end;

procedure TfrmPrincipal.ApplyBestFit;
var
  vIndex: Integer;
  vColumnValue: string;
begin
  { Aplica o melhor dimensionamento para as colunas
    baseado no primeiro registro ou no tamanho do header da coluna }
  for vIndex := 0 to dbgEndereco.Columns.Count - 1 do
  begin
    vColumnValue := dbgEndereco.Fields[vIndex].DisplayText;
    if Length(vColumnValue) < Length(dbgEndereco.Columns[vIndex].Title.Caption)
    then
      vColumnValue := dbgEndereco.Columns[vIndex].Title.Caption;
    dbgEndereco.Columns[vIndex].width := 50 + dbgEndereco.Canvas.TextWidth
      (vColumnValue);
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  dmPrincipal.FDQuery1.Open;
  Self.ApplyBestFit;

  rgChaveClick(Sender);
end;

procedure TfrmPrincipal.rgChaveClick(Sender: TObject);
begin
  case rgChave.ItemIndex of
    0:
      begin
        edtChave.NumbersOnly := true;
        edtChave.Text := KEY_CEP_TEXT;
      end;
    1:
      begin
        edtChave.NumbersOnly := false;
        edtChave.Text := KEY_END_TEXT;
      end;
  end;

  edtChave.SelStart := 0;
  edtChave.SelLength := Length(edtChave.Text) + 1;
  edtChave.SetFocus;
end;

end.
