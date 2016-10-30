unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg, Buttons, ComCtrls, FileCtrl,
  CoolTrayIcon, sSkinManager, sComboBox, sEdit, sButton, sSpeedButton, IniFiles,
  sCheckBox;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Edit2: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CoolTrayIcon1: TCoolTrayIcon;
    CheckBox1: TCheckBox;
    sSkinManager1: TsSkinManager;
    sComboBox1: TsComboBox;
    sComboBox2: TsComboBox;
    sEdit1: TsEdit;
    sSpeedButton1: TsSpeedButton;
    Timer1: TTimer;
    sEdit2: TsEdit;
    sCheckBox1: TsCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Edit2DblClick(Sender: TObject);
    procedure DropDownWidth(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure sComboBox1DropDown(Sender: TObject);
    procedure sComboBox2DropDown(Sender: TObject);
    procedure sComboBox1Change(Sender: TObject);
    procedure sEdit1DblClick(Sender: TObject);
    procedure sSpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sCheckBox1Click(Sender: TObject);
  private
    procedure WMHotkey( var msg: TMessage ); message WM_HOTKEY;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  jpg:tjpegimage;
  chosenDirectory : string;
  chosenCataloge : string;
  z : Integer = -1;
  c : string;

implementation

uses
  Unit2, Unit3;

{$R *.dfm}

procedure ScreenShotActiveWindow(Bild: TBitMap);
var
  c: TCanvas;
  r, t: TRect;
  h: THandle;
begin
  c := TCanvas.Create;
  c.Handle := GetWindowDC(GetDesktopWindow);
  // �������� handle ��������� ����
  h := GetForeGroundWindow;
  // ���� ���� �������� ����, �� �������� ��� ����������-Rect
  if h <> 0 then
    GetWindowRect(h, t);
  try
    r := Rect(0, 0, t.Right - t.Left, t.Bottom - t.Top);
    Bild.Width := t.Right - t.Left;
    Bild.Height := t.Bottom - t.Top;
    Bild.Canvas.CopyRect(r, c, t);
  finally
    ReleaseDC(0, c.Handle);
    c.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form1.Visible:= False;
  Sleep(750); // ������ �����, ��� ���� �������� ���������� ��������� �������� ����

  if Form3.Visible = True
  then begin
  Form3.Timer1.Enabled:=False;
  Form3.Timer1.Interval:=0;
  Form3.Visible:= False
  end;

  ScreenShotActiveWindow(Image1.Picture.BitMap);

  jpg:=tjpegimage.create;
  jpg.assign(image1.picture.graphic);
  jpg.compressionquality:=100;
  jpg.compress;
  while FileExists((chosenDirectory+c+chosenCataloge)+'����'+'_'+sEdit2.Text+'_'+sEdit1.Text+'.jpg')
  do sEdit1.Text:=IntToStr(StrToInt(sEdit1.Text)+1);
  jpg.savetofile((chosenDirectory+c+chosenCataloge)+'����'+'_'+sEdit2.Text+'_'+sEdit1.Text+'.jpg');
  jpg.free;
  sEdit1.Text:='0';
  //sEdit1.Text:=IntToStr(StrToInt(sEdit1.Text)+1);

  //Form3.sLabel1.Caption:='����� - '+((chosenDirectory+chosenCataloge)+sComboBox1.Text+'_'+sComboBox2.Text+'_'+sEdit1.Text+'.jpg')+' - ������';
  //if (not Assigned(Form3)) then begin
  //Form3:=TForm3.Create(Self);
  //Application.CreateForm(TForm3, Form3);
  //Form3.Show;
  //Form3.Refresh;
  //end;

  Form3.Visible:= True;
  Form3.AlphaBlend:=True;
  Form3.AlphaBlendValue:=205;
  Form3.Timer1.Interval:=2000;
  Form3.Timer1.Enabled:=True;
  if CheckBox1.Checked=True
  then Form1.Visible:= False
  else Form1.Visible:= True;
end;

procedure TForm1.Edit2DblClick(Sender: TObject);
begin
Edit2.Text:='0';
end;

procedure TForm1.DropDownWidth(Sender: TObject);
var
   CBox: TsComboBox;
   Width: Integer; 
   I, TextLen: Longint; 
   lf: LOGFONT; 
   f: HFONT;
begin 
   CBox :=  (Sender as TsComboBox);
   Width := CBox.Width; 
     FillChar(lf,SizeOf(lf),0);
     StrPCopy(lf.lfFaceName, CBox.Font.Name);
     lf.lfHeight := CBox.Font.Height; 
     lf.lfWeight := FW_NORMAL; 
     if fsBold in CBox.Font.Style then 
       lf.lfWeight := lf.lfWeight or FW_BOLD; 

     f := CreateFontIndirect(lf); 
       if (f <> 0) then
       try
         CBox.Canvas.Handle := GetDC(CBox.Handle);
         SelectObject(CBox.Canvas.Handle,f); 
         try 
         for i := 0 to CBox.Items.Count-1 do begin 
           TextLen := CBox.Canvas.TextWidth(CBox.Items[i]); 
         if CBox.Items.Count-1 > CBox.DropDownCount then 
           begin 
             if TextLen > Width-25 then 
               Width := TextLen +25; 
           end 
         else if CBox.Items.Count-1 <= CBox.DropDownCount then 
           begin 
             if TextLen > Width-5 then 
               Width := TextLen+8; 
           end; 
         end; 
         finally 
           ReleaseDC(CBox.Handle, CBox.Canvas.Handle); 
         end; 
       finally 
         DeleteObject(f); 
       end; 
   SendMessage(CBox.Handle, CB_SETDROPPEDWIDTH, Width, 0); 
end;

procedure TForm1.sComboBox1Change(Sender: TObject);
begin
  if sComboBox1.ItemIndex=0
  then begin
  sComboBox2.Clear;
  sComboBox2.Text:='�������� ��� ������� �����';
  sComboBox2.Items.Add('���������� ����������� Windows');
  sComboBox2.Items.Add('���������� �������� ������� ������� (UAC)');
  sComboBox2.Items.Add('���������� ���� IIS');
  sComboBox2.Items.Add('���������� �����������');
  sComboBox2.Items.Add('��������� ������ �Telnet�');
  sComboBox2.Items.Add('��������� .Net Framework');
  sComboBox2.Items.Add('��������� ���');
  sComboBox2.Items.Add('��������� DCOM');
  sComboBox2.Items.Add('��������� ������ �������� �����');
  sComboBox2.Items.Add('��������� PHP');
  sComboBox2.Items.Add('��������� ����� IIS');
  sComboBox2.Items.Add('��������� ������� GSM/GPRS � ������ SMS-�����������');
  sComboBox2.Items.Add('���������� ������ SMS-����������� � ������������');
  sComboBox2.Items.Add('��������� ���������');
  end;
  if sComboBox1.ItemIndex=1
  then begin
  sComboBox2.Clear;
  sComboBox2.Text:='�������� ��� ���� ������';
  sComboBox2.Items.Add('���������� ���� �Active Directory� � �DNS������');
  sComboBox2.Items.Add('���������� ����������� Windows');
  sComboBox2.Items.Add('���������� �������� ������� �������(UAC)');
  sComboBox2.Items.Add('���������� ���� IIS');
  sComboBox2.Items.Add('���������� �����������');
  sComboBox2.Items.Add('��������� ������ �Telnet�');
  sComboBox2.Items.Add('�������� �������� ���������');
  sComboBox2.Items.Add('��������� ��������� ��������');
  sComboBox2.Items.Add('��������� �������');
  sComboBox2.Items.Add('��������� ���� Firebird');
  sComboBox2.Items.Add('��������� .Net Framework');
  sComboBox2.Items.Add('��������� ���');
  sComboBox2.Items.Add('��������� DCOM');
  sComboBox2.Items.Add('��������� ����� IIS');
  sComboBox2.Items.Add('��������� ������ ������� ����������');
  sComboBox2.Items.Add('��������� PHP');
  sComboBox2.Items.Add('��������� ������ �������� �����');
  sComboBox2.Items.Add('��������� ����������');
  sComboBox2.Items.Add('��������� ���������� ����������� ���� ������ (backup)');
  sComboBox2.Items.Add('��������� ���������');
  end;
  if (sComboBox1.ItemIndex=2) or (sComboBox1.ItemIndex=4)
  then begin
  sComboBox2.Clear;
  sComboBox2.Text:='�������� �����';
  sComboBox2.Items.Add('��������� ����� ����������');
  sComboBox2.Items.Add('��������� IP-������');
  sComboBox2.Items.Add('��������� Windows');
  sComboBox2.Items.Add('��������� ����������');
  sComboBox2.Items.Add('���������� ����������� Windows');
  sComboBox2.Items.Add('���������� �������� ������� ������� (UAC)');
  sComboBox2.Items.Add('��������� ���');
  sComboBox2.Items.Add('��������� DCOM');
  sComboBox2.Items.Add('��������� ���������');
  end;
  if sComboBox1.ItemIndex=3
  then begin
  sComboBox2.Clear;
  sComboBox2.Text:='�������� ���';
  sComboBox2.Items.Add('���������� ����������� Windows');
  sComboBox2.Items.Add('���������� �������� ������� ������� (UAC)');
  sComboBox2.Items.Add('���������� ���� IIS');
  sComboBox2.Items.Add('���������� �����������');
  sComboBox2.Items.Add('��������� ������ �Telnet�');
  sComboBox2.Items.Add('�������� �������� ���������');
  sComboBox2.Items.Add('��������� ���� Firebird');
  sComboBox2.Items.Add('��������� .Net Framework');
  sComboBox2.Items.Add('��������� ���');
  sComboBox2.Items.Add('��������� DCOM');
  sComboBox2.Items.Add('��������� ������ ������� ����������');
  sComboBox2.Items.Add('��������� PHP');
  sComboBox2.Items.Add('��������� ����������');
  sComboBox2.Items.Add('��������� ���������� ����������� ���� ������ (backup)');
  sComboBox2.Items.Add('��������� ������ �������� �����');
  sComboBox2.Items.Add('��������� ����� IIS');
  sComboBox2.Items.Add('��������� ������� GSM/GPRS � ������ SMS-�����������');
  sComboBox2.Items.Add('���������� ������ SMS-����������� � ������������');
  sComboBox2.Items.Add('��������� ���������');
  end;
  if sComboBox1.ItemIndex=5
  then begin
  sComboBox2.Clear;
  sComboBox2.Text:='�������� ������������';
  sComboBox2.Items.Add('��������� ����');
  sComboBox2.Items.Add('��������� ��');
  sComboBox2.Items.Add('��������� ����������� (switch)');
  sComboBox2.Items.Add('��������� ��� (UPC)');
  sEdit1.Text:='0';
  end;
  if sComboBox1.ItemIndex=6
  then begin
  sComboBox2.Clear;
  sComboBox2.Text:='������';
  sComboBox2.Items.Add('��������');
  sEdit1.Text:='0';
  end;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
if sSpeedButton1.Visible=False
then sSpeedButton1.Visible:=True
else sSpeedButton1.Visible:=False;
end;

procedure TForm1.sSpeedButton1Click(Sender: TObject);
begin
  sComboBox2.Clear;
  sComboBox2.Text:='�������� ��';
  sComboBox2.Items.Add('��������� ����� ����������');
  sComboBox2.Items.Add('��������� IP-������');
  sComboBox2.Items.Add('��������� Windows');
  sComboBox2.Items.Add('��������� ����������');
  sComboBox2.Items.Add('���������� ���� �Active Directory� � �DNS������');
  sComboBox2.Items.Add('���������� ����������� Windows');
  sComboBox2.Items.Add('���������� �������� ������� �������(UAC)');
  sComboBox2.Items.Add('���������� ���� IIS');
  sComboBox2.Items.Add('���������� �����������');
  sComboBox2.Items.Add('��������� ������ �Telnet�');
  sComboBox2.Items.Add('�������� �������� ���������');
  sComboBox2.Items.Add('��������� ��������� ��������');
  sComboBox2.Items.Add('��������� �������');
  sComboBox2.Items.Add('��������� ���� Firebird');
  sComboBox2.Items.Add('��������� .Net Framework');
  sComboBox2.Items.Add('��������� ���');
  sComboBox2.Items.Add('��������� DCOM');
  sComboBox2.Items.Add('��������� ����� IIS');
  sComboBox2.Items.Add('��������� ������ ������� ����������');
  sComboBox2.Items.Add('��������� PHP');
  sComboBox2.Items.Add('��������� ������ �������� �����');
  sComboBox2.Items.Add('��������� ����������');
  sComboBox2.Items.Add('��������� ���������� ����������� ���� ������ (backup)');
  sComboBox2.Items.Add('��������� ������� GSM/GPRS � ������ SMS-�����������');
  sComboBox2.Items.Add('���������� ������ SMS-����������� � ������������');
  sComboBox2.Items.Add('��������� ���������');
  sComboBox2.Items.Add('��������� ����');
  sComboBox2.Items.Add('��������� ��');
  sComboBox2.Items.Add('��������� ����������� (switch)');
  sComboBox2.Items.Add('��������� ��� (UPC)');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
otv : word;
a : Char;
b : string;
Ini: Tinifile;
fileName : string;
begin
  if not RegisterHotkey(Handle, 1, MOD_CONTROL, VK_F1) then
  ShowMessage('Unable to assign Ctrl-F1 as hotkey');
  if not RegisterHotkey(Handle, 2, MOD_CONTROL, VK_F2) then
  ShowMessage('Unable to assign Ctrl-F2 as hotkey');
  if not RegisterHotkey(Handle, 3, MOD_CONTROL, VK_F3) then
  ShowMessage('Unable to assign Ctrl-F3 as hotkey');
  if not RegisterHotkey(Handle, 4, MOD_CONTROL, VK_F4) then
  ShowMessage('Unable to assign Ctrl-F4 as hotkey');
  if not RegisterHotkey(Handle, 5, MOD_CONTROL, VK_F5) then
  ShowMessage('Unable to assign Ctrl-F5 as hotkey');
  if not RegisterHotkey(Handle, 6, MOD_CONTROL, VK_F6) then
  ShowMessage('Unable to assign Ctrl-F6 as hotkey');
  if not RegisterHotkey(Handle, 7, MOD_CONTROL, VK_F7) then
  ShowMessage('Unable to assign Ctrl-F7 as hotkey');
  if FileExists('ScreenShooter_v.7.ini')
  then begin
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'ScreenShooter_v.7.ini');
  chosenDirectory:=Ini.ReadString('ScreenShooter_v.7','SaveDirectory',chosenDirectory);
  chosenCataloge:=Ini.ReadString('ScreenShooter_v.7','SaveCataloge',chosenCataloge);
  Ini.Free;
  end
  else begin
  if SelectDirectory('�� ������? ���? ����� �������� �������','::{20D04FE0-3AEA-1069-A2D8-08002B30309D}',chosenDirectory)
  then begin
  otv := MessageBox(handle,PChar('������ ������� ������� "ScreenShooter"?'+#13#10), PChar('ScreenShooter'), MB_YESNO+MB_DEFBUTTON1+MB_ICONQUESTION);
    if otv=IDYES
    then begin
      b:= chosenDirectory;
      a:= b[Length(b)];
      c:=a;
      if c<>'\' then c:='\'
      else c:='\';
    chosenCataloge:='ScreenShooter\';
    if not DirectoryExists(chosenDirectory+c+chosenCataloge) then CreateDir(chosenDirectory+c+chosenCataloge);
    ShowMessage('��������� ������� ��� ���������� - '+chosenDirectory+c+chosenCataloge);
    end;
    if otv=IDNO
    then begin
      b:= chosenDirectory;
      a:= b[Length(b)];
      c:=a;
      if c<>'\' then c:='\'
      else c:='\';
    chosenCataloge:='\';
    if not DirectoryExists(chosenDirectory+c+chosenCataloge) then CreateDir(chosenDirectory+c+chosenCataloge);
    ShowMessage('��������� ������� ��� ���������� - '+chosenDirectory);
    Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'ScreenShooter_v.7.ini');
    Ini.WriteString('ScreenShooter_v.7','SaveDirectory',chosenDirectory);
    Ini.WriteString('ScreenShooter_v.7','SaveCataloge',chosenCataloge);
    Ini.Free;
    end
  end
  else begin
  chosenDirectory:='C:\';
      b:= chosenDirectory;
      a:= b[Length(b)];
      c:=a;
      if c<>'\' then c:='\'
      else c:='\';
  chosenCataloge:='ScreenShooter\';
  if not DirectoryExists(chosenDirectory+c+chosenCataloge) then CreateDir(chosenDirectory+c+chosenCataloge);
  ShowMessage('������ ������� �� ��������� - '+chosenDirectory+chosenCataloge);
  Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'ScreenShooter_v.7.ini');
  Ini.WriteString('ScreenShooter_v.7','SaveDirectory',chosenDirectory);
  Ini.WriteString('ScreenShooter_v.7','SaveCataloge',chosenCataloge);
  Ini.Free;
  end
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
UnRegisterHotkey( Handle, 1 );
UnRegisterHotkey( Handle, 2 );
UnRegisterHotkey( Handle, 3 );
UnRegisterHotkey( Handle, 4 );
UnRegisterHotkey( Handle, 5 );
UnRegisterHotkey( Handle, 6 );
UnRegisterHotkey( Handle, 7 );
end;

