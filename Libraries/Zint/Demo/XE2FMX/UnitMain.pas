unit UnitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Edit, FMX.ListBox,
  FMX.Objects;

type
  TFormMain = class(TForm)
    imgResult: TImage;
    Panel1: TPanel;
    comType: TComboBox;
    edData: TEdit;

    procedure comTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GenBarcode;
    procedure edDataKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}


uses zint, zint_render_fmx_bmp;

type
  BCTypeEntry = record
    N : String;
    T : Integer;
  end;

const
  SupportedTypes : array[0..36] of BCTypeEntry =((N : '2 of 5 Matrix'; T : BARCODE_C25MATRIX),
                                                (N : '2 of 5 Industrial'; T : BARCODE_C25IND),
                                                (N : '2 of 5 Interleaved'; T : BARCODE_C25INTER),
                                                (N : '2 of 5 IATA'; T : BARCODE_C25IATA),
                                                (N : '2 of 5 Datalogic'; T : BARCODE_C25LOGIC),
                                                (N : 'Deutsche Post Leitcode'; T : BARCODE_DPLEIT),
                                                (N : 'Deutsche Post Identcode'; T : BARCODE_DPIDENT),
                                                (N : 'EAN 128'; T : BARCODE_EAN128),
                                                (N : 'Code 39'; T : BARCODE_CODE39),
                                                (N : 'Pharmazentral PZN'; T : BARCODE_PZN),
                                                (N : 'Extended Code 39'; T : BARCODE_EXCODE39),
                                                (N : 'Codabar'; T : BARCODE_CODABAR),
                                                (N : 'Code 93'; T : BARCODE_CODE93),
                                                (N : 'Logmars'; T : BARCODE_LOGMARS),
                                                (N : 'Code 128'; T : BARCODE_CODE128),
                                                (N : 'Code 128 B'; T : BARCODE_CODE128B),
                                                (N : 'NVE 18'; T : BARCODE_NVE18),
                                                (N : 'Code 11'; T : BARCODE_CODE11),
                                                (N : 'Pharmacode'; T : BARCODE_PHARMA),
                                                (N : 'ITF 14'; T : BARCODE_ITF14),
                                                (N : 'Australian Post Code'; T : BARCODE_AUSPOST),
                                                (N : 'Australian Post Reply'; T : BARCODE_AUSREPLY),
                                                (N : 'Australian Post Route'; T : BARCODE_AUSROUTE),
                                                (N : 'Australian Post Redirect'; T : BARCODE_AUSREDIRECT),
                                                (N : 'Pharma 2-track'; T : BARCODE_PHARMA_TWO),
                                                (N : 'Code 32 / Italian Pharmacode'; T : BARCODE_CODE32),
                                                (N : 'EAN 14'; T : BARCODE_EAN14),
                                                (N : 'Azrune'; T : BARCODE_AZRUNE),
                                                (N : 'HIBC 128'; T : BARCODE_HIBC_128),
                                                (N : 'HIBC 39'; T : BARCODE_HIBC_39),
                                                (N : 'HIBC Datamatrix'; T : BARCODE_HIBC_DM),
                                                (N : 'HIBC Aztec'; T : BARCODE_HIBC_AZTEC),
                                                (N : 'Datamatrix'; T : BARCODE_DATAMATRIX),
                                                (N : 'Maxicode'; T : BARCODE_MAXICODE),
                                                (N : 'Aztec'; T : BARCODE_AZTEC),
                                                (N : 'Code 16k'; T : BARCODE_CODE16K),
                                                (N : 'Code 49'; T : BARCODE_CODE49)
                                               );

procedure TFormMain.comTypeChange(Sender: TObject);
begin
  GenBarcode;
end;

procedure TFormMain.edDataKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  genBarcode
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  for i := Low(SupportedTypes) to High(SupportedTypes) do
    comType.Items.Add(SupportedTypes[i].N);

  comType.ItemIndex := 0;
end;

procedure TFormMain.GenBarcode;
var
  symbol : TZintSymbol;
  bmp : TBitmap;
  rt  : TZintBMPRenderTarget;
begin
  symbol := TZintSymbol.Create;
  symbol.symbology := SupportedTypes[comType.ItemIndex].T;
  symbol.input_mode := UNICODE_MODE;
  symbol.show_hrt := 1;
  symbol.output_options:=symbol.output_options or BARCODE_BOX;
  symbol.border_width:=1;
  symbol.whitespace_width:=10;
  symbol.Encode(UTF8Encode(edData.Text), true);

   bmp:=TBitmap.Create(round(imgResult.Width), round(imgResult.Height));
   rt:=TZintBMPRenderTarget.Create(bmp);
   rt.RenderAdjustMode:=ramScaleBarcode;
   rt.Font.Family:='Courier New';
   Symbol.Render(rt);
   rt.Free;
   imgResult.Bitmap:=bmp;
   bmp.Free;

   symbol.Free;
end;

end.