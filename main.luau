-- UI
local G2L = {};
local LocalPlayer = game:FindFirstChildOfClass("Players").LocalPlayer
G2L["1"] = Instance.new("ScreenGui", gethui and gethui() or pcall(game.GetService, game, "CoreGui") and game.CoreGui or LocalPlayer:WaitForChild("PlayerGui"))
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
G2L["2"]=Instance.new("Frame",G2L["1"])G2L["2"]["BorderSizePixel"]=0;G2L["2"]["BackgroundColor3"]=Color3.fromRGB(49,49,49)G2L["2"]["AnchorPoint"]=Vector2.new(0.5,0.5)G2L["2"]["Size"]=UDim2.new(0,250,0,97)G2L["2"]["Position"]=UDim2.new(0.5,-24,0.37186,71)G2L["2"]["BorderColor3"]=Color3.fromRGB(0,0,0)G2L["3"]=Instance.new("UICorner",G2L["2"])G2L["3"]["CornerRadius"]=UDim.new(0,4)G2L["4"]=Instance.new("UIStroke",G2L["2"])G2L["4"]["Thickness"]=2;G2L["4"]["Color"]=Color3.fromRGB(95,95,95)G2L["5"]=Instance.new("Frame",G2L["2"])G2L["5"]["BorderSizePixel"]=0;G2L["5"]["BackgroundColor3"]=Color3.fromRGB(255,255,255)G2L["5"]["AnchorPoint"]=Vector2.new(0.5,0.5)G2L["5"]["Size"]=UDim2.new(1,-20,1,-50)G2L["5"]["Position"]=UDim2.new(0.5,0,0.5,15)G2L["5"]["BorderColor3"]=Color3.fromRGB(0,0,0)G2L["5"]["Name"]=[[Loader]]G2L["5"]["BackgroundTransparency"]=1;G2L["6"]=Instance.new("Frame",G2L["5"])G2L["6"]["BorderSizePixel"]=0;G2L["6"]["BackgroundColor3"]=Color3.fromRGB(255,255,255)G2L["6"]["AnchorPoint"]=Vector2.new(0,1)G2L["6"]["Size"]=UDim2.new(1,0,-0.25424,30)G2L["6"]["Position"]=UDim2.new(0,0,1,0)G2L["6"]["BorderColor3"]=Color3.fromRGB(0,0,0)G2L["6"]["Name"]=[[ProgressBar]]G2L["7"]=Instance.new("UIStroke",G2L["6"])G2L["7"]["Color"]=Color3.fromRGB(141,141,141)G2L["8"]=Instance.new("Frame",G2L["6"])G2L["8"]["BorderSizePixel"]=0;G2L["8"]["BackgroundColor3"]=Color3.fromRGB(126,255,126)G2L["8"]["Size"]=UDim2.new(0.1,0,1,0)G2L["8"]["BorderColor3"]=Color3.fromRGB(0,0,0)G2L["8"]["Name"]=[[Color]]G2L["9"]=Instance.new("TextLabel",G2L["5"])G2L["9"]["BorderSizePixel"]=0;G2L["9"]["TextSize"]=14;G2L["9"]["TextYAlignment"]=Enum.TextYAlignment.Top;G2L["9"]["BackgroundColor3"]=Color3.fromRGB(255,255,255)G2L["9"]["FontFace"]=Font.new([[rbxasset://fonts/families/Inconsolata.json]],Enum.FontWeight.Regular,Enum.FontStyle.Normal)G2L["9"]["TextColor3"]=Color3.fromRGB(255,255,255)G2L["9"]["BackgroundTransparency"]=1;G2L["9"]["AnchorPoint"]=Vector2.new(1,0)G2L["9"]["Size"]=UDim2.new(1,0,-0.21277,30)G2L["9"]["BorderColor3"]=Color3.fromRGB(0,0,0)G2L["9"]["Text"]=[[Searching for Modules.]]G2L["9"]["Name"]=[[ProgressTitle]]G2L["9"]["Position"]=UDim2.new(1,0,0,0)G2L["a"]=Instance.new("Frame",G2L["2"])G2L["a"]["BorderSizePixel"]=0;G2L["a"]["BackgroundColor3"]=Color3.fromRGB(44,44,44)G2L["a"]["Size"]=UDim2.new(1,0,0.008,30)G2L["a"]["BorderColor3"]=Color3.fromRGB(0,0,0)G2L["a"]["Name"]=[[TopBar]]G2L["b"]=Instance.new("UICorner",G2L["a"])G2L["b"]["CornerRadius"]=UDim.new(0,4)G2L["c"]=Instance.new("TextLabel",G2L["a"])G2L["c"]["BorderSizePixel"]=0;G2L["c"]["TextSize"]=14;G2L["c"]["TextXAlignment"]=Enum.TextXAlignment.Left;G2L["c"]["BackgroundColor3"]=Color3.fromRGB(255,255,255)G2L["c"]["FontFace"]=Font.new([[rbxasset://fonts/families/GothamSSm.json]],Enum.FontWeight.Regular,Enum.FontStyle.Normal)G2L["c"]["TextColor3"]=Color3.fromRGB(255,255,255)G2L["c"]["BackgroundTransparency"]=1;G2L["c"]["Size"]=UDim2.new(1,-10,1,0)G2L["c"]["BorderColor3"]=Color3.fromRGB(0,0,0)G2L["c"]["Text"]=[[freesmart.xyz | loader]]G2L["c"]["Name"]=[[Title]]G2L["c"]["Position"]=UDim2.new(0,10,0,0)G2L["d"]=Instance.new("Frame",G2L["a"])G2L["d"]["BorderSizePixel"]=0;G2L["d"]["BackgroundColor3"]=Color3.fromRGB(44,44,44)G2L["d"]["AnchorPoint"]=Vector2.new(0,1)G2L["d"]["Size"]=UDim2.new(1,0,-0.66667,30)G2L["d"]["Position"]=UDim2.new(0,0,1,0)G2L["d"]["BorderColor3"]=Color3.fromRGB(0,0,0)G2L["d"]["Name"]=[[GapFill]]G2L["e"]=Instance.new("UIDragDetector",G2L["2"])G2L["e"]["DragUDim2"]=UDim2.new(0,-24,0,71)

-- Main
local RagdollHandler;
local Loader;

local ScreenGui = G2L['1']
local Color = G2L["8"]
local Progress = G2L["9"]

local function ChangeProgress(Size, Text)
	Color.Size = UDim2.new(Size, 0, 1, 0)
	Progress.Text = Text

	task.wait(1)
end

ChangeProgress(0.25, "Loading Ragdoller, can take 20s.")
RagdollHandler = loadstring(game:HttpGet("https://raw.githubusercontent.com/KadeTheExploiter/freesmart.xyz/refs/heads/main/libs/ragdoller.luau"))()
ChangeProgress(0.75, "Loading Main UI")
Loader = loadstring(game:HttpGet("https://raw.githubusercontent.com/KadeTheExploiter/freesmart.xyz/refs/heads/main/main.luau"))()
ChangeProgress(1, "Loaded!")
ScreenGui:Destroy()
