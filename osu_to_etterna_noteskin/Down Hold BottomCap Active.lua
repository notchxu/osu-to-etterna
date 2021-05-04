local i = Var("index")
local t =
	Def.Sprite {
			--Texture = NOTESKIN:GetPath("_down", "tap note"),
			Texture = "/" .. GetPathO(getHoldCapPaths(4)[i], "png"),
			Frame0000 = 0,
			Delay0000 = 1,
			InitCommand = function(self)
				local newHeight = self:GetHeight() * 64/self:GetWidth()
				self:SetWidth(64)
				self:SetHeight(newHeight)
			end,
		}
return t
