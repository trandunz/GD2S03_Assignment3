Player = {Sprite, ImageDimension, Width, Height, WalkGrid, WalkGridAnim};

function Player.Create(_xPos, _yPos)
  Player.Sprite = require("Sprite");
  Player.Sprite.Create("Resources/Textures/PatricStar.png", _xPos, _yPos);
end

function Player.GrabInput()
end

function Player.Move(_xAmount, _yAmount, _dt)
  Player.Sprite.XPos = Player.Sprite.XPos + _xAmount * _dt;
  Player.Sprite.YPos = Player.Sprite.YPos + _yAmount * _dt;
end

function Player.Draw()
  Player.Sprite.Draw();
end

return Player;
