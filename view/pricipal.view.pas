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
    GroupBox1: TGroupBox;
    edtChave: TEdit;
    btnConsultar: TButton;
    rgChave: TRadioGroup;
    rgRetornoConsulta: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure rgChaveClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
  private
    procedure operacaoJSON;
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

procedure TForm1.operacaoJSON();
var
  JSON: TJSONObject;
  vStl: TStringList;
begin
  case rgChave.ItemIndex of
    0:
      begin
        try
         JSON := TEnderecoController.getByCEP(edtChave.Text,
            dmPrincipal.FDConnection1);

          if not Assigned(JSON) then
           exit;

          TfrmCadastro.Execute(JSON);
          dmPrincipal.FDQuery1.Refresh;
          dbgEndereco.SetFocus;
        except
          on e: Exception do
          begin
            MessageDlg(Format('O CEP %s não consta na base de CEPs válidos!',
              [edtChave.Text]), mtError, [mbOK], 0);
          end;
        end;
      end;

    1:
      begin
        vStl := TStringList.Create;
        try
          try
            vStl.Delimiter := '/';
            vStl.DelimitedText := StringReplace(edtChave.Text, ' ', '+',
              [rfReplaceAll, rfIgnoreCase]);

            JSON := TEnderecoController.getByEndereco(vStl[0], vStl[1], vStl[2],
              dmPrincipal.FDConnection1);

            TfrmCadastro.Execute(JSON);
            dmPrincipal.FDQuery1.Refresh;
          except
            on e: Exception do
            begin
              MessageDlg
                (Format('O endereço %s não consta na base de endereços válidos!',
                [edtChave.Text]), mtError, [mbOK], 0);
            end;
          end;

          dbgEndereco.SetFocus;
        finally
          FreeAndNil(vStl);
          JSON.Free;
        end;
      end;
  end;
end;

procedure TForm1.btnConsultarClick(Sender: TObject);
begin
  case rgRetornoConsulta.ItemIndex of
    0:
      begin
        operacaoJSON;
      end;

    1:
      begin

      end;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  vIndex: Integer;
  vColumnValue: String;
begin
  dmPrincipal.FDQuery1.Open;

  { Aplica o melhor dimensionamento para as colunas
    baseado no primeiro registro ou no tamanho do título da coluna }
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