procedure TForm1.WMHotkey( var msg: TMessage );
begin
  case msg.wParam of
    1: Button1.Click;
    2: Button2.Click;
    3: Button3.Click;
    4: Button4.Click;
    5: Button5.Click;
    6: begin
    CoolTrayIcon1.HideMainForm;
    CheckBox1.Checked:=True;
    CoolTrayIcon1.ShowBalloonHint('ScreenShooter', '��������� �������� � ����', bitInfo, 11);
    end;
    7: begin
    CoolTrayIcon1.ShowMainForm;
    CheckBox1.Checked:=False;
    end;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
sComboBox2.ItemIndex:=(sComboBox2.ItemIndex)-1;
sEdit1.Text:='0';
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
sComboBox2.ItemIndex:=(sComboBox2.ItemIndex)+1;
sEdit1.Text:='0';
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
sEdit1.Text:='0';
end;

procedure ScreenShot(Bild: TBitMap);
 var
   c: TCanvas;
   r: TRect;
 begin
   c := TCanvas.Create;
  // �������� handle �������� �����
   c.Handle := GetWindowDC(GetDesktopWindow); 
   try
    // ���������� ��� �������
     r := Rect(0, 0, Screen.Width, Screen.Height); 
     Bild.Width := Screen.Width;
     Bild.Height := Screen.Height;
    // � �������� � Bitmap ����������� ������	
     Bild.Canvas.CopyRect(r, c, r);
   finally
     ReleaseDC(0, c.Handle);
     c.Free;
   end;
 end;

