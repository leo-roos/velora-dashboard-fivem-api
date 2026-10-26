local data = {
    version = 2,
    serverSlots = 64,

    players = {
        -- {
        --     name = "Leo",
        --     id = 1,
        --     staff = true,
        --     character = {
        --         firstName = "Leo",
        --         lastName = "Andersson",
        --     },
        -- },
    },

    recentKicks = {
        {
            name = "Leo",
            id = 1,
            staff = true,
        },
    },

    recentBans = {
        {
            name = "Leo",
            id = 1,
            staff = true,
        },
    },

    recentDisconnections = {
        {
            name = "Leo",
            id = 1,
            staff = true,
        },
    },

    activeCommunityService = {
        {
            name = "Leo",
            id = 1,
            staff = true,
        },
    },

    recentStaffActions = {
        {
            name = "Leo",
            id = 1,
            staff = true,
        },
    },
}

-- SetHttpHandler(function(request, response)
--     print(("Incoming request: %s %s"):format(
--         request.method,
--         request.path
--     ))

--     if request.method == "GET" and request.path == "/ping" then
--         response.writeHead(200, {
--             ["Content-Type"] = "text/plain; charset=utf-8"
--         })

--         response.send("pong")
--         return;
--     end

--     if (request?.headers?.Authorization or "") ~= ("Bearer " .. API_KEY) then
--         response.writeHead(401, {
--             ["Content-Type"] = "application/json; charset=utf-8"
--         })

--         response.send(json.encode({
--             error = "INVALID_API_KEY",
--             message = "You have given an invalid API Key. If you are not the server owner please contact them."
--         }))
--         return;
--     end

--     if request.method == "GET" and string.find(request.path, "/api/data") then
--         response.writeHead(200, {
--             ["Content-Type"] = "application/json; charset=utf-8"
--         })

--         local version = string.match(request.path, "version=(%d+)")
--         if version ~= data.version then
--             response.send(json.encode(data))
--         end
--         return;
--     end

--     response.writeHead(404, {
--         ["Content-Type"] = "text/plain; charset=utf-8"
--     })

--     response.send("Not found")
-- end)

local cachedData;
local content = LoadResourceFile(GetCurrentResourceName(), "cachedData.json");
local decoded = json.decode(content);
if decoded ~= nil then
    data = decoded;
end

Citizen.CreateThread(function()
    while true do
        data.version += 1;
        data.players = {};

        for k, v in pairs(ESX.GetExtendedPlayers()) do
            local playerData = {};
            playerData.name = GetPlayerName(v.playerId)
            playerData.id = v.playerId
            -- playerData.staff = true
            playerData.character = {
                firstName = v.get("firstName"),
                lastName = v.get("lastName"),
            }

            local job = v.getJob();
            playerData.job = {
                gradeName = job.grade_name,
                label = job.label,
                gradeSalary = v.grade_salary,
                grade = job.grade,
                type = job.type,
                name = job.name,
                onDuty = job.onDuty,
                gradeLabel = job.grade_label,
            }

            table.insert(data.players, playerData);
        end

        SaveResourceFile(GetCurrentResourceName(), "cachedData.json", json.encode(data, {indent=true}), -1)

        Citizen.Wait(1000)
        PerformHttpRequest("100.98.69.38:5173/velora-dashboard/api/server/update/",
            function(errorCode, resultData, resultHeaders, errorData)
                print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
                print("errorCode: " .. json.encode(errorCode));
                print("resultData: " .. json.encode(resultData));
                print("resultHeaders: " .. json.encode(resultHeaders));
                print("errorData: " .. json.encode(errorData));
            end, "POST", json.encode({ data = data }), {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. API_KEY
        })
    end
end)