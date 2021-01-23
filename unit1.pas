unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    buttonRead: TButton;
    openDialog: TOpenDialog;
    stringGrid: TStringGrid;
    procedure buttonReadClick(Sender: TObject);
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
    end;

  finally
    CloseFile(aFile);
  end;
end;

end.
