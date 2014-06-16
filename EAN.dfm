object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Natural Cubic Spline - normal mode'
  ClientHeight = 611
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FValueL: TLabel
    Left = 40
    Top = 200
    Width = 39
    Height = 13
    Caption = 'f(x) val:'
  end
  object XValueL: TLabel
    Left = 40
    Top = 160
    Width = 27
    Height = 13
    Caption = 'x val:'
  end
  object AddNodeL: TLabel
    Left = 88
    Top = 138
    Width = 73
    Height = 13
    Caption = 'Add new node:'
  end
  object Label4: TLabel
    Left = 56
    Top = 281
    Width = 136
    Height = 13
    Caption = 'Set x value to compute f(x):'
  end
  object ValueAtL: TLabel
    Left = 40
    Top = 303
    Width = 43
    Height = 13
    Caption = 'value at:'
  end
  object HeaderL: TLabel
    Left = 40
    Top = 31
    Width = 95
    Height = 13
    Caption = 'Natural Cubic Spline'
  end
  object PointsListL: TLabel
    Left = 320
    Top = 138
    Width = 49
    Height = 13
    Caption = 'Points list:'
  end
  object NumberOfPointsL: TLabel
    Left = 76
    Top = 365
    Width = 101
    Height = 13
    Caption = 'Number of nodes:   0'
  end
  object GraphL: TLabel
    Left = 616
    Top = 64
    Width = 105
    Height = 13
    Caption = 'Spline function graph:'
  end
  object FooterL: TLabel
    Left = 465
    Top = 572
    Width = 3
    Height = 13
  end
  object AddNodeB: TButton
    Left = 40
    Top = 234
    Width = 168
    Height = 25
    Caption = 'Add new node'
    TabOrder = 0
    OnClick = AddNodeBClick
  end
  object XValueAE: TEdit
    Left = 88
    Top = 157
    Width = 57
    Height = 21
    HelpType = htKeyword
    TabOrder = 1
    TextHint = 'x'
    OnKeyPress = XValueAEKeyPress
  end
  object FValueAE: TEdit
    Left = 88
    Top = 197
    Width = 57
    Height = 21
    TabOrder = 2
    TextHint = 'f(x)'
    OnKeyPress = FValueAEKeyPress
  end
  object ValueAtAE: TEdit
    Left = 88
    Top = 300
    Width = 57
    Height = 21
    TabOrder = 3
    TextHint = 'given x'
    OnKeyPress = ValueAtAEKeyPress
  end
  object ModeSelectionRG: TRadioGroup
    Left = 280
    Top = 31
    Width = 153
    Height = 81
    Caption = 'Select program mode:'
    ItemIndex = 0
    Items.Strings = (
      'normal mode'
      'automatic interval'
      'custom interval')
    TabOrder = 4
    OnClick = ModeSelectionRGClick
  end
  object XValueBE: TEdit
    Left = 151
    Top = 157
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 5
    Text = 'n/a'
    OnKeyPress = XValueBEKeyPress
  end
  object FValueBE: TEdit
    Left = 151
    Top = 197
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 6
    Text = 'n/a'
  end
  object ValueAtBE: TEdit
    Left = 151
    Top = 300
    Width = 57
    Height = 21
    Enabled = False
    TabOrder = 7
    Text = 'n/a'
    OnKeyPress = ValueAtBEKeyPress
  end
  object RemoveNodeB: TButton
    Left = 256
    Top = 351
    Width = 177
    Height = 25
    Caption = 'Remove selected node'
    TabOrder = 8
    OnClick = RemoveNodeBClick
  end
  object CalculateResultsB: TButton
    Left = 40
    Top = 416
    Width = 393
    Height = 41
    Caption = 'Calculate results - GO!'
    TabOrder = 9
    OnClick = CalculateResultsBClick
  end
  object ResultsLB: TListBox
    Left = 40
    Top = 472
    Width = 393
    Height = 113
    ItemHeight = 13
    TabOrder = 10
  end
  object PointsListLB: TListBox
    Left = 256
    Top = 157
    Width = 177
    Height = 188
    ItemHeight = 13
    TabOrder = 11
  end
  object ClearAllB: TButton
    Left = 256
    Top = 385
    Width = 177
    Height = 25
    Caption = 'Clear all'
    TabOrder = 12
    OnClick = ClearAllBClick
  end
end
