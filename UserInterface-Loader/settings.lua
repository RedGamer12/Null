local Http = game:GetService("HttpService")

local Data = {}
local FileName = "Settings.json"

local DataFunctions = {}

function DataFunctions:Set(name, value)
    self.data[name] = value
    writefile(self.FolderName.."/"..self.FileName, Http:JSONEncode(self.data))
end

function DataFunctions:Get(name)
    return self.data[name]
end

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
    
    --Add the adjustments to the structure of the table
    if not Data[name]["Weapons"] then
        Data[name]["Weapons"] = {
            Melee = {
                Enable = true,
                Delay = 0,
                Skills = {
                    Z = {Enable = false, HoldTime = 0},
                    X = {Enable = false, HoldTime = 0},
                    C = {Enable = false, HoldTime = 0}
                }
            },
            BloxFruit = {
                Enable = true,
                Delay = 0,
                Skills = {
                    Z = {Enable = false, HoldTime = 0},
                    X = {Enable = false, HoldTime = 0},
                    C = {Enable = false, HoldTime = 0},
                    V = {Enable = false, HoldTime = 0},
                    F = {Enable = false, HoldTime = 0}
                }
            },
            Gun = {
                Enable = true,
                Delay = 0,
                Skills = {
                    Z = {Enable = false, HoldTime = 0},
                    X = {Enable = false, HoldTime = 0}
                }
            },
            Sword = {
                Enable = true,
                Delay = 0,
                Skills = {
                    Z = {Enable = false, HoldTime = 0},
                    X = {Enable = false, HoldTime = 0}
                }
            }
        }
    end

    return setmetatable({
        FolderName = name,
        FileName = FileName,
        data = Data[name]
    }, {
        __index = DataFunctions
    })
end

return Data
