unit endereco.controller;

interface

uses files.interfaces, FireDAC.Comp.Client, System.SysUtils, System.JSON,
  endereco.service, System.MaskUtils, endereco.model;

type
  TEnderecoController = class
  private
    class procedure update(JSON: TJSONObject; connection: TFDConnection);
    class procedure checkConnection(connection: TFDConnection);
  public
    class procedure save(JSON: TJSONObject; connection: TFDConnection);

    class function getByCEP(cep: String; connection: TFDConnection)
      : TJSONObject;

    class function getByEndereco(uf, cidade, endereco: String;
      connection: TFDConnection): TJSONObject;
  end;

implementation

{ TEnderecoController }

class function TEnderecoController.getByCEP(cep: String;
  connection: TFDConnection): TJSONObject;
begin
  Self.checkConnection(connection);
  Result := TEnderecoService.getByCEP(cep, connection);
end;

class function TEnderecoController.getByEndereco(uf, cidade, endereco: String;
  connection: TFDConnection): TJSONObject;
begin
  Self.checkConnection(connection);
  Result := TEnderecoService.getByEndereco(uf, cidade, endereco, connection);
end;

class procedure TEnderecoController.checkConnection(connection: TFDConnection);
begin
  if not connection.Connected then
    raise Exception.Create('Erro na conex�o com o banco de dados.');
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
