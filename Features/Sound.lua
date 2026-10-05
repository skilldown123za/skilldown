
local SoundService = game:GetService("SoundService")
local AUDIO_FOLDER = "JAYJAY-audio"
local AUDIO_FILE = AUDIO_FOLDER .. "/audio.mp3"
local AUDIO_LINK = "https://files.catbox.moe/yn5vzu.mp3"
pcall(function()
    if not isfolder(AUDIO_FOLDER) then
        makefolder(AUDIO_FOLDER)
        print(" Created folder: " .. AUDIO_FOLDER)
    end
end)
if not isfile(AUDIO_FILE) then
    print("  Audio...")
    local ok, data = pcall(function() return game:HttpGet(AUDIO_LINK) end)
    if ok and data then
        writefile(AUDIO_FILE, data)
        print("  Audio !")
    else
        warn("  Audio !")
    end
end
local AudioAsset
pcall(function() AudioAsset = getcustomasset(AUDIO_FILE) end)
pcall(function()
    local old = SoundService:FindFirstChild("JayjayAudio")
    if old then old:Destroy() end
end)

local Sound = Instance.new("Sound")
Sound.Name = "JayjayAudio"
Sound.SoundId = AudioAsset or ""
Sound.Volume = 1
Sound.Looped = false  --   (No Loop)
Sound.Parent = SoundService
local HasPlayed = false  --  Flag  Play Once

local function PlayAudio()
    if HasPlayed then
        print(" Audio  (Play Once)")
        return
    end
    
    if Sound.SoundId and Sound.SoundId ~= "" then
        HasPlayed = true
        pcall(function() Sound:Play() end)
        print(" Audio: PLAYING (Once)")
    end
end

local function StopAudio()
    if Sound.IsPlaying then
        pcall(function() Sound:Stop() end)
        print(" Audio: STOPPED")
    end
end
_G.JAYJAY_Sound = {
    Play = PlayAudio,
    Stop = StopAudio,
    IsPlaying = function() return Sound.IsPlaying end,
    HasPlayed = function() return HasPlayed end,
    Sound = Sound,
    Folder = AUDIO_FOLDER,
    AudioFile = AUDIO_FILE,
}

print(" Sound Feature Loaded (Play Once)")
