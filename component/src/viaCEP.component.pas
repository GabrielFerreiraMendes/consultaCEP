unit viaCEP.component;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client, XMLDoc,
  Xml.XMLIntf, System.JSON;

type
  TViaCepComponent = class(TComponent)
  private
    FCEP: String;
    FUF: String;
    FCidade: String;
    FEndereco: String;

    RESTRequest: TRESTRequest;
    RESTClient: TRESTClient;
    RESTResponse: TRESTResponse;
    function getCEP: String;
    procedure setCEP(const Value: String);
    function getUF: String;
    procedure setUF(const Value: String);
    function getCidade: String;
    procedure setCidade(const Value: String);
    function getEndereco: String;
    procedure setEndereco(const Value: String);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    function getJSONByCEP(): TJSONValue;
    function getJSONByEndereco(): TJSONValue;
    function getXMLByCEP(): IXMLDocument;
    function getXMLByEndereco(): IXMLDocument;
  published
    { Published declarations }
    property CEP: String read getCEP write setCEP;
    property UF: String read getUF write setUF;
    property Cidade: String read getCidade write setCidade;
    property Endereco: String read getEndereco write setEndereco;
  end;

const
  URL_CEP: String = 'https://viacep.com.br/ws/{cep}/{type}';
  URL_END: String = 'https://viacep.com.br/ws/{uf}/{cidade}/{endereco}/{type}';
  CT_TP_JSON: String = 'application/json';
  CT_TP_XML: String = 'application/xhtml+xml';

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('viaCEP', [TViaCepComponent]);
end;

{ TViaCepComponent }

function TViaCepComponent.getCEP: String;
begin
  Result := Self.FCEP;
end;

function TViaCepComponent.getCidade: String;
begin
  Result := FCidade;
end;

function TViaCepComponent.getEndereco: String;
begin
  Result := FEndereco;
end;

function TViaCepComponent.getJSONByCEP: TJSONValue;
begin
  if SameText(Trim(FCEP), EmptyStr) then
    raise Exception.Create('Cep inv�lido ou em branco!');

  if not Assigned(RESTClient) then
    RESTClient := TRESTClient.Create(URL_CEP);

  if not Assigned(RESTResponse) then
    RESTResponse := TRESTResponse.Create(nil);

  RESTResponse.ContentType := CT_TP_JSON;

  if not Assigned(RESTRequest) then
    RESTRequest := TRESTRequest.Create(nil);

  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  RESTRequest.Method := rmGet;
  RESTRequest.Params.AddItem('cep', Self.FCEP, pkURLSEGMENT, [], ctNone);
  RESTRequest.Params.AddItem('type', 'json', pkURLSEGMENT, [], ctNone);
  RESTRequest.Execute;

  Result := RESTResponse.JSONValue;
end;

function TViaCepComponent.getJSONByEndereco: TJSONValue;
begin
  if not Assigned(RESTClient) then
    RESTClient := TRESTClient.Create(URL_END);

  if not Assigned(RESTResponse) then
    RESTResponse := TRESTResponse.Create(nil);

  RESTResponse.ContentType := CT_TP_JSON;

  if not Assigned(RESTRequest) then
    RESTRequest := TRESTRequest.Create(nil);

  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  RESTRequest.Method := rmGet;
  RESTRequest.Params.AddItem('uf', Self.FUF, pkURLSEGMENT);
  RESTRequest.Params.AddItem('cidade', Self.FCidade, pkURLSEGMENT);
  RESTRequest.Params.AddItem('endereco', Self.FEndereco, pkURLSEGMENT);
  RESTRequest.Params.AddItem('type', 'json', pkURLSEGMENT);
  RESTRequest.Execute;

  Result := RESTResponse.JSONValue;
end;

function TViaCepComponent.getUF: String;
begin
  Result := Self.FUF;
end;

function TViaCepComponent.getXMLByCEP: IXMLDocument;
var
  vStl: TStringList;
begin
  vStl := TStringList.Create;
  Result := TXMLDocument.Create(nil);

  try
    if not Assigned(RESTClient) then
      RESTClient := TRESTClient.Create(URL_CEP);

    if not Assigned(RESTResponse) then
      RESTResponse := TRESTResponse.Create(nil);

    RESTResponse.ContentType := CT_TP_XML;

    if not Assigned(RESTRequest) then
      RESTRequest := TRESTRequest.Create(nil);

    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Method := rmGet;
    RESTRequest.Params.AddItem('cep', Self.FCEP, pkURLSEGMENT);
    RESTRequest.Params.AddItem('type', 'xml', pkURLSEGMENT);
    RESTRequest.Execute;

    vStl.Text := RESTResponse.Content;

    Result.Xml.AddStrings(vStl);
    Result.Active := true;
  finally
    FreeAndNil(vStl);
  end;
end;

function TViaCepComponent.getXMLByEndereco: IXMLDocument;
var
  vStl: TStringList;
begin
  vStl := TStringList.Create;
  Result := TXMLDocument.Create(nil);

  try
    if not Assigned(RESTClient) then
      RESTClient := TRESTClient.Create(URL_END);

    if not Assigned(RESTResponse) then
      RESTResponse := TRESTResponse.Create(nil);

    RESTResponse.ContentType := CT_TP_XML;

    if not Assigned(RESTRequest) then
      RESTRequest := TRESTRequest.Create(nil);

    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Method := rmGet;
    RESTRequest.Params.AddItem('uf', Self.FUF, pkURLSEGMENT);
    RESTRequest.Params.AddItem('cidade', Self.FCidade, pkURLSEGMENT);
    RESTRequest.Params.AddItem('endereco', Self.FEndereco, pkURLSEGMENT);
    RESTRequest.Params.AddItem('type', 'xml', pkURLSEGMENT);
    RESTRequest.Execute;

    vStl.Text := RESTResponse.Content;

    Result.Xml.AddStrings(vStl);
    Result.Active := true;
  finally
    FreeAndNil(vStl);
  end;
end;

procedure TViaCepComponent.setCEP(const Value: String);
begin
  if ((not SameText(Trim(Value), EmptyStr)) and (Length(Value) <> 8)) then
    raise Exception.Create('CEP inv�lido');

  Self.FCEP := Value;
end;

procedure TViaCepComponent.setCidade(const Value: String);
begin
  if ((not SameText(Trim(Value), EmptyStr)) and (Length(Value) < 3)) then
    raise Exception.Create('Cidade inv�lida!');

  Self.FCidade := Value;
end;

procedure TViaCepComponent.setEndereco(const Value: String);
begin
  if ((not SameText(Trim(Value), EmptyStr)) and (Length(Value) < 3)) then
    raise Exception.Create('Endere�o inv�lido!');

  Self.FEndereco := Value;
end;

procedure TViaCepComponent.setUF(const Value: String);
begin
  if ((not SameText(Trim(Value), EmptyStr)) and (Length(Value) <> 2)) then
    raise Exception.Create('UF inv�lida!');

  Self.FUF := Value;
end;

end.
