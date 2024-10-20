unit pricipal.view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.MaskUtils, endereco.controller,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, dtPrincipal, System.JSON, cadastro.view;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    dbgEndereco: TDBGrid;
    Button1: TButton;
    GroupBox1: TGroupBox;
    edtChave: TEdit;
    btnConsultar: TButton;
    rgChave: TRadioGroup;
    rgRetornoConsulta: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgChaveClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure edtChaveClick(Sender: TObject);
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
begin
  case rgChave.ItemIndex of
    0:
      begin
        try
          JSON := TEnderecoController.getByCEP(edtChave.text);
          TfrmCadastro.Execute(JSON);
          dmPrincipal.FDQuery1.Refresh;
          dbgEndereco.SetFocus;
        except
          on e: Exception do
          begin
            MessageDlg(Format('O CEP %s n�o consta na base de CEPs v�lidos!',
              [edtChave.text]), mtError, [mbOK], 0);
          end;
        end;
      end;

    1:
      begin
        vStl := TStringList.Create;
        try
          try
            vStl.Delimiter := '/';
            vStl.DelimitedText := StringReplace(edtChave.text, ' ', '+',
              [rfReplaceAll, rfIgnoreCase]);

            JSON := TEnderecoController.getByEndereco(vStl[0], vStl[1],
              vStl[2]);
            TfrmCadastro.Execute(JSON);
            dmPrincipal.FDQuery1.Refresh;
            dbgEndereco.SetFocus;
          except
            on e: Exception do
            begin
              MessageDlg(Format('O CEP %s n�o consta na base de CEPs v�lidos!',
                [edtChave.text]), mtError, [mbOK], 0);
            end;
          end;
        finally
          FreeAndNil(vStl);
          JSON.Free;
        end;
      end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TfrmCadastro.Execute;
  dmPrincipal.FDQuery1.Refresh;
end;

procedure TForm1.edtChaveClick(Sender: TObject);
begin
  edtChave.SelStart := 0;
  edtChave.SelLength := Length(edtChave.text) + 1;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  vIndex: Integer;
  vColumnValue: String;
begin
  dmPrincipal.FDQuery1.Open;

  { Aplica o melhor dimensionamento para as colunas
    baseado no primeiro registro ou no tamanho do t�tulo da coluna }
  for vIndex := 0 to dbgEndereco.Columns.Count - 1 do
  begin
    vColumnValue := dbgEndereco.Fields[vIndex].DisplayText;

    if SameText(vColumnValue, EmptyStr) then
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
        edtChave.text := KEY_CEP_TEXT;
      end;
    1:
      begin
        edtChave.NumbersOnly := false;
        edtChave.text := KEY_END_TEXT;
      end;
  end;
end;

end.
