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
    object FDQuery1codigo: TLargeintField
      AutoGenerateValue = arAutoInc
      DisplayLabel = 'C'#243'digo'
      FieldName = 'codigo'
      Origin = 'codigo'
      ProviderFlags = [pfInWhere, pfInKey]
    end
    object FDQuery1cep: TStringField
      DisplayLabel = 'CEP'
      DisplayWidth = 9
      FieldName = 'cep'
      Origin = 'cep'
      Required = True
      OnGetText = FDQuery1cepGetText
      Size = 45
    end
    object FDQuery1logradouro: TStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Logradouro'
      FieldName = 'logradouro'
      Origin = 'logradouro'
      Size = 45
    end
    object FDQuery1complemento: TStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Complemento'
      FieldName = 'complemento'
      Origin = 'complemento'
      Size = 45
    end
    object FDQuery1bairro: TStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Bairro'
      FieldName = 'bairro'
      Origin = 'bairro'
      Size = 45
    end
    object FDQuery1localidade: TStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Localidade'
      FieldName = 'localidade'
      Origin = 'localidade'
      Size = 45
    end
    object FDQuery1uf: TStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'UF'
      FieldName = 'uf'
      Origin = 'uf'
      Size = 2
    end
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 240
    Top = 72
  end
end
