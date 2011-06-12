--[[
===========================================================================
Copyright (C) 2011 Leszek Godlewski

This file is part of Strike Online source code.

Strike Online source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Strike Online source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Strike Online source code; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
]]--

-- Main client module

require "map"

-- updates the tileset sprite batch
function updateTilesetBatch()
	tilesetBatch:clear()
	fY = math.floor(mapY)
	fX = math.floor(mapX)
	for y=0, tilesDisplayHeight-1 do
		for x=0, tilesDisplayWidth-1 do
			tilesetBatch:addq(tileQuads[map[y + fY][x + fX]], x * tileSize, y * tileSize)
		end
	end
end

-- game load callback
function love.load()
	local tilesetName = ""
	local mapfile = love.filesystem.newFile("data/maps/desert.tmx")
	mapfile:open('r')
	mapWidth, mapHeight, tilesetName, map = MapLoader:load(mapfile)

	mapX = 1
	mapY = 1
	tilesDisplayWidth = 50 + 2 -- entire screen + 1-tile margin
	tilesDisplayHeight = 38 + 2

	tilesetImage = love.graphics.newImage("data/tilesets/"..tilesetName..".png")
	tilesetImage:setFilter("nearest", "nearest")
	tileSize = 16

	tileQuads = {}
	for y = 0, (tilesetImage:getHeight() / 16 - 1) do
		for x = 0, (tilesetImage:getWidth() / 16 - 1) do
			tileQuads[y * 64 + x + 1] = love.graphics.newQuad(x * tileSize, y * tileSize,
				tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
		end
	end

	tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, tilesDisplayWidth * tilesDisplayHeight)
	updateTilesetBatch()
end

-- flushes the sprite batch to screen
function drawMapSpriteBatch()
	love.graphics.draw(tilesetBatch, math.floor(-(mapX % 1) * tileSize),
		math.floor(-(mapY % 1) * tileSize))
end

-- draws the entire map quad by quad (slow)
function drawMapImmediateMode()
	local xofs = math.floor(-(mapX%1)*tileSize)
	local yofs = math.floor(-(mapY%1)*tileSize)
	local fX = math.floor(mapX)
	local fY = math.floor(mapY)
	for y = 0, tilesDisplayHeight-1 do
		for x = 0, tilesDisplayWidth-1 do
			love.graphics.drawq(tilesetImage, tileQuads[map[y + fY][x + fX]],
				x*tileSize + xofs, y*tileSize + yofs)
		end
	end
end

-- function for moving the map
function moveMap(dx, dy)
	oldMapX = mapX
	oldMapY = mapY
	mapX = math.max(math.min(mapX + dx, mapWidth - tilesDisplayWidth), 1)
	mapY = math.max(math.min(mapY + dy, mapHeight - tilesDisplayHeight), 1)
	-- only update if we actually moved
	-- TODO: reenable when sprite batches on Intel GMA are fixed
	--[[if math.floor(mapX) ~= math.floor(oldMapX) or math.floor(mapY) ~= math.floor(oldMapY) then
		updateTilesetBatch()
	end]]--
end

-- game frame callback
function love.update(dt)
	if love.keyboard.isDown("up") then
		moveMap(0, -0.2 * tileSize * dt)
	end
	if love.keyboard.isDown("down") then
		moveMap(0, 0.2 * tileSize * dt)
	end
	if love.keyboard.isDown("left") then
		moveMap(-0.2 * tileSize * dt, 0)
	end
	if love.keyboard.isDown("right") then
		moveMap(0.2 * tileSize * dt, 0)
	end
end

function love.draw()
	-- TODO: reenable when sprite batches on Intel GMA are fixed
	--drawMapSpriteBatch()
	drawMapImmediateMode()
	love.graphics.print("Strike Online client - work in progress\nFPS: "..love.timer.getFPS(), 10, 20)
end
