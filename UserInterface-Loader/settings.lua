local Http = game:GetService("HttpService")

local Data = {}
local FileName = "Settings.json"

function Data.new(name, data)
	if not isfolder(name) then
		makefolder(name)
	end

	local FilePath = name.."/"..FileName
	
	if isfile(FilePath) then
		local SavedData = Http:JSONDecode(readfile(FilePath))
		
		for i,v in pairs(data) do
			if not SavedData[i] then
				SavedData[i] = v
			end
		end
		
		Data[name] = SavedData
	else
		writefile(FilePath, Http:JSONEncode(data))
		Data[name] = data
	end
	
	return setmetatable({
		FolderName = name,
		FileName = FileName
	}, {
		__index = DataFunctions
	})
end

local DataFunctions = {}

function DataFunctions:Set(name, value)
	self[name][value] = value
	writefile(self.FolderName.."/"..self.FileName, Http:JSONEncode(self[name]))
end

function DataFunctions:Get(name)
	return self[name]
end

return Data
