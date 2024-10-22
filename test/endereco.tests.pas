unit endereco.tests;

interface

uses
  DUnitX.TestFramework, endereco.model, SysUtils, JSON;

type

  [TestFixture]
  TestTEndereco = class
  private
    FEndereco: TEndereco;
    FJSON: TJSONObject;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    [TestCase('TestA',
      '17,74565006,Rua Vitória Régia,teste A,Panorama Parque, Goiânia, GO')]
    [TestCase('TestB',
      '18,74565220,Rua Atlético Goianiense - 1937,teste B,Setor Urias Magalhães, Goiânia, GO')]
    procedure TestLoad(codigo: Integer; cep, logradouro, complemento, bairro,
      localidade, uf: String);
  end;

implementation

procedure TestTEndereco.Setup;
begin
  FEndereco := TEndereco.Create;
  FJSON := TJSONObject.Create;
end;

procedure TestTEndereco.TearDown;
begin
  FJSON.Free;
  FreeAndNil(FEndereco);
end;

procedure TestTEndereco.TestLoad(codigo: Integer; cep, logradouro, complemento,
  bairro, localidade, uf: String);
begin
  FJSON.AddPair('codigo', Codigo);
  FJSON.AddPair('cep', CEP);
  FJSON.AddPair('logradouro', Logradouro);
  FJSON.AddPair('complemento', Complemento);
  FJSON.AddPair('bairro', Bairro);
  FJSON.AddPair('localidade', Localidade);
  FJSON.AddPair('uf', UF);

  FEndereco.loadFrom(FJSON);

  Assert.AreEqual(FEndereco.toJSON, FJSON);
end;

initialization

TDUnitX.RegisterTestFixture(TestTEndereco);

end.
