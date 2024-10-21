unit endereco.service;

interface

uses files.interfaces, FireDAC.Comp.Client, VCL.Dialogs,
  VCL.Controls, System.SysUtils, System.JSON, System.MaskUtils,
  viaCEP.component, endereco.model;

type
  TEnderecoService = class
  private
    class function getEnderecoDB(uf, cidade, endereco, cep: String;
      connection: TFDConnection): TJSONObject; static;
  public
    class procedure save(obj: iFiles; connection: TFDConnection);
    class procedure update(obj: iFiles; connection: TFDConnection);

    class function getByCEP(cep: String; connection: TFDConnection)
      : TJSONObject;
    class function getByEndereco(uf, cidade, endereco: String;
      connection: TFDConnection): TJSONObject;
  end;

implementation

{ TEnderecoService }

class function TEnderecoService.getEnderecoDB(uf, cidade, endereco, cep: String;
  connection: TFDConnection): TJSONObject;
var
  qry: TFDQuery;
  vMessage: String;
begin
  Result := nil;
  qry := TFDQuery.Create(nil);

  try
    qry.connection := connection;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT *             ');
    qry.SQL.Add('  FROM ENDERECOS E   ');
    qry.SQL.Add(' WHERE 1 = 1         ');

    if not SameText(Trim(cep), EmptyStr) then
    begin
      qry.SQL.Add('   AND E.CEP = :CEP  ');
      qry.ParamByName('CEP').AsString := FormatMaskText('00000\-000;0;', cep);

      vMessage := 'O cep informado consta na lista de endere�os cadastrados.' +
        #13 + 'Deseja atualiza-lo?';
    end;

    if (not SameText(Trim(uf), EmptyStr)) and
      (not SameText(Trim(cidade), EmptyStr)) and
      (not SameText(Trim(endereco), EmptyStr)) then
    begin
      qry.SQL.Add('   AND E.UF = :UF                    ');
      qry.SQL.Add('   AND E.LOCALIDADE = :LOCALIDADE    ');
      qry.SQL.Add('   AND E.LOGRADOURO = :LOGRADOURO  ');
      qry.ParamByName('UF').AsString := uf;
      qry.ParamByName('LOCALIDADE').AsString := cidade;
      qry.ParamByName('LOGRADOURO').AsString := StringReplace(endereco, '+',
        ' ', [rfReplaceAll, rfIgnoreCase]);

      vMessage :=
        'O endere�o informado consta na lista de endere�os cadastrados.' + #13 +
        'Deseja atualiza-lo?'
    end;

    qry.Open;

    if not qry.IsEmpty then
    begin
      if (MessageDlg(vMessage, mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrNo)
      then
        Exit;

      Result := TJSONObject.Create;
      Result.AddPair('codigo', qry.FieldByName('codigo').AsString);
      Result.AddPair('cep', qry.FieldByName('cep').AsString);
      Result.AddPair('logradouro', qry.FieldByName('logradouro').AsString);
      Result.AddPair('complemento', qry.FieldByName('complemento').AsString);
      Result.AddPair('bairro', qry.FieldByName('bairro').AsString);
      Result.AddPair('localidade', qry.FieldByName('localidade').AsString);
      Result.AddPair('uf', qry.FieldByName('uf').AsString);
    end
  finally
    qry.Close;
    FreeAndNil(qry);
  end;
end;

class function TEnderecoService.getByCEP(cep: String; connection: TFDConnection)
  : TJSONObject;
var
  JSON: TJSONObject;
  vViaCep: TViaCepComponent;
begin
  vViaCep := TViaCepComponent.Create(nil);

  try
    JSON := Self.getEnderecoDB(EmptyStr, EmptyStr, EmptyStr, cep, connection);

    if not Assigned(JSON) then
    begin
      vViaCep.cep := cep;
      vViaCep.uf := EmptyStr;
      vViaCep.cidade := EmptyStr;
      vViaCep.endereco := EmptyStr;

      JSON := TJSONObject(vViaCep.getJSONByCEP);
    end;

    Result := TEndereco.Create(JSON).toJSON;
  finally
    FreeAndNil(vViaCep);

    JSON.Free;
  end;
end;

class function TEnderecoService.getByEndereco(uf, cidade, endereco: String;
  connection: TFDConnection): TJSONObject;
var
  vViaCep: TViaCepComponent;
  JSON: TJSONObject;
  JSONArray: TJSONArray;
begin
  vViaCep := TViaCepComponent.Create(nil);

  try
    JSON := Self.getEnderecoDB(uf, cidade, endereco, EmptyStr, connection);

    if not Assigned(JSON) then
    begin
      vViaCep.cep := EmptyStr;
      vViaCep.uf := uf;
      vViaCep.cidade := cidade;
      vViaCep.endereco := endereco;

      JSON := TJSONObject(vViaCep.getJSONByEndereco);

      JSONArray := TJSONValue(JSON) as TJSONArray;

      { Como a consulta por endereco pode retornar mais de um endere�o,
        ser� realizada uma serie de convers�es para que possamos recuperar
        o primeiro da lista. Como sugest�o futura, criar mecanismo para que o
        usuario possa selecionar o endere�o dentre os retornados }
      JSON := TJSONObject(JSONArray[0]);
    end;

    Result := TEndereco.Create(JSON).toJSON;
  finally
    FreeAndNil(vViaCep);

    JSON.Free;
  end;
end;

class procedure TEnderecoService.save(obj: iFiles; connection: TFDConnection);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);

  try
    qry.connection := connection;

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

class procedure TEnderecoService.update(obj: iFiles; connection: TFDConnection);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);

  try
    qry.connection := connection;

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
