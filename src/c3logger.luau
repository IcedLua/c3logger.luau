--!strict
-- c3LOGGER (colon three logger) 1.0
-- By IcedLuau
-- https://github.com/IcedLua (Aka IcedLuau/Blueb-rry)
-- Licensed under MIT (bundled below) - Copyright (c) 2026 IcedLuau
--[[
    MIT License
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

-- // Cross // --
-- https://github.com/gaymeowing
-- Portions of the following section (from cross header, ending at code header) are derived from work by gaymeowing
-- Licensed under MIT (See header for full license text)
type Runtime = "Roblox" | "Lune" | "Unknown" | "Lute"

local RUNTIME: Runtime = if game and workspace then
		"Roblox"
	elseif string.find(_VERSION, "Lute") then
		"Lute"
	elseif string.find(_VERSION, "Lune") then
		"Lune"
	else
		"Unknown"

-- // Code // --
local c3l = {}
c3l.__index = c3l
export type c3lObject = {
    prefix: string?,
    level: styleLevel, -- Yes Luau, default is stylelevel. Do not unionize against my typing. ba-dum-tss!!!
    silent: boolean,
    priority: priorityLevel,
    formatting: {
        fusion: boolean,
        ansiColors: boolean, -- Very smart default.
        nextAnsi: {string},
		nextModifier: {modifier},
        table: {
            uwuify: boolean,
            allFormats: boolean,
        }
    }
} & typeof(setmetatable({}, c3l))
export type modifier = "noPrefix"
export type styleLevel = "none" | "default" | "always" | "hyper"
export type priorityLevel = "trace" | "debug" | "info" | "danger"
export type bothTables = {any} & {[any]: any}
export type ansiStyle = "black" | "red" | "green" | "yellow" | "blue" | "magenta" | "cyan" | "white" |
                        "brightBlack" | "brightRed" | "brightGreen" | "brightYellow" | "brightBlue" | 
                        "brightMagenta" | "brightCyan" | "brightWhite" | "bold" | "underline" | "inverse"
                        | "reset"

local byte: (string) -> number = (string.byte :: any)

local PRIORITY: {[priorityLevel]: number} = {
	trace = 0,
	debug = 1,
	info = 2,
	danger = 3, -- Anything other than a log
}

local esc = "\27["
local ANSI: {[ansiStyle]: string} = {
    black           = esc .. "30m",
    red             = esc .. "31m",
    green           = esc .. "32m",
    yellow          = esc .. "33m",
    blue            = esc .. "34m",
    magenta         = esc .. "35m",
    cyan            = esc .. "36m",
    white           = esc .. "37m",
    
    brightBlack     = esc .. "90m",
    brightRed       = esc .. "91m",
    brightGreen     = esc .. "92m",
    brightYellow    = esc .. "93m",
    brightBlue      = esc .. "94m",
    brightMagenta   = esc .. "95m",
    brightCyan      = esc .. "96m",
    brightWhite     = esc .. "97m",

    bold            = esc .. "1m",
    underline       = esc .. "4m",
    inverse         = esc .. "7m",
    
    reset           = esc .. "0m"
}

c3l.PRIORITY_ENUM = PRIORITY
c3l.ANSI = ANSI

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

Object Properties:
    - prefix: already mentioned
    - level: style level
    - silent: silences log types other than danger and print()
    - priority: trace, debug, info, danger
    - formatting:
        * fusion: enables fusion value unpacking
        * ansiColors: enables ansi color support. Side effect: Adds space at start
        * nextAnsi: used internally. change with :styleNext()
]]
function c3l.new(prefix: string?, level: styleLevel?): c3lObject
	return setmetatable({
		prefix = prefix,
		level = level or "default" :: styleLevel, -- Yes Luau, default is stylelevel. Do not unionize against my typing. ba-dum-tss!!!
		silent = false,
		priority = "trace":: priorityLevel,
		formatting = {
			fusion = true,
            ansiColors = if RUNTIME == "Roblox" then false else true, -- Very smart default.
            nextAnsi = {},
			nextModifier = {},
            table = {
                uwuify = false, -- For whatever reason AI just HATES it when I UwUify my keys, so, whenever I ask it "hey, is sending the right data" it goes "oh my gosh the keys they're DIFFERENT!!"
                allFormats = true,
            }
		}
	}, c3l)
end

--[=[
## :styleNext(ansiStyle) [METHOD]
Applies an ANSI style to the NEXT log.
Can be stacked.
Resets each time logged.
Returns self (chainable)
]=]
function c3l.styleNext(self: c3lObject, style: ansiStyle)
    table.insert(self.formatting.nextAnsi, ANSI[style])
	return self
end

--[=[
## :styleNext(ansiStyle) [METHOD]
Applies an ANSI style to the NEXT log.
Can be stacked.
Resets each time logged.
Returns self (chainable)
]=]
--[[function c3l.modifyNext(self: c3lObject, modifier: modifier)
    table.insert(self.formatting.nextModifier, ANSI[style])
	return self
end]]

