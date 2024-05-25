unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Spin,
  StdCtrls, ComCtrls, ExtCtrls, DateUtils, Crt;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListView1: TListView;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
Var Node1: TListItem;
    StartTime, StopTime: TDateTime;
    Interval: Integer;
begin
  StartTime:= Now();
  Interval:= SpinEdit1.Value*60*60+ SpinEdit2.Value*60+ SpinEdit3.Value;
  StopTime:= IncSecond(StartTime, Interval);
  Node1:= ListView1.Items.Add;
  Node1.Caption:= '1';
  Node1.SubItems.Add(IntToStr(Round(Interval))+ ' s');
  Node1.SubItems.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', StartTime));
  Node1.SubItems.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', StopTime));
  Node1.SubItems.Add(IntToStr(Round(Interval))+ ' s');
  Node1.SubItems.Add('Yes');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  If ListView1.ItemIndex<> -1 Then
    If ListView1.Items[ListView1.ItemIndex].SubItems[4]= 'No' Then
      Begin
        ListView1.Items[ListView1.ItemIndex].SubItems[4]:= 'Yes';
        Button2.Caption:= 'Inactive';
      End
    Else
      Begin
        ListView1.Items[ListView1.ItemIndex].SubItems[4]:= 'No';
        Button2.Caption:= 'Active';
      End;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  If MessageDlg('Remove alarm completly?', mtConfirmation, [mbYes, mbNo], 0)= mrYes Then
    ListView1.Selected.Delete;
end;

procedure TForm1.ListView1Click(Sender: TObject);
begin
  If ListView1.ItemIndex<> -1 Then
    If ListView1.Items[ListView1.ItemIndex].SubItems[4]= 'No' Then
      Button2.Caption:= 'Active'
    Else
      Button2.Caption:= 'Inactive';
  Button2.Enabled:= ListView1.ItemIndex<> -1;
  Button3.Enabled:= ListView1.ItemIndex<> -1;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  Button1.Enabled:= (SpinEdit1.Value+ SpinEdit2.Value+ SpinEdit3.Value)> 0;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
Var i: Integer;
    CurrentTime, AlarmTime: TDateTime;
    Interval: Integer;
begin
  CurrentTime:= Now();
  For i:= 1 To ListView1.Items.Count Do
    Begin
      If ListView1.Items[i- 1].SubItems[4]= 'Yes' Then
        Begin
          AlarmTime:= ScanDateTime('yyyy-mm-dd hh:nn:ss', ListView1.Items[i- 1].SubItems[2]);
          Interval:= SecondsBetween(CurrentTime, AlarmTime);
          ListView1.Items[i- 1].SubItems[3]:= IntToStr(Interval)+ ' s';
          If Interval<= 0 Then
            Begin
              ListView1.Items[i- 1].SubItems[4]:= 'No';
              ShowMessage('Alarm launched at '+ FormatDateTime('yyyy-mm-dd hh:nn:ss', AlarmTime)+ '!');
            End;
        End;
    End;
end;

end.

