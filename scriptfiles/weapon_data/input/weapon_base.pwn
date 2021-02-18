#if defined __WEAPON_DATA_INC__
#endinput
#endif
#define __WEAPON_DATA_INC__

#include <a_samp>

// Fire Types

enum (+=1)
{
	FIRE_TYPE_MELEE,
	FIRE_TYPE_PROJECTILE,
	FIRE_TYPE_USE,
	FIRE_TYPE_CAMERA,
	FIRE_TYPE_INSTANT_HIT,
	FIRE_TYPE_AREA_EFFECT
};

// Fixed Weapon ID Definitions!

#define WEAPON_UNARMED			0
#define WEAPON_NIGHTSTICK		WEAPON_NITESTICK
#define WEAPON_BASEBALLBAT		WEAPON_BAT
#define WEAPON_POOLCUE			WEAPON_POOLSTICK
#define WEAPON_DILDO1			WEAPON_DILDO
#define WEAPON_VIBE1			WEAPON_VIBRATOR
#define WEAPON_VIBE2			WEAPON_VIBRATOR2
#define WEAPON_FLOWERS			WEAPON_FLOWER

#define WEAPON_MOLOTOV			WEAPON_MOLTOV // No more moltov.

#define WEAPON_PISTOL			WEAPON_COLT45
#define WEAPON_PISTOL_SILENCED	WEAPON_SILENCED
#define WEAPON_DESERT_EAGLE		WEAPON_DEAGLE
#define WEAPON_SAWNOFF			WEAPON_SAWEDOFF
#define WEAPON_SPAS12			WEAPON_SHOTGSPA
#define WEAPON_MICRO_UZI		WEAPON_UZI
#define WEAPON_RLAUNCHER		WEAPON_ROCKETLAUNCHER
#define WEAPON_RLAUNCHER_HS		WEAPON_HEATSEEKER
#define WEAPON_FTHROWER			WEAPON_FLAMETHROWER
#define WEAPON_SATCHEL_CHARGE	WEAPON_SATCHEL

#define WEAPON_DETONATOR		WEAPON_BOMB
#define WEAPON_EXTINGUISHER		WEAPON_FIREEXTINGUISHER

// Enums

enum E_WEAPON_DATA_MELEE
{
	// All

	wdmID,
	wdmGTAName[16],
	wdmFireType,
	Float:wdmTargetRange,
	Float:wdmWeaponRange,
	wdmModel1,
	wdmModel2,
	wdmSlot,

	// Melee

	wdmBaseCombo[16],
	wdmNumCombos,
	wdmFlags,
	wdmStealthAnimGrp[16]
};

enum E_WEAPON_DATA_GUNS
{
	// All

	wdgID,
	wdgGTAName[16],
	wdgFireType,
	Float:wdgTargetRange,
	Float:wdgWeaponRange,
	wdgModel1,
	wdgModel2,
	wdgSlot,

	// Guns

	wdgAnimGrp[16],
	wdgAmmo,
	wdgDamage,
	Float:wdgFireOffsetX,
	Float:wdgFireOffsetY,
	Float:wdgFireOffsetZ,
	wdgSkillLevelID,
	wdgMinStatLevel,
	Float:wdgAccuracy,
	Float:wdgMoveSpeed,
	wdgAnim1Start,
	wdgAnim1End,
	wdgAnim1Fire,
	wdgAnim2Start,
	wdgAnim2End,
	wdgAnim2Fire,
	wdgBreakoutTime,
	wdgFlags,
	Float:wdgPrjSpeed,
	Float:wdgPrjRadius,
	Float:wdgPrjLifespawn,
	Float:wdgPrjSpread
};

// Data

static stock gWDM[][E_WEAPON_DATA_MELEE] =
{
$WEAPON_MELEE$ // This will be replaced by the melee array data
};

static stock gWDG[][E_WEAPON_DATA_GUNS] =
{
$WEAPON_GUNS$ // This will be replaced by the guns array data
};

// ------------------------------------------------------------ Index Functions

stock FindWeaponDataIndex_Melee(weaponid)
{
	for(new i = 0; i < sizeof(gWDM); ++i)
		if(gWDM[i][wdmID] == weaponid)
			return i;

	return -1;
}

stock FindWeaponDataIndex_Guns(weaponid, skill_level = -1)
{
	for(new i = 0; i < sizeof(gWDG); ++i)
		if(gWDG[i][wdgID] == weaponid && (skill_level == -1 || skill_level == gWDG[i][wdgSkillLevelID]))
			return i;

	return -1;
}

// ------------------------------------------------------------ General (all)

stock GetWeaponGTAName(weaponid, name[], size = sizeof(name))
{
	new id = FindWeaponDataIndex_Melee(weaponid);

	if(id != -1)
	{
		name[0] = EOS;
		strcat(name, gWDM[id][wdmGTAName], size);

		return 1;
	}

	id = FindWeaponDataIndex_Guns(weaponid);

	if(id != -1)
	{
		name[0] = EOS;
		strcat(name, gWDG[id][wdgGTAName], size);
		
		return 1;
	}

	return 0;
}

stock GetWeaponFireType(weaponid)
{
	new id = FindWeaponDataIndex_Melee(weaponid);

	if(id != -1)
	{
		return gWDM[id][wdmFireType];
	}

	id = FindWeaponDataIndex_Guns(weaponid);

	if(id != -1)
	{
		return gWDG[id][wdgFireType];
	}

	return -1;
}

