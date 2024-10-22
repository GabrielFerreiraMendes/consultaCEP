unit parametro.records;

interface

uses FireDAC.Comp.Client;

type
  TParametroRecord = record
    RequisitionType: Integer;
    ResultType: Integer;
    Key: String;
    Connection: TFDConnection;
  end;

implementation

end.
