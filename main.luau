-- :: Services

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- :: Variables

local Signals: {RBXScriptSignal} = {}
local LocalPlayer = Players.LocalPlayer
local Mouse: Mouse = LocalPlayer:GetMouse()

local Main
local CMDMain
local CMDDescription
local CMDTextDescription

local CMDListScrollFrame
local CommandsFolder
local ExampleCommand

local Resizer
local ListDrag
local CMDList_1
local CMDSearchBar
local SearchIcon
local SearchInput
local CMDCloseGui

local Drag_1
local ExecutionBarInput
local OpenButton
local CloseGui

local Dragging = false

local AddCommand,DescriptionStepped,HoveredCommand
local Commands; Commands = {
	[{"commands","cmds"}] = {
		Arguments = {},
		Description = "Opens the command list.",
		Function = function()
			CMDMain.Visible = true
		end,
	},
}

local GuiParent = gethui and gethui() or pcall(game, "GetService", game, "CoreGui") and game.CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local ExecutionCentre = Instance.new("ScreenGui"); do
	ExecutionCentre.Name = "ExecutionCentre"
	ExecutionCentre.ResetOnSpawn = false

	if GuiParent:FindFirstChild("ExecutionCentre") then
		GuiParent:FindFirstChild("ExecutionCentre"):Destroy()
	end

	Main = Instance.new("Frame"); do
		Main.BackgroundColor3 = Color3.fromRGB(44,44,44)
		Main.Name = "ExecutionCentreMain"
		Main.Position = UDim2.new(0,225,0,309)
		Main.Size = UDim2.new(0,320,0,83)
		Main.Visible = false

		local ExecMainCorner = Instance.new("UICorner"); do
			ExecMainCorner.CornerRadius = UDim.new(0,4)
			ExecMainCorner.Name = "ExecMainCorner"
			ExecMainCorner.Parent = Main
		end

		local Title = Instance.new("TextLabel"); do
			Title.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Title.BackgroundTransparency = 1
			Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular ,Enum.FontStyle.Normal)
			Title.FontSize = Enum.FontSize.Size18
			Title.Name = "Title"
			Title.Position = UDim2.new(0.037,0,0.05,0)
			Title.Size = UDim2.new(0,200,0,26)
			Title.Text = "freesmart.xyz, v1.1.0"
			Title.TextColor3 = Color3.fromRGB(231,231,231)
			Title.TextSize = 16
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Title.Parent = Main
		end

		local MainStroke = Instance.new("UIStroke"); do
			MainStroke.Color = Color3.fromRGB(15,15,15)
			MainStroke.Name = "MainStroke"
			MainStroke.Transparency = 0.75
			MainStroke.Parent = Main
		end

		local ExecutionBar = Instance.new("Frame"); do
			ExecutionBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
			ExecutionBar.Name = "ExecutionBar"
			ExecutionBar.Position = UDim2.new(0.0313,0,0.443,0)
			ExecutionBar.Size = UDim2.new(0,299,0,37)

			local ExecutionBarCorner = Instance.new("UICorner"); do
				ExecutionBarCorner.CornerRadius = UDim.new(0,4)
				ExecutionBarCorner.Name = "ExecutionBarCorner"
				ExecutionBarCorner.Parent = ExecutionBar
			end

			local ExecutionBarStroke = Instance.new("UIStroke"); do
				ExecutionBarStroke.Color = Color3.fromRGB(20,20,20)
				ExecutionBarStroke.Name = "ExecutionBarStroke"
				ExecutionBarStroke.Parent = ExecutionBar
			end

			ExecutionBarInput = Instance.new("TextBox"); do
				ExecutionBarInput.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ExecutionBarInput.BackgroundTransparency = 1
				ExecutionBarInput.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular ,Enum.FontStyle.Normal)
				ExecutionBarInput.FontSize = Enum.FontSize.Size14
				ExecutionBarInput.Name = "ExecutionBarInput"
				ExecutionBarInput.PlaceholderText = "Input here. Prefix: ;"
				ExecutionBarInput.Position = UDim2.new(0.1642,0,0.1892,0)
				ExecutionBarInput.Size = UDim2.new(0,222,0,23)
				ExecutionBarInput.Text = ""
				ExecutionBarInput.TextColor3 = Color3.fromRGB(216,216,216)
				ExecutionBarInput.TextSize = 14
				ExecutionBarInput.TextXAlignment = Enum.TextXAlignment.Left
				ExecutionBarInput.Parent = ExecutionBar
			end

			local ExecutionBarIcon = Instance.new("ImageLabel"); do
				ExecutionBarIcon.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ExecutionBarIcon.BackgroundTransparency = 1
				ExecutionBarIcon.Image = "rbxasset://textures/PluginManagement/back.png"
				ExecutionBarIcon.Name = "ExecutionBarIcon"
				ExecutionBarIcon.Position = UDim2.new(0.036,0,0.135,0)
				ExecutionBarIcon.Rotation = 180
				ExecutionBarIcon.Size = UDim2.new(0,27,0,27)
				ExecutionBarIcon.Parent = ExecutionBar
			end
			ExecutionBar.Parent = Main
		end

		local Shadow = Instance.new("ImageLabel"); do
			Shadow.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Shadow.BackgroundTransparency = 1
			Shadow.Image = "rbxasset://textures/StudioUIEditor/resizeHandleDropShadow.png"
			Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
			Shadow.ImageTransparency = 0.4
			Shadow.Name = "Shadow"
			Shadow.Position = UDim2.new(-0.18,0,-0.262,0)
			Shadow.Size = UDim2.new(0,443,0,129)
			Shadow.Visible = false
			Shadow.ZIndex = -1
			Shadow.Parent = Main
		end

		CloseGui = Instance.new("ImageButton"); do
			CloseGui.BackgroundColor3 = Color3.fromRGB(255,255,255)
			CloseGui.BackgroundTransparency = 1
			CloseGui.Image = "rbxasset://textures/DeveloperFramework/AssetPreview/close_button.png"
			CloseGui.Name = "CloseGui"
			CloseGui.Position = UDim2.new(0.9052,0,0.0891,0)
			CloseGui.Size = UDim2.new(0,19,0,19)
			CloseGui.Parent = Main
		end

		local TopBarApp = Instance.new("ScreenGui"); do
			--TopBarApp.AutoLocalize = false
			TopBarApp.DisplayOrder = 6
			TopBarApp.IgnoreGuiInset = true
			TopBarApp.ResetOnSpawn = false
			TopBarApp.Name = "TopBarApp"

			local TopBarFrame = Instance.new("Frame"); do
				TopBarFrame.BackgroundTransparency = 1
				TopBarFrame.Name = "TopBarFrame"
				TopBarFrame.Position = UDim2.new(0,0,0,-36)
				TopBarFrame.Size = UDim2.new(1,0,0,36)

				local RightFrame = Instance.new("Frame"); do
					RightFrame.AnchorPoint = Vector2.new(1,0)
					RightFrame.BackgroundTransparency = 1
					RightFrame.Name = "RightFrame"
					RightFrame.Position = UDim2.new(1,-16,0,0)
					RightFrame.Size = UDim2.new(1,-16,1,0)

					local MoreMenu = Instance.new("Frame"); do
						MoreMenu.BackgroundTransparency = 1
						MoreMenu.LayoutOrder = 2
						MoreMenu.Name = "MoreMenu"
						MoreMenu.Size = UDim2.new(0,32,1,0)

						OpenButton = Instance.new("ImageButton"); do
							OpenButton.AnchorPoint = Vector2.new(0,1)
							OpenButton.BackgroundTransparency = 1
							OpenButton.Image = "rbxasset://textures/ui/TopBar/iconBase.png"
							OpenButton.Name = "OpenButton"
							OpenButton.Position = UDim2.new(0,-40,1,0)
							OpenButton.Size = UDim2.new(0,32,0,32)
							OpenButton.Visible = true

							local Icon = Instance.new("ImageLabel"); do
								Icon.AnchorPoint = Vector2.new(0.5,0.5)
								Icon.BackgroundTransparency = 1
								Icon.Image = "rbxasset://textures/ui/InspectMenu/ico_alert_tilt@3x.png"
								Icon.Name = "Icon"
								Icon.Position = UDim2.new(0.5,0,0.5,0)
								Icon.Size = UDim2.new(0,24,0,24)
								Icon.Parent = OpenButton
							end

							local StateOverlay = Instance.new("ImageLabel"); do
								StateOverlay.BackgroundTransparency = 1
								StateOverlay.Image = "rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/AppImageAtlas/img_set_2x_10.png"
								StateOverlay.ImageRectOffset = Vector2.new(460,260)
								StateOverlay.ImageRectSize = Vector2.new(34,34)
								StateOverlay.ImageTransparency = 1
								StateOverlay.Name = "StateOverlay"
								StateOverlay.ScaleType = Enum.ScaleType.Slice
								StateOverlay.Size = UDim2.new(1,0,1,0)
								StateOverlay.SliceCenter = Rect.new(16,16,16,16)
								StateOverlay.SliceScale = 0.5
								StateOverlay.ZIndex = 2
								StateOverlay.Parent = OpenButton
							end
							OpenButton.Parent = MoreMenu
						end
						MoreMenu.Parent = RightFrame
					end

					local Layout = Instance.new("UIListLayout"); do
						Layout.FillDirection = Enum.FillDirection.Horizontal
						Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
						Layout.Name = "Layout"
						Layout.Padding = UDim.new(0,12)
						Layout.SortOrder = Enum.SortOrder.LayoutOrder
						Layout.VerticalAlignment = Enum.VerticalAlignment.Center
						Layout.Parent = RightFrame
					end
					RightFrame.Parent = TopBarFrame
				end
				TopBarFrame.Parent = ExecutionCentre
			end
			TopBarApp.Parent = Main
		end

		local CMDList = Instance.new("ScreenGui"); do
			CMDList.Name = "CMDList"
			CMDList.ResetOnSpawn = false

			CMDMain = Instance.new("Frame"); do
				CMDMain.BackgroundColor3 = Color3.fromRGB(44,44,44)
				CMDMain.ClipsDescendants = true
				CMDMain.Visible = false
				CMDMain.Name = "CMDMain"
				CMDMain.Position = UDim2.new(0.1152,0,0.4395,0)
				CMDMain.Size = UDim2.new(0,320,0,320)

				local CMDMainCorner = Instance.new("UICorner"); do
					CMDMainCorner.CornerRadius = UDim.new(0,4)
					CMDMainCorner.Name = "CMDMainCorner"
					CMDMainCorner.Parent = CMDMain
				end

				local CMDTitle = Instance.new("TextLabel"); do
					CMDTitle.BackgroundColor3 = Color3.fromRGB(255,255,255)
					CMDTitle.BackgroundTransparency = 1
					CMDTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular ,Enum.FontStyle.Normal)
					CMDTitle.FontSize = Enum.FontSize.Size18
					CMDTitle.Name = "CMDTitle"
					CMDTitle.Position = UDim2.new(0,12,0,6)
					CMDTitle.Size = UDim2.new(0,200,0,26)
					CMDTitle.Text = "Commands"
					CMDTitle.TextColor3 = Color3.fromRGB(231,231,231)
					CMDTitle.TextSize = 16
					CMDTitle.TextXAlignment = Enum.TextXAlignment.Left
					CMDTitle.Parent = CMDMain
				end

				local CMDMainStroke = Instance.new("UIStroke"); do
					CMDMainStroke.Color = Color3.fromRGB(15,15,15)
					CMDMainStroke.Name = "CMDMainStroke"
					CMDMainStroke.Transparency = 0.75
					CMDMainStroke.Parent = CMDMain
				end

				CMDList_1 = Instance.new("Frame"); do
					CMDList_1.BackgroundColor3 = Color3.fromRGB(40,40,40)
					CMDList_1.ClipsDescendants = true
					CMDList_1.Name = "CMDList"
					CMDList_1.Position = UDim2.new(0,10,0,39)
					CMDList_1.Size = UDim2.new(0,300,0,205)
					CMDList_1.ZIndex = 2

					local CMDListCorner = Instance.new("UICorner"); do
						CMDListCorner.CornerRadius = UDim.new(0,4)
						CMDListCorner.Name = "CMDListCorner"
						CMDListCorner.Parent = CMDList_1
					end

					CMDListScrollFrame = Instance.new("ScrollingFrame"); do
						CMDListScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
						CMDListScrollFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
						CMDListScrollFrame.BackgroundTransparency = 1
						CMDListScrollFrame.BorderSizePixel = 0
						CMDListScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
						CMDListScrollFrame.Name = "CMDListScrollFrame"
						CMDListScrollFrame.Position = UDim2.new(0.0338,0,0.036,0)
						CMDListScrollFrame.ScrollBarThickness = 2
						CMDListScrollFrame.Size = UDim2.new(0,279,0,175)
						CMDListScrollFrame.ZIndex = 2

						CommandsFolder = Instance.new("Folder"); do
							CommandsFolder.Name = "CommandsFolder"

							local CommandListLayout = Instance.new("UIListLayout"); do
								CommandListLayout.Name = "CommandListLayout"
								CommandListLayout.Padding = UDim.new(0,5)
								CommandListLayout.Parent = CommandsFolder
							end

							ExampleCommand = Instance.new("TextLabel"); do
								ExampleCommand.BackgroundColor3 = Color3.fromRGB(255,255,255)
								ExampleCommand.BackgroundTransparency = 1
								ExampleCommand.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular ,Enum.FontStyle.Normal)
								ExampleCommand.FontSize = Enum.FontSize.Size14
								ExampleCommand.Name = "Command"
								ExampleCommand.Size = UDim2.new(0,259,0,17)
								ExampleCommand.Text = "• Label"
								ExampleCommand.TextColor3 = Color3.fromRGB(231,231,231)
								ExampleCommand.TextSize = 14
								ExampleCommand.TextXAlignment = Enum.TextXAlignment.Left
								ExampleCommand.Visible = false
								ExampleCommand.ZIndex = 2
								ExampleCommand.Parent = CommandsFolder
							end
							CommandsFolder.Parent = CMDListScrollFrame
						end
						CMDListScrollFrame.Parent = CMDList_1
					end

					local CMDListStroke = Instance.new("UIStroke"); do
						CMDListStroke.Color = Color3.fromRGB(20,20,20)
						CMDListStroke.Name = "CMDListStroke"
						CMDListStroke.Parent = CMDList_1
					end
					CMDList_1.Parent = CMDMain
				end

				CMDSearchBar = Instance.new("Frame"); do
					CMDSearchBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
					CMDSearchBar.Name = "CMDSearchBar"
					CMDSearchBar.Position = UDim2.new(0,10,0,253)
					CMDSearchBar.Size = UDim2.new(0,299,0,37)

					local SearchBarCorner = Instance.new("UICorner"); do
						SearchBarCorner.CornerRadius = UDim.new(0,4)
						SearchBarCorner.Name = "SearchBarCorner"
						SearchBarCorner.Parent = CMDSearchBar
					end

					local SearchBarStroke = Instance.new("UIStroke"); do
						SearchBarStroke.Color = Color3.fromRGB(20,20,20)
						SearchBarStroke.Name = "SearchBarStroke"
						SearchBarStroke.Parent = CMDSearchBar
					end

					SearchInput = Instance.new("TextBox"); do
						SearchInput.BackgroundColor3 = Color3.fromRGB(255,255,255)
						SearchInput.BackgroundTransparency = 1
						SearchInput.ClearTextOnFocus = false
						SearchInput.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular ,Enum.FontStyle.Normal)
						SearchInput.FontSize = Enum.FontSize.Size14
						SearchInput.Name = "SearchInput"
						SearchInput.PlaceholderText = "Search.. (not working rn too lazy)"
						SearchInput.Position = UDim2.new(0.1642,0,0.1892,0)
						SearchInput.Size = UDim2.new(0,222,0,23)
						SearchInput.Text = ""
						SearchInput.TextColor3 = Color3.fromRGB(216,216,216)
						SearchInput.TextSize = 14
						SearchInput.TextXAlignment = Enum.TextXAlignment.Left
						SearchInput.Parent = CMDSearchBar
					end

					SearchIcon = Instance.new("ImageLabel"); do
						SearchIcon.BackgroundColor3 = Color3.fromRGB(255,255,255)
						SearchIcon.BackgroundTransparency = 1
						SearchIcon.Image = "rbxasset://textures/AnimationEditor/button_search.png"
						SearchIcon.Name = "SearchIcon"
						SearchIcon.Position = UDim2.new(0.036,0,0.135,0)
						SearchIcon.Size = UDim2.new(0,27,0,27)
						SearchIcon.Parent = CMDSearchBar
					end
					CMDSearchBar.Parent = CMDMain
				end

				CMDCloseGui = Instance.new("ImageButton"); do
					CMDCloseGui.BackgroundColor3 = Color3.fromRGB(255,255,255)
					CMDCloseGui.BackgroundTransparency = 1
					CMDCloseGui.Image = "rbxasset://textures/DeveloperFramework/AssetPreview/close_button.png"
					CMDCloseGui.Name = "CMDCloseGui"
					CMDCloseGui.Position = UDim2.new(0,289,0,9)
					CMDCloseGui.Size = UDim2.new(0,19,0,19)
					CMDCloseGui.Parent = CMDMain
				end

				local CMDCredits = Instance.new("TextLabel"); do
					CMDCredits.AnchorPoint = Vector2.new(0.5,1)
					CMDCredits.BackgroundColor3 = Color3.fromRGB(255,255,255)
					CMDCredits.BackgroundTransparency = 1
					CMDCredits.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular ,Enum.FontStyle.Normal)
					CMDCredits.FontSize = Enum.FontSize.Size12
					CMDCredits.Name = "CMDCredits"
					CMDCredits.Position = UDim2.new(0.5,4,1,-5)
					CMDCredits.Size = UDim2.new(0,294,0,14)
					CMDCredits.Text = "made by timedmarch and gelatekforever"
					CMDCredits.TextColor3 = Color3.fromRGB(143, 142, 142)
					CMDCredits.TextSize = 12
					CMDCredits.TextXAlignment = Enum.TextXAlignment.Left
					CMDCredits.TextYAlignment = Enum.TextYAlignment.Top
					CMDCredits.Parent = CMDMain
				end

				Resizer = Instance.new("Frame"); do
					Resizer.AnchorPoint = Vector2.new(0,1)
					Resizer.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Resizer.BackgroundTransparency = 1
					Resizer.Name = "Resizer"
					Resizer.Position = UDim2.new(0,0,1,0)
					Resizer.Size = UDim2.new(1,0,0,5)
					Resizer.ZIndex = 5
					Resizer.Parent = CMDMain
				end

				local CMDShadow = Instance.new("ImageLabel"); do
					CMDShadow.AnchorPoint = Vector2.new(0.5,0.5)
					CMDShadow.BackgroundColor3 = Color3.fromRGB(255,255,255)
					CMDShadow.BackgroundTransparency = 1
					CMDShadow.Image = "rbxasset://textures/StudioUIEditor/resizeHandleDropShadow.png"
					CMDShadow.ImageColor3 = Color3.fromRGB(0,0,0)
					CMDShadow.ImageTransparency = 0.4
					CMDShadow.Name = "CMDShadow"
					CMDShadow.Position = UDim2.new(0.5,0,0.5,0)
					CMDShadow.Size = UDim2.new(1.4,7,1.4,0)
					CMDShadow.Visible = false
					CMDShadow.ZIndex = -1
					CMDShadow.Parent = CMDMain
				end

				ListDrag = Instance.new("Frame"); do
					ListDrag.BackgroundColor3 = Color3.fromRGB(255,255,255)
					ListDrag.BackgroundTransparency = 1
					ListDrag.Name = "Drag"
					ListDrag.Size = UDim2.new(0,318,0,30)
					ListDrag.Parent = CMDMain
				end
				CMDMain.Parent = ExecutionCentre
			end

			CMDDescription = Instance.new("Frame"); do
				CMDDescription.BackgroundColor3 = Color3.fromRGB(44,44,44)
				CMDDescription.Name = "CMDDescription"
				CMDDescription.Position = UDim2.new(0.1158,0,0.4706,0)
				CMDDescription.Size = UDim2.new(0,215,0,22)
				CMDDescription.Visible = false
				CMDDescription.ZIndex = 3

				local CMDDescriptionCorner = Instance.new("UICorner"); do
					CMDDescriptionCorner.CornerRadius = UDim.new(0,4)
					CMDDescriptionCorner.Name = "CMDDescriptionCorner"
					CMDDescriptionCorner.Parent = CMDDescription
				end

				local CMDDescriptionStroke = Instance.new("UIStroke"); do
					CMDDescriptionStroke.Color = Color3.fromRGB(15,15,15)
					CMDDescriptionStroke.Name = "CMDDescriptionStroke"
					CMDDescriptionStroke.Parent = CMDDescription
				end

				CMDTextDescription = Instance.new("TextLabel"); do
					CMDTextDescription.BackgroundColor3 = Color3.fromRGB(255,255,255)
					CMDTextDescription.BackgroundTransparency = 1
					CMDTextDescription.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular ,Enum.FontStyle.Normal)
					CMDTextDescription.FontSize = Enum.FontSize.Size14
					CMDTextDescription.Name = "CMDTextDescription"
					CMDTextDescription.Position = UDim2.new(0.0359,0,0,0)
					CMDTextDescription.Size = UDim2.new(0.9641,0,0.8636,0)
					CMDTextDescription.Text = "Executes script on client."
					CMDTextDescription.TextColor3 = Color3.fromRGB(188,188,188)
					CMDTextDescription.TextScaled = true
					CMDTextDescription.TextSize = 14
					CMDTextDescription.TextWrap = true
					CMDTextDescription.TextWrapped = true
					CMDTextDescription.TextXAlignment = Enum.TextXAlignment.Left
					CMDTextDescription.ZIndex = 3

					local UITextSizeConstraint = Instance.new("UITextSizeConstraint"); do
						UITextSizeConstraint.MaxTextSize = 13
						UITextSizeConstraint.Parent = CMDTextDescription
					end
					CMDTextDescription.Parent = CMDDescription
				end
				CMDDescription.Parent = ExecutionCentre
			end
			CMDList.Parent = Main
		end

		Drag_1 = Instance.new("Frame"); do
			Drag_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Drag_1.BackgroundTransparency = 1
			Drag_1.Name = "Drag"
			Drag_1.Size = UDim2.new(0,318,0,30)
			Drag_1.Parent = Main
		end

		Main.Parent = ExecutionCentre
	end
	ExecutionCentre.Parent = GuiParent
