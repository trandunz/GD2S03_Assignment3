local Text = {};

function Text:new(_text)
  _text = _text or {Font = "", String, xPos, yPos};
  setmetatable(_text, self);
  self.__index = self;
  return _text;
end

function Text:Create(_string, _xPos, _yPos, _limit, _align, _angle, _xScale, _yScale)
  self.String = _string;
  self.xPos = _xPos;
  self.yPos = _yPos;
  self.limit = _limit;
  self.align = _align;
  self.angle = _angle;
  self.xScale = _xScale;
  self.yScale = _yScale;
end

function Text:SetFont(_font)
  self.Font = _font;
end

function Text:Draw()
  love.graphics.printf(self.String, self.xPos, self.yPos, self.limit, self.align, self.angle, self.xScale, self.yScale);
end

return Text;
