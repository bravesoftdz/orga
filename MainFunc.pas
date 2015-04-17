unit MainFunc;

interface
uses SysUtils, ComCtrls, StrUtils, Forms, Config,
     TasksUnit, ContactsUnit, PersonnelUnit, DbUnit;

procedure OnProgramStart();
procedure OnProgramStop();
procedure ReadDirToTree(CurDir: string; CurNode: TTreeNode; Tree: TTreeView);
procedure OpenTableEdit(ATable: TDbItemList);
procedure DebugMsg(Msg: string);
procedure DebugSQL(Msg: string);


var
  {glHomePath: string;
  glBasePath: string;
  glUserName: string;}
  glContactDataTypes: TContDataTypesList;
  glPersonnelDataTypes: TPersDataTypesList;
  glAllTaskList: TTaskList;
  DbDriver: TDbDriver;
  conf: TConfig;

const
  DbTypeCSV: string = 'CSV files';
  DbTypeSQLite: string = 'SQLite';

implementation
uses TableEditForm, Main;

procedure OnProgramStart();
begin
  conf:=TConfig.Create();
  {glHomePath:=ExtractFileDir(ParamStr(0));
  glBasePath:=glHomePath+'\Data\';
  glUserName:='Admin';}

  // ������� ������� ��
  if conf['LocalDbType'] = DbTypeCSV then
    DbDriver:= TDbDriverCSV.Create()
  else if conf['LocalDbType'] = DbTypeSQLite then
    DbDriver:= TDbDriverSQLite.Create()
  else
    DbDriver:= TDbDriverCSV.Create();

  DbDriver.Open(conf['LocalDbName']);

  // ��������� � ��������� ������ �������

  // ������ ������� ���������
  // 1-������� ����, 2-�����������
  glContactDataTypes:=TContDataTypesList.Create();
  with glContactDataTypes do
  begin
    LoadLocal();
    //if Count=0 then
    begin
      UpdateItem(1, '�������, ���, ��������');
      UpdateItem(1, '�������');
      UpdateItem(1, '�����������');
      UpdateItem(1, '�-����');
      UpdateItem(1, '�������� �����');
      UpdateItem(1, '����������');

      UpdateItem(2, '������ ��������');
      UpdateItem(2, '���� ������������');
      UpdateItem(2, '�������');
      UpdateItem(2, '�������� �����');
      UpdateItem(2, '����������� �����');
      UpdateItem(2, '������������');
      UpdateItem(2, '����������');
      SaveLocal();
    end;
  end;

  // ������ ������� ���������
  glPersonnelDataTypes:=TPersDataTypesList.Create();
  with glPersonnelDataTypes do
  begin
    LoadLocal();
    //if Count=0 then
    begin
      UpdateItem('�������', '�������');
      UpdateItem('���', '���');
      UpdateItem('��������', '��������');
      UpdateItem('���������', '���������');
      UpdateItem('����������', '����������');
      UpdateItem('������������', '���� ��������');
      UpdateItem('�������', '�������');
      UpdateItem('���', '���');
      SaveLocal();
    end;
  end;

  {glAllTaskList:=TTaskList.Create();
  glAllTaskList.FileName:=glBasePath+'tasks.lst';
  glAllTaskList.LoadList();}

end;

procedure OnProgramStop();
begin
  glContactDataTypes.SaveLocal();
  glPersonnelDataTypes.SaveLocal();

  DbDriver.Close();
  FreeAndNil(DbDriver);
end;

procedure ReadDirToTree(CurDir: string; CurNode: TTreeNode; Tree: TTreeView);
var
  SR: TSearchRec;
  NewNode: TTreeNode;
  s: String;
  ii: integer;
begin
  //if (CurNode<>nil) and (CurNode.HasChildren) then Exit;
  if FindFirst(CurDir+'\*.*', faAnyFile, SR)<>0 then Exit;
  repeat
    s:= SR.Name;
    if (SR.Attr and faDirectory) <> 0 then
    begin
      if (s='.') or (s='..') then Continue;
      NewNode := TTreeNode.Create(Tree.Items);
      NewNode.Text:=s;
      Tree.Items.AddNode(NewNode,CurNode, NewNode.Text, nil, naAddChild);
      ii := 1;
      ReadDirToTree(CurDir+'\'+s, NewNode, Tree);
    end
    else
    begin
      s:=LowerCase(RightStr(s, 3));
      ii := 2;
      NewNode := TTreeNode.Create(Tree.Items);
      NewNode.Text:=s;
      Tree.Items.AddNode(NewNode,CurNode, NewNode.Text, nil, naAddChild);
    end;
    NewNode.ImageIndex:= ii;
  until FindNext(SR)<>0;
  FindClose(SR);
end;

procedure OpenTableEdit(ATable: TDbItemList);
var
  frmTE: TfrmTableEdit;
begin
  frmTE:=TfrmTableEdit.Create(Application);
  frmTE.DbItemList:=ATable;
  try
    frmTE.ReadList();
  except
  end;
  frmTE.Show();
end;

procedure DebugMsg(Msg: string);
begin
  frmMain.memoDebugMsg.Lines.Add(Msg);
end;

procedure DebugSQL(Msg: string);
begin
  frmMain.memoDebugSql.Lines.Add(Msg);
end;

end.