end

-- :: Functions

local function ExecuteCommand(Text)
	local Arguments = string.split(Text," ")
	local Command = Arguments[1]; table.remove(Arguments,1)

	for i,v in pairs(Commands) do
		if table.find(i,string.lower(Command)) then
			v.Function(Arguments)
		end
	end
end

AddCommand = function(name,arguments,description,func,addtotable)
	if addtotable then
		Commands[{name}] = {
			Arguments = unpack(arguments),
			Description = description,
			Function = func
		}
	end

	local CommandLabel = ExampleCommand:Clone(); do
		local Arguments = ""; do
			for _,v in pairs(arguments) do
				Arguments ..= " <" .. v .. "> "
			end
		end

		CommandLabel.Text = "• " .. name .. Arguments
		CommandLabel.Name = name
		CommandLabel.Visible = true
		CommandLabel.Parent = CommandsFolder

		CommandLabel.MouseEnter:Connect(function()
			if DescriptionStepped then DescriptionStepped:Disconnect() end
			if HoveredCommand == CommandLabel then return end

			HoveredCommand = CommandLabel
			CMDDescription.Visible = true

			CMDTextDescription.Text = description

			DescriptionStepped = RunService.RenderStepped:Connect(function()
				local MousePosition = UserInputService:GetMouseLocation()

				CMDDescription.Position = UDim2.new(0,MousePosition.X+11,0,MousePosition.Y-25)
			end)
		end)

		CommandLabel.MouseLeave:Connect(function()
			if HoveredCommand ~= CommandLabel then return end
			if DescriptionStepped then DescriptionStepped:Disconnect() end

			CMDDescription.Visible = false
			HoveredCommand = nil
		end)
	end
