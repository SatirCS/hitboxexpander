local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")3
local Visibility = true

   
   return Objects
end

local function GetPartCorners(Part)
	local Size = Part.Size * Vector3.new(1, 1.5)
	return {
        TR = (Part.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).Position,
		BR = (Part.CFrame * CFrame.new(-Size.X, Size.Y, 0)).Position,
		TL = (Part.CFrame * CFrame.new(Size.X, -Size.Y, 0)).Position,
		BL = (Part.CFrame * CFrame.new(Size.X, Size.Y, 0)).Position,
	}
end

local function ApplyModel(Model)
    local Objects = ModelTemplate()
    local CurrentParent = Model.Parent
    
    spawn(function()
        Objects.Box.Visible = true
        Objects.Box.Transparency = 1
       
        while Model.Parent == CurrentParent do
            local Vector, OnScreen = Camera:WorldToScreenPoint(Model.Head.Position)
            local Distance = (Camera.CFrame.Position - Model.HumanoidRootPart.Position).Magnitude
            
         
            
            local PartCorners = GetPartCorners(Model.HumanoidRootPart)
            local VectorTR, OnScreenTR = Camera:WorldToScreenPoint(PartCorners.TR)
            local VectorBR, OnScreenBR = Camera:WorldToScreenPoint(PartCorners.BR)
            local VectorTL, OnScreenTL = Camera:WorldToScreenPoint(PartCorners.TL)
            local VectorBL, OnScreenBL = Camera:WorldToScreenPoint(PartCorners.BL)
            
            if (OnScreenBL or OnScreenTL or OnScreenBR or OnScreenTR) and Model.Parent.Name ~= game:GetService("Players").LocalPlayer.Team.Name and Visibility then
                Objects.Box.PointA = Vector2.new(VectorTR.X, VectorTR.Y + 36)
                Objects.Box.PointB = Vector2.new(VectorTL.X, VectorTL.Y + 36)
                Objects.Box.PointC = Vector2.new(VectorBL.X, VectorBL.Y + 36)
                Objects.Box.PointD = Vector2.new(VectorBR.X, VectorBR.Y + 36)
                Objects.Box.Color = Color3.fromHSV(math.clamp(Distance / 5, 0, 125) / 255, 0.75, 1)
                Objects.Box.Thickness = math.clamp(3 - (Distance / 100), 0, 3)
                Objects.Box.Transparency = math.clamp((500 - Distance) / 200, 0.2, 1)
                Objects.Box.Visible = true
            else
                Objects.Box.Visible = false
            end
            
            RunService.RenderStepped:Wait()
        end
        
        Objects.Name:Remove()
        Objects.Box:Remove()
    end)
end

for _, Player in next, game:GetService("Workspace").Players.Phantoms:GetChildren() do
    ApplyModel(Player)
end

for _, Player in next, game:GetService("Workspace").Players.Ghosts:GetChildren() do
    ApplyModel(Player)
end

game:GetService("Workspace").Players.Phantoms.ChildAdded:Connect(function(Player)
    delay(0.5, function()
        ApplyModel(Player)
    end)
end)

game:GetService("Workspace").Players.Ghosts.ChildAdded:Connect(function(Player)
    delay(0.5, function()
        ApplyModel(Player)
    end)
end)

UserInputService.InputBegan:Connect(function(Input, GP)
    if not GP and Input.KeyCode == Enum.KeyCode.Five then
        Visibility = not Visibility
    end 
    
    if not GP and Input.KeyCode == Enum.KeyCode.Four then
        CycleFont()
    end
end)
