local AudioManager = {Sources = {}};

function AudioManager.ForceCleanup()
  for i, v in pairs(AudioManager.Sources) do
    AudioManager.Sources[i]:stop();
    AudioManager.Sources[i] = nil;
  end
  collectgarbage("collect");
end

function AudioManager.CreateSound(_key, _file, _playOnCreate, _looping, _streamType)
  _playOnCreate = _playOnCreate or false;
  _looping = _looping or false;
  _streamType = _streamType or "static"
  AudioManager.Sources._key = love.audio.newSource(_file, _streamType);
  AudioManager.Sources._key:setLooping(_looping);
  if _playOnCreate == true then
    AudioManager.Sources._key:play();
  end
end

return AudioManager;
