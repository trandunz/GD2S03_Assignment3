local AudioManager = {};

function AudioManager:new(_audioManager)
  _audioManager = _audioManager or {Sources = {}, Music = {}};
  setmetatable(_audioManager, self);
  self.__index = self;
  return _audioManager;
end

function AudioManager:ForceCleanup()
  for i, v in pairs(self.Sources) do
    v:stop();
    v = nil;
  end
  for i, v in pairs(self.Music) do
    v:stop();
    v = nil;
  end
  collectgarbage();
end

function AudioManager:Update()
  for i, v in pairs(self.Music) do
    v:setVolume(MasterVolume * MusicVolume);
  end
  for i, v in pairs(self.Sources) do
    v:setVolume(MasterVolume * EffectVolume);
  end
end

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
