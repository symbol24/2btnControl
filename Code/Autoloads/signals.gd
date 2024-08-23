extends Node

#GameManager
signal LoadScene(id)
signal LoadSceneFromPath(path)
signal GameReady(game)

#Gameplay
signal CarParked()



#UI
signal ToggleDisplay(id, is_visible)
