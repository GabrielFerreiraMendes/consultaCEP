unit endereco.service;

interface

uses files.interfaces, endereco.model, FireDAC.Comp.Client, dtPrincipal,
  System.SysUtils, System.JSON, System.MaskUtils;

type
  TEnderecoService = class
  public
    class procedure save(obj: iFiles);
    class procedure update(obj: iFiles);
    class function exists(cep: String): Boolean;

    class function getByCEP(cep: String): TJSONObject;
    class function getByEndereco(uf, cidade, endereco: String): TJSONObject;
  end;

implementation

{ TEnderecoService }

class function TEnderecoService.exists(cep: String): Boolean;
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
    qry.ParamByName('CEP').AsString := cep;
    qry.Open;

    Result := (qry.FieldByName('CT').AsInteger > 0);
  finally
    FreeAndNil(qry);
  end;
end;

class function TEnderecoService.getByCEP(cep: String): TJSONObject;
var
  qry: TFDQuery;
  JSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  qry := TFDQuery.Create(nil);

  try
    qry.Connection := dmPrincipal.FDConnection1;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT *             ');
    qry.SQL.Add('  FROM ENDERECOS E   ');
    qry.SQL.Add(' WHERE E.CEP = :CEP  ');
    qry.ParamByName('CEP').AsString := FormatMaskText('00000\-000;0;', cep);
    qry.Open;

    if not qry.IsEmpty then
    begin
      Result.AddPair('codigo', qry.FieldByName('codigo').AsString);
      Result.AddPair('cep', qry.FieldByName('cep').AsString);
      Result.AddPair('logradouro', qry.FieldByName('logradouro').AsString);
      Result.AddPair('complemento', qry.FieldByName('complemento').AsString);
      Result.AddPair('bairro', qry.FieldByName('bairro').AsString);
      Result.AddPair('localidade', qry.FieldByName('localidade').AsString);
      Result.AddPair('uf', qry.FieldByName('uf').AsString);

      Exit;
    end;

    dmPrincipal.ViaCepComponent1.cep := cep;

    JSON := TJSONObject(dmPrincipal.ViaCepComponent1.getJSONByCEP);

    Result.AddPair('codigo', EmptyStr);
    Result.AddPair('cep', JSON.GetValue<String>('cep'));
    Result.AddPair('logradouro', JSON.GetValue<String>('logradouro'));
    Result.AddPair('complemento', JSON.GetValue<String>('complemento'));
    Result.AddPair('bairro', JSON.GetValue<String>('bairro'));
    Result.AddPair('localidade', JSON.GetValue<String>('localidade'));
    Result.AddPair('uf', JSON.GetValue<String>('uf'));
  finally
    JSON.Free;

    qry.Close;
    FreeAndNil(qry);
  end;

end;

class function TEnderecoService.getByEndereco(uf, cidade, endereco: String)
  : TJSONObject;
var
  qry: TFDQuery;
  JSON: TJSONObject;
  JSONArray: TJSONArray;
  vEndereco: TEndereco;
  vCodigo, vCep, vLogradouro, vComplemento, vBairro, vLocalidade, vUf: String;
