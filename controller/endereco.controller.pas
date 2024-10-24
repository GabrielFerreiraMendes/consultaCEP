unit endereco.controller;

interface

uses files.interfaces, FireDAC.Comp.Client, System.SysUtils, System.JSON,
  endereco.service, endereco.model, VCL.Dialogs, VCL.Controls,
  XMLDoc, Xml.XMLIntf, parametro.records, System.Classes, System.UITypes,
  System.StrUtils, viacep.records, endereco.exceptions;

type
  TEnderecoController = class
  private
    class procedure checkConnection(connection: TFDConnection);
    class function getByCEP(param: TParametroRecord): TJSONObject;
    class function getByEndereco(param: TParametroRecord): TJSONObject;
  public
    class procedure save(endereco: TEndereco; connection: TFDConnection);
    class function findEncereco(param: TParametroRecord): TJSONObject;
  end;

implementation

{ TEnderecoController }

class function TEnderecoController.getByCEP(param: TParametroRecord)
  : TJSONObject;
var
  viaCEPParam: TViaCEPRecord;
begin
  Self.checkConnection(param.connection);

  viaCEPParam.CEP := param.Key;
  Result := TEnderecoService.getEnderecoDB(viaCEPParam, param.connection);

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
    case param.ResultType of
      0:
        Result := TEnderecoService.getCEPByJSON(viaCEPParam);

      1:
        Result := TEnderecoService.getCEPByXML(viaCEPParam);
    end;
  end;

end;

class function TEnderecoController.getByEndereco(param: TParametroRecord)
  : TJSONObject;
var
  vStl: TStringList;
  viaCEPParam: TViaCEPRecord;
begin
  vStl := TStringList.Create;

  try
    vStl.Delimiter := '/';
    vStl.DelimitedText := StringReplace(param.Key, ' ', '+',
      [rfReplaceAll, rfIgnoreCase]);

    if (vStl.Count < 3) then
      raise TFortmatoEnderecoException.Create;

    if (Length(vStl[1]) <= 3) then
      raise TCidadeException.Create;

    if (Length(vStl[2]) <= 3) then
      raise TLogradouroException.Create;

    viaCEPParam.Uf := vStl[0];
    viaCEPParam.Cidade := vStl[1];
    viaCEPParam.Logradouro := vStl[2];

    Self.checkConnection(param.connection);

    Result := TEnderecoService.getEnderecoDB(viaCEPParam, param.connection);

    if Assigned(Result) and
      (MessageDlg
      ('O endere�o informado consta na lista de endere�os cadastrados.' + #13 +
      ' Deseja atualiza-lo ? ', mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrNo)
    then
    begin
      Result := nil;
      Exit;
    end;

    if not Assigned(Result) then
    begin
      case param.ResultType of
        0:
          Result := TEnderecoService.getEnderecoByJSON(viaCEPParam);

        1:
          Result := TEnderecoService.getEnderecoByXML(viaCEPParam);
      end;
    end;
  finally
    FreeAndNil(vStl);
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
    TEnderecoService.save(endereco, connection)
  else
    TEnderecoService.update(endereco, connection);
end;

class function TEnderecoController.findEncereco(param: TParametroRecord)
  : TJSONObject;
var
  errorMsg: String;
begin
  Result := nil;

  case param.RequisitionType of
    0:
      begin
        try
          Result := TEnderecoController.getByCEP(param);
        except
          on e: Exception do
          begin
            MessageDlg(Format('O CEP %s n�o consta na base de CEPs v�lidos!',
              [param.Key]), mtError, [mbOK], 0);
          end;
        end;
      end;

    1:
      begin
        try
          Result := TEnderecoController.getByEndereco(param);
        except
          on e: Exception do
          begin
            errorMsg := Format('O CEP %s n�o consta na base de CEPs v�lidos!',
              [param.Key]);

            if (e.ClassType = TFortmatoEnderecoException) or
              (e.ClassType = TCidadeException) or
              (e.ClassType = TLogradouroException) then
              errorMsg := e.Message;

            MessageDlg(errorMsg, mtError, [mbOK], 0);
          end;
        end;
      end;
  end;
end;

end.
