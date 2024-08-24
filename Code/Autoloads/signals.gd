extends Node

#GameManager
signal LoadScene(id)
signal LoadSceneFromPath(path)
signal GameReady(game)
signal PauseGame(is_paused)

#Gameplay
signal CarParked()
signal StartLevelTimer()

#level
signal ResetLevel()

#UI
signal ToggleDisplay(id, is_visible)
signal UpdateLevelTimer(value)
signal LevelButtonPressed(level_id)
