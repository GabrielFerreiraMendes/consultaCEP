object dmPrincipal: TdmPrincipal
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=consultacep'
      'User_Name=root'
      'Password=masterkey'
      'DriverID=MySQL')
    Left = 176
    Top = 104
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 
      'C:\Users\Gabriel\OneDrive\Documentos\consultaCEP\lib\LIBMYSQL.DL' +
      'L'
    Left = 176
    Top = 40
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM ENDERECOS;')
    Left = 520
    Top = 192
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 520
    Top = 128
  end
  object ViaCepComponent1: TViaCepComponent
    Left = 520
    Top = 272
  end
end
