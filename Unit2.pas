unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm2 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    isDown:Boolean;
    downX, downY: Integer;
    { Private declarations }
  public
    Bild: TBitMap;
    { Public declarations }
  end;

var
  Form2: TForm2;
  r: TRect;

implementation

uses
  Unit1;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
//������� ������ Bild
    Bild:=TBitMap.Create;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
//����������� ������ Bild
   Bild.Free;
end;

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   // ������������� ���� ������� ���� � true
  isDown := true;
  // � ���������� ������� ����������
  downX := X;
  downY := Y;
end;

function CaptureScreenRect(aRect: TRect): TBitMap;
var
  ScreenDC: HDC;
begin
  Result := TBitMap.Create;
  with Result, aRect do
  begin
     // ������������� ������� ���������� ����������� ������� ���������� �������
    Width := Right - Left;
    Height := Bottom - Top;
    
    // �������� ����� �������� ����
    ScreenDC := GetDC(0);
    try
      // � �������� ������ ������� ������
      BitBlt(Canvas.Handle, 0, 0, Width, Height, ScreenDC, Left, Top, SRCCOPY);
    finally
      ReleaseDC(0, ScreenDC);
    end;
  end;
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // ���� ������ ������� ����, �� �� ������ ����� ���������
  if isDown then
  begin
   // �������������� �����
   Self.Repaint;

    // ��� �� ������ �����
    Self.Canvas.Pen.Color := clBlack;
    Self.Canvas.Pen.Width := 1;

    Self.Canvas.Pen.Style := psSolid;
   // ��� ����� �� �������� ������� ������� ������, ��������� ���� ��� ����������� ����������
    Self.Canvas.Brush.Color := clGreen;
    Self.Canvas.Rectangle(downX, downY, X, Y);


    // � ����� ������  ������� �������� ����� � ����� � ��������� ������ ��� �������
    Self.Canvas.Pen.Style := psSolid;
    Self.Canvas.Brush.Color := clWhite;

    Self.Canvas.TextOut(downX, downY, '������� � ������� ScreenShooter');

    //Self.Canvas.Rectangle(downX - 3, downY - 3, downX + 3, downY + 3);
    //Self.Canvas.Rectangle(X - 3, Y - 3, X + 3, Y + 3);
    //Self.Canvas.Rectangle(X - 3, downY - 3, X + 3, downY + 3);
    //Self.Canvas.Rectangle(downX - 3, Y - 3, downX + 3, Y + 3);

    //Self.Canvas.Rectangle(downX - 3, (downY + Y) div 2 - 3, downX + 3, (downY + Y) div 2 + 3);
    //Self.Canvas.Rectangle(X - 3, (downY + Y) div 2 - 3, X + 3, (downY + Y) div 2 + 3);
    //Self.Canvas.Rectangle((downX + X) div 2 - 3, downY - 3, (downX + X) div 2 + 3, downY + 3);
    //Self.Canvas.Rectangle((downX + X) div 2 - 3, Y - 3, (downX + X) div 2 + 3, Y + 3);
  end;
end;

procedure TForm2.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // ���������� ����
  isDown := false;

  // ��������� ���������� �������
  r.Left := downX;
  r.Top := downY;
  r.Right := X;
  r.Bottom := Y;

  // � ���������� Bild ������� ������� ������
  Bild := CaptureScreenRect(r);

  // � ��������� �����
  Self.Close;
end;

end.
