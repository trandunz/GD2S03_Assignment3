Text = {Font = "", String, xPos, yPos};

function Text.Create(_string, _xPos, _yPos)
  Text.String = _string;
  Text.xPos = _xPos;
  Text.yPos = _yPos;
end

function Text.SetFont(_font)
  Text.Font = _font;
end

function Text.Draw()
  love.graphics.print(Text.String, Text.xPos, Text.yPos);
end

return Text;
