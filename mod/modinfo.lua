--------------------------------------------------
---- Description
--------------------------------------------------
name = "Tame Tallbirds"
description = "Full-grown Tallbirds raised by the player will be friendly."

-- Ever raised a Tallbird? Probably not because in the base game raised Tallbirds are hostile and not much use. Tame Tallbirds seeks to fix that by making Tallbirds raised by the player loyal pets and potential combat allies.

-- Tame Tallbirds:
--   - Have similar combat stats to wild Tallbirds
--   - Friendly with both tame and wild Tallbirds
--   - Require food every few days (configurable)
--   - Any food will heal the bird for a large amount
--   - Will peck you if they are hungry (similar to teen birds)
--   - Will not eat Tallbird Eggs
--   - Will follow you into and out of caves

-- Right click the bird to make it guard an area, then give it food to cause it to follow you again.

-- NOTE: Be careful of starving your Tame Tallbirds near other player companions. Pecking you will often cause your other companions to attempt to defend you.

-- Have feedback, suggestions, or found a bug? Submit an issue on [url=https://github.com/brisberg/TameTallbirds/issues]Github[/url] or open a pull request. If you don't have a Github account you can post in the pinned discussions below.

-- Next: Converting the mod to work with Don't Starve Together!

-- Special Thanks to [url=http://steamcommunity.com/id/wheatmouse/]Yuli[/url] for the mod icon art!

-- Testing: Configure the mod with 'DEBUG Fast Bird Growth' to cause Tallbirds to grow up in a matter of seconds.

author = "Keidence"
version = "1.02"
forumthread = "None"
icon_atlas = "modicon.xml"
icon = "modicon.tex"
--------------------------------------------------
---- Compatibility
--------------------------------------------------
dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true

api_version = 6
--------------------------------------------------
---- Config
--------------------------------------------------
configuration_options =
{
    {
        name = "TAMETALLBIRD_HEALTH_MOD",
        label = "Health",
        options = {
            {description = "Very Low", data = .5},
            {description = "Low", data = .75},
            {description = "Normal", data = 1},
            {description = "High", data = 1.5},
            {description = "Very High", data = 2},
        },
        default = 1,
        hover = "Maximum health of Tame Tallbirds."
    },
    {
        name = "TAMETALLBIRD_DAMAGE_MOD",
        label = "Attack Damage",
        options = {
            {description = "Very Low", data = .5},
            {description = "Low", data = .75},
            {description = "Normal", data = 1},
            {description = "High", data = 1.5},
            {description = "Very High", data = 2},
        },
        default = 1,
        hover = "Maximum health of Tame Tallbirds.",
    },
    {
        name = "TAMETALLBIRD_STARVE_TIME",
        label = "Food Consumption",
        options = {
            {description = "None", data = 0},
            {description = "Very Low", data = 6},
            {description = "Low", data = 4},
            {description = "Normal", data = 3},
            {description = "High", data = 2},
            {description = "Very High", data = 1},
        },
        default = 3,
        hover = "Amount of food your Tame Tallbirds will consume each day.",
    },
    {
        name = "TALLBIRDEGG_HATCH_TIME",
        label = "Egg Hatch Time",
        options = {
            {description = "1 Day", data = 1},
            {description = "2 Days", data = 2},
            {description = "3 Days", data = 3},
            {description = "4 Days", data = 4},
            {description = "5 Days", data = 5},
        },
        default = 3,
        hover = "Number of days for a Tallbird Egg to hatch."
    },
    {
        name = "TEEN_GROWTH_TIME",
        label = "Teen Growth Time",
        options = {
            {description = "1 Day", data = 1},
            {description = "3 Days", data = 3},
            {description = "5 Days", data = 5},
            {description = "10 Days", data = 10},
            {description = "15 Days", data = 15},
            {description = "20 Days", data = 20},
        },
        default = 10,
        hover = "Number of days for a Smallbird to grow up."
    },
    {
        name = "ADULT_GROWTH_TIME",
        label = "Adult Growth Time",
        options = {
            {description = "1 Day", data = 1},
            {description = "3 Days", data = 3},
            {description = "5 Days", data = 5},
            {description = "10 Days", data = 10},
            {description = "15 Days", data = 15},
            {description = "20 Days", data = 20},
        },
        default = 10,
        hover = "Number of days for a Teenbird to grow up."
    },
    {
        name = "DEBUG_GROWTH_SPEED",
        label = "DEBUG Fast Tallbird Growth",
        options = {
            {description = "Off", data = false},
            {description = "On", data = true},
        },
        default = false,
        hover = "For testing only. Makes Tallbirds hatch and grow in a matter of seconds.",
    },
}
