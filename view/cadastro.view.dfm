object frmCadastro: TfrmCadastro
  Left = 0
  Top = 0
  Caption = 'Cadastro de endere'#231'o'
  ClientHeight = 195
  ClientWidth = 570
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 570
    Height = 195
    Align = alClient
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 442
      Top = 105
      Width = 120
      Height = 49
      Caption = ' UF '
      TabOrder = 4
      object edtUf: TEdit
        Left = 10
        Top = 16
        Width = 100
        Height = 23
        TabOrder = 0
        Text = 'edtUf'
      end
    end
    object GroupBox2: TGroupBox
      Left = 136
      Top = 0
      Width = 120
      Height = 44
      Caption = ' CEP '
      TabOrder = 0
      object edtCep: TEdit
        Left = 10
        Top = 16
        Width = 100
        Height = 23
        TabOrder = 0
        Text = 'Edit1'
      end
    end
    object GroupBox3: TGroupBox
      Left = 262
      Top = 0
      Width = 300
      Height = 44
      Caption = 'Logradouro'
      TabOrder = 1
      object edtLogradouro: TEdit
        Left = 10
        Top = 16
        Width = 280
        Height = 23
        TabOrder = 0
        Text = 'Edit1'
      end
    end
    object GroupBox4: TGroupBox
      Left = 10
      Top = 50
      Width = 552
      Height = 49
      Caption = ' Complemento '
      TabOrder = 2
      object edtComplemento: TEdit
        Left = 10
        Top = 16
        Width = 532
        Height = 23
        TabOrder = 0
        Text = 'Edit1'
      end
    end
    object GroupBox5: TGroupBox
      Left = 10
      Top = 105
      Width = 300
      Height = 49
      Caption = ' Bairro '
      TabOrder = 3
      object edtBairro: TEdit
        Left = 10
        Top = 16
        Width = 280
        Height = 23
        TabOrder = 0
      end
    end
    object Button1: TButton
      Left = 487
      Top = 160
      Width = 75
      Height = 25
      Caption = 'Salvar'
      TabOrder = 5
      OnClick = Button1Click
    end
    object GroupBox7: TGroupBox
      Left = 316
      Top = 105
      Width = 120
      Height = 49
      Caption = ' Localidade '
      TabOrder = 6
      object edtLocalidade: TEdit
        Left = 10
        Top = 16
        Width = 100
        Height = 23
        TabOrder = 0
        Text = 'edtLocalidade'
      end
    end
    object GroupBox6: TGroupBox
      Left = 10
      Top = 0
      Width = 120
      Height = 44
      Caption = ' C'#243'digo '
      TabOrder = 7
      object edtCodigo: TEdit
        Left = 10
        Top = 16
        Width = 100
        Height = 23
        TabOrder = 0
        Text = 'edtCodigo'
      end
    end
  end
end
