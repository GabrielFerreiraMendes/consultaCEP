object dmPrincipal: TdmPrincipal
  Height = 256
  Width = 344
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=consultacep'
      'User_Name=root'
      'Password=masterkey'
      'DriverID=MySQL')
    Left = 64
    Top = 128
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 
      'C:\Users\Gabriel\OneDrive\Documentos\consultaCEP\lib\LIBMYSQL.DL' +
      'L'
    Left = 64
    Top = 64
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM ENDERECOS;')
    Left = 240
    Top = 136
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 240
    Top = 72
  end
end