end

-- :: Code

do -- // CmdList
	Resizer.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not Dragging then
			local OriginalSize = CMDMain.Size
			local MousePosition = UserInputService:GetMouseLocation()
			local RenderStepped
			Dragging = true
			Mouse.Icon = "rbxasset://textures/Cursors/mouseIconCameraTrack.png"

			SearchIcon.Active = false
			SearchInput.Active = false
			CMDCloseGui.Active = false

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					RenderStepped:Disconnect()
					Mouse.Icon = ""
					Dragging = false
					SearchIcon.Active = true
					SearchInput.Active = true
					CMDCloseGui.Active = true
				end
			end)

			RenderStepped = RunService.RenderStepped:Connect(function(Alpha)
				local delta = (MousePosition - UserInputService:GetMouseLocation())
				local yGoal = (OriginalSize.Y.Offset - delta.Y)
				yGoal = yGoal <= 50 and 50 or yGoal > 320 and 320 or yGoal

				CMDMain.Size = UDim2.new(0,320,0,yGoal)
				Mouse.Icon = "rbxasset://textures/Cursors/mouseIconCameraTrack.png"

				CMDSearchBar.Visible = yGoal >= 310
				CMDList_1.Visible = yGoal >= 51
				CMDList_1.Size = yGoal >= 310 and UDim2.new(0,300,0,205) or UDim2.new(0,300,0,240)
			end)
		end
	end)

	ListDrag.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not Dragging then
			local OriginalPosition = CMDMain.AbsolutePosition
			local MousePosition = UserInputService:GetMouseLocation()
			local RenderStepped
			Dragging = true
			Mouse.Icon = "rbxasset://textures/Cursors/mouseIconCameraTrack.png"

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					RenderStepped:Disconnect()
					Mouse.Icon = ""
					Dragging = false
				end
			end)

			RenderStepped = RunService.RenderStepped:Connect(function(Alpha)
				local delta = (MousePosition - UserInputService:GetMouseLocation())

				CMDMain.Position = UDim2.new(0,(OriginalPosition.X - delta.X),0,(OriginalPosition.Y - delta.Y))
				Mouse.Icon = "rbxasset://textures/Cursors/mouseIconCameraTrack.png"
			end)
		end
	end)

	Resizer.MouseEnter:Connect(function()
		if Dragging then return end
		Mouse.Icon = "rbxasset://textures/Cursors/mouseIconCameraTrack.png"
	end)

	Resizer.MouseLeave:Connect(function()
		if Dragging then return end
		Mouse.Icon = ""
	end)

	CMDCloseGui.Activated:Connect(function()
		CMDMain.Visible = false
	end)
