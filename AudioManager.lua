--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : AudioManager.lua
--Description : AudioManager Implementation File
--Author : Will Inman

local AudioManager = {};

-- returns a new instance of the audio manager
function AudioManager:new(_audioManager)
  _audioManager = _audioManager or {Sources = {}, Music = {}};
  setmetatable(_audioManager, self);
  self.__index = self;
  return _audioManager;
end

-- force cleans up all audio sources including any music tracks
function AudioManager:ForceCleanup()
  for i, source in pairs(self.Sources) do
    source:stop();
    source = nil;
  end
  for i, music in pairs(self.Music) do
    music:stop();
    music = nil;
  end
  collectgarbage();
end

-- updates all audio sources
function AudioManager:Update()
  for i, source in pairs(self.Music) do
    source:setVolume(MasterVolume * MusicVolume);
  end
  for i, music in pairs(self.Sources) do
    music:setVolume(MasterVolume * EffectVolume);
  end
end

-- Creates a new music player
function AudioManager:CreateMusic(_key, _file, _playOnCreate, _looping, _streamType, _volume)
  _playOnCreate = _playOnCreate or false;
  _looping = _looping or false;
  _streamType = _streamType or "static"
  _volume = _volume or 1;
  self.Music._key = love.audio.newSource(_file, _streamType);
  self.Music._key:setLooping(_looping);
  self.Music._key:setVolume(_volume);
  if _playOnCreate == true then
    self.Music._key:play();
  end
end

-- Creates a new effect player
function AudioManager:CreateSound(_key, _file, _playOnCreate, _looping, _streamType, _volume)
  _playOnCreate = _playOnCreate or false;
  _looping = _looping or false;
  _streamType = _streamType or "static"
  _volume = _volume or 1;
  self.Sources._key = love.audio.newSource(_file, _streamType);
  self.Sources._key:setLooping(_looping);
  self.Sources._key:setVolume(_volume);
  if _playOnCreate == true then
    self.Sources._key:play();
  end
end

return AudioManager;
