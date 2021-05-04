local P1X = Var("P1X")
local width = Var("width")
local padding = 0

local t = Def.ActorFrame { }

local bippy = nil
-- da stages left and right (not the lifebar only the outline)
t[#t + 1] = 
    Def.Sprite {
	InitCommand = function(self)
		self:halign(1):valign(1):xy(P1X - (width * getNoteFieldScale(PLAYER_1) / 2) - padding, SCREEN_BOTTOM)
	end,
	BeginCommand = function(self)
		self:finishtweening()
		self:Load(GetPathO("mania-stage-left", "png"))
		self:zoomtoheight(SCREEN_BOTTOM - SCREEN_TOP)
		self:zoomx(self:GetZoomY())
	end
} 
t[#t + 1] = 
	Def.Sprite {
	InitCommand = function(self)
        self:halign(0):valign(1):xy(P1X + (width * getNoteFieldScale(PLAYER_1) / 2) + padding, SCREEN_BOTTOM)
        self:Load(GetPathO("mania-stage-right", "png"))
        self:zoomtoheight(SCREEN_BOTTOM - SCREEN_TOP)
        self:zoomx(self:GetZoomY())
	end,
}

-- da lifebar bg
local LIFEBAR_ZOOM = 7/16   
local LIFEBAR_OFFSET = 1
t[#t + 1] = 
    Def.Sprite {
    OnCommand = function(self)
        self:finishtweening()
        self:rotationz(-90)
        self:zoom(LIFEBAR_ZOOM)  
        self:halign(0):valign(0):xy(P1X + (width * getNoteFieldScale(PLAYER_1) / 2) + LIFEBAR_OFFSET, SCREEN_BOTTOM)
        self:Load(GetPathO("scorebar-bg", "png"))
    end
}

-- da lifebar


t[#t + 1] = 
    Def.Sprite {
    OnCommand = function(self)
        self:finishtweening()
        self:rotationz(-90)  
        self:zoom(LIFEBAR_ZOOM)
        --scorebar marker bullshit
        local LIFEBAR_RIGHT_OFFSET_X = 8
        local LIFEBAR_RIGHT_OFFSET_Y = 2.5
        if GetPathO("scorebar-marker", "png", true) then 
            LIFEBAR_RIGHT_OFFSET_X = 6
            LIFEBAR_RIGHT_OFFSET_Y = 6
        end
        --actual good stuff
        self:halign(0):valign(0):xy(P1X + (width * getNoteFieldScale(PLAYER_1) / 2) + padding + LIFEBAR_RIGHT_OFFSET_X, SCREEN_BOTTOM - LIFEBAR_RIGHT_OFFSET_Y)
        self:Load(GetPathO("scorebar-colour", "png"))
    end,
    LifeChangedMessageCommand = function(self, params)
        local life = params.LifeMeter:GetLife()
        self:cropright(1-life)
    end
}




return t