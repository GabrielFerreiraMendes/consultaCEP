unit files.interfaces;

interface

uses System.JSON, XMLDoc, Xml.XMLIntf;

type
  iFiles = interface
    function toJSON(): TJSONObject;
    procedure fromJSON(JSON: TJSONObject);
    function toXML(): TXMLDocument;
    procedure fromXML(XML: IXMLDocument);
  end;

implementation

end.
