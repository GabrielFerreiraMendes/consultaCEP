unit endereco.controller;

interface

uses files.interfaces, FireDAC.Comp.Client, System.SysUtils, System.JSON,
  endereco.service, endereco.model, VCL.Dialogs, VCL.Controls,
  XMLDoc, Xml.XMLIntf, parametro.records;

type
  TEnderecoController = class
  private
    class procedure update(JSON: TJSONObject; connection: TFDConnection);
    class procedure checkConnection(connection: TFDConnection);
  public
    class procedure save(JSON: TJSONObject; connection: TFDConnection);

    class function getByCEP(param: TParametroRecord): TJSONObject;

    class function getByEndereco(param: TParametroRecord): TJSONObject;
  end;

implementation

{ TEnderecoController }

class function TEnderecoController.getByCEP(param: TParametroRecord)
  : TJSONObject;
begin
  Self.checkConnection(param.connection);

  Result := TEnderecoService.getEnderecoDB(param);

  if Assigned(Result) and
    (MessageDlg('O CEP informado consta na lista de endereços cadastrados.' +
    #13 + 'Deseja atualiza-lo?', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrNo)
  then
  begin
    Result := nil;
    Exit;
  end;

  if not Assigned(Result) then
  begin
    if (param.aclass = TJSONObject) then
      Result := TEnderecoService.getCEPByJSON(param);

    if (param.aclass = TXMLDocument) then
      Result := TEnderecoService.getCEPByXML(param);
  end;

end;

class function TEnderecoController.getByEndereco(param: TParametroRecord)
  : TJSONObject;
begin
  Self.checkConnection(param.connection);

  Result := TEnderecoService.getEnderecoDB(param);

  if (Length(param.Cidade) < 3) or (Length(param.endereco) < 3) then
    Abort;

  if Assigned(Result) and
    (MessageDlg('O endereço informado consta na lista de endereços cadastrados.'
    + #13 + ' Deseja atualiza-lo ? ', mtConfirmation, [mbYes, mbNo], 0, mbYes)
    = mrNo) then
  begin
    Result := nil;
    Exit;
  end;

  if not Assigned(Result) then
  begin
    if param.aclass = TJSONObject then
      Result := TEnderecoService.getEnderecoByJSON(param);

    if param.aclass = TXMLDocument then
      Result := TEnderecoService.getEnderecoByXML(param);
  end;
end;

class procedure TEnderecoController.checkConnection(connection: TFDConnection);
begin
  if not connection.Connected then
    raise Exception.Create('Erro na conexão com o banco de dados.');
end;

class procedure TEnderecoController.save(JSON: TJSONObject;
  connection: TFDConnection);
begin
  Self.checkConnection(connection);

  if not SameText(JSON.GetValue<String>('codigo'), EmptyStr) then
    TEnderecoController.update(JSON, connection)
  else
    TEnderecoService.save(TEndereco.Create(JSON), connection);
end;

class procedure TEnderecoController.update(JSON: TJSONObject;
  connection: TFDConnection);
begin
  Self.checkConnection(connection);
  TEnderecoService.update(TEndereco.Create(JSON), connection);
end;

end.
