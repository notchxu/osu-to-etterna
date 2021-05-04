--If a Command has "NOTESKIN:GetMetricA" in it, that means it gets the command from the metrics.ini, else use cmd(); to define command.
--If you dont know how "NOTESKIN:GetMetricA" works here is an explanation.
--NOTESKIN:GetMetricA("The [Group] in the metrics.ini", "The actual Command to fallback on in the metrics.ini");
local i = Var("index")

local usingReverse = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():UsingReverse()
local r = usingReverse and 0 or 180
local o = usingReverse and 1 or -1
local v = usingReverse and 0 or 1

local t =
	Def.ActorFrame {
	
	Def.Sprite{
		Texture = "/" .. GetPathO(getReceptors(4)[i], "png"),
		Frame0000 = 0,
		Delay0000 = 1,
		InitCommand = function(self)
			self:addrotationx(r)
			w = self:GetWidth()*52/84
			c = THEME:GetMetric("Player", "ColumnWidth")
			-- y offset shit
			h = self:GetHeight()*64/self:GetWidth() * w/c
			yOffset = o*((240-getHitPosDownscroll(4))*64/c - h/2)
			-- zoom zoom
			self:basezoomx(c/w)
			self:zoom(64/self:GetWidth() * w/c)
			self:xy(0, yOffset)
			self:visible(true)
		end,
		PressCommand = function(self)
			self:visible(false)
		end,
		LiftCommand = function(self)
			self:visible(true)
		end,
	}, 

	Def.Sprite{
		Texture = "/" .. GetPathO(getReceptorsPress(4)[i], "png"),
		Frame0000 = 0,
		Delay0000 = 1,
		InitCommand = function(self)
			self:addrotationx(r)
			w = self:GetWidth()*52/84
			c = THEME:GetMetric("Player", "ColumnWidth")
			-- y offset shit
			h = self:GetHeight()*64/self:GetWidth() * w/c
			yOffset = o*((240-getHitPosDownscroll(4))*64/c - h/2)
			-- zoom zoom
			self:basezoomx(c/w)
			self:zoom(64/self:GetWidth() * w/c)
			self:xy(0, yOffset)
			self:visible(false)
		end,
		PressCommand = function(self)
			self:visible(true)
		end,
		LiftCommand = function(self)
			self:visible(false)
		end,
	}, 

	Def.Sprite{
		Texture = "/" .. GetPathO("mania-stage-hint", "png"),
		Frame0000 = 0,
		Delay0000 = 1,
		InitCommand = function(self)
			self:addrotationx(r)
			--self:cropright((4-i)/4*100):cropleft((i-1)/4*100)
			w = self:GetWidth()*52/84
			c = THEME:GetMetric("Player", "ColumnWidth")
			-- y offset shit
			h = self:GetHeight()*64/self:GetWidth() * w/c
			yOffset = o*((getOsuHitPosDownscroll(4)-getHitPosDownscroll(4) - 240)*64/c)
			-- zoom zoom
			self:basezoomx(c/w)
			self:zoom(64/self:GetWidth() * w/c)
			--self:halign(0):valign(v)
			self:xy(0, yOffset)
			self:visible(true)
		end,
	}
}
return t
