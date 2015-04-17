unit MiscFunc;

interface
uses SysUtils, Windows, Dialogs;

function ShiftPressed(): boolean;
function SelectFilename(sFileName: string = ''; sFilter: string = ''): string;
function CopySingleFile(SrcName, DestName: string): boolean;

// ���������� ��� ������������ windows
function GetWinUserName(): string;
// ���������� ��� ����������
function GetWinCompName(): string;
// ���������� ������ IP-������� ����������
function GetWinIpList(): string;


implementation

function ShiftPressed(): boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  //State:=GetKeyState(Key);
  result := ((State[VK_SHIFT] and 128) <> 0);
end;

function SelectFilename(sFileName: string = ''; sFilter: string = ''): string;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog:=TOpenDialog.Create(nil);
  OpenDialog.FileName:=sFileName;
  OpenDialog.Filter:=sFilter;
  result:='';
  if OpenDialog.Execute() then
  begin
    result:=OpenDialog.FileName;
  end;
  OpenDialog.Free();
end;

function CopySingleFile(SrcName, DestName: string): boolean;
begin
  Windows.CopyFile(PChar(SrcName), PChar(DestName), false);
end;

// ���������� ��� ������������ windows
function GetWinUserName(): string;
var
  lpBuffer: PChar;
  n: cardinal;
begin
  n:=20;
  lpBuffer:=StrAlloc(n);
  GetUserName(lpBuffer, n);
  result := String(lpBuffer);
end;

// ���������� ��� ����������
function GetWinCompName(): string;
var
  lpBuffer: PChar;
  n: cardinal;
begin
  n:=20;
  lpBuffer:=StrAlloc(n);
  GetComputerName(lpBuffer, n);
  result := String(lpBuffer);
end;

// ���������� ������ IP-������� ����������
function GetWinIpList(): string;
begin
  result:='127.0.0.1';
end;

end.
