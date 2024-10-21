unit files.interfaces;

interface

uses System.JSON, XMLDoc, Xml.XMLIntf;

type
  iFiles = interface
  ['{901166D6-E2B7-4AF5-B72A-BBD4CC4A8377}']
    function toJSON(): TJSONObject;
    procedure loadFrom(JSON: TJSONObject); overload;
    procedure loadFrom(XML: IXMLDocument); overload;
  end;

implementation

end.
