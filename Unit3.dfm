object Form3: TForm3
  Left = 1377
  Top = 387
  Cursor = crArrow
  AlphaBlend = True
  AlphaBlendValue = 205
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'ScreenShooter v.7'
  ClientHeight = 27
  ClientWidth = 124
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel1: TsLabel
    Left = 8
    Top = 6
    Width = 69
    Height = 13
    Caption = #1057#1082#1088#1080#1085' '#1089#1086#1079#1076#1072#1085
  end
  object ListBox1: TListBox
    Left = 64
    Top = 0
    Width = 25
    Height = 25
    ItemHeight = 13
    TabOrder = 0
    Visible = False
  end
  object CheckBox1: TCheckBox
    Left = 40
    Top = 0
    Width = 25
    Height = 25
    Caption = 'CheckBox1'
    TabOrder = 1
    Visible = False
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 0
    OnTimer = Timer1Timer
    Left = 88
  end
end
