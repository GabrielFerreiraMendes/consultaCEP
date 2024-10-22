unit endereco.exceptions;

interface

uses System.SysUtils;

type
  TFortmatoEnderecoException = class(Exception)
    constructor Create();
  end;

type
  TCidadeException = class(Exception)
    constructor Create();
  end;

type
  TLogradouroException = class(Exception)
    constructor Create();
  end;

implementation

{ TFortmatoEnderecoException }

constructor TFortmatoEnderecoException.Create;
begin
  Self.Message := 'Formato de endere�o inv�lido!';
end;

{ TCidadeException }

constructor TCidadeException.Create;
begin
  Self.Message :=
    'Cidade inv�lida, o nome da cidade deve conter mais de 3 caracteres!';
end;

{ TLogradouroException }

constructor TLogradouroException.Create;
begin
  Self.Message :=
    'Logradouro inv�lido, a descri��o do logradouro deve conter mais de 3 caracteres!';
end;

end.
