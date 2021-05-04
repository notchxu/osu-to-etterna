-- Removed all the protiming junk, it's obsoleted
local allowedCustomization = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).CustomizeGameplay
local c
local enabledJudgment = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).JudgmentText

-- -- need to get P1X
-- local cols = GAMESTATE:GetCurrentStyle():ColumnsPerPlayer()
-- assert(cols == 4, "Number of columns isn't 4. We receptors will be invisible nao")
-- local evencols = cols - cols%2
-- local nfspace = MovableValues.NotefieldSpacing and MovableValues.NotefieldSpacing or 0

-- local width = getNoteFieldScale(PLAYER_1)*(64 * cols * MovableValues.NotefieldWidth + nfspace * (evencols))
-- local colWidth = width/cols
-- local P1X = SCREEN_CENTER_X + MovableValues.NotefieldX + (cols % 2 == 0 and -nfspace / 2 or 0)

-- local usingReverse = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():UsingReverse()
-- local o = usingReverse and 1 or -1

-- -- x and y positions so they're always centered and correspond to osu hitPos
-- -- yes this is hardcoded to shit									
-- local x = P1X
-- local y = o*(math.min(getOsuScorePosition(cols),480) - 240)*308/240 + 39


local JudgeCmds = {
	TapNoteScore_W1 = THEME:GetMetric("Judgment", "JudgmentW1Command"),
	TapNoteScore_W2 = THEME:GetMetric("Judgment", "JudgmentW2Command"),
	TapNoteScore_W3 = THEME:GetMetric("Judgment", "JudgmentW3Command"),
	TapNoteScore_W4 = THEME:GetMetric("Judgment", "JudgmentW4Command"),
	TapNoteScore_W5 = THEME:GetMetric("Judgment", "JudgmentW5Command"),
	TapNoteScore_Miss = THEME:GetMetric("Judgment", "JudgmentMissCommand")
}

local TNSFrames = {
	TapNoteScore_W1 = 0,
	TapNoteScore_W2 = 1,
	TapNoteScore_W3 = 2,
	TapNoteScore_W4 = 3,
	TapNoteScore_W5 = 4,
	TapNoteScore_Miss = 5
}

local Judges = {"Judgment1", "Judgment2", "Judgment3", "Judgment4", "Judgment5", "JudgmentMiss"}

local function judgmentZoom(value)
	for i, Judgment in ipairs(Judges) do
		c[Judgment]:zoom(value)
		if allowedCustomization then
			c.Border:playcommand("ChangeWidth", {val = c[Judgment]:GetZoomedWidth()})
			c.Border:playcommand("ChangeHeight", {val = c[Judgment]:GetZoomedHeight()})
		end
	end
end

local t = Def.ActorFrame {
	Def.ActorFrame{
		Name = "Judgment",
		Def.Sprite {
			Texture = "/" .. GetPathO("mania-hit300g", "png"), -- .. getAssetPath("judgment"),
			Name = "Judgment1",
			InitCommand = function(self)
				self:pause():visible(false):xy(MovableValues.JudgeX, MovableValues.JudgeY)
			end,
			ResetCommand = function(self)
				self:finishtweening():stopeffect():visible(false)
			end
		},
		Def.Sprite {
			Texture = "/" .. GetPathO("mania-hit300", "png"), -- .. getAssetPath("judgment"),
			Name = "Judgment2",
			InitCommand = function(self)
				self:pause():visible(false):xy(MovableValues.JudgeX, MovableValues.JudgeY)
			end,
			ResetCommand = function(self)
				self:finishtweening():stopeffect():visible(false)
			end
		},
		Def.Sprite {
			Texture = "/" .. GetPathO("mania-hit200", "png"), -- .. getAssetPath("judgment"),
			Name = "Judgment3",
			InitCommand = function(self)
				self:pause():visible(false):xy(MovableValues.JudgeX, MovableValues.JudgeY)
			end,
			ResetCommand = function(self)
				self:finishtweening():stopeffect():visible(false)
			end
		},
		Def.Sprite {
			Texture = "/" .. GetPathO("mania-hit100", "png"), -- .. getAssetPath("judgment"),
			Name = "Judgment4",
			InitCommand = function(self)
				self:pause():visible(false):xy(MovableValues.JudgeX, MovableValues.JudgeY)
			end,
			ResetCommand = function(self)
				self:finishtweening():stopeffect():visible(false)
			end
		},
		Def.Sprite {
			Texture = "/" .. GetPathO("mania-hit50", "png"), -- .. getAssetPath("judgment"),
			Name = "Judgment5",
			InitCommand = function(self)
				self:pause():visible(false):xy(MovableValues.JudgeX, MovableValues.JudgeY)
			end,
			ResetCommand = function(self)
				self:finishtweening():stopeffect():visible(false)
			end
		},
		Def.Sprite {
			Texture = "/" .. GetPathO("mania-hit0", "png"), -- .. getAssetPath("judgment"),
			Name = "JudgmentMiss",
			InitCommand = function(self)
				self:pause():visible(false):xy(MovableValues.JudgeX, MovableValues.JudgeY)
			end,
			ResetCommand = function(self)
				self:finishtweening():stopeffect():visible(false)
			end
		},
	},
	
	OnCommand = function(self)
		c = self:GetChildren()
		j = c.Judgment:GetChildren()
		judgmentZoom(MovableValues.JudgeZoom)
		if allowedCustomization then
			Movable.DeviceButton_1.element = c
			Movable.DeviceButton_2.element = c
			Movable.DeviceButton_1.condition = enabledJudgment
			Movable.DeviceButton_2.condition = enabledJudgment
			Movable.DeviceButton_2.DeviceButton_up.arbitraryFunction = judgmentZoom
			Movable.DeviceButton_2.DeviceButton_down.arbitraryFunction = judgmentZoom
			Movable.DeviceButton_1.propertyOffsets = {self:GetTrueX() , self:GetTrueY() - c.Judgment:GetHeight()}	-- centered to screen/valigned
		end
	end,
	JudgmentMessageCommand = function(self, param)
		if param.HoldNoteScore or param.FromReplay then
			return
		end
		-- local iNumStates = c.Judgment:GetNumStates()
		local iFrame = TNSFrames[param.TapNoteScore]
		if not iFrame then
			return
		end
		-- if iNumStates == 12 then
		-- 	iFrame = iFrame * 2
		-- 	if not param.Early then
		-- 		iFrame = iFrame + 1
		-- 	end
		-- end

		self:playcommand("Reset")
		j[Judges[iFrame+1]]:visible(true)
		--c.Judgment:setstate(iFrame)
		JudgeCmds[param.TapNoteScore](j[Judges[iFrame + 1]])
	end,
	MovableBorder(0, 0, 1, MovableValues.JudgeX, MovableValues.JudgeY)
}

if enabledJudgment then
	return t
end

return Def.ActorFrame {}
