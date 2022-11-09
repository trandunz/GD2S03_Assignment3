--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Text.lua
--Description : Text Implementation File
--Author : Will Inman

local Text = {};

-- returns a new text instance
function Text:new(_text)
  _text = _text or {Font = "", String, xPos, yPos, xScale = 1, yScale = 1};
  setmetatable(_text, self);
  self.__index = self;
  return _text;
end

-- initializes the text
function Text:Create(_string, _xPos, _yPos, _align, _angle, _charSize, _r, _g, _b)
  _string = _string or "";
  _xPos = _xPos or 0;
  _yPos = _yPos or 0;
  _align = _align or "center";
  _charSize = _charSize or 32;
  _r = _r or 255;
  _g = _g or 255;
  _b = _b or 255;

  self.Font = love.graphics.newFont( "Resources/Fonts/Cuphead.ttf", _charSize );
  self.String = _string;
  self.xPos = _xPos;
  self.yPos = _yPos;
  self.align = _align;
  self.angle = _angle;
  self.R = _r / 255;
  self.G = _g / 255;
  self.B = _b / 255;
  self.CharSize = _charSize;

  self.Font:setFilter("nearest");
  love.graphics.setFont(self.Font);
end

-- sets the colour of the text
function Text:SetColor(_r, _g, _b, _a)
  self.R = _r / 255;
  self.G = _g / 255;
  self.B = _b / 255;
end

-- sets the scale of the text
function Text:SetScale(_x, _y)
  self.xScale = _x;
  self.yScale = _x;
end

-- sets the font of the text
function Text:SetFont(_font)
  self.Font = _font;
end

-- returns the center position of the text
function Text:GetCenterPosition()
  return self.xPos - (self.CharSize * string.len (self.String) / 2) * self.xScale;
end

-- draws the text
function Text:Draw()
  love.graphics.setColor(self.R, self.G, self.B);

  if self.align == "left" then
    love.graphics.printf(self.String, self.xPos, self.yPos, self.CharSize * string.len (self.String) , self.align, self.angle, self.xScale, self.yScale);
  elseif self.align == "center" then
    love.graphics.printf(self.String, self:GetCenterPosition(), self.yPos, self.CharSize * string.len (self.String) , self.align, self.angle, self.xScale, self.yScale);
  end

  love.graphics.setColor(1, 1, 1);
end

return Text;
