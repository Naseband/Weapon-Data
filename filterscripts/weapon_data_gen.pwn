#include <a_samp_extra>
#include <sscanf2>

new gInvalidWeapons[][] = 
{
	// These do not actually exist in samp so why bother

	"FREEFALL_BOMB",
	"ROCKET",
	"ROCKET_HS"
};

public OnFilterScriptInit()
{
	new File:FIn = fopen("weapon_data/input/weapon.dat", io_read);

	if(!FIn)
	{
		print("Failed to open weapon.dat");
		
		return 1;
	}

	new File:FOut_Melee = fopen("weapon_data/temp_weapon_melee.pwn", io_write);

	if(!FOut_Melee)
	{
		fclose(FIn);
		print("Failed to open weapon_melee.pwn");

		return 1;
	}

	new File:FOut_Guns = fopen("weapon_data/temp_weapon_guns.pwn", io_write);

	if(!FOut_Guns)
	{
		fclose(FIn);
		fclose(FOut_Melee);
		print("Failed to open weapon_guns.pwn");

		return 1;
	}

	// ---

	static text[380];

	new len, bool:first_m = true, bool:first_g = true,
		// All:
		Type[32],
		FireType[32],
		Float:TargetRange,
		Float:WeaponRange,
		Model1,
		Model2,
		Slot,
		// Guns:
		AnimGroup[32],
		Ammo,
		Damage,
		Float:FireOffsetX,
		Float:FireOffsetY,
		Float:FireOffsetZ,
		SkillLevel,
		MinStatLevel,
		Float:Accuracy,
		Float:MoveSpeed,
		Anim1Start,
		Anim1End,
		Anim1Fire,
		Anim2Start,
		Anim2End,
		Anim2Fire,
		BreakoutTime,
		Flags,
		Float:PrjSpeed,
		Float:PrjRadius,
		Float:PrjLifespan,
		Float:PrjSpread,
		// Melee:
		BaseCombo[32],
		NumCombos,
		StealthAnimGroup[32];

	// ---

	while((len = fread(FIn, text)))
	{
		if(len < 6)
			continue;

		RemoveStringCodes(text);

		switch(text[0])
		{
			case '£':
			{
				if(sscanf(text, "'£'s[32]s[32]ffiiis[32]iis[32]", 
					Type, FireType, TargetRange, WeaponRange, Model1, Model2, Slot, BaseCombo, NumCombos, Flags, StealthAnimGroup))
					continue;

				if(!CheckDefinition(Type))
					continue;

				if(!first_m)
				{
					fwrite(FOut_Melee, ",\r\n");
				}

				first_m = false;

				format(text, sizeof(text), "\t{WEAPON_%s, \"%s\", FIRE_TYPE_%s, %f, %f, %d, %d, %d, \"%s\", %d, %d, \"%s\"}",
					Type, Type, FireType, TargetRange, WeaponRange, Model1, Model2, Slot, BaseCombo, NumCombos, Flags, StealthAnimGroup);

				fwrite(FOut_Melee, text);
			}
			case '$':
			{
				if(sscanf(text, "'$'s[32]s[32]ffiiis[32]iifffiiffiiiiiiiiF(0)F(0)F(0)F(0)", 
					Type, FireType, TargetRange, WeaponRange, Model1, Model2, Slot, AnimGroup, Ammo, Damage, FireOffsetX, FireOffsetY, FireOffsetZ,
					SkillLevel, MinStatLevel, Accuracy, MoveSpeed, Anim1Start, Anim1End, Anim1Fire, Anim2Start, Anim2End, Anim2Fire, BreakoutTime, Flags,
					PrjSpeed, PrjRadius, PrjLifespan, PrjSpread))
					continue;

				if(!CheckDefinition(Type))
					continue;

				if(!first_g)
				{
					fwrite(FOut_Guns, ",\r\n");
				}

				first_g = false;

				format(text, sizeof(text), "\t{WEAPON_%s, \"%s\", FIRE_TYPE_%s, %f, %f, %d, %d, %d, \"%s\", %d, %d, %f, %f, %f, %d, %d, %f, %f, %d, %d, %d, %d, %d, %d, %d, %d, %f, %f, %f, %f}",
					Type, Type, FireType, TargetRange, WeaponRange, Model1, Model2, Slot, AnimGroup, Ammo, Damage, FireOffsetX, FireOffsetY, FireOffsetZ,
					SkillLevel, MinStatLevel, Accuracy, MoveSpeed, Anim1Start, Anim1End, Anim1Fire, Anim2Start, Anim2End, Anim2Fire, BreakoutTime, Flags,
					PrjSpeed, PrjRadius, PrjLifespan, PrjSpread);

				fwrite(FOut_Guns, text);
			}
		}
	}

	// ---

	fclose(FIn);
	fclose(FOut_Melee);
	fclose(FOut_Guns);

	// Now write the final include, read the content from weapon_base.pwn and replace $WEAPON_MELEE$ and $WEAPON_GUNS$ respectively

	FIn = fopen("weapon_data/input/weapon_base.pwn", io_read);

	if(!FIn)
	{
		print("Failed to open weapon_base.pwn (2)");
		return 1;
	}

	new File:FOut = fopen("weapon_data/weapon_data.inc", io_write);

	if(!FOut)
	{
		fclose(FIn);
		print("Failed to open weapon_data.inc");
		return 1;
	}

	while(fread(FIn, text))
	{
		if(strcmp(text, "$WEAPON_MELEE$", true, strlen("$WEAPON_MELEE$")) == 0)
		{
			new File:FIn2 = fopen("weapon_data/temp_weapon_melee.pwn");

			while(fread(FIn2, text))
				fwrite(FOut, text);

			fwrite(FOut, "\r\n");

			fclose(FIn2);
		}
		else if(strcmp(text, "$WEAPON_GUNS$", true, strlen("$WEAPON_GUNS$")) == 0)
		{
			new File:FIn2 = fopen("weapon_data/temp_weapon_guns.pwn");

			while(fread(FIn2, text))
				fwrite(FOut, text);

			fwrite(FOut, "\r\n");

			fclose(FIn2);
		}
		else
		{
			fwrite(FOut, text);
		}
	}

	fclose(FOut);
	fclose(FIn);

	return 1;
}

CheckDefinition(const type[])
{
	for(new i = 0; i < sizeof(gInvalidWeapons); ++i)
	{
		if(strcmp(type, gInvalidWeapons[i], true) == 0)
		{
			return 0;
		}
	}

	return 1;
}
