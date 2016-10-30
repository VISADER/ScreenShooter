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
//создаем объект Bild
    Bild:=TBitMap.Create;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
//освобождаем объект Bild
   Bild.Free;
end;

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   // устанавливаем флаг нажатия мыши в true
  isDown := true;
  // и запоминаем текущие координаты
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
     // Устанавливаем размеры выводимого изображения равными выделенной области
    Width := Right - Left;
    Height := Bottom - Top;
    
    // Получаем Хендл рабочего окна
    ScreenDC := GetDC(0);
    try
      // и копируем нужную область экрана
      BitBlt(Canvas.Handle, 0, 0, Width, Height, ScreenDC, Left, Top, SRCCOPY);
    finally
      ReleaseDC(0, ScreenDC);
    end;
  end;
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // если нажата клавиша мыши, то мы рисуем рамку выделения
  if isDown then
  begin
   // перерисовываем форму
   Self.Repaint;

    // тут мы рисуем рамку
    Self.Canvas.Pen.Color := clBlack;
    Self.Canvas.Pen.Width := 1;

    Self.Canvas.Pen.Style := psSolid;
   // вот здесь мы заливаем область зеленым цветом, благодаря чему она становиться прозрачной
    Self.Canvas.Brush.Color := clGreen;
    Self.Canvas.Rectangle(downX, downY, X, Y);


    // а здесь рисуем  маркеры красного цвета в углах и серединах сторон для красоты
    Self.Canvas.Pen.Style := psSolid;
    Self.Canvas.Brush.Color := clWhite;

    Self.Canvas.TextOut(downX, downY, 'Сделано с помощью ScreenShooter');

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
  // сбрасываем флаг
  isDown := false;

  // сохраняем координаты области
  r.Left := downX;
  r.Top := downY;
  r.Right := X;
  r.Bottom := Y;

  // в переменную Bild выводим область экрана
  Bild := CaptureScreenRect(r);

  // и закрываем форму
  Self.Close;
end;

end.
