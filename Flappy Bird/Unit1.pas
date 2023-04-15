{

  Made by ThomasDev
  https://github.com/ThomasDev-1

}

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.Actions, System.Math,
  Vcl.ActnList, Vcl.StdCtrls, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    actlst1: TActionList;
    actJump: TAction;
    pnlBG: TPanel;
    tmrFall: TTimer;
    tmrMoveTubes: TTimer;
    tmrCollisionChecker: TTimer;
    pnlGameOver: TPanel;
    txtGameOver: TStaticText;
    btnReplay: TButton;
    txtScore: TStaticText;
    tmrIncreaseScore: TTimer;
    txtGameScore: TStaticText;
    shpBall: TImage;
    imgTopTube1: TImage;
    imgBottomTube1: TImage;
    imgBottomTube2: TImage;
    imgTopTube2: TImage;
    imgBackground: TImage;
    tmrIncreaseSpeed: TTimer;
    procedure actJumpExecute(Sender: TObject);
    procedure tmrFallTimer(Sender: TObject);
    procedure tmrMoveTubesTimer(Sender: TObject);
    function Collision(Shape1 : TImage; Shape2: TImage): Boolean;
    procedure tmrCollisionCheckerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RandomTubes(TopTube : TImage; BottomTube : TImage);
    procedure EndGame();
    procedure tmrIncreaseScoreTimer(Sender: TObject);
    procedure RestartGame();
    procedure btnReplayClick(Sender: TObject);
    procedure tmrIncreaseSpeedTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  isRunning : Boolean;
  iScore : integer;
  iHighScore : integer;
  iReset : integer;
  iGravity : integer;


implementation

{$R *.dfm}

procedure TForm1.btnReplayClick(Sender: TObject);
var
page : string;
begin
 RestartGame();
end;

function TForm1.Collision(Shape1 : TImage; Shape2: TImage): Boolean;
var
  overlapX, overlapY: Integer;
  R1, R2 : TRect;
begin

  R1 := Shape1.BoundsRect;
  R2 := Shape2.BoundsRect;
  // calculate the x-axis overlap
  overlapX := Min(R1.Right, R2.Right) - Max(R1.Left, R2.Left);

  // calculate the y-axis overlap
  overlapY := Min(R1.Bottom, R2.Bottom) - Max(R1.Top, R2.Top);

  // if both overlaps are positive, there is a collision
  if (overlapX > 0) and (overlapY > 0) then
    Result := True
  else
    Result := False;
end;

procedure TForm1.RandomTubes(TopTube : TImage; BottomTube : TImage);
var
TopHeight, BottomHeight, Gap : Integer;
BottomTop : Integer;
begin
  //377
  //57 - 230

  TopHeight := RandomRange(57, 230);
  Gap := 120;
  BottomHeight := 418 - TopHeight - Gap;

  BottomTop := 418 - BottomHeight;

  TopTube.Height := TopHeight;
  BottomTube.Height := BottomHeight;

  BottomTube.Top := BottomTop;

end;

procedure TForm1.EndGame();
begin
  pnlGameOver.Visible := True;
  tmrFall.Enabled := False;
  tmrMoveTubes.Enabled := False;
  tmrCollisionChecker.Enabled := False;
  isRunning := False;
  tmrIncreaseScore.Enabled := False;

  txtScore.Caption := 'Score : ' + IntToStr(iScore);
  if iScore > iHighScore then
    iHighScore := iScore;

end;

procedure TForm1.RestartGame();
begin
  shpBall.Top := 177;
  iScore := 0;

  imgTopTube1.Left := 280;
  imgBottomTube1.Left := 280;

  imgTopTube2.Left := 648;
  imgBottomTube2.Left := 648;

  pnlGameOver.Visible := False;
  tmrFall.Enabled := True;
  tmrMoveTubes.Enabled := True;
  tmrCollisionChecker.Enabled := True;
  isRunning := True;
  tmrIncreaseScore.Enabled := True;

  tmrMoveTubes.Interval := 50;

  iGravity := 7;

end;


procedure TForm1.FormActivate(Sender: TObject);
begin
  isRunning := True;
  pnlGameOver.Visible := False;
  iScore := 0;
  iReset := 0;

  tmrMoveTubes.Interval := 50;

  iGravity := 7;
end;

procedure TForm1.actJumpExecute(Sender: TObject);
var
  i: Integer;
begin
  //Jump
  for i := 0 to 10 do
  begin
    if shpBall.Top > 5 then
       shpBall.Top:= shpBall.Top - 4;
  end;
end;

procedure TForm1.tmrCollisionCheckerTimer(Sender: TObject);
begin

  if isRunning then
  begin
    if Collision(shpBall, imgBottomTube1) then
    begin
      EndGame();
    end;
    if Collision(shpBall, imgBottomTube2) then
    begin
      EndGame();
    end;
    if Collision(shpBall, imgTopTube1) then
    begin
      EndGame();
    end;
    if Collision(shpBall, imgTopTube2) then
    begin
      EndGame();
    end;
  end;

end;

procedure TForm1.tmrFallTimer(Sender: TObject);
begin


  if shpBall.Top < 377 then
      shpBall.Top := shpBall.Top + iGravity;
end;

procedure TForm1.tmrIncreaseScoreTimer(Sender: TObject);
begin
  iScore := iScore + 1;
  txtGameScore.Caption := IntToStr(iScore);
end;

procedure TForm1.tmrIncreaseSpeedTimer(Sender: TObject);
begin
  iReset := iReset + 1;

  if iReset > 5 then
  begin
    tmrMoveTubes.Interval := tmrMoveTubes.Interval - 2;
    iReset := 0;
    iGravity := iGravity + 1;
  end;
end;

procedure TForm1.tmrMoveTubesTimer(Sender: TObject);
begin
  imgTopTube1.Left := imgTopTube1.Left - 7;
  imgBottomTube1.Left := imgBottomTube1.Left - 7;

  imgTopTube2.Left := imgTopTube2.Left - 7;
  imgBottomTube2.Left := imgBottomTube2.Left - 7;


  if imgTopTube1.Left < -70 then
  begin
    imgTopTube1.Left := 648;
    RandomTubes(imgTopTube1, imgBottomTube1);
  end;

  if imgTopTube2.Left < -70 then
  begin
    imgTopTube2.Left := 648;
    RandomTubes(imgTopTube2, imgBottomTube2);
  end;

  if imgBottomTube1.Left < -70 then
  begin
    imgBottomTube1.Left := 648;
  end;

  if imgBottomTube2.Left < -70 then
  begin
    imgBottomTube2.Left := 648;
  end;


end;

end.
