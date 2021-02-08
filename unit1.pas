unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    buttonSave: TButton;
    buttonNew: TButton;
    buttonRead: TButton;
    openDialog: TOpenDialog;
    saveDialog: TSaveDialog;
    stringGrid: TStringGrid;
    procedure buttonNewClick(Sender: TObject);
    procedure buttonReadClick(Sender: TObject);
    procedure buttonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  aFile: TextFile;
  row: string;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  stringGrid.Cells[0, 0] := 'Datum';
  stringGrid.Cells[1, 0] := 'km-Stand Start';
  stringGrid.Cells[2, 0] := 'km-Stand Ziel';
  stringGrid.Cells[3, 0] := 'gef. km';
  stringGrid.Cells[4, 0] := 'getankt in l';
  stringGrid.Cells[5, 0] := 'Verbrauch pro km';
end;

procedure TForm1.buttonReadClick(Sender: TObject);
var
  i: integer = 1;
  p: integer;

begin
  try
    if (openDialog.Execute = True) then
    begin
      AssignFile(aFile, openDialog.FileName);
      reset(aFile); // erfoderlich zum Lesen der Datei

      repeat
        begin
          if (i > stringGrid.RowCount - 1) then
          begin
            stringGrid.RowCount := stringGrid.RowCount + 1;
          end;
          ReadLn(aFile, row);

          p := pos('#', row);
          stringGrid.Cells[0, i] := copy(row, 1, p - 1);
          Delete(row, 1, p);

          p := pos('#', row);
          stringGrid.Cells[1, i] := copy(row, 1, p - 1);
          Delete(row, 1, p);

          p := pos('#', row);
          stringGrid.Cells[2, i] := copy(row, 1, p - 1);
          Delete(row, 1, p);

          p := pos('#', row);
          stringGrid.Cells[3, i] := copy(row, 1, p - 1);
          Delete(row, 1, p);

          p := pos('#', row);
          stringGrid.Cells[4, i] := copy(row, 1, p - 1);
          Delete(row, 1, p);

          stringGrid.Cells[5, i] := row;

          i := i + 1;
        end;
      until EOF(aFile);

      CloseFile(aFile);
      ShowMessage('Einlesen erfolgreich.');
    end;

  except
    CloseFile(aFile);
    ShowMessage('Einlesen nicht erfolgreich.');
  end;
end;

procedure TForm1.buttonNewClick(Sender: TObject);
begin
  // add new row
  stringGrid.RowCount := stringGrid.RowCount + 1;

  // copy old cell
  stringGrid.Cells[1, stringGrid.RowCount - 1] :=
    stringGrid.Cells[2, stringGrid.RowCount - 2];

  // enter current date
  stringGrid.Cells[0, stringGrid.RowCount - 1] := DateToStr(Date());
end;

procedure TForm1.buttonSaveClick(Sender: TObject);
var
  i: integer;
begin
  if (saveDialog.Execute = True) then
  begin
    AssignFile(aFile, saveDialog.FileName);
    Rewrite(aFile);

    for i := 1 to stringGrid.RowCount - 1 do
    begin
      row := stringGrid.cells[0, i] + '#' + stringGrid.Cells[1, i] +
        '#' + stringGrid.Cells[2, i] + '#' + stringGrid.Cells[3, i] +
        '#' + stringGrid.Cells[4, i] + '#' + stringGrid.Cells[5, i];
      WriteLn(aFile, row);
    end;

    CloseFile(aFile);
  end;
end;

end.
