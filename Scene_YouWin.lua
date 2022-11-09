--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Scene_YouWin.lua
--Description : Scene_YouWin Implementation File
--Author : Will Inman

local Scene_YouWin = {};

local GUI = require("GUI");

-- returns a new instance of scene_youwin
function Scene_YouWin:new(_youWin)
  _youWin = _youWin or {BG = require("Sprite"):new(), Cuphead = require("AnimatedSprite"):new(), AudioManager = require("AudioManager"):new(),
 Results = require("AnimatedSprite"):new(), Credit = require("Sprite"):new(), CupheadName = require("Sprite"):new(),
Board = require("Sprite"):new(), Line = require("Sprite"):new()};
  setmetatable(_youWin, self);
  self.__index = self;
  return _youWin;
end

-- cleans up the scene
function Scene_YouWin:Cleanup()
  self.AudioManager:ForceCleanup();
  GUI:Cleanup();
end

-- initializes the scene
function Scene_YouWin:Start()
    GUI = require("GUI"):new();

    self.AudioManager:CreateMusic("VictoryMusic", "Resources/Music/Victory.mp3", true, true, "stream");

    self.BG:Create("Resources/Textures/GUI/WinScreen/BG.png", WindowSize.x/2, WindowSize.y/2);
    self.BG:SetScale(1,1);

    self.Cuphead:Create("Resources/Textures/GUI/WinScreen/Cuphead.png", (WindowSize.x /2) - 300, (WindowSize.y /2) + 50, 301 ,433);
    self.Cuphead:AddAnimation('1-13', 0.04166);
    self.Cuphead.CurrentAnimation = 1;

    self.Results:Create("Resources/Textures/GUI/WinScreen/Results.png", (WindowSize.x /2), 90, 792,150);
    self.Results:AddAnimation('1-3', 0.04166);
    self.Results.CurrentAnimation = 1;

    self.Credit:Create("Resources/Textures/GUI/WinScreen/Credit.png", (WindowSize.x /2), 175);
    self.Credit:SetScale(1,1);

    self.CupheadName:Create("Resources/Textures/GUI/WinScreen/Title.png", self.Cuphead:GetPosition().x, self.Cuphead:GetPosition().y + 250);
    self.CupheadName:SetScale(1,1);

    self.Board:Create("Resources/Textures/GUI/WinScreen/Board.png", (WindowSize.x/2) + 150, WindowSize.y/2 + 80);
    self.Board:SetScale(1,1);

    self.Line:Create("Resources/Textures/GUI/WinScreen/Line.png", (WindowSize.x/2) + 150, WindowSize.y/2 + 150);
    self.Line:SetScale(1,1);

    GUI:CreateText("Time", "time . . . . . . . . . . . . . .", self.Board:GetPosition().x - 190, self.Board:GetPosition().y - 150, "left", 0, 32);
    GUI.Elements.Time:SetScale(1.2,1.2);
    GUI:CreateText("TimeValue", "01:30", self.Board:GetPosition().x + 140, self.Board:GetPosition().y - 150, "center", 0, 32, 255, 180, 0);
    GUI.Elements.TimeValue:SetScale(1.2,1.2);

    GUI:CreateText("HpBonus", "hp bonus . . . . . . . . . . .", self.Board:GetPosition().x - 190, self.Board:GetPosition().y - 110, "left", 0, 32);
    GUI.Elements.HpBonus:SetScale(1.2,1.2);
    GUI:CreateText("HpBonusValue", "3/3", self.Board:GetPosition().x + 160, self.Board:GetPosition().y - 110, "center", 0, 32, 255, 180, 0);
    GUI.Elements.HpBonusValue:SetScale(1.2,1.2);

    GUI:CreateText("Parry", "parry . . . . . . . . . . . . . . .", self.Board:GetPosition().x - 190, self.Board:GetPosition().y - 70, "left", 0, 32);
    GUI.Elements.Parry:SetScale(1.2,1.2);
    GUI:CreateText("ParryValue", "3/3", self.Board:GetPosition().x + 160, self.Board:GetPosition().y - 70, "center", 0, 32, 255, 180, 0);
    GUI.Elements.ParryValue:SetScale(1.2,1.2);

    GUI:CreateText("SuperMeter", "super meter . . . . . . . .", self.Board:GetPosition().x - 190, self.Board:GetPosition().y - 30, "left", 0, 32);
    GUI.Elements.SuperMeter:SetScale(1.2,1.2);
    GUI:CreateText("SuperMeterValue", "6/6", self.Board:GetPosition().x + 160, self.Board:GetPosition().y - 30, "center", 0, 32, 255, 180, 0);
    GUI.Elements.SuperMeterValue:SetScale(1.2,1.2);

    GUI:CreateText("SkillLevel", "skill level . . . . . . . .", self.Board:GetPosition().x - 190, self.Board:GetPosition().y + 10, "left", 0, 32);
    GUI.Elements.SkillLevel:SetScale(1.2,1.2);

    GUI:CreateText("Grade", "grade . . .", self.Board:GetPosition().x - 45, self.Board:GetPosition().y + 80, "center", 0, 32, 255, 180, 0);
    GUI.Elements.Grade:SetScale(1.75,1.75);

    GUI:CreateText("GradeValue", "A+", self.Board:GetPosition().x + 110, self.Board:GetPosition().y + 80, "center", 0, 32);
    GUI.Elements.GradeValue:SetScale(1.75,1.75);
end

-- updates the scene
function Scene_YouWin:Update(_dt)
  LevelLoader:HandleSceneStartTransition(_dt);

  self.BG:Rotate(_dt);

  self.AudioManager:Update();
  self.Cuphead:Update(_dt);
  self.Results:Update(_dt);
end

-- recieves key events from love key callback
function Scene_YouWin:KeyEvents( key, scancode, isrepeat )
  if key == "return" then
    self.AudioManager:CreateSound("Confirm", "Resources/Sounds/GUI/Confirm.wav", true, false);
    LevelLoader:LoadLevel("Scene_Overworld");
  end
end

-- draws the scene
function Scene_YouWin:Draw()
    self.BG:Draw();
    self.Cuphead:Draw();
    self.Results:Draw();
    self.CupheadName:Draw();
    self.Credit:Draw();
    self.Board:Draw();
    self.Line:Draw();
    GUI:Draw();
end

return Scene_YouWin;