stock GetWeaponRange(weaponid, skill_level, &Float:target_range, &Float:weapon_range)
{
	new id = FindWeaponDataIndex_Melee(weaponid);

	if(id != -1)
	{
		target_range = gWDM[id][wdmTargetRange];
		weapon_range = gWDM[id][wdmWeaponRange];
		return 1;
	}

	id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		target_range = gWDG[id][wdgTargetRange];
		weapon_range = gWDG[id][wdgWeaponRange];
		return 1;
	}

	return 0;
}

stock GetWeaponModels(weaponid, &model1, &model2 = -1)
{
	new id = FindWeaponDataIndex_Melee(weaponid);

	if(id != -1)
	{
		model1 = gWDM[id][wdmModel1];
		model2 = gWDM[id][wdmModel2];
		return 1;
	}

	id = FindWeaponDataIndex_Guns(weaponid);

	if(id != -1)
	{
		model1 = gWDG[id][wdgModel1];
		model2 = gWDG[id][wdgModel2];
		return 1;
	}

	return 0;
}

stock GetWeaponSlot(weaponid)
{
	new id = FindWeaponDataIndex_Melee(weaponid);

	if(id != -1)
	{
		return gWDM[id][wdmSlot];
	}

	id = FindWeaponDataIndex_Guns(weaponid);

	if(id != -1)
	{
		return gWDG[id][wdgSlot];
	}

	return -1;
}

stock GetWeaponFlags(weaponid, skill_level)
{
	new id = FindWeaponDataIndex_Melee(weaponid);

	if(id != -1)
	{
		return gWDM[id][wdmFlags];
	}

	id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		return gWDG[id][wdgFlags];
	}

	return 0;
}

// ------------------------------------------------------------ Melee

stock GetWeaponComboData(weaponid, base_combo[], &num_combos, size = sizeof(base_combo))
{
	new id = FindWeaponDataIndex_Melee(weaponid);

	if(id != -1)
	{
		base_combo[0] = EOS;
		strcat(base_combo, gWDM[id][wdmBaseCombo], size);

		num_combos = gWDM[id][wdmNumCombos];

		return 1;
	}

	return 0;
}

stock GetWeaponStealthAnimGroup(weaponid, st_anim_grp[], size = sizeof(st_anim_grp))
{
	new id = FindWeaponDataIndex_Melee(weaponid);

	if(id != -1)
	{
		st_anim_grp[0] = EOS;
		strcat(st_anim_grp, gWDM[id][wdmStealthAnimGrp], size);

		return 1;
	}

	return 0;
}

// ------------------------------------------------------------ Guns

stock GetWeaponAnimGroup(weaponid, skill_level, anim_grp[], size = sizeof(anim_grp))
{
	new id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		anim_grp[0] = EOS;
		strcat(anim_grp, gWDG[id][wdgAnimGrp], size);

		return 1;
	}

	return 0;
}

stock GetWeaponAmmo(weaponid, skill_level)
{
	new id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		return gWDG[id][wdgAmmo];
	}

	return 0;
}

stock GetWeaponDamage(weaponid, skill_level)
{
	new id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		return gWDG[id][wdgDamage];
	}

	return 0;
}

stock GetWeaponFireOffset(weaponid, skill_level, Float:fire_offset_x, Float:fire_offset_y, Float:fire_offset_z)
{
	new id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		fire_offset_x = gWDG[id][wdgFireOffsetX];
		fire_offset_y = gWDG[id][wdgFireOffsetY];
		fire_offset_z = gWDG[id][wdgFireOffsetZ];
		return 1;
	}

	return 0;
}

stock GetWeaponMinStatLevel(weaponid, skill_level)
{
	new id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		return gWDG[id][wdgMinStatLevel];
	}

	return 0;
}

stock Float:GetWeaponAccuracy(weaponid, skill_level)
{
	new id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		return gWDG[id][wdgAccuracy];
	}

	return 0;
}

stock Float:GetWeaponMoveSpeed(weaponid, skill_level)
{
	new id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		return gWDG[id][wdgMoveSpeed];
	}

	return 0;
}

stock GetWeaponAnimData(weaponid, skill_level, &anim1_start, &anim1_end, &anim1_fire, &anim2_start, &anim2_end, &anim2_fire, &breakout_time)
{
	new id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		anim1_start = gWDG[id][wdgAnim1Start];
		anim1_end = gWDG[id][wdgAnim1End];
		anim1_fire = gWDG[id][wdgAnim1Fire];

		anim2_start = gWDG[id][wdgAnim2Start];
		anim2_end = gWDG[id][wdgAnim2End];
		anim2_fire = gWDG[id][wdgAnim2Fire];

		breakout_time = gWDG[id][wdgBreakoutTime];
		return 1;
	}

	return 0;
}

stock GetWeaponProjectileData(weaponid, skill_level, &Float:speed, &Float:radius, &Float:lifespan, &Float:spread)
{
	new id = FindWeaponDataIndex_Guns(weaponid, skill_level);

	if(id != -1)
	{
		speed = gWDG[id][wdgPrjSpeed];
		radius = gWDG[id][wdgPrjRadius];
		lifespan = gWDG[id][wdgPrjLifespan];
		spread = gWDG[id][wdgPrjSpread];
		return 1;
	}

	return 0;
}

// ------------------------------------------------------------ 

// EOF
