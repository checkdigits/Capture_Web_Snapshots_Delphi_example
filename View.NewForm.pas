//---------------------------------------------------------------------------

// This software is Copyright (c) 2021 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

unit View.NewForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Main, FMX.Effects, FMX.Layouts, FMX.Ani, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  System.Hash;

type
  TNewFormFrame = class(TMainFrame)
    EdtAccKey: TEdit;
    EdtURL: TEdit;
    EdtViewPort: TEdit;
    Lyt1: TLayout;
    ChkBFullPage: TCheckBox;
    BtnSendRequest: TButton;
    img1: TImage;
    IdHTTP1: TIdHTTP;
    EdtSecretKey: TEdit;
    procedure BtnSendRequestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TNewFormFrame.BtnSendRequestClick(Sender: TObject);
begin
  inherited;
  var MS := TMemoryStream.Create;
  var BM := TBitmap.Create;
  var HashMD5 := THashMD5.Create;
  try
    var IsFullPage := '0';  // default value: not full page
    if ChkBFullPage.IsChecked then
      IsFullPage := '1';

    // generate a hash string: url+secret_keyword
    var SecretHash := HashMD5.GetHashString(EdtURL.Text + EdtSecretKey.Text);

    var Query := Format('http://api.screenshotlayer.com/api/capture?access_key=%s&url=%s&viewport=%s&fullpage=%s&secret_key=%s', [EdtAccKey.Text, EdtURL.Text, EdtViewPort.Text, IsFullPage, SecretHash]);
    IdHTTP1.Get(Query, MS);

    MS.Seek(0, soFromBeginning);
    BM.LoadFromStream(MS);  // load image from stream

    // show in control and save
    img1.Bitmap := BM;
    img1.Bitmap.SaveToFile('Snapshot.png');
  finally
    FreeAndNil(MS);
    FreeAndNil(BM);
  end;
end;

initialization
  // Register frame
  RegisterClass(TNewFormFrame);
finalization
  // Unregister frame
  UnRegisterClass(TNewFormFrame);

end.
