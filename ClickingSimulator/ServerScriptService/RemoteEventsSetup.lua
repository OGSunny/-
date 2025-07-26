-- RemoteEvents Setup (ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvents folder
local remoteEventsFolder = Instance.new("Folder")
remoteEventsFolder.Name = "RemoteEvents"
remoteEventsFolder.Parent = ReplicatedStorage

-- Create individual RemoteEvents
local clickRemote = Instance.new("RemoteEvent")
clickRemote.Name = "ClickRemote"
clickRemote.Parent = remoteEventsFolder

local updateGUIRemote = Instance.new("RemoteEvent")
updateGUIRemote.Name = "UpdateGUIRemote"
updateGUIRemote.Parent = remoteEventsFolder

local leaderboardRemote = Instance.new("RemoteEvent")
leaderboardRemote.Name = "LeaderboardRemote"
leaderboardRemote.Parent = remoteEventsFolder

print("RemoteEvents created successfully!")