end

do -- // Execution Bar
	Drag_1.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not Dragging then
			local OriginalPosition = Main.AbsolutePosition
			local MousePosition = UserInputService:GetMouseLocation()
			local RenderStepped
			Dragging = true
			Mouse.Icon = "rbxasset://textures/Cursors/mouseIconCameraTrack.png"

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					RenderStepped:Disconnect()
					Mouse.Icon = ""
					Dragging = false
				end
			end)

			RenderStepped = RunService.RenderStepped:Connect(function(Alpha)
				local delta = (MousePosition - UserInputService:GetMouseLocation())

				Main.Position = UDim2.new(0,(OriginalPosition.X - delta.X),0,(OriginalPosition.Y - delta.Y))
				Mouse.Icon = "rbxasset://textures/Cursors/mouseIconCameraTrack.png"
			end)
		end
	end)

	OpenButton.Activated:Connect(function()
		OpenButton.Visible = false
		Main.Visible = true
	end)

	CloseGui.Activated:Connect(function()
		OpenButton.Visible = true
		Main.Visible = false
	end)

	ExecutionBarInput.FocusLost:Connect(function(enter)
		if enter then ExecuteCommand(ExecutionBarInput.Text) end

		ExecutionBarInput.Text = ""
	end)
end

-- Start

