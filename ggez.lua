
_G.ASTDCheckRecordedActions = function()
    local actions = _G.ASTDGetRecordedActions()

    local total = #actions
    local clickCount = 0
    local keyCount = 0
    local screenCount = 0
    local worldCount = 0
    local invalidCount = 0

    for i, action in ipairs(actions) do
        if type(action) ~= "table" then
            invalidCount += 1
            continue
        end

        if action.type == "click" then
            clickCount += 1
        elseif action.type == "key" then
            keyCount += 1
        else
            invalidCount += 1
        end

        if type(action.screen) == "table"
            and type(action.screen.x) == "number"
            and type(action.screen.y) == "number" then
            screenCount += 1
        elseif action.type == "click" then
            warn("Missing screen position at action", i)
        end

        if type(action.world) == "table"
            and type(action.world.x) == "number"
            and type(action.world.y) == "number"
            and type(action.world.z) == "number" then
            worldCount += 1
        end

        if type(action.t) ~= "number" or action.t < 0 then
            invalidCount += 1
        end
    end

    print("===== ASTD Record Check =====")
    print("Total actions:", total)
    print("Clicks:", clickCount)
    print("Keys:", keyCount)
    print("Screen positions:", screenCount)
    print("World positions:", worldCount)
    print("Invalid entries:", invalidCount)
    print("=============================")

    return {
        total = total,
        clicks = clickCount,
        keys = keyCount,
        screenPositions = screenCount,
        worldPositions = worldCount,
        invalid = invalidCount
    }
end
