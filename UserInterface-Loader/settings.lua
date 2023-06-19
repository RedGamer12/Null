local Data = {}
local DataFunctions = {}
local HttpService = game:GetService("HttpService")

function Data.new(name, data, fileName)
    if not isfolder(name) then
        makefolder(name)
    end

    local filePath = name .. "/" .. (fileName or "settings.json")
    local savedData = isfile(filePath) and HttpService:JSONDecode(readfile(filePath))

    if savedData then
        for key, value in pairs(data) do
            if not savedData[key] then
                savedData[key] = value
            end
        end
    end

    return setmetatable({
        Data = savedData or data,
        FileName = fileName or "settings.json",
        FolderName = name,
    }, {
        __index = Data,
    })
end

function Data:Set(key, value)
    self.Data[key] = value
    writefile(self.FolderName .. "/" .. self.FileName, HttpService:JSONEncode(self.Data))
end

function Data:Get(key)
    return self.Data[key]
end

function Data:Load()
    local filePath = self.FolderName .. "/" .. self.FileName

    if isfile(filePath) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(filePath))
        end)

        if success then
            self.Data = result or {}
        else
            warn("Error loading data: ", result)
        end
    end
end
