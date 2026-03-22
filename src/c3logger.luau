--!strict
-- c3LOGGER (colon three logger)

-- // CONFIGURATION // --
-- EDIT THIS!
--local cross = require("@self/cross") -- Luauberries Cross Module. (https://libs.luau.lol/) (https://github.com/gaymeowing/luauberries)
-- Cross is currently unused. But DO insert it under the script if you plan on updating.

















-- // Code // --
local any: any = nil

local c3l = {}
c3l.__index = c3l
type styleLevel = "none" | "default" | "always" | "hyper"
type priorityLevel = "trace" | "debug" | "info"

local byte: (string) -> number = (string.byte :: any)

local PRIORITY = {
	trace = 0,
	debug = 1,
	info = 2,
	danger = 3, -- Anything other than a log
}

local VOWELS = {
	[byte "a"] = true,
	[byte "e"] = true,
	[byte "i"] = true,
	[byte "o"] = true,
	[byte "u"] = true,
	[byte "y"] = true, -- Not REALLY a vowel but for these purposes it's fine.
}
local ENDINGS = { 
	[byte " "] = true,
	[byte "."] = true,
	[byte "!"] = true,
	[byte "?"] = true,
	[byte ")"] = true,
	[byte "]"] = true,
	[byte "}"] = true,
	[byte "-"] = true,
}

--[[
!!CONSTRUCTOR!!

Prefix: It's a prefix. Automatically appends a space on the end.

Level: Style level.
	- none: Sensible, exactly what you pass in
	- default: most of the time, sometimes refuses
	- always: still cares that it sounds right, but, no gambling
	- hyper: you don't need to read these logs, right?
]]
function c3l.new(prefix: string?, level: styleLevel?)
	return setmetatable({
		prefix = prefix or "",
		level = level or "default" :: styleLevel, -- Yes Luau, default is stylelevel. Do not unionize against my typing. ba-dum-tss!!!
		silent = false,
		priority = "trace":: priorityLevel,
		formatting = {
			fusion = true
		}
	}, c3l)
end

function c3l:stylize(text: string, level: styleLevel?): string
	-- short circuit here because string
	level = level or self.level or "default"
	if typeof(text) ~= "string" or level == "none" or #text == 0 then return text end

	local words = text:lower():split(" ")
	local processedWords = {}

	for _, word in words do
		if #word == 0 then continue end

		if level == "hyper" or (level == "always" and #word > 2) or (level == "default" and #word > 7 and math.random() < 0.1) then
			-- If hyper... go nuts. Otherwise always maintains clarity and default is just default.
			local firstChar = word:sub(1, 1)
			if firstChar:match("%a") then
				word = firstChar .. "-" .. word
			end
		end

		word = word:gsub("ne", "nye") -- Wow. AI is revolutionary, maybe it WILL take over the world!

		-- Use buffers here because:
		-- 1. 2763 strings is a LOT to garbage collect
		-- 2. gsub and gmatch isn't granular enough for lookaheads and stuff.
		local buf = buffer.fromstring(word)
		for i = 0, buffer.len(buf) - 1 do
			local char = buffer.readu8(buf, i)
			if char == byte "l" or char == byte "r" then
				local shouldTransform = (level == "hyper") -- Hyper does not care for the readability

				if (level == "default" and math.random() <= 0.8) or level == "always" then -- Always is STILL readable.
					local prev = if i > 0 then buffer.readu8(buf, i - 1) else nil
					local next = if i < buffer.len(buf) - 1 then buffer.readu8(buf, i + 1) else nil
					if next and not ENDINGS[next] then
						if (prev and VOWELS[prev]) or (next and VOWELS[next]) then
							shouldTransform = true
						end
					end
				end

				if shouldTransform then
					buffer.writeu8(buf, i, byte "w")
				end
			end
		end

		table.insert(processedWords, buffer.tostring(buf))
	end

	return table.concat(processedWords, " ")
end

function c3l:getLoggable(...: any): (string, ...any)
	local self: typeof(c3l.new(any)) = (self :: any)
	
	local packed = {...}
	local toPrint: {any} = {}
	for _, printable in packed do
		if typeof(printable) == "string" then
			local styled = self:stylize(printable)
			table.insert(toPrint, styled)
		elseif typeof(printable) == "table" then				
			local seen = {}
			local reconstruction: {any | string} | string = {} -- even though string is UNREACHABLE on first attempt, i wish to satiate luau's type solver in the fast way.

			local function applyToTable(tab): {any} | string -- partially ai assisted
				if seen[tab] then
					return self:stylize("** cyclic reference detected **")
				end

				if self.formatting.fusion and tab["type"] == "State" then
					local val = tab["_EXTREMELY_DANGEROUS_usedAsValue"]

					return {
						_special = self:stylize(`Fusion state object of kind: {tab["kind"]} ({tab["validity"]})`),
						value = if typeof(val) == "table" then applyToTable(val) else val
					}
				end

				local myNew: any = {} -- luau views this as never, "infecting" the other types.
				seen[tab] = myNew

				for i, v in pairs(tab) do
					local newKey = if typeof(i) == "table" then applyToTable(i) else self:stylize(i) -- haha uwu keys
					local newValue = if typeof(v) == "table" then applyToTable(v) else v

					myNew[newKey] = newValue
				end

				return myNew
			end

			reconstruction = applyToTable(printable)
			table.insert(toPrint, reconstruction) -- Leverage Default Tostring with uwuified keys.
		else
			table.insert(toPrint, printable) -- screw it, output tostring is good enough for other cases.
		end
	end

	return self.prefix, table.unpack(toPrint)
end

--[[
Does not have any leveling, perhaps use the other ones?
]]
function c3l:log(...)
	local self: typeof(c3l.new(any)) = (self :: any)


	if not self.silent then
		print(self:getLoggable())
	end
end

function c3l:trace(...)
	local self: typeof(c3l.new(any)) = (self :: any)
	
	if PRIORITY[self.priority] <= PRIORITY.trace then
		c3l:log(...)
	end
end

function c3l:debug(...)
	local self: typeof(c3l.new(any)) = (self :: any)

	if PRIORITY[self.priority] <= PRIORITY.trace then
		c3l:log(...)
	end
end

function c3l:info(...)
	local self: typeof(c3l.new(any)) = (self :: any)

	if PRIORITY[self.priority] <= PRIORITY.trace then
		c3l:log(...)
	end
end

function c3l:warn(...) -- Warnings NEVER sleep.
	warn(c3l:getLoggable(...))
end

function c3l:error(...) -- Oh and errors ig
	error(c3l:getLoggable(...))
end

function c3l:logAssert(x:any, ...: any)
	if not x then
		self:log(...)
	end
end

function c3l:warnAssert(x:any, ...: any)
	if not x then
		self:warn(...)
	end
end

function c3l:errorAssert(x:any, ...:any)
	if not x then
		self:error(...)
	end
end

--if cross.runtime == "NONE" then
	local logger = c3l.new("[C3L]", "hyper")
	-- logger:warn("C3L is most optimized for Lune or Roblox!")
	logger:warnAssert(buffer, "this enviornment doesn't support buffers. Please do NOT use UwUifier as it WILL crash your code.")
--end

return c3l