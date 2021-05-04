local i = Var("index")
local usingReverse = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():UsingReverse()
local r = usingReverse and 0 or 180
local t =
	Def.ActorFrame{
		Def.Sprite {
			--Texture = NOTESKIN:GetPath("_down", "tap note"),
			Texture = "/" .. GetPathO(getTapNotePaths(4)[i], "png"),
			Frame0000 = 0,
			Delay0000 = 1,
			InitCommand = function(self)
				self:addrotationx(r)
				local m = 64/self:GetWidth()
				local h = self:GetHeight()*m/2
				self:zoom(m) --:xy(0,h)
			end,
		}
	}
return t
