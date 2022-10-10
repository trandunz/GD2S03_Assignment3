Sprite = {XPos, XPos};

function Sprite.Create(_filePath, _xPos, _yPos)
  Sprite.Image = love.graphics.newImage(_filePath);
  Sprite.XPos = _xPos;
  Sprite.YPos = _yPos;
end

function Sprite:GetWidth()
  return Sprite.Image:getWidth();
end

function Sprite:GetHeight()
  return Sprite.Image:getHeight();
end

function Sprite.Draw()
  love.graphics.draw(Sprite.Image,
  Sprite.XPos,
  Sprite.YPos,
  0,
  0.5,
  0.5,
  Sprite.Image:getWidth()/2,
  Sprite.Image:getHeight()/2);
end

return Sprite;
