--=============================================================================
--selectplus.lua  -  Copyright (c) 2026 scristopher
--=============================================================================
--Drop this file in  external/mods/
--=============================================================================
--TERMS OF USE
--Free to use as-is in any FREE build, roster, or collection. No credit is
--required for normal use, and you may redistribute the UNMODIFIED file freely.
--
--This mod must remain free. You may NOT sell it, charge money for it, place it
--behind a paywall, or include it in any paid or commercial product.
--
--If you MODIFY this file, or reuse any part of its code in another work, you
--must give clear, visible credit to the original author
--(scristopher, https://github.com/scristopher/Ikemen-selectplus) and must not
--present the work as your own.
--
--This notice must remain intact in the source file.
--=============================================================================

local selectplus = {}
selectplus.version = '0.12-rc6'

--=============================================================================
-- CONFIGURATION  edit this section to customise
-- Style (fonts, colors, backdrop art) is provided by your motif automatically.
--=============================================================================

-- FEATURE: PAGE SCROLLING
-- Multi-page browsing for rosters larger than one screen of cells
selectplus.PageScrolling = {
    enabled    = true,
    controller = { prev = 'd',      next = 'w'        },  -- controller L1 / L2
    keyboard   = { prev = 'PAGEUP', next = 'PAGEDOWN' },  -- keyboard PGUP/PGDN
    edgePaging = true,  -- push RIGHT off the last cell -> next page; LEFT off the
                        -- first cell -> previous page. Corners are read from the motif (columns/rows)
}

--SEARCH
--name filter typed on keyboard or on screen keyboard
selectplus.Search = {
    enabled = true,
    openKey = 'F3',   -- keyboard key to open / close search
}

--TAG / CATEGORY SEARCH
--A leading '#' in the search filters by character tag (e.g. '#sf' shows chars
--tagged sf). Tags come from two sources, merged: a namespaced select.def param
--(default 'sptag', e.g. 'Ryu, stages/sf.def, sptag = sf|capcom') and an OPTIONAL
--tag file (see 'file' below). Multiple tags in one value are separated by '|'.
selectplus.Tags = {
    enabled     = true,
    inlineParam = 'sptag',   -- select.def param, read in Lua as cd.<inlineParam>
    multiSep    = '|',       -- separator for multiple tags in one value
    --OPTIONAL tag file (folder-keyed), merged with inline tags. Leave the file
    --absent to ignore it entirely; only inline sptag= is used then. Formats:
    --  [sf]              <- section header sets the tag
    --  ryu               <- folder 'ryu' gets tag 'sf'
    --  morrigan = ds|cap <- explicit 'folder = tag|tag' (works in or out of a section)
    file        = 'selectplus_tags.txt',
}

--ON-SCREEN KEYBOARD
selectplus.OnScreenKeyboard = {
    enabled    = true,
    openButton = 's',                          -- controller button (START)
    cols       = 6,
    x0         = 500,  y0    = 276,            -- top-left of the key grid (localcoord)
    cellW      = 100,  cellH = 52,             -- per-key spacing
    bgWindow   = {448, 250, 1052, 616},        -- dim panel  x1, y1, x2, y2
    bgPasses   = 2,                            -- redraws to deepen the dim alpha
}

--ICON RESIZE
-- Keyboard   : F5 = shrink, F6 = grow (fine, scaleStep at a time)
-- Controller : press BOTH shoulders (L1+L2) to cycle to the next preset size
selectplus.IconResize = {
    enabled    = true,
    scale      = 1.0,           -- current (1.0 = native)
    scaleMin   = 0.5,           -- lower (F5/F6)
    scaleMax   = 2.0,           -- upper (F5/F6)
    scaleStep  = 0.1,           -- F5/F6 change per press
    presets    = {0.7, 1.0, 1.3, 1.6, 2.0},  --  sizes the L1+L2 combo cycles through
    keyboard   = { down = 'F5', up = 'F6' },   -- keyboard
    controllerCombo = true,     -- L1+L2 cycles size set false to disable
}

--STYLE / THEMING
--Per-element control of the on-screen text: show/hide, position, font, bank,
--alignment, scale, and color.
--  show  : draw this element or not
--  x/y   : localcoord position (x = nil keeps the motif's text base x)
--  font  : '' = the motif's stage font; or a font file
--          (e.g. 'font/mine.def') loaded just for this element
--  bank  : palette bank for bitmap/SFF fonts
--  align : -1 left, 0 center, 1 right
--  scale : {x,y} text scale for custom fonts
--  color : {r,g,b} 0-255, applied ONLY to a custom font. Leave it out for bitmap/SFF
--          fonts (they keep their built-in colors). TrueType fonts have no color of
--          their own and render INVISIBLE without one, so give TTF elements a color.
--The keyboard element additionally supports a 'keys' table (per-letter overrides,
--keyed by label) and 'evenKeyStyle' (a fallback for keys at an even grid position);
--see the commented example below.
selectplus.Style = {
    --Defaults to the motif's own stage font (font = '') so this stays a single-file
    --drop-in with no bundled font assets. Point font at a screenpack-provided .def
    --(e.g. 'font/mine.def') to borrow a different look for one element.
    pageReadout  = { show = true, x = nil, y = 110, font = '' }, -- "PAGE 1/1  N CHARS  F3=SEARCH"
    sizeReadout  = { show = true, x = nil, y = 146, font = '' }, -- "SIZE 100%  F5/F6 / L1+L2"
    searchPrompt = { show = true, x = 610, y = 632, font = '' }, -- "SEARCH: query_"
    foundCount   = { show = true, x = 610, y = 662, font = '' }, -- "N FOUND"
    --EXAMPLE (whole keyboard): font = 'font/mine.def', selFont = 'font/mine.def', bank = 1,
    --selBank = 2, color = {255,255,255}, selColor = {192,255,192} would give every key a
    --shared custom font, with the selected key in a different color so it stands out.
    keyboard     = { font = '', selFont = '', bank = nil, selBank = nil, align = 0, scale = nil, color = nil, selColor = nil,
        --EXAMPLE (individual letters): a key's own entry in 'keys' always wins; 'evenKeyStyle'
        --is a fallback for keys at an even grid position (2nd, 4th, ...) with no entry of
        --their own; anything left over falls back to the shared font/color/bank above.
        --keys = {
        --    A = { font = 'font/mine.def', bank = 1, color = {255,255,255} },
        --    B = { font = 'font/mine.def', bank = 2, color = {255,120,120} },
        --},
        --evenKeyStyle = { font = 'font/mine.def', bank = 1, scale = {0.9, 0.9} },
    }, -- on-screen keyboard labels
}

--EXAMPLE: borrow a bitmap/SFF font from your screenpack for the page readout only,
--leaving every other element on the motif's own stage font. Bitmap fonts need 'bank'
--(their palette bank), not 'color' (they already have baked-in colors).
--selectplus.Style.pageReadout = { show = true, x = nil, y = 110, font = 'font/mine.def', bank = 1, scale = {0.7, 0.7} }

--EXAMPLE: use a TrueType font for the search prompt. TrueType fonts have no built-in
--color, so give them one explicitly or they render invisible.
--selectplus.Style.searchPrompt = { show = true, x = 610, y = 632, font = 'font/mine-tt.def', color = {255,255,255}, scale = {0.85, 0.85} }

--=============================================================================
--END OF CONFIGURATION
--=============================================================================

--------------------------------------------------------------------------------
--Fallback cmd read by keyboard-only paths and used before any player-specific cmd is known.
--Search itself prefers whichever player's cmd is still browsing (see f_updateSearch), so a
--second player isn't stuck reading player 1's controller after player 1 locks in.
local function p1cmd()
	return -1
end

--Draw a string with the motif's stage font at an absolute localcoord. Uses textImgAddPos
--(relative), never textImgSetPos, on this shared engine sprite: SetPos permanently
--overwrites the sprite's own offsetInit as a side effect (confirmed in the engine source),
--which would corrupt it for the engine's own later reuse of this same sprite -- the
--stage-select screen's stage name reuses this exact object once character select ends, so
--corrupting its baked position here made the stage name render in the wrong place there.
--The relative delta is computed from the sprite's true resting position (its own configured
--offset plus stage.pos) so this lands at the right spot regardless of what that offset is,
--without ever touching offsetInit. 'el' is the motif element table (e.g. si.stage.active),
--not a raw TextSprite -- it needs both .TextSpriteData and .offset.
local function drawText(text, x, y, el)
	local si = motif and motif.select_info
	if si == nil or si.stage == nil or si.stage.active == nil then return end
	el = el or si.stage.active
	local td = el.TextSpriteData
	if td == nil then return end
	local restX, restY = 0, 0
	if el.offset ~= nil then restX, restY = el.offset[1], el.offset[2] end
	if si.stage.pos ~= nil then restX, restY = restX + si.stage.pos[1], restY + si.stage.pos[2] end
	local targetX = x or restX
	textImgReset(td)
	if textImgSetAlign ~= nil then textImgSetAlign(td, 0) end
	if textImgAddPos ~= nil then textImgAddPos(td, targetX - restX, y - restY) end
	textImgSetText(td, text)
	textImgDraw(td)
end

--Load a custom font file once (via fontNew) into a reusable text sprite. Result is
--cached per path; a failed load is cached as false so we don't retry every frame.
local _customFontCache = {}
local function f_customFont(spec)
	if spec == nil or spec == '' then return nil end
	if _customFontCache[spec] ~= nil then return _customFontCache[spec] or nil end
	local ts = false
	if fontNew ~= nil and textImgNew ~= nil and textImgSetFont ~= nil then
		local fnt = fontNew(spec)
		if fnt ~= nil then
			ts = textImgNew()
			textImgSetFont(ts, fnt)
		end
	end
	_customFontCache[spec] = ts
	return ts or nil
end

--Draw a string honouring a per-element font. '' uses the motif's stage font (drawText);
--a font file is loaded once and drawn at the absolute position (textImgSetPos). color is
--a {r,g,b[,a]} table applied only when set: bitmap/SFF fonts keep their baked colors when
--color is nil, but TrueType fonts have NO color of their own and render invisibly without one.
local function drawStyledText(text, x, y, fontSpec, color, bank, align, scale)
	if fontSpec == nil or fontSpec == '' then
		drawText(text, x, y)
		return
	end
	local ts = f_customFont(fontSpec)
	if ts == nil then drawText(text, x, y); return end   --load failed -> fall back to motif font
	local si = motif and motif.select_info
	local px = x
	if px == nil then px = (si and si.stage and si.stage.pos and si.stage.pos[1]) or 160 end
	textImgReset(ts)
	if textImgSetLocalcoord ~= nil and motif ~= nil and motif.info ~= nil and motif.info.localcoord ~= nil then
		textImgSetLocalcoord(ts, motif.info.localcoord[1], motif.info.localcoord[2])
	end
	if textImgSetAlign ~= nil then textImgSetAlign(ts, align or 0) end
	if bank ~= nil and textImgSetBank ~= nil then textImgSetBank(ts, bank) end
	if type(scale) == 'table' and textImgSetScale ~= nil then
		textImgSetScale(ts, scale[1] or 1, scale[2] or scale[1] or 1)
	end
	if type(color) == 'table' and textImgSetColor ~= nil then
		textImgSetColor(ts, color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 255)
	end
	textImgSetText(ts, text)
	if textImgSetPos ~= nil then textImgSetPos(ts, px, y) end
	textImgDraw(ts)
end

local spHeld = {}
local function rising(cmd, key)       
	local now = getInput(cmd, key) and true or false
	local was = spHeld[key] or false
	spHeld[key] = now
	return now and not was
end

local keyHeld = {}
local function keyRising(kc)           
	if getKey == nil then return false end
	local now = getKey(kc) and true or false
	local was = keyHeld[kc] or false
	keyHeld[kc] = now
	return now and not was
end

--------------------------------------------------------------------------------
--PAGING + SEARCH 
--------------------------------------------------------------------------------
start.rosterPage = start.rosterPage or {current = 1, pageSize = 0, total = 1}
start.rosterFilter    = nil
start.rosterNameCache = nil
start.rosterAuthorCache = nil
start.rosterTagCache  = nil
start.searchMode      = false
start.searchQuery     = ''
start.searchCloseGuard = 0
start.kbIndex         = 1
start.kbTypeGuard     = 0
start.ROSTER_CELL_EMPTY = -1

function start.f_rosterCount()
	if start.rosterFilter ~= nil then return #start.rosterFilter end
	if main and main.t_selGrid then return #main.t_selGrid end
	return 0
end

function start.f_updateRosterPageTotals()
	local rp = start.rosterPage
	rp.pageSize = motif.select_info.rows * motif.select_info.columns
	rp.total    = math.max(1, math.ceil(start.f_rosterCount() / math.max(1, rp.pageSize)))
	if rp.current < 1 then rp.current = 1
	elseif rp.current > rp.total then rp.current = rp.total end
end

--Map a visible cell to its roster index 
function start.f_pageCell(cell)
	local rp = start.rosterPage
	--pageSize is constant for this session, map it once instead of every call
	if rp.pageSize == 0 then rp.pageSize = motif.select_info.rows * motif.select_info.columns end
	local pos = (rp.current - 1) * rp.pageSize + cell
	if start.rosterFilter ~= nil then
		return start.rosterFilter[pos] or start.ROSTER_CELL_EMPTY
	end
	return pos
end

local _origSelGrid = start.f_selGrid
start.f_selGrid = function(cell, slot)
	return _origSelGrid(start.f_pageCell(cell), slot)
end

--Wrap the engine's per-player select handler so controller input can be read
local _origSelectMenu = start.f_selectMenu
start.f_selectMenu = function(side, cmd, player, member, selectState)
	if start.searchMode or start.searchCloseGuard > 0 then
		return selectState, false
	end
	if start.f_controllerSelectInput ~= nil and start.f_controllerSelectInput(side, cmd, player) then
		return selectState, false  
	end
	return _origSelectMenu(side, cmd, player, member, selectState)
end

local function snapCursorTopLeft()
	if start.c == nil then return end
	for i = 1, #start.c do
		if start.c[i] ~= nil then
			start.c[i].selX, start.c[i].selY, start.c[i].cell = 0, 0, 0
		end
	end
end

--Refresh per-cell character data and invalidate the draw list so the current page shows right away
function start.f_refreshRosterPageGrid()
	if start.t_grid == nil then return end
	local cols = motif.select_info.columns
	for row = 1, motif.select_info.rows do
		local grow = start.t_grid[row]
		if grow ~= nil then
			for col = 1, cols do
				local g = grow[col]
				if g ~= nil then
					local cd = start.f_selGrid((row - 1) * cols + col)
					g.char     = cd.char
					g.char_ref = cd.char_ref
					g.hidden   = cd.hidden
				end
			end
		end
	end
	start.needUpdateDrawList = true
end

local function changePage(delta)
	if not selectplus.PageScrolling.enabled then return false end
	local rp = start.rosterPage
	start.f_updateRosterPageTotals()
	if rp.total <= 1 then return false end
	local n = rp.current + delta
	if n < 1 then n = rp.total elseif n > rp.total then n = 1 end
	if n == rp.current then return false end
	rp.current = n
	start.f_refreshRosterPageGrid()
	--Leave the cursor in place so the roster scrolls underneath it instead of jumping to the first tile
	return true
end

--------------------------------------------------------------------------------
--SEARCH
--------------------------------------------------------------------------------
--Load the OPTIONAL tag file into a folder->tags map. Missing/disabled file returns
--an empty map (inline tags only). Supports [tag] sections + 'folder = tag|tag' lines.
function start.f_loadTagFile()
	local cfg = selectplus.Tags
	local map = {}
	if cfg == nil or not cfg.enabled or cfg.file == nil or cfg.file == '' or io == nil then
		return map
	end
	local f = io.open(cfg.file, 'r')
	if f == nil then return map end   --file absent = optional, just skip
	local sep = cfg.multiSep or '|'
	local section = nil
	local function addTag(folder, tag)
		folder = folder:lower()
		map[folder] = (map[folder] ~= nil and (map[folder] .. sep) or '') .. tag:lower()
	end
	for line in f:lines() do
		line = line:gsub('^%s+', ''):gsub('%s+$', '')
		if line ~= '' and line:sub(1, 1) ~= ';' then
			local sec = line:match('^%[%s*(.-)%s*%]$')
			local folder, tags = line:match('^(.-)%s*=%s*(.+)$')
			if sec ~= nil then
				section = sec
			elseif folder ~= nil and folder ~= '' then
				addTag(folder, tags)                  --explicit 'folder = tags'
			elseif section ~= nil then
				addTag(line, section)                 --bare folder under a [section]
			end
		end
	end
	f:close()
	return map
end

--Build lowercase name/author/tag indexes keyed to roster position (author comes free from getCharInfo)
function start.f_buildNameCache()
	local nameCache, authorCache, tagCache = {}, {}, {}
	local tagParam = (selectplus.Tags and selectplus.Tags.inlineParam) or 'sptag'
	local sep      = (selectplus.Tags and selectplus.Tags.multiSep) or '|'
	local fileMap  = start.f_loadTagFile()
	for i = 1, #main.t_selGrid do
		local nm, au, tg = '', '', ''
		local gc = main.t_selGrid[i]
		if gc ~= nil and gc.chars ~= nil and #gc.chars > 0 then
			local cd = main.t_selChars[gc.chars[gc.slot or 1]]
			--Skip characters a user has hidden from the grid so they don't appear in search results.
			--boss is not a real select.def param (engine never sets it, so this check is a harmless no-op)
			--but is kept here since some users expect it to exist.
			if cd ~= nil and cd.name ~= nil and cd.hidden ~= 2 and cd.exclude ~= 1 and cd.bonus ~= 1 and cd.boss ~= 1 then
				nm = cd.name:lower()
				au = (cd.author or ''):lower()
				--Tags = the inline select.def param (cd.<sptag>) UNION the optional tag file,
				--matched by folder name. Kept raw with the separator so a substring match
				--can't bleed across two tags.
				local inlineTags = tostring(cd[tagParam] or ''):lower()
				local folder     = ((cd.def or ''):match('([^/\\]+)[/\\][^/\\]+%.[Dd][Ee][Ff]$') or ''):lower()
				local fileTags   = fileMap[folder] or ''
				if fileTags ~= '' and inlineTags ~= '' then tg = fileTags .. sep .. inlineTags
				elseif fileTags ~= '' then tg = fileTags
				else tg = inlineTags end
			end
		end
		nameCache[i]   = nm
		authorCache[i] = au
		tagCache[i]    = tg
	end
	start.rosterNameCache   = nameCache
	start.rosterAuthorCache = authorCache
	start.rosterTagCache    = tagCache
end

--Apply a search filter, where nil clears it and an empty query matches nothing.
--A leading '@' searches the author field instead of the name (e.g. '@pots').
function start.f_applyFilter(query)
	if query == nil then
		start.rosterFilter = nil
		start.f_finishFilter()
		return
	end
	if start.rosterNameCache == nil then start.f_buildNameCache() end
	--'@' searches author, '#' searches tags, anything else searches the name.
	local prefix = query:sub(1, 1)
	local cache, q
	if prefix == '@' then
		cache, q = start.rosterAuthorCache, query:sub(2):lower()
	elseif prefix == '#' then
		cache, q = start.rosterTagCache, query:sub(2):lower()
	else
		cache, q = start.rosterNameCache, query:lower()
	end
	if q == '' then
		start.rosterFilter = {}
		start.f_finishFilter()
		return
	end
	--Score matches (exact beats prefix beats contains, shorter value wins ties) so the closest lands first.
	local matches = {}
	for i = 1, #main.t_selGrid do
		local s = cache[i]
		if s ~= nil and s ~= '' then
			local at = s:find(q, 1, true)
			if at ~= nil then
				local score = 2
				if s == q then score = 0 elseif at == 1 then score = 1 end
				matches[#matches + 1] = {idx = i, score = score, len = #s}
			end
		end
	end
	table.sort(matches, function(a, b)
		if a.score ~= b.score then return a.score < b.score end
		if a.len   ~= b.len   then return a.len   < b.len   end
		return a.idx < b.idx
	end)
	local filt = {}
	for k = 1, #matches do filt[k] = matches[k].idx end
	start.rosterFilter = filt
	start.f_finishFilter()
end

--Reset to the first page, recompute totals, redraw the grid and snap the cursor to the top-left.
function start.f_finishFilter()
	start.rosterPage.current = 1
	start.f_updateRosterPageTotals()
	start.f_refreshRosterPageGrid()
	snapCursorTopLeft()
end

--Point the preview portrait at the first search result while the cursor is stopped
function start.f_updateSearchPortrait()
	if start.p == nil or start.c == nil then return end
	for side = 1, 2 do
		local ps = start.p[side]
		if ps ~= nil and ps.t_selCmd ~= nil then
			for k, v in ipairs(ps.t_selCmd) do
				local member = main.f_tableLength(ps.t_selected) + k
				if main.coop and (side == 1 or gameMode('versuscoop')) then
					member = k
				end
				local player = v.player
				local cd     = start.f_selGrid(1)
				local newRef = (cd ~= nil) and cd.char_ref or nil
				if newRef ~= nil and start.c[player] ~= nil then
					start.c[player].selRef = newRef
					if main.f_preloadSetCharHighlight ~= nil then
						main.f_preloadSetCharHighlight(player, newRef)
					end
					local st = ps.t_selTemp[member]
					if st ~= nil and st.ref ~= newRef then
						st.ref       = newRef
						st.cell      = start.c[player].cell
						st.face_data = nil
						st.face2_data = nil
						start.needUpdateDrawList = true
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
--ICON RESIZE
--------------------------------------------------------------------------------
--Capture the motif's original sizes once so every resize is computed from them without drift.
local _irInit             = false
local _ctrlHeld           = {}    --per-side latch for shoulder-button rising edges
local _lastCmd            = {}    --per-side cmd, captured each frame so search can read whichever player is still browsing, not just p1
local _irOrigGrid         = {}    --[row][col] = {x, y}
local _irOrigPortraitSc   = nil   --portrait.scale  {x, y}  (default {1,1} if nil)
local _irOrigPortraitOff  = nil   --portrait.offset {x, y}
local _irOrigBgSc         = nil   --cell.bg.scale   {x, y}
local _irOrigRandomSc     = nil   --cell.random.scale {x, y}
local _irOrigCellSize     = nil   --cell.size  {w, h}  (used by cursor wrap check)

local function initIconResize()
	if _irInit then return end
	local rows = motif.select_info.rows
	local cols = motif.select_info.columns
	for row = 1, rows do
		_irOrigGrid[row] = {}
		for col = 1, cols do
			local g = start.t_grid[row] and start.t_grid[row][col]
			if g then _irOrigGrid[row][col] = {x = g.x, y = g.y} end
		end
	end
	--Guard every optional motif field so a screenpack that omits portrait/cell can't crash us.
	local p  = motif.select_info.portrait or {}
	local cs = motif.select_info.cell or {}
	local cb = cs.bg or {}
	local cr = cs.random or {}
	_irOrigPortraitSc  = p.scale  and {p.scale[1],  p.scale[2]}  or {1, 1}
	_irOrigPortraitOff = p.offset and {p.offset[1], p.offset[2]} or {0, 0}
	_irOrigBgSc        = cb.scale and {cb.scale[1], cb.scale[2]} or {1, 1}
	_irOrigRandomSc    = cr.scale and {cr.scale[1], cr.scale[2]} or {1, 1}
	_irOrigCellSize    = cs.size  and {cs.size[1],  cs.size[2]}  or {24, 24}
	_irInit = true
end

local function applyIconResize(s)
	initIconResize()
	local ir = selectplus.IconResize
	s = math.max(ir.scaleMin, math.min(ir.scaleMax, s))
	s = math.floor(s * 100 + 0.5) / 100
	ir.scale = s

	--Scale the cell positions that the cursor and draw list both read
	local rows = motif.select_info.rows
	local cols = motif.select_info.columns
	for row = 1, rows do
		for col = 1, cols do
			local orig = _irOrigGrid[row] and _irOrigGrid[row][col]
			local g    = start.t_grid[row] and start.t_grid[row][col]
			if orig and g then
				g.x = orig.x * s
				g.y = orig.y * s
			end
		end
	end

	--Scale the portrait sprite (guarded: some motifs omit portrait)
	local p = motif.select_info.portrait
	if p then
		p.scale  = {_irOrigPortraitSc[1]  * s, _irOrigPortraitSc[2]  * s}
		p.offset = {_irOrigPortraitOff[1] * s, _irOrigPortraitOff[2] * s}
	end

	--Scale the cell background / size (guarded: some motifs omit cell.*)
	local cs = motif.select_info.cell or {}
	local cb = cs.bg
	if cb then cb.scale = {_irOrigBgSc[1] * s, _irOrigBgSc[2] * s} end
	local cr = cs.random
	if cr then cr.scale = {_irOrigRandomSc[1] * s, _irOrigRandomSc[2] * s} end
	if cs.size then cs.size = {_irOrigCellSize[1] * s, _irOrigCellSize[2] * s} end

	start.needUpdateDrawList = true
end

--Cycle to the next preset size
local function cycleIconSizePreset()
	local ir = selectplus.IconResize
	local p  = ir.presets
	if p == nil or #p == 0 then            --Fall back
		applyIconResize(ir.scale + ir.scaleStep)
		return
	end
	local nextVal = nil
	for i = 1, #p do
		if p[i] > ir.scale + 0.001 then nextVal = p[i]; break end
	end
	applyIconResize(nextVal or p[1])      
end

--Find first filled cell when paging forward, or the last when paging back.
local function findPageLandingCell(reverse)
	local cols     = motif.select_info.columns
	local pageSize = start.rosterPage.pageSize
	local first, last, step = 1, pageSize, 1
	if reverse then first, last, step = pageSize, 1, -1 end
	for cell = first, last, step do
		local x = (cell - 1) % cols
		local y = math.floor((cell - 1) / cols)
		local g = start.t_grid[y + 1] and start.t_grid[y + 1][x + 1]
		if g ~= nil and g.char ~= nil and g.skip ~= 1 and g.hidden ~= 2 then
			return x, y
		end
	end
	return 0, 0
end

--Handle controller paging and icon resize
function start.f_controllerSelectInput(side, cmd, player)
	_lastCmd[side] = cmd  --the engine only calls this for players still picking, with their own real cmd
	local ps = selectplus.PageScrolling
	local ir = selectplus.IconResize
	local prevHeld = ps.enabled and getInput(cmd, ps.controller.prev) and true or false  --L1 = 'd'
	local nextHeld = ps.enabled and getInput(cmd, ps.controller.next) and true or false  --L2 = 'w'
	local h = _ctrlHeld[side]
	if h == nil then h = {} _ctrlHeld[side] = h end

	--Pressing both shoulders cycles the size once
	if ir.enabled and ir.controllerCombo and prevHeld and nextHeld then
		if not h.combo then cycleIconSizePreset() end
		h.prev, h.next, h.combo = true, true, true
		return true 
	end

	--Page on a single shoulder's release
	local paged = false
	if h.prev and not prevHeld and not h.combo then paged = changePage(-1) or paged end
	if h.next and not nextHeld and not h.combo then paged = changePage(1)  or paged end
	if not prevHeld and not nextHeld then h.combo = false end  --Reset once both are released.
	h.prev, h.next = prevHeld, nextHeld
	if paged then return true end

	--Page by pushing past the corner tiles
	if ps.enabled and ps.edgePaging and player ~= nil and start.c ~= nil and start.c[player] ~= nil then
		local cols  = motif.select_info.columns
		local lastX = cols - 1
		local lastY = motif.select_info.rows - 1
		local selX, selY = start.c[player].selX, start.c[player].selY
		if selX == lastX and selY == lastY and getInput(cmd, motif.select_info.cell.right.key) then
			if changePage(1) then
				local x, y = findPageLandingCell(false)
				start.c[player].selX, start.c[player].selY, start.c[player].cell = x, y, x + cols * y
				return true
			end
		elseif selX == 0 and selY == 0 and getInput(cmd, motif.select_info.cell.left.key) then
			if changePage(-1) then
				local x, y = findPageLandingCell(true)
				start.c[player].selX, start.c[player].selY, start.c[player].cell = x, y, x + cols * y
				return true
			end
		end
	end

	return false
end

--------------------------------------------------------------------------------
--ON-SCREEN KEYBOARD
--------------------------------------------------------------------------------
do
	local keys = {}
	for c in ('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'):gmatch('.') do
		keys[#keys + 1] = {label = c, type = 'char', ch = c:lower()}
	end
	keys[#keys + 1] = {label = '@', type = 'char', ch = '@'}   --leading '@' switches to author search
	keys[#keys + 1] = {label = '#', type = 'char', ch = '#'}   --leading '#' switches to tag search
	keys[#keys + 1] = {label = 'SPC', type = 'space'}
	keys[#keys + 1] = {label = 'DEL', type = 'del'}
	keys[#keys + 1] = {label = 'CLR', type = 'clear'}
	keys[#keys + 1] = {label = 'OK',  type = 'ok'}
	selectplus.OnScreenKeyboard.keys = keys
end

function start.f_searchClose(clearFilter)
	start.searchMode       = false
	start.searchCloseGuard = 8   --short pause so the closing button cant select a char
	if clearFilter or start.searchQuery == '' then
		start.searchQuery = ''
		start.f_applyFilter(nil)
	end
end

--Apply one on-screen key action and return false if search closed
function start.f_doKbKey(k)
	if k == nil then return true end
	if     k.type == 'char'  then start.searchQuery = start.searchQuery .. k.ch
	elseif k.type == 'space' then start.searchQuery = start.searchQuery .. ' '
	elseif k.type == 'del'   then
		if #start.searchQuery > 0 then start.searchQuery = start.searchQuery:sub(1, -2) end
	elseif k.type == 'clear' then start.searchQuery = ''
	elseif k.type == 'ok'    then start.f_searchClose(false); return false
	end
	start.f_applyFilter(start.searchQuery)
	start.f_updateSearchPortrait()
	return true
end

--Navigate the on-screen keyboard and return false if search was closed
function start.f_updateOnScreenKeyboard(cmd, typing)
	if not selectplus.OnScreenKeyboard.enabled then return true end
	local kb   = selectplus.OnScreenKeyboard
	local cols = kb.cols
	local n    = #kb.keys
	--Navigation uses a single rising-edge source because reading both getInput and getKey double-fires one press.
	local up = rising(cmd, motif.select_info.cell.up.key)
	local dn = rising(cmd, motif.select_info.cell.down.key)
	local lf = rising(cmd, motif.select_info.cell.left.key)
	local rt = rising(cmd, motif.select_info.cell.right.key)
	--Always read a/b to keep their latches fresh but ignore them while typing, since some letter keys map to the a/b buttons.
	--RETURN is deliberately unused here 
	local aPressed = rising(cmd, 'a')
	local bPressed = rising(cmd, 'b')
	local btnA = aPressed and not typing
	local btnB = bPressed and not typing
	if rising(cmd, kb.openButton) then
		start.f_searchClose(false)
		return false
	end
	if up and start.kbIndex - cols >= 1 then start.kbIndex = start.kbIndex - cols end
	if dn and start.kbIndex + cols <= n then start.kbIndex = start.kbIndex + cols end
	if lf and (start.kbIndex - 1) % cols ~= 0 then start.kbIndex = start.kbIndex - 1 end
	if rt and start.kbIndex % cols ~= 0 and start.kbIndex < n then start.kbIndex = start.kbIndex + 1 end
	if btnA then
		if start.f_doKbKey(kb.keys[start.kbIndex]) == false then return false end
	elseif btnB then
		if #start.searchQuery > 0 then
			start.searchQuery = start.searchQuery:sub(1, -2)
			start.f_applyFilter(start.searchQuery)
			start.f_updateSearchPortrait()
		end
	end
	return true
end

--Draw the dim panel behind the on-screen keyboard
function start.f_drawKbBackdrop()
	if rectSetWindow == nil or rectDraw == nil then return end
	local rd = nil
	local ti = motif.title_info
	if ti ~= nil and ti.connecting ~= nil and ti.connecting.overlay ~= nil then
		rd = ti.connecting.overlay.RectData
	elseif ti ~= nil and ti.textinput ~= nil and ti.textinput.overlay ~= nil then
		rd = ti.textinput.overlay.RectData
	end
	if rd == nil then return end
	local kb = selectplus.OnScreenKeyboard
	local w  = kb.bgWindow
	rectSetWindow(rd, w[1], w[2], w[3], w[4])
	if rectUpdate ~= nil then rectUpdate(rd) end
	for _ = 1, (kb.bgPasses or 1) do rectDraw(rd) end
end

function start.f_drawOnScreenKeyboard()
	if not selectplus.OnScreenKeyboard.enabled then return end
	if not start.searchMode then return end
	start.f_drawKbBackdrop()
	local kb    = selectplus.OnScreenKeyboard
	local ks    = selectplus.Style.keyboard or {}
	local cols  = kb.cols
	local stage = motif.select_info.stage
	local elNorm = (stage ~= nil and stage.active  ~= nil) and stage.active  or nil
	--Use active2 because it has a distinct color in every screenpack
	local elSel  = (stage ~= nil and stage.active2 ~= nil) and stage.active2 or elNorm

	--A per-key entry in ks.keys[label] always wins; evenKeyStyle falls back for keys at
	--an even grid position that have no entry of their own; otherwise use the shared style.
	local function drawKeyLabel(label, x, y, selected, keyIndex)
		local override = nil
		if type(ks.keys) == 'table' then override = ks.keys[label] end
		if override == nil and type(ks.evenKeyStyle) == 'table' and keyIndex % 2 == 0 then
			override = ks.evenKeyStyle
		end
		override = override or {}

		local baseFont = selected and (ks.selFont ~= nil and ks.selFont ~= '' and ks.selFont or ks.font) or ks.font
		local font = selected and (override.selFont ~= nil and override.selFont ~= '' and override.selFont or override.font or baseFont)
			or (override.font or baseFont)
		local color = selected and (override.selColor or override.color or ks.selColor or ks.color)
			or (override.color or ks.color)
		local bank = selected and (override.selBank or override.bank or ks.selBank or ks.bank)
			or (override.bank or ks.bank)
		local align = override.align or ks.align
		local scale = override.scale or ks.scale
		if font ~= nil and font ~= '' then
			drawStyledText(label, x, y, font, color, bank, align, scale)
		else
			drawText(label, x, y, selected and elSel or elNorm)
		end
	end

	--Last 6 keys (@ # SPC DEL CLR OK) render on the action row so they don't add extra grid rows
	local nAction = 6
	local nChar = #kb.keys - nAction
	for i = 1, nChar do
		local col0 = (i - 1) % cols
		local row0 = math.floor((i - 1) / cols)
		local x    = kb.x0 + col0 * kb.cellW
		local y    = kb.y0 + row0 * kb.cellH
		drawKeyLabel(kb.keys[i].label, x, y, i == start.kbIndex, i)
	end
	local actionY = kb.y0 + math.ceil(nChar / cols) * kb.cellH
	local panelW  = (cols - 1) * kb.cellW
	for a = 1, nAction do
		local idx = nChar + a
		local x   = kb.x0 + ((a - 1) / (nAction - 1)) * panelW
		drawKeyLabel(kb.keys[idx].label, x, actionY, idx == start.kbIndex, idx)
	end
end


function start.f_updateSearch()
	if not selectplus.Search.enabled then return end
	if start.searchCloseGuard > 0 then start.searchCloseGuard = start.searchCloseGuard - 1 end
	--Find a side that's still browsing (hasn't locked in a character yet). In 2-player mode
	--this must not be hardcoded to side 1: once p1 locks in, p2 still needs to be able to
	--open and drive search with their own controller, not be stuck reading p1's input.
	local browseSide, cmd = nil, p1cmd()
	for side = 1, 2 do
		local ps = start.p and start.p[side]
		if ps ~= nil and ps.teamEnd and not ps.selEnd then
			browseSide = side
			cmd = _lastCmd[side] or cmd
			break
		end
	end
	local browsing = browseSide ~= nil

	if not start.searchMode then
		local openCtrl = selectplus.OnScreenKeyboard.enabled
			and rising(cmd, selectplus.OnScreenKeyboard.openButton)
		local openKb   = keyRising(selectplus.Search.openKey)
		if (openCtrl or openKb) and browsing then
			start.searchMode  = true
			start.searchQuery = ''
			start.kbIndex     = 1
			start.f_applyFilter('')
			start.f_updateSearchPortrait()
			if resetKey ~= nil then resetKey() end
		end
		return
	end


	--Read this frame's keyboard input first so the on-screen keyboard can ignore letter keys that double as a/b buttons.
	local hwBackspace, typedText = false, ''
	if getKey ~= nil then
		if getKey('BACKSPACE') then
			hwBackspace = true
		elseif getKeyText ~= nil then
			--strip control chars (Enter/Tab/etc.) so they can't pollute the query
			typedText = (getKeyText() or ''):gsub('%c', '')
		end
	end
	--Hold a short cooldown after each keystroke to suppress the on-screen keyboard's a/b actions, covering the frame lag before an aliased button registers.
	if hwBackspace or (typedText ~= '') then
		start.kbTypeGuard = 8
	elseif start.kbTypeGuard > 0 then
		start.kbTypeGuard = start.kbTypeGuard - 1
	end
	local suppressBtns = start.kbTypeGuard > 0

	if start.f_updateOnScreenKeyboard(cmd, suppressBtns) == false then return end

	if getKey == nil then return end
	if esc ~= nil and esc() then
		start.f_searchClose(true)
		esc(false)
		if resetKey ~= nil then resetKey() end
		return
	end
	local changed = false
	--F3 closes the search and keeps the filter so the snapped match stays for selection.
	if keyRising(selectplus.Search.openKey) then
		start.f_searchClose(false)
		if resetKey ~= nil then resetKey() end
		return
	elseif hwBackspace then
		if #start.searchQuery > 0 then
			start.searchQuery = start.searchQuery:sub(1, -2)
			changed = true
		end
	elseif typedText ~= '' then
		start.searchQuery = start.searchQuery .. typedText
		changed = true
	end
	if resetKey ~= nil then resetKey() end
	if changed then
		start.f_applyFilter(start.searchQuery)
		start.f_updateSearchPortrait()
	end
end

--------------------------------------------------------------------------------
--frame hook
--------------------------------------------------------------------------------
hook.add('start.f_selectScreen', 'selectplus', function()
	if not _irInit and start.t_grid ~= nil then initIconResize() end

	start.f_updateRosterPageTotals()

	local locked = start.p ~= nil and start.p[1] ~= nil and start.p[2] ~= nil
		and start.p[1].selEnd and start.p[2].selEnd
	if not locked then
		start.f_updateSearch()

		--Handle keyboard paging and resize here
		if not start.searchMode then
			local ps = selectplus.PageScrolling
			local ir = selectplus.IconResize
			if ps.enabled then
				if keyRising(ps.keyboard.prev) then changePage(-1) end
				if keyRising(ps.keyboard.next) then changePage(1)  end
			end
			if ir.enabled then
				if keyRising(ir.keyboard.down) then applyIconResize(ir.scale - ir.scaleStep) end
				if keyRising(ir.keyboard.up)   then applyIconResize(ir.scale + ir.scaleStep) end
			end
		end
	end

	--Draw the overlay. Gated by 'locked': once both players finish picking characters the
	--engine moves on to stage select and reuses stage.active's text sprite to show the
	--highlighted stage's name, so drawing here past that point fights over the same sprite
	--every frame and makes the stage name flicker unreadable.
	if not locked then
		if start.searchMode then
			--Draw the search prompt, result count, and on-screen keyboard
			local st = selectplus.Style
			local n  = start.rosterFilter and #start.rosterFilter or 0
			--A leading '@'/'#' switches the readout label to author/tag mode and hides the prefix
			local q, label = start.searchQuery, 'SEARCH: '
			local pfx = q:sub(1, 1)
			if     pfx == '@' then q, label = q:sub(2), 'SEARCH AUTHOR: '
			elseif pfx == '#' then q, label = q:sub(2), 'SEARCH TAG: ' end
			if st.searchPrompt.show then drawStyledText(label .. q:upper() .. '_', st.searchPrompt.x, st.searchPrompt.y, st.searchPrompt.font, st.searchPrompt.color, st.searchPrompt.bank, st.searchPrompt.align, st.searchPrompt.scale) end
			if st.foundCount.show   then drawStyledText(n .. ' FOUND',             st.foundCount.x,   st.foundCount.y,   st.foundCount.font, st.foundCount.color, st.foundCount.bank, st.foundCount.align, st.foundCount.scale) end
			start.f_drawOnScreenKeyboard()
		elseif selectplus.PageScrolling.enabled then
			--Draw the page and size readout in the band under the mode title
			local rp = start.rosterPage
			local ir = selectplus.IconResize
			local st = selectplus.Style
			--Keep the active filter visible after the keyboard closes so it is clear what the grid is limited to
			local tail = 'F3=SEARCH'
			if start.rosterFilter ~= nil and start.searchQuery ~= '' then
				local q = start.searchQuery
				local pfx = q:sub(1, 1)
				if     pfx == '@' then tail = 'AUTHOR: ' .. q:sub(2):upper()
				elseif pfx == '#' then tail = 'TAG: ' .. q:sub(2):upper()
				else tail = 'FILTER: ' .. q:upper() end
			end
			if st.pageReadout.show then
				drawStyledText('PAGE ' .. rp.current .. '/' .. rp.total
					.. '   ' .. start.f_rosterCount() .. ' CHARS   ' .. tail, st.pageReadout.x, st.pageReadout.y, st.pageReadout.font, st.pageReadout.color, st.pageReadout.bank, st.pageReadout.align, st.pageReadout.scale)
			end
			if ir.enabled and st.sizeReadout.show then
				drawStyledText('SIZE ' .. string.format('%.0f%%', ir.scale * 100)
					.. '   F5/F6  /  L1+L2', st.sizeReadout.x, st.sizeReadout.y, st.sizeReadout.font, st.sizeReadout.color, st.sizeReadout.bank, st.sizeReadout.align, st.sizeReadout.scale)
			end
		end
	end
end)

print('selectplus ' .. selectplus.version .. ' loaded')

return selectplus
