local function mergeTable(t1, t2) -- Hàm gộp 2 table
    for k, v in pairs(t2) do
        if type(v) == "table" and type(t1[k]) == "table" then
            mergeTable(t1[k], v)
        else
            t1[k] = v
        end
    end
end

local Data = {}
local DataFunctions = {}
local Http = game:GetService("HttpService")

function Data.new(name, data)
    if not isfolder(name) then
        makefolder(name)
    end

    local savedData = {}
    if isfile(name .. "/settings.json") then
        savedData = Http:JSONDecode(readfile(name .. "/Settings.json"))
        mergeTable(savedData, data) -- Gộp dữ liệu lưu trữ và dữ liệu mặc định
    else
        savedData = data
    end

    return setmetatable({
        Data = savedData,
        FolderName = name
    }, {
        __index = DataFunctions
    })
end

function DataFunctions:Set(name, value)
    self.Data[name] = value
    writefile(self.FolderName .. "/Settings.json", Http:JSONEncode(self.Data))
end

function DataFunctions:Get(name)
    return self.Data[name]
end

return Data