begin
  Result := TJSONObject.Create;
  qry := TFDQuery.Create(nil);

  try
    qry.Connection := dmPrincipal.FDConnection1;

    dmPrincipal.ViaCepComponent1.uf := uf;
    dmPrincipal.ViaCepComponent1.cidade := cidade;
    dmPrincipal.ViaCepComponent1.endereco := endereco;

    JSON := TJSONObject(dmPrincipal.ViaCepComponent1.getJSONByEndereco);

    JSONArray := TJSONValue(JSON) as TJSONArray;

    { Como a consulta por endereco pode retornar mais de um endere�o,
      ser� realizada uma serie de convers�es para que possamos recuperar
      o primeiro da lista. Como sugest�o futura, criar mecanismo para que o
      usuario possa selecionar o endere�o dentre os retornados }
    vEndereco := TEndereco.Create(TJSONObject(JSONArray[0]));

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT *                             ');
    qry.SQL.Add('  FROM ENDERECOS E                   ');
    qry.SQL.Add(' WHERE E.UF = :UF                    ');
    qry.SQL.Add('   AND E.LOCALIDADE = :LOCALIDADE    ');
    qry.SQL.Add('   AND E.LOGRADOURO = :LOGRADOURO  ');
    qry.ParamByName('UF').AsString := vEndereco.uf;
    qry.ParamByName('LOCALIDADE').AsString := vEndereco.Localidade;
    qry.ParamByName('LOGRADOURO').AsString := vEndereco.Logradouro;
    qry.Open;

    if not qry.IsEmpty then
    begin
      vEndereco.Codigo := qry.FieldByName('CODIGO').AsInteger;
      vEndereco.cep := qry.FieldByName('CEP').AsString;
      vEndereco.Logradouro := qry.FieldByName('LOGRADOURO').AsString;
      vEndereco.Complemento := qry.FieldByName('COMPLEMENTO').AsString;
      vEndereco.Bairro := qry.FieldByName('BAIRRO').AsString;
      vEndereco.Localidade := qry.FieldByName('LOCALIDADE').AsString;
      vEndereco.uf := qry.FieldByName('UF').AsString;
    end;

    Result := vEndereco.toJSON;
  finally
    qry.Close;
    FreeAndNil(qry);

    JSON.Free;
  end;
end;

class procedure TEnderecoService.save(obj: iFiles);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);

  try
    qry.Connection := dmPrincipal.FDConnection1;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('INSERT INTO consultacep.enderecos(CEP,          ');
    qry.SQL.Add('                                  LOGRADOURO,   ');
    qry.SQL.Add('                                  COMPLEMENTO,  ');
    qry.SQL.Add('                                  BAIRRO,       ');
    qry.SQL.Add('                                  LOCALIDADE,   ');
    qry.SQL.Add('                                  UF)           ');
    qry.SQL.Add('                           VALUES(:CEP,         ');
    qry.SQL.Add('                                  :LOGRADOURO,  ');
    qry.SQL.Add('                                  :COMPLEMENTO, ');
    qry.SQL.Add('                                  :BAIRRO,      ');
    qry.SQL.Add('                                  :LOCALIDADE,  ');
    qry.SQL.Add('                                  :UF)          ');
    qry.ParamByName('CEP').AsString := TEndereco(obj).cep;
    qry.ParamByName('LOGRADOURO').AsString := TEndereco(obj).Logradouro;
    qry.ParamByName('COMPLEMENTO').AsString := TEndereco(obj).Complemento;
    qry.ParamByName('BAIRRO').AsString := TEndereco(obj).Bairro;
    qry.ParamByName('LOCALIDADE').AsString := TEndereco(obj).Localidade;
    qry.ParamByName('UF').AsString := TEndereco(obj).uf;
    qry.ExecSQL;
  finally
    qry.Close;
    FreeAndNil(qry);
  end;
end;

class procedure TEnderecoService.update(obj: iFiles);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);

  try
    qry.Connection := dmPrincipal.FDConnection1;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('UPDATE consultacep.enderecos       ');
    qry.SQL.Add('   SET CEP         = :CEP,         ');
    qry.SQL.Add('       LOGRADOURO  = :LOGRADOURO,  ');
    qry.SQL.Add('       Complemento = :COMPLEMENTO, ');
    qry.SQL.Add('       Bairro      = :BAIRRO,      ');
    qry.SQL.Add('       Localidade  = :LOCALIDADE,  ');
    qry.SQL.Add('       UF          = :UF           ');
    qry.SQL.Add(' WHERE CODIGO      = :CODIGO;      ');
    qry.ParamByName('CODIGO').AsInteger := TEndereco(obj).Codigo;
    qry.ParamByName('CEP').AsString := TEndereco(obj).cep;
    qry.ParamByName('LOGRADOURO').AsString := TEndereco(obj).Logradouro;
    qry.ParamByName('COMPLEMENTO').AsString := TEndereco(obj).Complemento;
    qry.ParamByName('BAIRRO').AsString := TEndereco(obj).Bairro;
    qry.ParamByName('LOCALIDADE').AsString := TEndereco(obj).Localidade;
    qry.ParamByName('UF').AsString := TEndereco(obj).uf;
    qry.ExecSQL;
  finally
    qry.Close;
    FreeAndNil(qry);
  end;
end;

end.