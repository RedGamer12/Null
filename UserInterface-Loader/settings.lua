local Http = game:GetService("HttpService")

local Data = {}
local FileName = "Settings.json"

function Data.new(name, data)
	local self = {}
	
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
		
		self[name] = SavedData
	else
		writefile(FilePath, Http:JSONEncode(data))
		self[name] = data
	end
	
	return setmetatable({
		FolderName = name,
		FileName = FileName,
		data = self[name]
	}, {
		__index = DataFunctions
	})
end

local DataFunctions = {}

function DataFunctions:Set(name, value)
	self.data[name][value] = value
	writefile(self.FolderName.."/"..self.FileName, Http:JSONEncode(self.data))
end

function DataFunctions:Get(name)
	return self.data[name]
end

return Data