--[=[
## :stylize(string, styleLevel?) [METHOD/FUNCTION]
UwUifies a string based on styleLevel. Defaults to self's style level.
Self is optional, but if ommited, must be nil and NOT void.
]=]
function c3l.stylize(self: c3lObject, text: string, level: styleLevel?): string
	-- short circuit here because string
	level = level or self.level or "default"
	if typeof(text) ~= "string" or level == "none" or #text == 0 then return text end

	local words = text:lower():split(" ")
	local processedWords = {}

	for _, word in words do
		if #word == 0 then continue end
        -- NE:NYE
		word = word:gsub("ne", "nye") -- Wow. AI is revolutionary, maybe it WILL take over the world!

		-- Use buffers here because:
		-- 1. 2763 strings is a LOT to garbage collect
		-- 2. gsub and gmatch isn't granular enough for lookaheads and stuff.
        -- UWU
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

        word = buffer.tostring(buf)

		if level == "hyper" or (level == "always" and #word > 2) or (level == "default" and #word > 7 and math.random() < 0.1) then
			-- If hyper... go nuts. Otherwise always maintains clarity and default is just default.
			local firstChar = word:sub(1, 1)
			if firstChar:match("%a") then
				word = firstChar .. "-" .. word
			end
		end

		table.insert(processedWords, word)
	end

	return table.concat(processedWords, " ")
end

function c3l.getLoggable(self: c3lObject, ...: any): ...any
	local packed = {...}
	local toPrint: {any} = {}
	for _, printable in packed do
		if typeof(printable) == "string" then
			local styled = self:stylize(printable)
			table.insert(toPrint, styled)
		elseif typeof(printable) == "table" then		
            if not self.formatting.table.allFormats then table.insert(toPrint, printable) continue end		
			local seen = {}
			local reconstruction: {any | string} | string = {} -- even though string is UNREACHABLE on first attempt, i wish to satiate luau's type solver in the fast way.

			local function applyToTable(tab: bothTables): {any} | string -- partially ai assisted
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
					local newKey = if typeof(i) == "table" then applyToTable(i) elseif self.formatting.table.uwuify then self:stylize(i) else i -- haha uwu keys
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

    local ansi: string? = nil
    if self.formatting.ansiColors then
        ansi = ""

        for _, style in self.formatting.nextAnsi do
            ansi ..= style
        end

        table.insert(toPrint, ANSI.reset)
        self.formatting.nextAnsi = {}
    end

	if self.prefix then
        if ansi then
            return ansi, self.prefix, table.unpack(toPrint)
        else
            return self.prefix, table.unpack(toPrint)
        end
	else
        if ansi then
            return ansi, table.unpack(toPrint)
        else
            return table.unpack(toPrint)
        end
	end
end

--[=[
## :print(...printable) - [METHOD]
Ignores priority, cannot be silenced.
Takes in a `"printable"`. (`Tuple` of printable types.)
]=]
function c3l.print(self: c3lObject, ...)
    print(self:getLoggable(...)) 
end

--[=[
## :log(...printable) - [METHOD]
Ignores priority, can be silenced.
Takes in a `"printable"`. (`Tuple` of printable types.)
]=]
function c3l.log(self: c3lObject, ...)
    if not self.silent then
        print(self:getLoggable(...)) 
    end
end

--[=[
## :logLevel(priorityLevel, ...printable) - [METHOD]
Runs :log() ONLY if the priority level is higher or equal to the currently set one.
Can be silenced.
]=]
function c3l.logLevel(self: c3lObject, level: priorityLevel, ...)
	if PRIORITY[self.priority :: priorityLevel] <= PRIORITY[level] then
		self:log(...)
	end
end

--[=[
## :trace(...printable) - [METHOD]
Priority 0. Logs only when set priority is less than or equal to this function's priority.
Can be silenced.
]=]
function c3l.trace(self: c3lObject, ...)
	self:logLevel("trace", ...)
end

--[=[
## :debug(...printable) - [METHOD]
Priority 1. Logs only when set priority is less than or equal to this function's priority.
Can be silenced.
]=]
function c3l.debug(self: c3lObject, ...)
	self:logLevel("debug", ...)
end

--[=[
## :info(...printable) - [METHOD]
Priority 2. Logs only when set priority is less than or equal to this function's priority.
Can be silenced.
]=]
function c3l.info(self: c3lObject, ...)
	self:logLevel("info", ...)
end

--[=[
## :warn(...printable) - [METHOD]
Priority 3. Logs only when set priority is less than or equal to this function's priority.
Cannot be silenced. Respects priority.
]=]
function c3l.warn(self: c3lObject, ...) -- Warnings NEVER sleep.
    if PRIORITY[self.priority :: priorityLevel] <= PRIORITY["danger"] then
	    warn(self:getLoggable(...))
    end
end

--[=[
## :logAssert(x, ...printable) - [METHOD]
Priority 3. Logs only when set priority is less than or equal to this function's priority AND IF x is falsy..
Cannot be silenced. Respects priority.
]=]
function c3l.logAssert(self: c3lObject, x: any, ...: any)
	if not x then
		self:logLevel("danger", ...)
	end
end

--[=[
## :warnAssert(x, ...printable) - [METHOD]
Priority 3. Warns only when set priority is less than or equal to this function's priority AND IF x is falsy..
Cannot be silenced. Respects priority.
]=]
function c3l.warnAssert(self: c3lObject, x: any, ...: any)
	if not x then
		self:warn(...)
	end
end

return c3l
