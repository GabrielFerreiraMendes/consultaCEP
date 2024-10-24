unit endereco.model;

interface

uses files.interfaces, System.JSON, XMLDoc, Xml.XMLIntf, System.SysUtils,
  System.StrUtils, System.Variants;

type
  TEndereco = class(TInterfacedObject, iFiles)
  private
    FCodigo: Integer;
    FCEP: String;
    FLogradouro: String;
    FComplemento: String;
    FBairro: String;
    FLocalidade: String;
    FUF: String;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property CEP: String read FCEP write FCEP;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Complemento: String read FComplemento write FComplemento;
    property Bairro: String read FBairro write FBairro;
    property Localidade: String read FLocalidade write FLocalidade;
    property UF: String read FUF write FUF;

    procedure loadFrom(JSON: TJSONObject); overload;
    procedure loadFrom(Xml: IXMLDocument); overload;
    function toJSON(): TJSONObject;

    constructor Create(JSON: TJSONObject); overload;
    constructor Create(Xml: TXMLDocument); overload;
  end;

implementation

{ TEndereco }

procedure TEndereco.loadFrom(JSON: TJSONObject);
begin
  try
    try
      Self.FCodigo := JSON.GetValue<Integer>('codigo');
    except
      Self.FCodigo := 0;
    end;

    Self.FCEP := JSON.GetValue<String>('cep');
    Self.FLogradouro := JSON.GetValue<String>('logradouro');
    Self.FComplemento := JSON.GetValue<String>('complemento');
    Self.FBairro := JSON.GetValue<String>('bairro');
    Self.FLocalidade := JSON.GetValue<String>('localidade');
    Self.FUF := JSON.GetValue<String>('uf');
  except
    on e: Exception do
    begin
      raise Exception.Create('JSON inv�lido!' + #13 + 'Mensagem de erro: ' +
        e.Message);
    end;
  end;
end;

constructor TEndereco.Create(JSON: TJSONObject);
begin
  Self.loadFrom(JSON);
end;

constructor TEndereco.Create(Xml: TXMLDocument);
begin
  Self.loadFrom(Xml);
end;

procedure TEndereco.loadFrom(Xml: IXMLDocument);
var
  vIndex: Integer;
  root, node: IXMLNode;
  list: IXMLNodeList;
begin
  try
    root := Xml.DocumentElement.ChildNodes.FindNode('enderecos')
      .ChildNodes.FindNode('endereco');

    Self.FCEP := root.AttributeNodes.Nodes['cep'].Text;

    list := root.ChildNodes;

    for vIndex := 0 to list.Count - 1 do
    begin
      node := list[vIndex];

      Case IndexStr(node.NodeName, ['cep', 'logradouro', 'complemento',
        'bairro', 'localidade', 'uf']) of
        0:
          Self.FCEP := VarToStr(node.NodeValue);

        1:
          Self.Logradouro := VarToStr(node.NodeValue);

        2:
          Self.Complemento := VarToStr(node.NodeValue);

        3:
          Self.FBairro := VarToStr(node.NodeValue);

        4:
          Self.FLocalidade := VarToStr(node.NodeValue);

        5:
          Self.FUF := VarToStr(node.NodeValue);
      end;
    end;
  except
    on e: Exception do
    begin
      raise Exception.Create(Format('XML inv�lido! Menssagem do erro: %s',
        [e.Message]));
    end;
  end;
end;

function TEndereco.toJSON: TJSONObject;
begin
  Result := TJSONObject.Create;

  try
    if (Self.FCodigo > 0) then
      Result.AddPair('codigo', Self.FCodigo);

    Result.AddPair('cep', Self.FCEP);
    Result.AddPair('logradouro', Self.FLogradouro);
    Result.AddPair('complemento', Self.FComplemento);
    Result.AddPair('bairro', Self.FBairro);
    Result.AddPair('localidade', Self.FLocalidade);
    Result.AddPair('uf', Self.FUF);
  except
    on e: Exception do
    begin
      raise Exception.Create(Format('JSON inv�lido! Menssagem do erro: %s',
        [e.Message]));
    end;
  end;
end;

end.
