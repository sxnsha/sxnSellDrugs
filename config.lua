Config = {}

Config.DiscussTime = math.random(3500,6500)


Config.CopsNeeded = 0--2

Config.NotifyCopsPercentage = 30
Config.NotifyCallCopsPercentage = 50

Config.DrugItems = {
    cocaine_packaged = {
        name = "cocaine_packaged",
        price = 915, -- Très dangereux, prix élevé
        prixbonuslspd = 80,
        sellCountMin = 1,
        sellCountMax = 2
    },
    meth_packaged = {
        name = "meth_packaged",
        price = 750, -- Dangereux, prix élevé
        prixbonuslspd = 70,
        sellCountMin = 1,
        sellCountMax = 2
    },
    opiumtreat = {
        name = "opiumtreat",
        price = 670, -- Moins dangereux que meth/cocaine
        prixbonuslspd = 60,
        sellCountMin = 1,
        sellCountMax = 2
    },
    weed_packaged = {
        name = "weed_packaged",
        price = 600, -- Moins dangereux, prix bas
        prixbonuslspd = 40,
        sellCountMin = 1,
        sellCountMax = 3
    },


}