procedure TForm1.Button1Click(Sender: TObject);
var
  jpg:tjpegimage;
begin
  Form1.Visible := False;
  Sleep(750); // ������ �����, ��� ���� �������� ���������� ��������� �������� ����

  if Form3.Visible = True
  then begin
  Form3.Timer1.Enabled:=False;
  Form3.Timer1.Interval:=0;
  Form3.Visible:= False
  end;

  ScreenShot(Image1.Picture.BitMap);

  jpg:=tjpegimage.create;
  jpg.assign(image1.picture.graphic);
  jpg.compressionquality:=100;
  jpg.compress;
  while FileExists((chosenDirectory+c+chosenCataloge)+'�����'+'_'+sEdit2.Text+'_'+sEdit1.Text+'.jpg')
  do sEdit1.Text:=IntToStr(StrToInt(sEdit1.Text)+1);
  jpg.savetofile((chosenDirectory+c+chosenCataloge)+'�����'+'_'+sEdit2.Text+'_'+sEdit1.Text+'.jpg');
  jpg.free;
  sEdit1.Text:='0';
  //sEdit1.Text:=IntToStr(StrToInt(sEdit1.Text)+1);


  Form3.Visible:= True;
  Form3.AlphaBlend:=True;
  Form3.AlphaBlendValue:=205;
  Form3.Timer1.Interval:=2000;
  Form3.Timer1.Enabled:=True;

  if CheckBox1.Checked=True
  then Form1.Visible := False
  else Form1.Visible := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  ScreenForm: TForm2;
