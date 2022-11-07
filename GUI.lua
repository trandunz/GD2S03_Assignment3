--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : GUI.lua
--Description : GUI Implementation File
--Author : Will Inman

local GUI = {};

-- returns a new GUI instance
function GUI:new(_gui)
  _gui = _gui or {NumberOfElements = 0, Elements = {}};
  setmetatable(_gui, self);
  self.__index = self;
  return _gui;
end

-- Creates an image with the specified key
function GUI:CreateImage(_key, _file, _xPos, _yPos)
  self.Elements[_key] = require("Sprite"):new();
  self.Elements[_key]:Create(_file, _xPos, _yPos)
end

-- Creates a text element with the specified key
function GUI:CreateText(_key, _string, _xPos, _yPos, _align, _angle, _charSize, _r, _g, _b)
  self.Elements[_key] = require("Text"):new();
  self.Elements[_key]:Create(_string, _xPos, _yPos, _align, _angle, _charSize, _r, _g, _b);
end

-- draw all Ui elements
function GUI:Draw()
  for i, v in pairs(self.Elements) do
    self.Elements[i]:Draw();
  end
end

-- Cleans up all GUI elements
function GUI:Cleanup()
  for i, v in pairs(self) do
    self.Elements[i] = nil;
  end
end

return GUI;
