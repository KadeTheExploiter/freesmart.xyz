-- Ragdoll Bruteforce, credit Gelatek when used

local Player = game:GetService("Players").LocalPlayer
local Instances =  game:GetDescendants()

local IndexNames = {"ragdoll", "falling"}
local ModuleFunctions = {"Ragdoll", "ServerRagdoll", "StartRagdolling"}
local RagdollHandlers = {
	['RemoteFunction'] = {['Start'] ={}, ['End']={}},
	['RemoteEvent'] = {['Start'] ={}, ['End']={}},
	['ModuleScript'] = {['Start'] ={}, ['End']={}},
}

local RequiredModules = {}
for _, Index in Instances do
	if RequiredModules[Index] then
		continue
	end

	local IsModule = Index:IsA("ModuleScript") if not IsModule then return end
	local IsRemoteFunction = Index:IsA("RemoteFunction") if not IsRemoteFunction then return end
	local IsRemoteEvent = Index:IsA("RemoteEvent") if not IsRemoteEvent then return end

	if IsRemoteEvent and Index.Name == "variableserver" then
		table.insert(RagdollHandlers['RemoteEvent']["Start"], {Index, "FireServer", {"ragdoll", true}})
		table.insert(RagdollHandlers['RemoteEvent']["End"], {Index, "FireServer", {"ragdoll", false}})

		continue
	end

	local LowercaseName = string.lower(Index.Name)
	for _, StartName in IndexNames do
		if string.match(LowercaseName, StartName) then
			local Category = Index.ClassName
			local Method = IsRemoteFunction and "InvokeServer" or IsRemoteEvent and "FireServer"
		
			local IsDeragdolling = string.match(LowercaseName, "un")
			local SubCategory = IsDeragdolling and "End" or "Start"

			if IsModule then
				local Success, Module = pcall(require, Index)
				if not Success then
					continue
				end

				local IsAFunction = typeof(Module) == "function"
				local IsNotATable = typeof(Module) ~= "table"
					
				if IsAFunction then
					table.insert(RagdollHandlers[Category][SubCategory], {Index, nil, {9e9, nil, Player, Player.Character}})

					continue
				end

				if IsNotATable then
					return
				end
				RequiredModules[RequiredModules] = true
				for _, FunctionName in ModuleFunctions do
					local FoundFunctions = Module[FunctionName]

					if not FoundFunctions then
						continue
					end

					table.insert(RagdollHandlers[Category][SubCategory], {FoundFunctions, nil, {9e9, nil, Player, Player.Character}})
				end

				continue
			end

			table.insert(RagdollHandlers[Category][SubCategory], {Index, Method, {nil, Player, Player.Character}})
		end

		break
	end
end

table.clear(RequiredModules);

local function TriggerRagdoll(State: string | boolean)
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

				if Success then
					break
				end
			end
		end
	end
end
return TriggerRagdoll
