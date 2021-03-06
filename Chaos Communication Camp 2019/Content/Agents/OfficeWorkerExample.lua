Agent =
{
  world =
  {
    { state = "AnsweredIntercom", value = false },
    { state = "GreetedJoe", value = false },
    { state = "hasPrisoner", value = false },
    { state = "playerInBossOffice", value = false },
    { state = "playerInGreetingZone", value = false },
    { state = "JoeScoldedOnce", value = false },
    { state = "JoeScoldedTwice", value = false },
    { state = "JoeScoldedThrice", value = false },
    { state = "JoeKickedOut", value = false },
    { state = "CalledSecurity", value = false },

    --{ state = "CalledMama", value = false},
    --{ state = "feelingLonely", value = false},
    --{ state = "hasfreetime", value = true}, --TODO has to time into NPC's lunch break?
    --{ state = "phoneCharged", value = true},
  },

  actions =
  {
    {-- AnsweringIntercom Action
        name = "AnsweringIntercom",
        gesture = "DanceHipHop",
        audio = "Play_VO_Secretary_Didntknowyouwherein",
        required =
        {
          { state = "AnsweredIntercom", value = false },
        },
        effect = { state = "AnsweredIntercom", value = false },
        -- targetPlayer = true,
    },
    {-- GreetingJoe Action
        name = "GreetingJoe",
        gesture = "StandingTalkingCalmly",
        audio = "Play_VO_Secretary_Didntknowyouwherein",
        required =
        {
          { state = "GreetedJoe", value = false },
          { state = "AnsweredIntercom", value = true },
          { state = "intruderVisible", value = true },
          { state = "playerInGreetingZone", value = true },
        },
        effect = { state = "GreetedJoe", value = true },
        data = {
          internalName = "OpenStaffDoorData",
          name = "AutoDoorsApi()",
          description = "A remote call to Staff door",
          immutable = true,
          dataType = 3,
          creatorName = "PassageSystems",
          dataString = "",
          dataColor = {0.0, 0.6, 1.0, 0.3},
        },
        -- targetPlayer = true,
        -- range = 12,
    },
    {-- ScoldingJoeOnce Action
        name = "ScoldingJoeOnce",
        gesture = "StandingTalkingAngrily",
        audio = "Play_VO_Secretary_YouKnowFullWellYouCant",
        required =
        {
          { state = "playerInBossOffice", value = true },
          { state = "intruderVisible", value = true },
        },
        effect = { state = "JoeScoldedOnce", value = true },
    },
    {-- ScoldingJoeTwice Action
        name = "ScoldingJoeTwice",
        gesture = "StandingTalkingAngrily",
        audio = "Play_VO_Secretary_YourNotPermittedInThere",
        required =
        {
          { state = "playerInBossOffice", value = true },
          { state = "intruderVisible", value = true },
          { state = "JoeScoldedOnce", value = true },
        },
        effect = { state = "JoeScoldedTwice", value = true },
        -- set target player at 12m away
        targetPlayer = true,
        range = 12,
        speed = 1, -- walk
    },
    {-- ScoldingJoeThrice Action
        name = "ScoldingJoeThrice",
        gesture = "StandingTalkingAngrily",
        audio = "Play_VO_Secretary_GetOutOrIWillReport",
        required =
        {
          { state = "playerInBossOffice", value = true },
          { state = "intruderVisible", value = true },
          { state = "JoeScoldedTwice", value = true },
        },
        effect = { state = "JoeScoldedThrice", value = true },
        -- set target player at 10m away
        targetPlayer = true,
        range = 12,
        speed = 2, -- jog
    },
    -- {-- CallingMama Action - Example written for live stream
    --   name = "CallingMama",
    --   gesture = "LookAtPhone",
    --   audio = "Play_VO_RoboVoice_ImHereToRustleYour_01",
    --   required =
    --   {
    --     { state = "feelingLonely", value = true},
    --     { state = "hasfreetime", value = true}, --TODO has to time into NPC's lunch break?
    --     { state = "phoneCharged", value = true},
    --   },
    --   effect = --TODO should "feelingLonely" be a personalityEffect instead of effect?
    --   {
    --     { state = "feelingLonely", value = false},
    --     { state = "CalledMama", value = false},
    --   },
    -- },
    {-- CallingSecurity Action
        name = "CallingSecurity",
        gesture = "LookAtPhone,",
        audio = "Play_VO_Secretary_ImGettingSecurity",
        required =
        {
          { state = "playerInBossOffice", value = true },
          { state = "JoeScoldedThrice", value = true },
          { state = "intruderVisible", value = true },
          -- is this "intruderVisible" even being used here?
        },
        effect = { state = "CalledSecurity", value = true },
        --TODO set target player at 5m away?
        -- targetPlayer = true,
        --TODO send data to alarm device to spawn guard
        data = {
            internalName = "AlarmData",
            name = "AlarmData",
            description = "Data to call an alarm and a guard",
            immutable = true,
            dataType = 3,
            creatorName = "AlarmCo",
            dataString = "CallForHelp()",
            dataColor = {0.0, 0.6, 1.0, 0.3},
        },
        --set to target player at 5m away
        targetPlayer = true,
        range = 5, --not sure if this is currently working
        speed = 3, --run
    },
    {-- KickingJoeOut Action
        name = "KickingJoeOut",
        gesture = "StandingTalkingAngrily",
        audio = "Play_VO_Secretary_LookIToldYouTooMany",
        required =
        {
          { state = "playerInBossOffice", value = true },
          { state = "CalledSecurity", value = true },
          { state = "intruderVisible", value = true },
          -- is this "intruderVisible" even being used here?
        },
        effect = { state = "JoeKickedOut", value = true },
        targetPlayer = true,
    },
  },

  goals =
  {
    {-- Catch player in Boss' Office and kick out
      goal =
      {
        { state = "playerInBossOffice", value = true },
        { state = "JoeScoldedThrice", value = true },
        { state = "CalledSecurity", value = true },
        { state = "JoeKickedOut", value = true },
      },
      interrupts = true,
      priority = 90,
      onCompletion =
      {
          -- end level / gameover
         -- agent sends data to alarm or virtual Character
      }
    },
    {-- Tell player not to be in Boss' office 1st Time
      goal =
      {
        { state = "playerInBossOffice", value = true },
        { state = "JoeScoldedOnce", value = true },
      },
      interrupts = true,
      priority = 85,
      onCompletion =
      {
         --
      }
    },
    {-- Tell player not to be in Boss' office 2nd time
      goal =
      {
        { state = "playerInBossOffice", value = true },
        { state = "JoeScoldedTwice", value = true },
      },
      interrupts = true,
      priority = 84,
      onCompletion =
      {
         --
      }
    },
    {-- Tell player not to be in Boss' office 3rd Time
      goal =
      {
        { state = "playerInBossOffice", value = true },
        { state = "JoeScoldedThrice", value = true },
      },
      interrupts = true,
      priority = 83,
      onCompletion =
      {
         --
      }
    },
    {-- Answers intercom at beginning of level
      goal =
      {
        { state = "AnsweredIntercom", value = true },
      },
      interrupts = true,
      priority = 81,
    },
    {-- Greet PLayer at Reception
      goal =
      {
        { state = "GreetedJoe", value = true },
      },
      interrupts = true,
      priority = 80,
    },
    -- { -- CalledMama Goal : NPC wants to not feel lonely and so calls mama
    --   goal =
    --   {
    --     { state = "CalledMama", value = true},
    --   },
    --   interrupts = true,
    --   priority = 70,
    -- },
    {-- Stand out of sight until player uses intercom
      goal =
      {
        { state = "usedCoffeeMaker-Kitchen_01", value = true},
        { state = "AnsweredIntercom", value = false},
      },
      interrupts = true,
      priority = 61,
      onCompletion =
      {
        { state = "usedCoffeeMaker-Kitchen_01", value = false},
      }
    },
    {-- Stand at reception desk until player is greeted
      goal =
      {
        { state = "usedReceptionDesk", value = true},
        { state = "GreetedJoe", value = false},
      },
      interrupts = true,
      priority = 60,
      onCompletion =
      {
        { state = "usedReceptionDesk", value = false},
      }
    },
    {-- loop using filing cabinet, printer and computer
      goal =
      {
        { state = "usedFilingCabinet", value = true },
        { state = "GreetedJoe", value = true },
        { state = "AnsweredIntercom", value = true },
      },
      interrupts = false,
      priority = 10,
      onCompletion =
      {
        { state = "usedFilingCabinet", value = false },
        { state = "usedPrinter", value = false },
        { state = "usedComputer", value = false },
      }
    },
    {-- this is a backstop goal that sends the NPC to the dest of everything else fails
      goal =
      {
        { state = "usedReceptionDesk", value = true},
        { state = "GreetedJoe", value = true},
      },
      interrupts = true,
      priority = 1, -- low priority
      onCompletion =
      {
        { state = "usedReceptionDesk", value = false},
      }
    },
  },

  canUse =
  {
    --[[ requirements here must be absolute and need completion before the next
    action can be done - this will create a chain of events
    e.g. get cup, pour tea, drink tea.
    DO NOT put requirements in actions if you dont want them to stop the action
    from occuring ]]
    -- {--Phone Charger Interst Point
    --   interest = "PhoneCharger",
    --   gesture = "StandingAmokDeviceHit",
      -- TODO This event is a placeholder - Audio events need setting up to work in CanUse actions (with interest point handling the event based on its state?)
    --   audio = "Play_VO_Secretary_LookIToldYouTooMany",
    -- },
    {--FilingCabinet Interest Point
      interest = "FilingCabinet",
      required = { state = "usedPrinter", value = true },
      -- TODO This event is a placeholder - Audio events need setting up to work in CanUse actions (with interest point handling the event based on its state?)
      audio = "Play_VO_Secretary_IHaveSomeFilingToDo",
      gesture = "StandingFilingCabinetSearch",
    },
    {--Printer Interest Point
      interest = "Printer",
      required = { state = "usedComputer", value = true },
      -- TODO This event is a placeholder - Audio events need setting up to work in CanUse actions (with interest point handling the event based on its state?)
      audio = "Play_VO_Secretary_BloodyPrinter",
      gesture = "StandingLookAtHipHeight",
    },
    {--Computer Interest Point
      interest = "Computer",
      -- TODO This event is a placeholder - Audio events need setting up to work in CanUse actions (with interest point handling the event based on its state?)
      audio = "Play_VO_Secretary_Didntknowyouwherein",
      gesture = "StandingTypingCalm",
    },
    {--ReceptionDesk Interest Point
      interest = "ReceptionDesk",
      required = { state = "AnsweredIntercom", value = true },
      -- TODO This event is a placeholder - Audio events need setting up to work in CanUse actions (with interest point handling the event based on its state?)
      audio = "Play_VO_Secretary_FaxMachineIsOnTheBrink",
      gesture = "StandingTypingCalm",
    },
    {--ReceptionDesk Interest Point
      interest = "CoffeeMaker-Kitchen_01",
      -- TODO This event is a placeholder - Audio events need setting up to work in CanUse actions (with interest point handling the event based on its state?)
      audio = "Play_VO_Secretary_FaxMachineIsOnTheBrink",
      gesture = "StandingLookAtHipHeight",
    },
  },
  canFix = {	},
}
