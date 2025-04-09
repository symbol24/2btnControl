extends Node

#GameManager
signal LoadScene(id)
signal LoadSceneFromPath(path)
signal GameReady(game)
signal PauseGame(is_paused)

#Gameplay
signal CarParked()
signal StartLevelTimer()
signal ConeHit()
signal ToggleGate(open)

#level
signal ResetLevel()

#UI
signal ToggleDisplay(id:StringName, is_visible:bool, from:StringName)
signal UpdateLevelTimer(value)
signal LevelButtonPressed(level_id)
signal DisplaySaveIcon()
signal DisplayPopup(id:StringName, title:String, description:String, timer:int)
signal PopupResult(id:StringName, result:bool)

#Audio
signal PlayAudio(audio_data, is_2d)
signal AudioExiting(player)
signal ResetAudioVolumes()
signal UpdateAudioVolume(track:StringName, value:float)