begin

  if Form3.Visible = True
  then begin
  Form3.Timer1.Enabled:=False;
  Form3.Timer1.Interval:=0;
  Form3.Visible:= False
  end;

  // ������� ���� �������������� �����
  ScreenForm := TForm2.Create(nil);
  try
    // � ����������� � �� ���� �����
    ScreenForm.Width := Screen.DesktopWidth;
    ScreenForm.Height := Screen.DesktopHeight;
    ScreenForm.Left := 0;
    ScreenForm.Top := 0;

    // ������ ������ �������� �����
    self.Hide;

    // ���������� �������������� ��������
    ScreenForm.ShowModal;

    // � ������� ���������� ������� ������
    Image1.Picture.BitMap := ScreenForm.Bild;

    self.Show;
  finally
    ScreenForm.Free;
  end;

  jpg:=tjpegimage.create;
  jpg.assign(image1.picture.graphic);
  jpg.compressionquality:=100;
  jpg.compress;
  while FileExists((chosenDirectory+c+chosenCataloge)+'�������'+'_'+sEdit2.Text+'_'+sEdit1.Text+'.jpg')
  do sEdit1.Text:=IntToStr(StrToInt(sEdit1.Text)+1);
  jpg.savetofile((chosenDirectory+c+chosenCataloge)+'�������'+'_'+sEdit2.Text+'_'+sEdit1.Text+'.jpg');
  jpg.free;
  sEdit1.Text:='0';
  //sEdit1.Text:=IntToStr(StrToInt(sEdit1.Text)+1);

  Form3.Visible:= True;
  Form3.AlphaBlend:=True;
  Form3.AlphaBlendValue:=205;
  Form3.Timer1.Interval:=2000;
  Form3.Timer1.Enabled:=True;

  if CheckBox1.Checked=True
  then Form1.Visible := False
  else Form1.Visible := True;
end;

procedure TForm1.sComboBox1DropDown(Sender: TObject);
begin
DropDownWidth(sComboBox1);
end;

procedure TForm1.sComboBox2DropDown(Sender: TObject);
begin
DropDownWidth(sComboBox2);
end;


procedure TForm1.sEdit1DblClick(Sender: TObject);
begin
sEdit1.Text:='0';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  HWnd : THandle;
  N : Integer;
  tmpStr : PChar;
begin
 HWnd := GetForeGroundWindow;
 N := GetWindowTextLength(HWnd);
 tmpStr := StrAlloc(N + 1);
 GetWindowText(HWnd, tmpStr, N + 1);
 sEdit2.Text := tmpStr;
 //Label2.Caption := "����� ������" + IntToStr(Length(tmpStr));
 //StrDispose(tmpStr);
end;

procedure TForm1.sCheckBox1Click(Sender: TObject);
begin
if sCheckBox1.Checked=True then Timer1.Enabled:=True
else Timer1.Enabled:=False;
end;

end.
