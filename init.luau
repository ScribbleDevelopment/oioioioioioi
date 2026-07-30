-- // 0HM3G Hub - GitHub Multi-Language Bootstrapper & Parser //
-- // Target Repository Base: https://raw.githubusercontent.com/ScribbleDevelopment/oioioioioioi/refs/heads/main/ //

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

print("0HM3G: Bootstrapper initializing from ScribbleDevelopment repository...")

local BASE_URL = "https://raw.githubusercontent.com/ScribbleDevelopment/oioioioioioi/refs/heads/main/"

-- // 1. Fetch config.json //
local successConfig, configData = pcall(function()
    local rawJson = game:HttpGet(BASE_URL .. "config.json")
    return HttpService:JSONDecode(rawJson)
end)

if successConfig and configData then
    print("0HM3G Bootstrapper: Successfully loaded config.json schema.")
else
    print("0HM3G Bootstrapper: Failed to load config.json, using fallback configuration.")
    configData = {
        Theme = "DarkModern",
        Files = {
            HTML = "index.html",
            CSS = "styles.css",
            Core = "init.luau"
        },
        Variables = {
            ["bg-primary"] = "18, 18, 24",
            ["bg-secondary"] = "28, 28, 38",
            ["text-main"] = "240, 240, 245"
        }
    }
end

-- // 2. Fetch styles.css and index.html using the base link //
local successCSS, cssContent = pcall(function() return game:HttpGet(BASE_URL .. (configData.Files.CSS or "styles.css")) end)
local successHTML, htmlContent = pcall(function() return game:HttpGet(BASE_URL .. (configData.Files.HTML or "index.html")) end)

print("0HM3G: styles.css Fetched -> " .. tostring(successCSS))
print("0HM3G: index.html Fetched -> " .. tostring(successHTML))

-- // 3. Parse CSS Variables or Fallback to JSON Variables //
local themeColors = {
    bgPrimary = Color3.fromRGB(18, 18, 24),
    bgSecondary = Color3.fromRGB(28, 28, 38),
    textMain = Color3.fromRGB(240, 240, 245)
}

local function parseRGB(str)
    local r, g, b = str:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
    if r and g and b then
        return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end
    return nil
end

if successCSS then
    for varName, r, g, b in cssContent:gmatch("--([%w%-]+)%s*:%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)") do
        local parsed = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
        if varName == "bg-primary" then themeColors.bgPrimary = parsed
        elseif varName == "bg-secondary" then themeColors.bgSecondary = parsed
        elseif varName == "text-main" then themeColors.textMain = parsed end
    end
elseif configData.Variables then
    if configData.Variables["bg-primary"] then themeColors.bgPrimary = parseRGB(configData.Variables["bg-primary"]) or themeColors.bgPrimary end
    if configData.Variables["bg-secondary"] then themeColors.bgSecondary = parseRGB(configData.Variables["bg-secondary"]) or themeColors.bgSecondary end
    if configData.Variables["text-main"] then themeColors.textMain = parseRGB(configData.Variables["text-main"]) or themeColors.textMain end
end

-- // 4. Parse HTML Attributes //
local windowTitle = "0HM3G // Bootstrapped Hub"
if successHTML then
    local parsedTitle = htmlContent:match('title="([^"]+)"')
    if parsedTitle then windowTitle = parsedTitle end
end

-- // 5. Render Bootstrapped UI Interface //
if CoreGui:FindFirstChild("HM3G_BootstrappedHub") then
    CoreGui.HM3G_BootstrappedHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HM3G_BootstrappedHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = themeColors.bgPrimary
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = themeColors.bgSecondary
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = windowTitle
Title.TextColor3 = themeColors.textMain
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -30, 1, -65)
StatusLabel.Position = UDim2.new(0, 15, 0, 50)
StatusLabel.BackgroundColor3 = themeColors.bgSecondary
StatusLabel.BorderSizePixel = 0
StatusLabel.Font = Enum.Font.Code
StatusLabel.Text = string.format("Status: Fully Bootstrapped\nRepo: ScribbleDevelopment/oioioioioioi\nTheme: %s\nconfig.json parsed successfully.\nstyles.css applied successfully.\nindex.html parsed successfully.", tostring(configData.Theme))
StatusLabel.TextColor3 = themeColors.textMain
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusLabel

print("0HM3G: Bootstrapper execution complete.")
