Text = require("Text");
Player = require("Player");

function love.load(arg)
  love.window.setMode(800, 800);
  centerX = love.graphics.getWidth()/2;
  centerY = love.graphics.getHeight()/2;

  Player.Create(centerX, centerY);
  Text.Create("Yay!");
end

function HandleKeyboard(_dt)
  if love.keyboard.isDown("up") then
    Player.Move(0,-100, _dt)
  end
  if love.keyboard.isDown("down") then
    Player.Move(0,100, _dt)
  end
  if love.keyboard.isDown("left") then
    Player.Move(-100,0, _dt)
  end
  if love.keyboard.isDown("right") then
    Player.Move(100,0, _dt)
  end
end

function HandleMouse(_dt)

end

function love.update(dt)
  HandleKeyboard(dt);
  HandleMouse(dt);

end

function love.draw()
  Player.Draw();
  Text.Draw();
end