local RagdollRemotes = {}
local DeragdollRemotes = {}

for _, Remote in game:GetDescendants() do 
	if Remote:IsA("RemoteEvent") and string.match(string.lower(Remote.Name),"ragdoll") then
		if not string.match(string.lower(Remote.Name), "un") then
			RagdollRemotes[Remote] = {"FireServer", "Ball"}
		else
			DeragdollRemotes[Remote] = {"FireServer", "Ball"}
		end
	elseif Remote:IsA("RemoteFunction") and string.match(string.lower(Remote.Name),"ragdoll") then 
		if not string.match(string.lower(Remote.Name), "un") then
			RagdollRemotes[Remote] = {"InvokeServer", nil}
		else
			DeragdollRemotes[Remote] = {"InvokeServer", nil}
		end
	end
end

local Prefix = Enum.KeyCode.Semicolon
local HoldingControl = nil
local HoldingAlt = nil
local AnimationPlayer = nil
local RespawnHandler = nil

local KeyAliasMap = {
	["-"] = Enum.KeyCode.Minus,
	["="] = Enum.KeyCode.Equals,
	["["] = Enum.KeyCode.LeftBracket,
	["]"] = Enum.KeyCode.RightBracket,
	[";"] = Enum.KeyCode.Semicolon,
	["'"] = Enum.KeyCode.Quote,
	[","] = Enum.KeyCode.Comma,
	["."] = Enum.KeyCode.Period,
	["/"] = Enum.KeyCode.Slash,
	["\\"] = Enum.KeyCode.BackSlash,
	["`"] = Enum.KeyCode.Backquote,
	["ctrl"] = Enum.KeyCode.LeftControl,
	["lctrl"] = Enum.KeyCode.LeftControl,
	["rctrl"] = Enum.KeyCode.RightControl,
	["shift"] = Enum.KeyCode.LeftShift,
	["lshift"] = Enum.KeyCode.LeftShift,
	["rshift"] = Enum.KeyCode.RightShift,
	["alt"] = Enum.KeyCode.LeftAlt,
	["lalt"] = Enum.KeyCode.LeftAlt,
	["ralt"] = Enum.KeyCode.RightAlt,
	["esc"] = Enum.KeyCode.Escape,
	["del"] = Enum.KeyCode.Delete,
}

local function FindKeyCode(UserInput)
	if not UserInput then return nil end
	local LowerInput = string.lower(UserInput)

	if KeyAliasMap[LowerInput] then
		return KeyAliasMap[LowerInput]
	end

	for _, KeyCode in Enum.KeyCode:GetEnumItems() do
		if string.lower(KeyCode.Name) == LowerInput then
			return KeyCode
		end
	end

	return nil
end

local Animations = {
    ['Freestylin'] = 4432024917,
    ['Floss'] = 4812941481,
    ['Smooth Moves'] = 4900539662,
    ['Aerostepping'] = 4776588732,
    ['ElectroSwing'] = 3485013176,
    ['MinecraftParrot'] = 4300228160,
    ['CaramellDansen'] = 6607554805,
    ['Breakdown'] = 4558409610,
    ['OrangeJustice'] = 3262592866,
    ['Smug'] = 3450125501,
    ['Crabby'] = 3643129020,
    ['Conga'] = 4572096542,
    ['DreamFeet'] = 4300218011,
    ['KazotskyKick'] = 4846209506,
    ['Radical'] = 4686555525,
    ['TakeTheL'] = 4827299133,
    ['Laughing'] = 4846000379,
    ['Drip'] = 4959380041,
    ['Pushups'] = 99504427539243
}

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Prefix then
		ExecutionBarInput:CaptureFocus() task.wait()
		ExecutionBarInput.Text = ""
	end
	
	if input.KeyCode == Enum.KeyCode.LeftControl then
		HoldingControl = true
	end

	if input.KeyCode == Enum.KeyCode.LeftAlt then
		HoldingAlt = true
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.LeftControl then
		HoldingControl = nil
	end

	if input.KeyCode == Enum.KeyCode.LeftAlt then
		HoldingAlt = nil
	end
