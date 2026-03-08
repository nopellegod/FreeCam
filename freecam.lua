local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local freecam = false
local speed = 1
local sensitivity = 0.2

local move = Vector3.new()
local rotX = 0
local rotY = 0

local keys = {
	W=false,A=false,S=false,D=false,Q=false,E=false
}

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

function updateMove()
	move = Vector3.new(
		(keys.D and 1 or 0) - (keys.A and 1 or 0),
		(keys.E and 1 or 0) - (keys.Q and 1 or 0),
		(keys.S and 1 or 0) - (keys.W and 1 or 0)
	)
end

UIS.InputBegan:Connect(function(input,gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		freecam = not freecam
		
		if freecam then
			camera.CameraType = Enum.CameraType.Scriptable
			UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
			
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
		else
			camera.CameraType = Enum.CameraType.Custom
			UIS.MouseBehavior = Enum.MouseBehavior.Default
			
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
		end
	end
	
	if keys[input.KeyCode.Name] ~= nil then
		keys[input.KeyCode.Name] = true
		updateMove()
	end
end)

UIS.InputEnded:Connect(function(input)
	if keys[input.KeyCode.Name] ~= nil then
		keys[input.KeyCode.Name] = false
		updateMove()
	end
end)

UIS.InputChanged:Connect(function(input)
	if freecam and input.UserInputType == Enum.UserInputType.MouseMovement then
		rotX = math.clamp(rotX - input.Delta.Y * sensitivity,-90,90)
		rotY = rotY - input.Delta.X * sensitivity
	end
end)

RunService.RenderStepped:Connect(function()
	if freecam then
		
		UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
		
		local camCF =
			CFrame.new(camera.CFrame.Position) *
			CFrame.Angles(0, math.rad(rotY), 0) *
			CFrame.Angles(math.rad(rotX),0,0)

		camera.CFrame = camCF + camCF:VectorToWorldSpace(move) * speed
	end
end)
