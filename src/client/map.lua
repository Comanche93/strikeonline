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

-- Map loader module

require "lib/xml.lua"

MapLoader = {}

--[[function dump(_class, no_func, depth)
	if(not _class) then
		print("nil");
		return;
	end

	if(depth==nil) then depth=0; end
	local str="";
	for n=0,depth,1 do
		str=str.."\t";
	end

	print(str.."["..type(_class).."]");
	print(str.."{");

	for i,field in pairs(_class) do
		if(type(field)=="table") then
			print(str.."\t"..tostring(i).." =");
			dump(field, no_func, depth+1);
		else
			if(type(field)=="number") then
				print(str.."\t"..tostring(i).."="..field);
			elseif(type(field) == "string") then
				print(str.."\t"..tostring(i).."=".."\""..field.."\"");
			elseif(type(field) == "boolean") then
				print(str.."\t"..tostring(i).."=".."\""..tostring(field).."\"");
			else
				if(not no_func)then
					if(type(field)=="function")then
						print(str.."\t"..tostring(i).."()");
					else
						print(str.."\t"..tostring(i).."<userdata=["..type(field).."]>");
					end
				end
			end
		end
	end
	print(str.."}");
end]]--


function MapLoader:load(file)
	--file:open('r')
	XmlText = file:read()
	XmlDoc = XmlParser:ParseXmlText(XmlText)
	--dump(XmlDoc)
	-- the root node is always <map>
	local width = XmlDoc.Attributes.width
	local height = XmlDoc.Attributes.height
	-- get tileset name
	local tileset = XmlDoc.ChildNodes[1].Attributes.name
	-- start the map table
	local map = {}
	local i = 0
	local j = 1
	for y = 1, height do
		local row = {}
		for x = 1, width do
			i = string.find(XmlDoc.ChildNodes[2].ChildNodes[1].Value, ",", i + 1)
			if i == nil then break end
			table.insert(row, tonumber(string.sub(XmlDoc.ChildNodes[2].ChildNodes[1].Value, j, i - 1)))
			j = i + 1
		end
		table.insert(map, row)
	end

	return width, height, tileset, map
end
