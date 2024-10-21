unit endereco.service;

interface

uses files.interfaces, FireDAC.Comp.Client, XMLDoc, Xml.XMLIntf,
  System.SysUtils, System.JSON, System.MaskUtils, System.Variants,
  viaCEP.component, endereco.model, parametro.records;

type
  TEnderecoService = class
  public
    class function getEnderecoDB(param: TParametroRecord): TJSONObject; static;

    class procedure save(obj: iFiles; connection: TFDConnection); static;
    class procedure update(obj: iFiles; connection: TFDConnection); static;

    class function getCEPByJSON(param: TParametroRecord): TJSONObject; static;

    class function getCEPByXML(param: TParametroRecord): TJSONObject; static;

    class function getEnderecoByJSON(param: TParametroRecord)
      : TJSONObject; static;

    class function getEnderecoByXML(param: TParametroRecord): TJSONObject; static;
  end;

implementation

{ TEnderecoService }
class function TEnderecoService.getEnderecoDB(param: TParametroRecord)
  : TJSONObject;
var
  qry: TFDQuery;
begin
  result := nil;
  qry := TFDQuery.Create(nil);

  try
    qry.connection := param.connection;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT *             ');
    qry.SQL.Add('  FROM ENDERECOS E   ');
    qry.SQL.Add(' WHERE 1 = 1         ');

    if not SameText(Trim(param.cep), EmptyStr) then
    begin
      qry.SQL.Add('   AND E.CEP = :CEP  ');
      qry.ParamByName('CEP').AsString := param.cep;
    end;

    if (not SameText(Trim(param.uf), EmptyStr)) and
      (not SameText(Trim(param.cidade), EmptyStr)) and
      (not SameText(Trim(param.endereco), EmptyStr)) then
    begin
      qry.SQL.Add('   AND E.UF = :UF                    ');
      qry.SQL.Add('   AND E.LOCALIDADE = :LOCALIDADE    ');
      qry.SQL.Add('   AND E.LOGRADOURO = :LOGRADOURO  ');
      qry.ParamByName('UF').AsString := param.uf;
      qry.ParamByName('LOCALIDADE').AsString := param.cidade;
      qry.ParamByName('LOGRADOURO').AsString := StringReplace(param.endereco,
        '+', ' ', [rfReplaceAll, rfIgnoreCase]);
    end;

    qry.Open;

    if not qry.IsEmpty then
    begin
      result := TJSONObject.Create;
      result.AddPair('codigo', qry.FieldByName('codigo').AsString);
      result.AddPair('cep', qry.FieldByName('cep').AsString);
      result.AddPair('logradouro', qry.FieldByName('logradouro').AsString);
      result.AddPair('complemento', qry.FieldByName('complemento').AsString);
      result.AddPair('bairro', qry.FieldByName('bairro').AsString);
      result.AddPair('localidade', qry.FieldByName('localidade').AsString);
      result.AddPair('uf', qry.FieldByName('uf').AsString);
    end
  finally
    qry.Close;
    FreeAndNil(qry);
  end;
end;

class function TEnderecoService.getCEPByJSON(param: TParametroRecord)
  : TJSONObject;
var
  JSON: TJSONObject;
  vViaCep: TViaCepComponent;
begin
  vViaCep := TViaCepComponent.Create(nil);

  try
    vViaCep.cep := param.cep;

    result := TJSONObject(vViaCep.getJSONByCEP);
  finally
    FreeAndNil(vViaCep);
  end;
end;

class function TEnderecoService.getCEPByXML(param: TParametroRecord)
  : TJSONObject;
var
  JSON: TJSONObject;
  vViaCep: TViaCepComponent;
begin
  vViaCep := TViaCepComponent.Create(nil);

  try
    vViaCep.cep := param.cep;

    result := TEndereco.Create(TXMLDocument(vViaCep.getXMLByCEP)).toJSON;
  finally
    FreeAndNil(vViaCep);
  end;
end;

class function TEnderecoService.getEnderecoByJSON(param: TParametroRecord): TJSONObject;
var
  vViaCep: TViaCepComponent;
  JSON: TJSONObject;
  JSONArray: TJSONArray;
begin
  vViaCep := TViaCepComponent.Create(nil);

  try
    vViaCep.uf := param.Uf;
    vViaCep.cidade := param.Cidade;
    vViaCep.endereco := param.Endereco;

    JSON := TJSONObject(vViaCep.getJSONByEndereco);

    { Como a consulta por endereco pode retornar mais de um endere�o,
      ser�o realizadas opera��es para que seja poss�vel recuperar
      o primeiro da lista. Como sugest�o futura, criar mecanismo para que o
      usuario possa selecionar o endere�o dentre os retornados }
    JSONArray := TJSONValue(JSON) as TJSONArray;

    result := TJSONObject(JSONArray[0]);
  finally
    FreeAndNil(vViaCep);
  end;
end;

class function TEnderecoService.getEnderecoByXML(param: TParametroRecord): TJSONObject;
var
  vViaCep: TViaCepComponent;
  teste: String;
begin
  vViaCep := TViaCepComponent.Create(nil);

  try
    vViaCep.uf := param.Uf;
    vViaCep.cidade := param.Cidade;
    vViaCep.endereco := param.Endereco;

    { Como a consulta por endereco pode retornar mais de um endere�o,
      ser� utilizado um registro da lista. Como sugest�o futura, criar
      mecanismo para que o usuario possa selecionar o endere�o dentre
      os retornados }
    result := TEndereco.Create(TXMLDocument(vViaCep.getXMLByEndereco)).toJSON;
  finally
    FreeAndNil(vViaCep);
  end;
end;

class procedure TEnderecoService.save(obj: iFiles; connection: TFDConnection);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);

  try
    if not connection.InTransaction then
      connection.StartTransaction;

    qry.connection := connection;

    try
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
    except
      on e: Exception do
      begin
        connection.Rollback;

        raise Exception.Create(e.Message);
      end;
    end;

    connection.Commit;
  finally
    qry.Close;
    FreeAndNil(qry);
  end;
end;

class procedure TEnderecoService.update(obj: iFiles; connection: TFDConnection);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);

  try
    if not connection.InTransaction then
      connection.StartTransaction;

    qry.connection := connection;

    try
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
    except
      on e: Exception do
      begin
        connection.Rollback;

        raise Exception.Create(e.Message);
      end;
    end;

    connection.Commit;
  finally
    qry.Close;
    FreeAndNil(qry);
  end;
end;

end.
