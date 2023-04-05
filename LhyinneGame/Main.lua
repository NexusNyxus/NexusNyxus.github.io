local Round = require(script.RoundModule)

local Status = game.ReplicatedStorage:WaitForChild("Status")

while wait() do
	
	repeat
		local availableplayers = {}
		
		for i, plr in pairs(game.Players:GetPlayers()) do
			if not plr:FindFirstChild("InMenu") then
				table.insert(availableplayers, plr)
			end
		end
		
		Status.Value = "Loading.."
		
		wait(1)
		
		game.ReplicatedStorage.AvailablePlayers.Value = #availableplayers
		
	until #availableplayers >= 1
	
	Round.Intermission(20)
	
	local chosenChapter = Round.SelectChapter()
	
	local clonedChapter = chosenChapter:Clone()
	clonedChapter.Name = "Map"
	clonedChapter.Parent = workspace
	
	Round.SelectGamemode()
	
	local contestants = {}
	
	for i, v in pairs(game.Players:GetPlayers()) do
		if not v:FindFirstChild("InMenu") then
			table.insert(contestants,v)
		end
	end
	
	local chosenPiggy = Round.ChoosePiggy(contestants)
	
	for i, v in pairs(contestants) do
		if game.ReplicatedStorage.ChosenGamemode.Value == "Player" or game.ReplicatedStorage.ChosenGamemode.Value == "Player + Bot" then
			if v == chosenPiggy then
				table.remove(contestants,i)
			end
		end
	end
	
	for i, v in pairs(contestants) do
		if game.ReplicatedStorage.ChosenGamemode.Value == "Player" or game.ReplicatedStorage.ChosenGamemode.Value == "Player + Bot" then
			if v ~= chosenPiggy then
				game.ReplicatedStorage.ToggleCrouch:FireClient(v,true)
			end
		elseif game.ReplicatedStorage.ChosenGamemode.Value == "Bot" then
			game.ReplicatedStorage.ToggleCrouch:FireAllClients(true)
		end
	end
	
	wait(2)
	
	if game.ReplicatedStorage.ChosenGamemode.Value == "Player" or game.ReplicatedStorage.ChosenGamemode.Value == "Player + Bot" then
		Round.DressPiggy(chosenPiggy)
		Round.TeleportPiggy(chosenPiggy)
	end
	
	if clonedChapter:FindFirstChild("PlayerSpawns") then
		Round.TeleportPlayers(contestants, clonedChapter.PlayerSpawns:GetChildren())
	else
		warn("No player spawns found.")
	end
	
	Round.InsertTag(contestants,"Contestant")
	
	if game.ReplicatedStorage.ChosenGamemode.Value == "Player" or game.ReplicatedStorage.ChosenGamemode.Value == "Player + Bot" then
		Round.InsertTag({chosenPiggy},"Piggy")
	end
	
	Round.ToggleCutscene("Intro",game.ReplicatedStorage.ChosenChapter.Value)
	
	Round.StartRound(600,chosenPiggy,clonedChapter)
	
	print("Round ended")
	
	contestants = {}
	
	for i, v in pairs(game.Players:GetPlayers()) do
		if not v:FindFirstChild("InMenu") then
			table.insert(contestants,v)
		end
	end
	
	if game.Workspace.Lobby:FindFirstChild("Spawns") then
		Round.TeleportPlayers(contestants, game.Workspace.Lobby.Spawns:GetChildren())
	else
		warn("No spawns in lobby")
	end
	
	clonedChapter:Destroy()
	
	Round.RemoveTags()
	
	if workspace:FindFirstChild("Bot") then workspace.Bot:Destroy() end
	
	game.ServerStorage.EliminatedPlayers:ClearAllChildren()
	game.ReplicatedStorage.ReadyPlayers:ClearAllChildren()
	
	wait(2)
end
