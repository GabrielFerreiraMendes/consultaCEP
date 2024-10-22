unit endereco.controller;

interface

uses files.interfaces, FireDAC.Comp.Client, System.SysUtils, System.JSON,
  endereco.service, endereco.model, VCL.Dialogs, VCL.Controls,
  XMLDoc, Xml.XMLIntf, parametro.records;

type
  TEnderecoController = class
  private
    class procedure update(endereco: TEndereco; connection: TFDConnection);
    class procedure checkConnection(connection: TFDConnection);
  public
    class procedure save(endereco: TEndereco; connection: TFDConnection);

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
    (MessageDlg('O CEP informado consta na lista de endere�os cadastrados.' +
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
  if (Length(param.Cidade) <= 3) or (Length(param.endereco) <= 3) then
    Abort;

  Self.checkConnection(param.connection);

  Result := TEnderecoService.getEnderecoDB(param);

  if Assigned(Result) and
    (MessageDlg('O endere�o informado consta na lista de endere�os cadastrados.'
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
    raise Exception.Create('Erro na conex�o com o banco de dados.');
end;

class procedure TEnderecoController.save(endereco: TEndereco;
  connection: TFDConnection);
begin
  Self.checkConnection(connection);

  if (endereco.Codigo <= 0) then
    TEnderecoController.update(endereco, connection)
  else
    TEnderecoService.save(endereco, connection);
end;

class procedure TEnderecoController.update(endereco: TEndereco;
  connection: TFDConnection);
begin
  Self.checkConnection(connection);
  TEnderecoService.update(endereco, connection);
end;

end.
