unit endereco.controller;

interface

uses files.interfaces, endereco.model, FireDAC.Comp.Client, dtPrincipal,
  System.SysUtils, System.JSON, endereco.service, System.MaskUtils;

type
  TEnderecoController = class
  private
    class procedure update(JSON: TJSONObject);
  public
    class procedure save(JSON: TJSONObject);

    class function exists(cep: String): Boolean;

    class function getByCEP(cep: String): TJSONObject;
    class function getByEndereco(uf, cidade, endereco: String): TJSONObject;
  end;

implementation

{ TEnderecoController }

class function TEnderecoController.exists(cep: String): Boolean;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);

  try
    qry.Connection := dmPrincipal.FDConnection1;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add
      ('SELECT COUNT(*) as CT FROM consultacep.enderecos WHERE CEP = :CEP;');
    qry.ParamByName('CEP').AsString := FormatMaskText('00000\-000;0;', cep);
    qry.Open;

    Result := (qry.FieldByName('CT').AsInteger > 0);
  finally
    FreeAndNil(qry);
  end;
end;

class function TEnderecoController.getByCEP(cep: String): TJSONObject;
begin
  Result := TEnderecoService.getByCEP(cep);
end;

class function TEnderecoController.getByEndereco(uf, cidade,
  endereco: String): TJSONObject;
begin
  Result := TEnderecoService.getByEndereco(uf, cidade, endereco);
end;

class procedure TEnderecoController.save(JSON: TJSONObject);
begin
  if not SameText(JSON.GetValue<String>('codigo'), EmptyStr) then
  begin
    TEnderecoController.update(JSON);

    Exit;
  end;

  TEnderecoService.save(TEndereco.Create(JSON));
end;

class procedure TEnderecoController.update(JSON: TJSONObject);
begin
  TEnderecoService.update(TEndereco.Create(JSON));
end;

end.
