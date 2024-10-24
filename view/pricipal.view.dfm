object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de endere'#231'os'
  ClientHeight = 545
  ClientWidth = 710
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 710
    Height = 545
    Align = alClient
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 10
      Top = 99
      Width = 690
      Height = 433
      Caption = ' CEP/Endere'#231'os cadastrados '
      TabOrder = 0
      object dbgEndereco: TDBGrid
        Left = 2
        Top = 17
        Width = 686
        Height = 414
        Align = alClient
        DataSource = dmPrincipal.DataSource1
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'codigo'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'cep'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'logradouro'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'complemento'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'bairro'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'localidade'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'uf'
            Width = 64
            Visible = True
          end>
      end
    end
    object GroupBox1: TGroupBox
      Left = 10
      Top = 54
      Width = 690
      Height = 44
      Caption = 'Filtro'
      TabOrder = 1
      object edtChave: TEdit
        Left = 10
        Top = 16
        Width = 575
        Height = 23
        TabOrder = 0
        Text = 'edtChave'
      end
      object btnConsultar: TButton
        Left = 591
        Top = 16
        Width = 90
        Height = 23
        Caption = 'Consultar'
        TabOrder = 1
        OnClick = btnConsultarClick
      end
    end
    object rgChave: TRadioGroup
      Left = 10
      Top = 4
      Width = 300
      Height = 44
      Caption = 'Chave da consulta'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'CEP'
        'Endere'#231'o Completo')
      TabOrder = 2
      OnClick = rgChaveClick
    end
    object rgRetornoConsulta: TRadioGroup
      Left = 316
      Top = 4
      Width = 185
      Height = 44
      Caption = ' Retorno consulta'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'JSON'
        'XML')
      TabOrder = 3
    end
  end
end
