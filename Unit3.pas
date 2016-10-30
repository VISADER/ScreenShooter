unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sLabel, ExtCtrls, sSkinManager;

type
  TForm3 = class(TForm)
    sLabel1: TsLabel;
    Timer1: TTimer;
    ListBox1: TListBox;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  Unit1;

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
var
  pzrect: TRect;
  hh: integer;
  x,y:integer;
begin
hh:=FindWindow('Shell_TrayWnd','');
GetWindowRect(hh,pzrect);
x:=(screen.Height)-(pzrect.Bottom-pzrect.Top)-78;
y:=27;
Form3.Left:=y;
Form3.Top:=x;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled:=False;
Timer1.Interval:=0;
Form3.Visible:= False;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
if Form1.Button1.Click then sLabel1.Caption:=('—криншот - '+((chosenDirectory+c+chosenCataloge)+'Ёкран'+'_'+sEdit2.Text+'_'+sEdit1.Text+'.jpg')+' - создан');
if Form1.Button2.Click then sLabel1.Caption:=('—криншот - '+((chosenDirectory+c+chosenCataloge)+'ќкно'+'_'+sEdit2.Text+'_'+sEdit1.Text+'.jpg')+' - создан');
if Form1.Button3.Click then sLabel1.Caption:=('—криншот - '+((chosenDirectory+c+chosenCataloge)+'ќбласть'+'_'+sEdit2.Text+'_'+sEdit1.Text+'.jpg')+' - создан');
Form3.Width:=sLabel1.Width+22;
Timer1.Interval:=2000;
Timer1.Enabled:=True;
CheckBox1.Checked:=True;
end;

end.

