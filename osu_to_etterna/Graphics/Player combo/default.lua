local allowedCustomization = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).CustomizeGameplay
local c
local enabledCombo = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).ComboText

local function arbitraryComboX(value) 
	c.Label:x(value) 
	c.Number:x(value + 10)
	c.Border:x(value)
  end 

local function arbitraryComboZoom(value)
	c.Label:zoom(value)
	c.Number:zoom(value - 0.1)
	if allowedCustomization then
		c.Border:playcommand("ChangeWidth", {val = c.Number:GetZoomedWidth() + c.Label:GetZoomedWidth()})
		c.Border:playcommand("ChangeHeight", {val = c.Number:GetZoomedHeight()})
	end
end

local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")
local OsuBounce = THEME:GetMetric("Combo", "ComboDoTheOsuBounceCommand")

local translated_combo = "" --THEME:GetString("ScreenGameplay", "ComboText")

local t =
	Def.ActorFrame {
	InitCommand = function(self)
		self:vertalign(bottom)
	end,
	LoadFont("Combo", "numbers") ..
		{
			Name = "Number",
			InitCommand = function(self)
				self:xy(MovableValues.ComboX + 10, MovableValues.ComboY):halign(0.5):valign(0.5):visible(
					false
				)
			end,
			ResetCommand = function(self)
				self:finishtweening():stopeffect():visible(false)
			end
		},
	LoadFont("Common Normal") ..
		{
			Name = "Label",
			InitCommand = function(self)
				self:xy(MovableValues.ComboX, MovableValues.ComboY):diffusebottomedge(color("0.75,0.75,0.75,1")):halign(0):valign(
					1
				):visible(false)
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
			c.Label:settext(translated_combo)
			c.Number:visible(true)
			c.Label:visible(true)
			c.Number:settext(1000)
			Movable.DeviceButton_3.propertyOffsets = {self:GetTrueX() -6, self:GetTrueY() + c.Number:GetHeight()*1.5}	-- centered to screen/valigned
			setBorderAlignment(c.Border, 0.5, 1)
		end
		arbitraryComboZoom(0.5)
	end,
	ComboCommand = function(self, param)
		local iCombo = param.Combo
		if not iCombo or iCombo < ShowComboAt then
			c.Number:visible(false)
			c.Label:visible(false)
			return
		end

		c.Label:settext(translated_combo)
		self:playcommand("Reset")
		c.Number:visible(true)
		c.Label:visible(true)
		c.Number:settext(iCombo)
		OsuBounce(c.Number)
	end,
	MovableBorder(0, 0, 1, MovableValues.ComboX, MovableValues.ComboY),
}

if enabledCombo then
	return t
end

return Def.ActorFrame {}
