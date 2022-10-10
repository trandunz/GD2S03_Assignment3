Text = require("Text");
Player = require("Player");
require("World");

function love.load(arg)
  love.window.setMode(800, 800);

  InitWorld();

  Player.Create(love.graphics.getWidth()/2, love.graphics.getHeight()/2);
  Text.Create("Yay!");
end

function love.update(dt)
  world:update(dt);
  Player.GrabInput();
  Player.Update(dt);
end

function love.draw()
  Player.Draw();
  Text.Draw();
end
