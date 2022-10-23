local GUI = {};

function GUI:new(_gui)
  _gui = _gui or {NumberOfElements = 0, Elements = {}};
  setmetatable(_gui, self);
  self.__index = self;
  return _gui;
end

function GUI:CreateImage(_key, _file, _xPos, _yPos)
  self.Elements[_key] = require("Sprite"):new();
  self.Elements[_key]:Create(_file, _xPos, _yPos)
end

function GUI:Draw()
  for i, v in pairs(self.Elements) do
    self.Elements[i]:Draw();
  end
end

function GUI:Cleanup()
  for i, v in pairs(self) do
    self.Elements[i] = nil;
  end
end

return GUI;
