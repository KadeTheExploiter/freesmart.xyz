-- Ragdoll Bruteforce, credit Gelatek when used
local _stringlower = string.lower
local _stringmatch = string.match

local Player = game:GetService("Players").LocalPlayer
local Instances = game:GetDescendants()

local ModuleFunctions = {"Ragdoll", "ServerRagdoll", "StartRagdolling"}
local RagdollHandlers = {
	['RemoteFunction'] = {['Start'] ={}, ['End']={}},
	['RemoteEvent'] = {['Start'] ={}, ['End']={}},
	['ModuleScript'] = {['Start'] ={}, ['End']={}},
}

for _, Index in Instances do
	if Index:IsA("Part") then
		continue
	end

	local ClassName = Index.ClassName

	local IsModuleScript = ClassName == "ModuleScript"
	local IsRemoteFunction = ClassName == "RemoteFunction"
	local IsRemoteEvent = ClassName == "RemoteEvent"

	if not (IsModuleScript or IsRemoteEvent or IsRemoteFunction) then
		continue
	end

	if IsRemoteEvent and Index.Name == "variableserver" then
		table.insert(RagdollHandlers['RemoteEvent']["Start"], {Index, "FireServer", {"ragdoll", true}})
		table.insert(RagdollHandlers['RemoteEvent']["End"], {Index, "FireServer", {"ragdoll", false}})

		continue
	end

	local LowercaseName = _stringlower(Index.Name)

	if game.PlaceId == 606849621 then
		if LowercaseName == "ragdoll" then
			continue
		end	
	end

	if _stringmatch(LowercaseName, "ragdoll") or _stringmatch(LowercaseName, "falling") then
		local IsDeragdolling = _stringmatch(LowercaseName, "un")
		local SubCategory = IsDeragdolling and "End" or "Start"
		
		if IsModuleScript then
			local Success, Module = pcall(require, Index)
			if not Success then
				continue
			end

			local IsAFunction = typeof(Module) == "function"
			local IsNotATable = typeof(Module) ~= "table"
				
			if IsAFunction then
				table.insert(RagdollHandlers[ClassName][SubCategory], {Index, nil, {9e9, nil, Player, Player.Character}})

				continue
			end

			if IsNotATable then
				return
			end

			for _, FunctionName in ModuleFunctions do
				local FoundFunctions = Module[FunctionName]

				if not FoundFunctions then
					continue
				end

				table.insert(RagdollHandlers[ClassName][SubCategory], {FoundFunctions, nil, {9e9, nil, Player, Player.Character}})
			end

			continue
		end
		local Method = IsRemoteFunction and "InvokeServer" or IsRemoteEvent and "FireServer"
	
		table.insert(RagdollHandlers[ClassName][SubCategory], {Index, Method, {nil, Player, Player.Character}})
	end
end


local function TriggerRagdoll(State: string | boolean, BreakOnEnd: boolean?)
	if type(State) == "boolean" then
		State = State and "Start" or "End"
	end

	for _, Class in RagdollHandlers do
		for _, Argument in Class[State] do
			local Index = Argument[1]
			local Method = Argument[2]
			local ListOfArguments = Argument[3]
			for _, VArgument in ListOfArguments do
				local Success, _ = Method and pcall(Index[Method], Index, VArgument) or pcall(Index, VArgument)
				
				if BreakOnEnd and Success then
					break
				end
			end
		end
	end
end
getgenv().RagdollHandler = TriggerRagdoll
