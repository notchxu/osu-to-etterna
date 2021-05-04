local allowedCustomization = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).CustomizeGameplay
local c
local enabledCombo = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).ComboText

local function arbitraryComboX(value) 
	c.Number:x(value - 4)
	c.Border:x(value)
  end 

local function arbitraryComboZoom(value)
	c.Number:zoom(value - 0.1)
	if allowedCustomization then
		c.Border:playcommand("ChangeWidth", {val = c.Number:GetZoomedWidth()})
		c.Border:playcommand("ChangeHeight", {val = c.Number:GetZoomedHeight()})
	end
end

local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")
local OsuBounce = THEME:GetMetric("Combo", "ComboDoTheOsuBounceCommand")
local labelColor = getComboColor("ComboLabel")
local mfcNumbers = getComboColor("Marv_FullCombo")
local pfcNumbers = getComboColor("Perf_FullCombo")
local fcNumbers = getComboColor("FullCombo")
local regNumbers = getComboColor("RegularCombo")

local translated_combo = THEME:GetString("ScreenGameplay", "ComboText")

local usingReverse = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():UsingReverse()
local o = usingReverse and 1 or -1

-- x and y positions so they're always centered and correspond to osu hitPos
--local x = P1X
--local y = o*(math.min(getOsuComboPosition(4),480) - 240)*308.5/240 - 83.5 -- god this is really fuckin hacky

local t =
	Def.ActorFrame {
	InitCommand = function(self)
		self:vertalign(bottom)
	end,
	LoadFont("Combo", "numbers") ..
		{
			Name = "Number",
			InitCommand = function(self)
				-- TODO: make it part of the lane cover instead of MovableValues ?
				self:pause():visible(true):xy(MovableValues.ComboX, MovableValues.ComboY):halign(0.5):valign(0.5)
			end,
			ResetCommand = function(self)
				self:finishtweening():stopeffect():visible(false)
			end
		},
	InitCommand = function(self)
		c = self:GetChildren()
		if (allowedCustomization) then
			Movable.DeviceButton_3.element = c
			Movable.DeviceButton_4.element = c
			Movable.DeviceButton_3.condition = enabledCombo
			Movable.DeviceButton_4.condition = enabledCombo
			Movable.DeviceButton_3.Border = self:GetChild("Border")
			Movable.DeviceButton_3.DeviceButton_left.arbitraryFunction = arbitraryComboX 
			Movable.DeviceButton_3.DeviceButton_right.arbitraryFunction = arbitraryComboX 
			Movable.DeviceButton_4.DeviceButton_up.arbitraryFunction = arbitraryComboZoom
			Movable.DeviceButton_4.DeviceButton_down.arbitraryFunction = arbitraryComboZoom
		end
	end,
	OnCommand = function(self)
		if (allowedCustomization) then
			c.Number:visible(true)
			c.Number:settext(1000)
			Movable.DeviceButton_3.propertyOffsets = {self:GetTrueX() -6, self:GetTrueY() + c.Number:GetHeight()*1.5}	-- centered to screen/valigned
			setBorderAlignment(c.Border, 0.5, 1)
		end
		arbitraryComboZoom(MovableValues.ComboZoom)
	end,
	ComboCommand = function(self, param)
		self:playcommand("Reset")
		c.Number:settext(param.Combo)
		c.Number:visible(true)
		OsuBounce(c.Number)
	end,
	MovableBorder(0, 0, 1, MovableValues.ComboX, MovableValues.ComboY),
}

if enabledCombo then
	return t
end

return Def.ActorFrame {}
