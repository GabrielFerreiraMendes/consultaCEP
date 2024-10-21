unit dtPrincipal;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, viaCEP.component, System.MaskUtils;

type
  TdmPrincipal = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    FDQuery1codigo: TLargeintField;
    FDQuery1cep: TStringField;
    FDQuery1logradouro: TStringField;
    FDQuery1complemento: TStringField;
    FDQuery1bairro: TStringField;
    FDQuery1localidade: TStringField;
    FDQuery1uf: TStringField;
    procedure FDQuery1cepGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    { Public declarations }
  end;

var
  dmPrincipal: TdmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TdmPrincipal }

procedure TdmPrincipal.Commit;
begin
  if not Self.FDConnection1.InTransaction then
    raise Exception.Create('N�o h� transa��o ativa.');

  Self.FDConnection1.Commit;
end;

procedure TdmPrincipal.FDQuery1cepGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := FormatMaskText('00000\-000;0;', Sender.AsString);
end;

procedure TdmPrincipal.RollBack;
begin
  if not Self.FDConnection1.InTransaction then
    raise Exception.Create('N�o h� transa��o ativa.');

  Self.FDConnection1.RollBack;
end;

procedure TdmPrincipal.StartTransaction;
begin
  { Permite transa��es aninhadas }
  Self.FDConnection1.TxOptions.EnableNested := True;
  Self.FDConnection1.TxOptions.AutoCommit := True;

  Self.FDConnection1.StartTransaction;
end;

end.
