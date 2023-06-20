local Data = {}
local DataFunctions = {}
local Http = game:GetService("HttpService")

function Data.new(name, data, fileName)
	if not isfolder(name) then
		makefolder(name)
	end

	fileName = fileName or "settings.json"
	local filePath = name .. "/" .. fileName
    local savedData = isfile(filePath) and Http:JSONDecode(readfile(filePath))
    
    if savedData then
        for i,v in pairs(data) do
            if not savedData[i] then
                savedData[i] = v
            end
        end
    else
        writefile(filePath, Http:JSONEncode(data))
        savedData = data
    end

	return setmetatable({
		Data = savedData,
		FolderName = name,
        FileName = fileName
	}, {
		__index = DataFunctions
	})
end

function DataFunctions:Set(name, value)
	self.Data[name] = value
	writefile(self.FolderName.."/"..self.FileName, Http:JSONEncode(self.Data))
end

function DataFunctions:Get(name)
	return self.Data[name]
end

function DataFunctions:Load()
    local filePath = self.FolderName .. "/" .. self.FileName

    if isfile(filePath) then
        local success, result = pcall(function()
            return Http:JSONDecode(readfile(filePath))
        end)

        if success then
            self.Data = result or {}
        else
            warn("Error loading data: ", result)
        end
    end
end

return Data
