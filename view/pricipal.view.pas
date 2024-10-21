unit pricipal.view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.MaskUtils, endereco.controller,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, dtPrincipal, System.JSON, cadastro.view,
  parametro.records, XMLDoc, Xml.XMLIntf;

type
  TForm1 = class(TForm)
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
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  KEY_CEP_TEXT: String = 'Informe o CEP sem os pontos (Exp: 01001000)';
  KEY_END_TEXT
    : String = 'Informe a UF, Cidade e logradouro (Exp: UF/CIDADE/LOGRADOURO)';

implementation

{$R *.dfm}

procedure TForm1.btnConsultarClick(Sender: TObject);
var
  JSON: TJSONObject;
  vStl: TStringList;
  param: TParametroRecord;
begin
  vStl := TStringList.Create;
  JSON := TJSONObject.Create;

  try
    case rgChave.ItemIndex of
      0:
        begin
          try
            param.CEP := edtChave.Text;
            param.Uf := EmptyStr;
            param.Cidade := EmptyStr;
            param.endereco := EmptyStr;
            param.Connection := dmPrincipal.FDConnection1;

            case rgRetornoConsulta.ItemIndex of
              0:
                param.AClass := TJSONObject;

              1:
                param.AClass := TXMLDocument;
            end;

            JSON := TEnderecoController.getByCEP(param);
            if not Assigned(JSON) then
              exit;

            TfrmCadastro.Execute(JSON);
          except
            on e: Exception do
            begin
              MessageDlg(Format('O CEP %s n�o consta na base de CEPs v�lidos!',
                [edtChave.Text]), mtError, [mbOK], 0);
            end;
          end;
        end;

      1:
        begin
          try
            vStl.Delimiter := '/';
            vStl.DelimitedText := StringReplace(edtChave.Text, ' ', '+',
              [rfReplaceAll, rfIgnoreCase]);

            param.CEP := EmptyStr;
            param.Uf := vStl[0];
            param.Cidade := vStl[1];
            param.endereco := vStl[2];
            param.Connection := dmPrincipal.FDConnection1;

            case rgRetornoConsulta.ItemIndex of
              0:
                param.AClass := TJSONObject;

              1:
                param.AClass := TXMLDocument;
            end;

            JSON := TEnderecoController.getByEndereco(param);

            TfrmCadastro.Execute(JSON);
          except
            on e: Exception do
            begin
              MessageDlg
                (Format('O endere�o %s n�o consta na base de endere�os v�lidos!',
                [edtChave.Text]), mtError, [mbOK], 0);
            end;
          end;
        end;
    end;

    dmPrincipal.FDQuery1.Refresh;
    dbgEndereco.SetFocus;
  finally
    FreeAndNil(vStl);
    JSON.Free;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  vIndex: Integer;
  vColumnValue: String;
begin
  dmPrincipal.FDQuery1.Open;

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

  rgChaveClick(Sender);
end;

procedure TForm1.rgChaveClick(Sender: TObject);
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
