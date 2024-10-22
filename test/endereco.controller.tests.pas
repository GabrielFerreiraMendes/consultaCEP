unit endereco.controller.tests;

interface

uses
  DUnitX.TestFramework, endereco.controller, viacep.records, parametro.records,
  JSON, endereco.exceptions;

type

  [TestFixture]
  TestTEnderecoController = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure TestParametroException;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA', '1,2')]
    [TestCase('TestB', '3,4')]
    procedure Test2(const AValue1: Integer; const AValue2: Integer);
  end;

implementation

procedure TestTEnderecoController.Setup;
begin
end;

procedure TestTEnderecoController.TearDown;
begin
end;

procedure TestTEnderecoController.TestParametroException;
var
  param: TParametroRecord;
begin
  param.Key := 'GO/GYN/Rua Atlético Goianiense';
  param.RequisitionType := 1;
  param.ResultType := 0;

  Assert.WillRaise(
    procedure
    begin
      TEnderecoController.findEncereco(param);
    end, TCidadeException,
    '');
end;

procedure TestTEnderecoController.Test2(const AValue1: Integer;
const AValue2: Integer);
begin
end;

initialization

TDUnitX.RegisterTestFixture(TestTEnderecoController);

end.