end)

local function Reanimate()
	-- Based off Kade's Myworld Testing Place Reanimate
	-- Ragdoll Method by Hemi/Kaiya

	local Events = {}
	local Offsets = {}
	local Joints = {}
	local JointsOffsets = {}
	local FrameTimes = {}
	local FrameData = {}
	local CurrentAnimation

	local GetDescendants = game.GetDescendants
	local FindFirstChild = game.FindFirstChild
	local FindFirstChildOfClass = game.FindFirstChildOfClass
	local IsDescendantOf = game.IsDescendantOf
	local GetChildren = game.GetChildren
	local Destroy = game.Destroy
	local Close = game.Close

	local SignalOnce = Close['Once']
	local Disconnect = SignalOnce(Close, function() end)['Disconnect']

	local Respawn = Instance.new("BindableEvent")

	local InsertService = game:GetService("InsertService")
	local Workspace = game:GetService("Workspace")

	if FindFirstChild(Workspace,  "!!!!KadeRig") then
		warn(`[freesmart.xyz] Reanimation already running!`)
		return
	end
	
	local RunService = game:GetService("RunService")
	local StarterGui = game:GetService("StarterGui")
	local Players = game:GetService("Players")

	local Player = Players.LocalPlayer

	local Character = Player.Character
	local RootPart = Character:WaitForChild("HumanoidRootPart", 3)
	local OriginalRootSize = RootPart.Size
	local Humanoid = FindFirstChildOfClass(Character, "Humanoid")
	local RigType = Humanoid.RigType.Name
	Character.Archivable = true

	local _Animate = Character:FindFirstChild("Animate")
	if _Animate then
		_Animate.Disabled = true

		for _, Track in Humanoid:GetPlayingAnimationTracks() do
			Track:Stop()
		end
	end

	local FakeRig = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6)
	FakeRig.Name = "!!!!KadeRig"
	FakeRig.Parent = Workspace
	Workspace.CurrentCamera.CameraSubject = FakeRig

	local FakeRigDescendants = GetDescendants(FakeRig)
	local FakeHumanoid = FindFirstChildOfClass(FakeRig, "Humanoid")
	local FakeRoot = FindFirstChild(FakeRig, "HumanoidRootPart")
	local function ObtainMeshAndTextureOfAccessory(Accessory)
		local Handle = FindFirstChild(Accessory, "Handle")
		local IfMesh = FindFirstChildOfClass(Handle, "SpecialMesh")

		if Handle:IsA("MeshPart") then
			return {MeshId = Handle.MeshId, TextureId = Handle.TextureID}
		elseif IfMesh then
			return {MeshId = IfMesh.MeshId, TextureId = IfMesh.TextureId}
		end
	end

	for Remote, Info in RagdollRemotes do
		Remote[Info[1]](Remote, Info[2])
	end

	for _, FakePart in next, FakeRigDescendants do
		if FakePart:IsA("BasePart") then
			FakePart.Transparency = 1
						
			local RealPart = FindFirstChild(Character, FakePart.Name)

			if RealPart then
				RealPart.CollisionGroup = RootPart.CollisionGroup

				if RigType == "R6" then
					Offsets[RealPart] = {FakePart, CFrame.identity}
				end
			end
		elseif FakePart:IsA("Decal") then
			FakePart.Transparency = 1
		elseif FakePart:IsA("Motor6D") then
			local Name = FakePart.Part1.Name

			JointsOffsets[Name] = FakePart.Transform
			Joints[Name] = FakePart
		end
	end

	local R15Offsets = {
		["Head"] = {FindFirstChild(FakeRig, "Head"), CFrame.identity},
		["HumanoidRootPart"] = {FindFirstChild(FakeRig, "HumanoidRootPart"), CFrame.identity},
		["UpperTorso"] = {FindFirstChild(FakeRig, "Torso"), CFrame.new(0, 0.194, 0)},
		["LowerTorso"] = {FindFirstChild(FakeRig, "Torso"), CFrame.new(0, -0.79, 0)},
		["RightUpperArm"] = {FindFirstChild(FakeRig, "Right Arm"), CFrame.new(0, 0.4085, 0)},
		["RightLowerArm"] = {FindFirstChild(FakeRig, "Right Arm"), CFrame.new(0, -0.184, 0)},
		["RightHand"] = {FindFirstChild(FakeRig, "Right Arm"), CFrame.new(0, -0.83, 0)},
		["LeftUpperArm"] = {FindFirstChild(FakeRig, "Left Arm"), CFrame.new(0, 0.4085, 0)},
		["LeftLowerArm"] = {FindFirstChild(FakeRig, "Left Arm"), CFrame.new(0, -0.184, 0)},
		["LeftHand"] = {FindFirstChild(FakeRig, "Left Arm"), CFrame.new(0, -0.83, 0)},
		["RightUpperLeg"] = {FindFirstChild(FakeRig, "Right Leg"), CFrame.new(0, 0.575, 0)},
		["RightLowerLeg"] = {FindFirstChild(FakeRig, "Right Leg"), CFrame.new(0, -0.199, 0)},
		["RightFoot"] = {FindFirstChild(FakeRig, "Right Leg"), CFrame.new(0, -0.849, 0)},
		["LeftUpperLeg"] = {FindFirstChild(FakeRig, "Left Leg"), CFrame.new(0, 0.575, 0)},
		["LeftLowerLeg"] = {FindFirstChild(FakeRig, "Left Leg"), CFrame.new(0, -0.199, 0)},
		["LeftFoot"] = {FindFirstChild(FakeRig, "Left Leg"), CFrame.new(0, -0.849, 0)}
	}

	for Name, Input in R15Offsets do
		local Limb = FindFirstChild(Character, Name)
		if not Limb then
			continue
		end

		Limb.CollisionGroup = RootPart.CollisionGroup
		Offsets[Limb] = Input
	end

	Events[1] = RunService.PreSimulation:Connect(function()
		for RealPart, Info in next, Offsets do
			local FakePart = Info[1]

			RealPart.CanCollide = false
			RealPart.CanQuery = false
			RealPart.CanTouch = false
			RealPart.Massless = true

			RealPart.AssemblyLinearVelocity = FakePart.AssemblyLinearVelocity
			RealPart.AssemblyAngularVelocity = FakePart.AssemblyAngularVelocity
		end
	end)

	Events[2] = RunService.PostSimulation:Connect(function()
		for RealPart, Info in Offsets do
			local FakePart = Info[1]
			local Offset = Info[2]

			RealPart.CFrame = FakePart.CFrame * Offset
		end

		FakeHumanoid.Jump = Humanoid.Jump
		FakeHumanoid:Move(Humanoid.MoveDirection, false)
	end)

	local function StopAnimationThread()
		if AnimationThread then
			Disconnect(AnimationThread)
			AnimationThread = nil
		end

		if CurrentAnimation then
			Destroy(CurrentAnimation)
		end
		
		for Name, Joint in Joints do
			Joint.Transform = JointsOffsets[Name]
		end

		table.clear(FrameTimes)
		table.clear(FrameData)

	end

	RespawnHandler = function()
		StarterGui:SetCore("ResetButtonCallback", true)
		for _, Signal in next, Events do
			Disconnect(Signal)
		end

		table.clear(Offsets)
		table.clear(Events)

		Workspace.CurrentCamera.CameraSubject = Character
		StopAnimationThread()
		FakeRig:Destroy()
		AnimationPlayer = nil
		RespawnHandler = nil

		for Remote, Info in DeragdollRemotes do
			Remote[Info[1]](Remote, Info[2])
		end

		RootPart.Size = OriginalRootSize
		if _Animate and _Animate.Parent then
			_Animate.Disabled = false
		end
		Humanoid:ChangeState(2)
		Humanoid:ChangeState(7)
	end

	Character:GetPropertyChangedSignal("Parent"):Connect(RespawnHandler)
	Respawn.Event:Connect(RespawnHandler)

	RootPart.RootPriority = 1
	RootPart.Size = Vector3.zero
	Humanoid:ChangeState(16)
	FakeRig:PivotTo(RootPart.CFrame * CFrame.new(0, 2, 0))
	StarterGui:SetCore("ResetButtonCallback", Respawn)

	warn(`[freesmart.xyz] Reanimation Loaded (made by gelatek, creds to kayia for method)`)

	-- Animator
	AnimationPlayer = {
		Start = function(AnimationID: number)
			if not FakeRig and not FakeRoot then 
				warn('[freesmart.xyz] Animation Failed to load (no active reanimate)')
				return
			end
			local Lerp = FakeRoot.CFrame.Lerp

			StopAnimationThread()

			local Animate = FindFirstChild(FakeRig, "Animate")
			if Animate then Animate.Disabled = true end

			local Success, AnimationModel = pcall(InsertService.LoadLocalAsset, InsertService, "rbxassetid://" .. tostring(AnimationID))
			if not Success then warn("Failed to load animation.") return end

			CurrentAnimation = AnimationModel
			CurrentAnimation.Name = "Animation"
			CurrentAnimation.Parent = FakeRig

			table.clear(FrameTimes)
			table.clear(FrameData)

			for _, Frame in GetChildren(CurrentAnimation) do
				table.insert(FrameTimes, Frame.Time)
				FrameData[Frame.Time] = {}

				for _, Part in GetDescendants(Frame) do
					FrameData[Frame.Time][Part.Name] = Part
				end
			end

			table.sort(FrameTimes)
			
			local AnimationLength = FrameTimes[#FrameTimes]
			local StartTime = os.clock()

			AnimationThread = RunService.Heartbeat:Connect(function()
				if not IsDescendantOf(FakeRig, Workspace) then return end

				local Elapsed = (os.clock() - StartTime) % AnimationLength

				local _Index = 1
				while _Index < #FrameTimes and FrameTimes[_Index + 1] <= Elapsed do
					_Index += 1
				end

				local _Current = FrameTimes[_Index]
				local _Next = FrameTimes[_Index + 1] or _Current
				local Alpha = (Elapsed - _Current) / (_Next - _Current)
				local Frame1 = FrameData[_Current]
				local Frame2 = FrameData[_Next]

				for Name, Part1 in Frame1 do
					local Part2 = Frame2 and Frame2[Name]
					local Joint = Joints[Name]
					if Part1 and Part2 and Joint then
						local Transform = Lerp(Part1.CFrame, Part2.CFrame, Alpha)
						Joint.Transform = Transform
					end
				end
			end)
		end,

		Stop = StopAnimationThread
	}

	warn(`[freesmart.xyz] Animation Handler Embedded.`)
end

Commands[{"dex", "explorer"}] = {
	Arguments = {},
	Description = "runs dex explorer by moon and the other guy",
	Function = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
	end
}

Commands[{"saveinstance", "saveplace", "dumpgame"}] = {
	Arguments = {"safeMode"},
	Description = "uses synsaveins to save place, safemode kicks you to bypass ac",
	Function = function(Args)
		local SafeMode = Args[1]
		SafeMode = string.lower(SafeMode or "") == "true" or string.lower(SafeMode or "") == "y" and true or false

		local Params = {
			RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
			SSI = "saveinstance",
		}
		
		local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
		
		local CustomOptions = { SafeMode = SafeMode }
		
		synsaveinstance(CustomOptions)
	end
}

Commands[{"fling","f"}] = {
	Arguments = {"PlayerName"},
	Description = "Flings the target",
	Function = function(Args)
		local Character = LocalPlayer.Character
		local Name: string = Args[1]

		for _, Player: Player in Players:GetPlayers() do
			if string.match(Player.Name:lower(), Name) or string.match(Player.DisplayName:lower(), Name) then
				local SavePos = Character.PrimaryPart.CFrame

				local RootPart = Character:FindFirstChild("HumanoidRootPart")

				if not RootPart then
					return
				end
				
				local _RootPart = Player.Character.PrimaryPart
				if not _RootPart then
					return
				end

				for _ = 0, 32 do
					RootPart.AssemblyLinearVelocity = Vector3.new(1,1,1) * 16000
					RootPart.CFrame = _RootPart.CFrame + Vector3.new(0, math.random(-2, 2), 0) + _RootPart.AssemblyLinearVelocity / 2

					task.wait()
				end
				
				task.wait(.1)
				RootPart.AssemblyLinearVelocity = Vector3.zero
				RootPart.AssemblyAngularVelocity = Vector3.zero

				task.wait(.1)

				RootPart.CFrame = SavePos

				break
			end
		end
	end,
}

Commands[{"flingclick","fc"}] = {
	Arguments = {},
	Description = "multitime use, ctrl + left click on target to fling...",
	Function = function()
		if Signals['FlingLoopClick'] then
			Signals['FlingLoopClick']:Disconnect()
			Signals['FlingLoopClick'] = nil

			return
		end

		Signals['FlingLoopClick'] = UserInputService.InputBegan:Connect(function(Input)
			if HoldingControl and Input.UserInputType == Enum.UserInputType.MouseButton1 then
				local Character = LocalPlayer.Character

				local ___ =  Mouse.Target
				local _1 = ___.Parent

				local Target = ___ and (_1:IsA("Model") and _1 or _1.Parent:IsA("Model") and _1.Parent)
				
				if not Target then
					return
				end

				local SavePos = Character.PrimaryPart.CFrame

				local RootPart = Character:FindFirstChild("HumanoidRootPart")

				if not RootPart then
					return
				end
				
				local _RootPart = Target.PrimaryPart
				if not _RootPart then
					return
				end

				for _ = 0, 32 do
					RootPart.AssemblyLinearVelocity = Vector3.new(1,1,1) * 16000
					RootPart.CFrame = _RootPart.CFrame + Vector3.new(0, math.random(-2, 2), 0) + _RootPart.AssemblyLinearVelocity / 2

					task.wait()
				end
				
				task.wait()
				RootPart.AssemblyLinearVelocity = Vector3.zero
				RootPart.AssemblyAngularVelocity = Vector3.zero
				RootPart.Anchored = true
				task.wait()

				RootPart.Anchored = false
				RootPart.CFrame = SavePos
			end
		end)
	end,
}

Commands[{"getplayerdata","gpd"}] = {
	Arguments = {},
	Description = "multi use, click on target to print their name...",
	Function = function()
		if Signals['PlayerDataLoop'] then
			Signals['PlayerDataLoop']:Disconnect()
			Signals['PlayerDataLoop'] = nil

			return
		end

		Signals['PlayerDataLoop'] = UserInputService.InputBegan:Connect(function(Input)
			if HoldingAlt and Input.UserInputType == Enum.UserInputType.MouseButton1 then

				local ___ =  Mouse.Target
				local _1 = ___.Parent

				local Target = ___ and (_1:IsA("Model") and _1 or _1.Parent:IsA("Model") and _1.Parent)
				
				if not Target then
					return
				end
				
				local Player = Players:GetPlayerFromCharacter(Target)
				
				if not Player then
					return
				end

				local InfoDump = table.concat({
					`[freesmart.xyz]: Dump for {Player.Name}`,
					`- UserId: {Player.UserId}`,
					`- DisplayName: {Player.DisplayName}`,
					`- AccountAge: {Player.AccountAge} days`,
				}, "\n")

				if setclipboard then
					setclipboard(InfoDump)
				end

				warn(InfoDump)
			end
		end)
	end,
}

Commands[{"clickgoto", "cgoto", "cg"}] = {
	Arguments = {},
	Description = "multiuse, ctrl+scroll-click anywhere to be tped",
	Function = function()
		local Character = LocalPlayer.Character

		if Signals['ClickGoto'] then
			Signals['ClickGoto']:Disconnect()
			Signals['ClickGoto'] = nil
			print("disconnected!")

			return
		end

		Signals['ClickGoto'] = UserInputService.InputBegan:Connect(function(Input)
			print(
				HoldingControl and Input.UserInputType == Enum.UserInputType.MouseButton3,
				Input.UserInputType == Enum.UserInputType.MouseButton3,
				HoldingControl
			)

			if HoldingControl and Input.UserInputType == Enum.UserInputType.MouseButton3 then
				local RootPart = Character:FindFirstChild("HumanoidRootPart")

				if not RootPart then
					return
				end
				
				RootPart.CFrame = CFrame.new(Mouse.Hit.Position) * CFrame.new(0, 2, 0)
			end
		end)
	end,
}

Commands[{"goto", "tp"}] = {
	Arguments = {"PlayerName"},
	Description = "detection on all devices.",
	Function = function(Args)
		local Character = LocalPlayer.Character
		local Name = Args[1]

		for _, Player: Player in Players:GetPlayers() do
			if string.match(Player.Name:lower(), Name) or string.match(Player.DisplayName:lower(), Name) then
				local Target = Player.Character

				if not Target then
					return
				end

				local RootPart = Character:FindFirstChild("HumanoidRootPart")

				if not RootPart then
					return
				end
				
				local _RootPart = Target.PrimaryPart
				if not _RootPart then
					return
				end

				for _ = 0, 6 do
					RootPart.CFrame = _RootPart.CFrame
				end

				break
			end
		end
	end,
}

Commands[{"r6", "reanim"}] = {
	Arguments = {},
	Description = "loads r6 reanimate, requires ragdoll",
	Function = Reanimate
}

Commands[{"unr6", "dereanim"}] = {
	Arguments = {},
	Description = "de-reanimates you (better to respawn atm)",
	Function = function()
		if RespawnHandler then
			RespawnHandler()
		end
	end
}

Commands[{"playanim"}] = {
	Arguments = {"animation_id_or_name"},
	Description = "(!!! reanim first) loads r6 animation",
	Function = function(Args)
		local Input = Args[1]

		if not Input then return end 
        local PlayID = nil

		Input = string.lower(Input)

		if not PlayID then
            PlayID = tonumber(Input)
        end

        for Name, AnimationID in Animations do
            if string.match(Name:lower(), Input) then
                PlayID = AnimationID
                break
            end
        end

        if PlayID and AnimationPlayer then
            AnimationPlayer.Start(PlayID)
        else
            print("['freesmart.xyz'] Animation not found: " .. Input)
        end
	end
}

Commands[{"stopanim"}] = {
	Arguments = {},
	Description = "(!!! reanim first) loads r6 animation",
	Function = function()
		if AnimationPlayer then
			AnimationPlayer.Stop()
		end
	end
}

Commands[{"printanims"}] = {
	Arguments = {},
	Description = "(!!! reanim first) prints all the preset anims in console",
	Function = function()
		table.foreach(Animations, print)
	end
}

Commands[{"prefix", "pr"}] = {
	Arguments = {"newPrefix"},
	Description = "changes prefix (default is ;)",
	Function = function(Args)
		local NewKeyName = Args[1]
		local FoundKeyCode = FindKeyCode(NewKeyName)

		if FoundKeyCode then
			Prefix = FoundKeyCode
			ExecutionBarInput.PlaceholderText = `Input here. Prefix: {NewKeyName}`
		end
	end
}

for i,v in pairs(Commands) do
	AddCommand(i[1],v.Arguments,v.Description,nil,false)
end
