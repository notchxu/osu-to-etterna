--credit to Dynodizzo

local function osuSkinDir()
	return "Themes/osu_to_etterna/Graphics/OsuSkins/" .. THEME:GetMetric("Common", "OsuFolder") .. "/"
end

local function osuFallbackSkinDir()
	return "Themes/osu_to_etterna/Graphics/OsuSkins/" .. THEME:GetMetric("Common", "OsuFallbackFolder") .. "/"
end

local function formatFile(f)
	-- remove trailing whitespaces and replace back with forward slash
	-- also escape them properly; you'll likely find dashes in practice though
	f = f:gsub("\\", "/"):gsub("^%s*(.-)%s*$", "%1"):gsub("%-", "%%-")
	return f
end

local function m(candPath, prefix, suffix)
	suffix = suffix and "%." .. suffix or ""
	return candPath:find(prefix .. suffix) or 
			candPath:find(prefix .. "@2x" .. suffix) or 
			candPath:find(prefix .. "%-%d+" .. suffix) or 
			candPath:find(prefix .. "%-%d+@2x" .. suffix)
end

function GetPathO(p, suffix, suppressFallbackCheck) --GetOnePathO or findFileStartingWith
	-- p = "arrow/arrowleft" 
	-- then prefixDir = "Themes/osu_to_etterna/Graphics/OsuSkins/Skin_NAME/arrow/"
	-- prefix = "arrowleft" and hopefully you find "arrowleft.png"
	-- or "arrowleft@2x.png"
	suppressFallbackCheck = suppressFallbackCheck or false
	p = formatFile(p)
	local cut = p:match(".*()/")
	local dirs = {osuSkinDir()}
	if not suppressFallbackCheck then 
		dirs[#dirs+1] = osuFallbackSkinDir()
	end
	for __, skinDir in ipairs(dirs) do 
		local prefixDir, prefix
		if cut then
			if __ == 2 then 
				return nil
			end 
			prefixDir = skinDir .. p:sub(1,cut)
			prefix = p:sub(cut+1):lower()
		else 
			prefixDir = skinDir
			prefix = p:lower()
		end 
		for _, f in ipairs(FILEMAN:GetDirListing(prefixDir)) do
			f = f:lower()
			if m(f, prefix, suffix) == 1 then
				return prefixDir .. f
			end
		end
	end
	return nil
end

-- turns Skin.ini into a table wooo -chxu
local function loadOsuSkin()
	local fileName = GetPathO("skin", "ini")
	--local fileName = "skin.ini"
	local file = RageFileUtil.CreateRageFile()
	if not file:Open(fileName, 1) then
		Warn(string.format("ReadFile(%s): %s", fileName, file:GetError()))
		file:destroy()
		return {} -- return a blank table
	end
	local data = {
		Mania = {}
	}
	local section
	local isManiaSection = false
	while not file:AtEOF() do
		local line = file:GetLine()
		if not line then
			break
		end
		-- ew comments bad
		local commentIndex = line:find("//")
		if commentIndex then 
			line = line:sub(1, commentIndex-1)
		end
		-- sections
		local tempSection = line:match('^%[([^%[%]]+)%]$');
		if(tempSection) then
			section = tonumber(tempSection) and tonumber(tempSection) or tempSection;
			-- mania bullshit
			if section == "Mania" then
				isManiaSection = true
				data.Mania[#data.Mania+1] = {}
			else
				isManiaSection = false
				data[section] = data[section] or {};
			end
		end
		-- shit in sections
		local param, value = line:match('^([%w|_]+)%s-:%s-(.+)$');
		if(param and value ~= nil)then
			if(tonumber(value))then
				value = tonumber(value);
			elseif(value == 'true')then
				value = true;
			elseif(value == 'false')then
				value = false;
			end
			if(tonumber(param))then
				param = tonumber(param);
			end
			-- Mania section???
			if isManiaSection then
				data.Mania[#data.Mania][param] = value;
			else
				data[section][param] = value;
			end
		end
	end
	file:Close()
	file:destroy()
	return data;
end

-- May be useful later -chxu
-- local function LIP.save(fileName, data)
-- 	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
-- 	assert(type(data) == 'table', 'Parameter "data" must be a table.');
-- 	local file = assert(io.open(fileName, 'w+b'), 'Error loading file :' .. fileName);
-- 	local contents = '';
-- 	for section, param in pairs(data) do
-- 		contents = contents .. ('[%s]\n'):format(section);
-- 		for key, value in pairs(param) do
-- 			contents = contents .. ('%s=%s\n'):format(key, tostring(value));
-- 		end
-- 		contents = contents .. '\n';
-- 	end
-- 	file:write(contents);
-- 	file:close();
-- end

local data = loadOsuSkin()
local noteDims = {}
local hitPosDownscroll = {}

local function getManiaBlock(keyCount) -- gets the relevant blocky block of table to look at
	for _, v in ipairs(data.Mania) do
		if v["Keys"] == keyCount then
			return v
		end
	end
	return {}
end

local function getNoteWidthHeight(keyCount)
	if noteDims[keyCount] then 
		return noteDims[keyCount][1], noteDims[keyCount][2]
	else
		local notePath = getTapNotePaths(keyCount)[1]
		noteDims[keyCount] = {}
		noteDims[keyCount][1], noteDims[keyCount][2] = GetImageWidthHeight(GetPathO(notePath, "png"))
		return noteDims[keyCount][1], noteDims[keyCount][2]
	end
end

function getOsuHitPosDownscroll(keyCount)
	-- 402 = osu default hitpos woooo
	return math.min(tonumber(getManiaBlock(keyCount)["HitPosition"]) or 402, 480)
end

function getHitPosDownscroll(keyCount)
	if hitPosDownscroll[keyCount] then 
		return hitPosDownscroll[keyCount]
	else
		-- offset the receptors by half the scaled height of a note 
		local noteWidth, noteHeight = getNoteWidthHeight(keyCount)
		local offset = noteHeight*getColumnWidth(keyCount)/(2*noteWidth)
		local osu_ret = getOsuHitPosDownscroll(keyCount) - offset
		-- change coordinates by subtracting 240
		hitPosDownscroll[keyCount] = osu_ret - 240
		return hitPosDownscroll[keyCount] 
	end
end

function getHitPosUpscroll(keyCount)
    return -getHitPosDownscroll(keyCount)
end

local function fallbackArrows(keyCount, nork)
	-- nork = "note" or "key"
	local a = {"mania-".. nork .. "1", "mania-".. nork .. "2", "mania-".. nork .. "S"}
	if keyCount == 4 then 
		return {a[1], a[2], a[2], a[1]}
	elseif keyCount == 6 then 
		return {a[1], a[2], a[1], a[1], a[2], a[1]}
	elseif keyCount == 7 then 
		return {a[1], a[2], a[1], a[3], a[1], a[2], a[1]}
	end
end

local function gat(keyCount, c, nork)
	-- nork = "Note" or "Key" (note the capitalization)
	local ret = {}
	local fallback = fallbackArrows(keyCount, nork:lower())
	for i = 1, keyCount, 1 do
		local p = getManiaBlock(keyCount)[nork .. "Image" .. i-1 .. c] or fallback[i] .. c
		ret[#ret+1] = p
	end
	return ret
end

function getHoldBodyPaths(keyCount)
	return gat(keyCount, "L", "Note")
end

function getHoldCapPaths(keyCount)
	return gat(keyCount, "T", "Note")
end

function getTapNotePaths(keyCount)
	return gat(keyCount, "", "Note")
end

function getHeldNotePaths(keyCount)
	return gat(keyCount, "H", "Note")
end

function getReceptors(keyCount)
	return gat(keyCount, "", "Key")
end

function getReceptorsPress(keyCount)
	return gat(keyCount, "D", "Key")
end

function getColumnWidth(keyCount)
	local widths = getManiaBlock(keyCount)["ColumnWidth"] or "30,"
	--it's the same in every useful instance just parse out the first one
	local i = widths:find(",")
	return tonumber(widths:sub(1,i-1))
end

function getColumnStart(keyCount)
	return tonumber(getManiaBlock(keyCount)["ColumnStart"]) or 136
end

function getColumnCenter(keyCount)
	return getColumnStart(keyCount) + getColumnWidth(keyCount)*keyCount/2
end

function getOsuScorePosition(keyCount)
	return tonumber(getManiaBlock(keyCount)["ScorePosition"]) or 325
end

function getOsuComboPosition(keyCount)
	return tonumber(getManiaBlock(keyCount)["ComboPosition"]) or 111
end

local function getComboNumbers()
	local ret = {}
	local pre = (data.Fonts or {})["ComboPrefix"] or "score"
	for i = 0, 9, 1 do 
		ret[#ret+1] = GetPathO(pre .. "-" .. i .. "@2x", "png") or GetPathO(pre .. "-" .. i, "png")
	end
	return ret
end


-- Let's make the osu combo numbers now!
local comboNumbers = getComboNumbers()
local _, comboH = GetImageWidthHeight(comboNumbers[1])
function getComboHeight()
	return comboH
end
local dsf = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
for i = 0, 9, 1 do 
	os.execute(string.format('copy "%s" "%s"', comboNumbers[i+1]:gsub("/", "\\"), "Themes\\osu_to_etterna\\Fonts\\_osucombo [" .. dsf[i+1] .. "] 1x1.png"))
end
