extends Node

#GameManager
signal LoadScene(id)
signal LoadSceneFromPath(path)
signal GameReady(game)
signal PauseGame(is_paused)

#PlayerData
signal Save()
signal Load()

#Gameplay
signal CarParked()
signal StartLevelTimer()
signal ConeHit()
signal ToggleGate(open)

#level
signal ResetLevel()

#UI
signal ToggleDisplay(id, is_visible)
signal UpdateLevelTimer(value)
signal LevelButtonPressed(level_id)

#Audio
signal PlayAudio(audio_data, is_2d)
signal AudioExiting(player)
signal UpdateAudioVolumes()
