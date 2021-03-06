
Agent =
{
	world =
	{
		{ state = "unreadMessages", value = false },
	},
	goals =
	{
		{
			goal =
			{
				{ state = "hasPrisoner", value = true },
			},
			interrupts = true,
			priority = 100,
		},
		{
			goal =
			{
				{ state = "investigate", value = false },
			},
			interrupts = true,
			priority = 99,
		},
		{
			goal =
			{
				{ state = "intruderVisible", value = true },
			},
			interrupts = true,
			priority = 98,
		},
		{
			goal =
			{
				{ state = "needsToilet", value = false },
			},
			priority = 50,
		},
		{
			goal =
			{
				{ state = "patrolCompleted", value = true },
				{ state = "hasMotivation", value = true },
				{ state = "unreadMessages", value = false },
			},
			priority = 10,
			onCompletion =
			{
				{ state = "patrolCompleted", value = false },
			}
		},
	},
	canUse =
	{

		{
			interest = "Coffee",
			effect = { state = "hasMotivation", value = true },
			personalityEffect =
			{
				{ stat = "motivation", adjust = 1.0 },
				{ stat = "bladder", adjust = 0.1 },
				{ stat = "energy", adjust = 1.0 },
			}
		},
		{
			interest = "Toilet",
			effect = { state = "needsToilet", value = false },
			personalityEffect = { stat = "bladder", adjust = -1.0 },
			required = { state = "needsToilet", value = true },
		}
	},
	canFix = {	},
}
