//-----------------------------------------------------------------------
// <copyright file="ginc_sls2.nss" company="Molior RS">
// Copyright (c) Molior RS. All rights reserved.
// </copyright>
// <revision> 1 </revision>
// <lasteditedby>Austin Jensen</lasteditedby>
//-----------------------------------------------------------------------
// *************************************************
// Global functions and constants for SLS2
// Last Updated: 2008-09-23
// Brendan 'Slayster' Ellis - http://www.slayweb.com
// *************************************************

// --------------
// SLS2 Constants
// --------------

// Light States
const int SLS2_LIGHTSTATE_ON		= 220000;
const int SLS2_LIGHTSTATE_OFF 		= 220001;
const int SLS2_LIGHTSTATE_PERMAON 	= 220002;
const int SLS2_LIGHTSTATE_PERMAOFF	= 220003;
// User Defined Events
const int SLS2_EVENT_INIT			= 221000;
const int SLS2_EVENT_TOGGLE			= 221001;
const int SLS2_EVENT_TURNON			= 221002;
const int SLS2_EVENT_TURNOFF		= 221003;
const int SLS2_EVENT_TURNONPERM		= 221004;
const int SLS2_EVENT_TURNOFFPERM	= 221005;
const int SLS2_EVENT_UPDATE			= 221006;
const int SLS2_EVENT_RESET			= 221007;
const int SLS2_EVENT_ONESHOT		= 221008;
const int SLS2_EVENT_CHAIN			= 221009;
// Other
const float SLS2_EVENT_DELAY		= 0.1f;

// ---------------
// SLS2 Prototypes
// ---------------

// Area Functions
void SLS2AreaOnEnter(object oArea);
void SLS2AreaHeartbeat(object oArea);
void SLS2AreaLightEvent(int iEvent, object oArea=OBJECT_INVALID, int bDelay=TRUE);
// Object Functions
void SLS2ObjectOnUserDefinedEvent(object oFitting, int iEvent);
void SLS2ObjectLightEvent(int nEvent, string sObjectTag);
void SLS2ObjectSetBlueprints(object oFitting, string sNewLight="", string sNewVfx="");
void SLS2ObjectOneShot(object oFitting);
// Trigger Functions
void SLS2TiggerLightEvent(int nEvent, object oTrigger);
// Misc Functions
void SLS2ShapeLightEvent(int iEvent, float fRange, location lLocation);
void SLS2SetBlueprints(string sTag="",string sNewLightBP="",string sNewVfxBP="",int bDelay=0);
void SLS2SetLightState(object oFitting, int iState);
int SLS2CalcLightState(object oFitting);
int SLS2ToggleLightState(object oFitting);
int SLS2ResetLightState(object oFitting);
void SLS2LightUsed(object oFitting);
void SLS2SpeakTime();
// Chain Functions
void SLS2StartChain(string sTag,int nLength,string sType,int nDir);
void SLS2StopChain(string sTag);
void SLS2ChainEvent(object oFitting);
void SLS2ChainEventEnd(object oFitting);
// Internal Functions - Shouldn't be called directly
void SLS2Initialize(object oFitting);
void SLS2CopyVars(object oSrc, object oTar);
void SLS2VarDump(object oFitting);

// --------------
// SLS2 Functions
// --------------

// OnEnter function for areas using SLS2 lighting
// Checks if this area has been initialized yet
// if not, loops objects in the specified area and sends init signal
// designed to be called from a wrapper script (see sls2_onenter)
// oArea: area object to initialize
void SLS2AreaOnEnter(object oArea) {
	if (GetLocalInt(oArea,"sls2_init")==0) {
		SLS2AreaLightEvent(SLS2_EVENT_INIT,oArea,FALSE);
		SetLocalInt(oArea,"sls2_currenthour",GetTimeHour());
		SetLocalInt(oArea,"sls2_init",1);
	}
}

// OnHeartBeat function for areas using SLS2 lighting
// Checks if the current hour has changed since it was last stored
// If is has send UPDATE signal to all objects in the area and store the new time
// designed to be called from a wrapper script (see sls2_heartbeat)
// oArea: area object that sent heartbeat signal
void SLS2AreaHeartbeat(object oArea) {
	if (GetTimeHour()!=GetLocalInt(oArea,"sls2_currenthour")) {
		float delay = 0.0f;
		object oObject = GetFirstObjectInArea(oArea);
		while (oObject != OBJECT_INVALID) {
			int nType = GetObjectType(oObject);
			if ((nType==OBJECT_TYPE_CREATURE)||(nType=OBJECT_TYPE_PLACEABLE)) {
				DelayCommand(delay,SignalEvent(oObject,EventUserDefined(SLS2_EVENT_UPDATE)));
				delay = delay + SLS2_EVENT_DELAY;
				oObject = GetNextObjectInArea(oArea);
			}
		}
		SetLocalInt(oArea,"sls2_currenthour",GetTimeHour());
	}
}

// Loops all objects in an area and sends the specified light event to them
// nEvent: the SLS2 light event constant to send
// oArea: the area to send the event to
// bDelay: TRUE - Send the events with a delay in between (SLS2_EVENT_DELAY)
//         FALSE - Send the events all at once
void SLS2AreaLightEvent(int nEvent, object oArea=OBJECT_INVALID, int bDelay=TRUE) {
	if (oArea==OBJECT_INVALID) {
		oArea = GetArea(GetPCSpeaker());
	}
	float fDelay = 0.0f;
	object oObject = GetFirstObjectInArea(oArea);
	while (oObject != OBJECT_INVALID) {
		int nType = GetObjectType(oObject);
		if ((nType==OBJECT_TYPE_CREATURE)||(nType=OBJECT_TYPE_PLACEABLE)) {
			if (bDelay) {
				DelayCommand(fDelay,SignalEvent(oObject,EventUserDefined(nEvent)));
				fDelay = fDelay + SLS2_EVENT_DELAY;
				oObject = GetNextObjectInArea(oArea);
			} else {
				SignalEvent(oObject,EventUserDefined(nEvent));
				oObject = GetNextObjectInArea(oArea);
			}
		}
	}
}

// On User Defined Event script for lighting placeables
// designed to be called from a wrapper script (see p_sls2_fitting_ud)
// oFitting: the Light Fitting receiving the event
// nEvent: the SLS2 event number
void SLS2ObjectOnUserDefinedEvent(object oFitting, int nEvent) {
	int nEvent = GetUserDefinedEventNumber();
	switch (nEvent) {
		case SLS2_EVENT_INIT:
			SLS2Initialize(oFitting);
			break;
		case SLS2_EVENT_TOGGLE:
			SLS2SetLightState(oFitting,SLS2ToggleLightState(oFitting));
			break;
		case SLS2_EVENT_TURNON:
			SLS2SetLightState(oFitting,SLS2_LIGHTSTATE_ON);
			break;
		case SLS2_EVENT_TURNOFF:
			SLS2SetLightState(oFitting,SLS2_LIGHTSTATE_OFF);
			break;
		case SLS2_EVENT_TURNONPERM:
			SLS2SetLightState(oFitting,SLS2_LIGHTSTATE_PERMAON);
			break;
		case SLS2_EVENT_TURNOFFPERM:
			SLS2SetLightState(oFitting,SLS2_LIGHTSTATE_PERMAOFF);
			break;
		case SLS2_EVENT_UPDATE:
			SLS2SetLightState(oFitting,SLS2CalcLightState(oFitting));
			break;
		case SLS2_EVENT_RESET:
			SLS2SetLightState(oFitting,SLS2ResetLightState(oFitting));
			break;
		case SLS2_EVENT_ONESHOT:
			SLS2ObjectOneShot(oFitting);
			break;
		case SLS2_EVENT_CHAIN:
			SLS2ChainEvent(oFitting);
			break;
		default:
			// Not an SLS2 Event
			break;
	}
}

// Send a light event to all objects with the specified tag
// nEvent: the SLS2 light event to send
// sObjectTag: the tag of the objects which want the event
void SLS2ObjectLightEvent(int nEvent, string sObjectTag) {
	object oFitting;
	if (sObjectTag=="") {
		oFitting = OBJECT_SELF;
		SignalEvent(oFitting,EventUserDefined(nEvent));
	} else {
		int i = 0;
		float fDelay = 0.0f;
		oFitting = GetObjectByTag(sObjectTag,i);
		while (oFitting!=OBJECT_INVALID) {
			DelayCommand(fDelay,SignalEvent(oFitting,EventUserDefined(nEvent)));
			fDelay = fDelay + SLS2_EVENT_DELAY;
			i++;
			oFitting = GetObjectByTag(sObjectTag,i);
		}
	}
}

// changes the light and vfx blueprints for the specified object
// values left as empty string "" will not be changed
// oFitting: SLS2 light object to update
// sNewLight: new light blueprint
// sNewVfx: new fx blueprint
void SLS2ObjectSetBlueprints(object oFitting, string sNewLight="", string sNewVfx="") {
	int nState = GetLocalInt(oFitting,"sls2_state");
	// change lights
	if (sNewLight!="") {
		// get light tag
		string sLightTag = GetLocalString(oFitting,"lightTag");
		// get light object locations then destroy
		int nLightCount = 0;
		object oLight = GetObjectByTag(sLightTag,nLightCount);
		while (oLight!=OBJECT_INVALID) {
			// set light object location
			SetLocalLocation(oFitting,"sls2_ltloc_"+IntToString(nLightCount),GetLocation(oLight));
			// destroy old light
			DestroyObject(oLight,0.0f,FALSE);
			nLightCount++;
			oLight = GetObjectByTag(sLightTag,nLightCount);
		}
		// spawn new lights
		int i;
		for (i=0; i<nLightCount; i++) {
			oLight = CreateObject(OBJECT_TYPE_LIGHT,sNewLight,GetLocalLocation(oFitting,"sls2_ltloc_"+IntToString(i)),FALSE,sLightTag);
			if ((nState==SLS2_LIGHTSTATE_OFF)||(nState==SLS2_LIGHTSTATE_PERMAOFF)) {
				SetLightActive(oLight,FALSE);
			}
		}
	}
	// change vfx
	if (sNewVfx!="") {
		if ((nState==SLS2_LIGHTSTATE_OFF)||(nState==SLS2_LIGHTSTATE_PERMAOFF)) {
			SetLocalString(oFitting,"vfxBlueprint",sNewVfx);
		} else {
			// get vfx tag
			string sVfxTag = GetLocalString(oFitting,"vfxTag");
			// destroy old fx objects
			int i = 0;
			object oVfx = GetObjectByTag(sVfxTag,i);
			while (oVfx!=OBJECT_INVALID) {
				// destroy old vfx
				DestroyObject(oVfx,0.0f,FALSE);
				i++;
				oVfx = GetObjectByTag(sVfxTag,i);
			}
			// spawn new fx objects
			int nEffectCount = GetLocalInt(oFitting,"sls2_effectcount");
			for (i=0; i<nEffectCount; i++) {
				CreateObject(OBJECT_TYPE_PLACED_EFFECT,sNewVfx,GetLocalLocation(oFitting,"sls2_fxloc_"+IntToString(i)),FALSE,sVfxTag);
			}
			
			SetLocalString(oFitting,"vfxBlueprint",sNewVfx);
		}
	}
}

// run a oneshot light event on the specified object
// turn light on, wait for delay, turn light off
// oFitting: SLS2 light fitting to use
void SLS2ObjectOneShot(object oFitting) {
	SLS2SetLightState(oFitting,SLS2_LIGHTSTATE_ON);
	DelayCommand(GetLocalFloat(oFitting,"oneShotDelay"),SLS2SetLightState(oFitting,SLS2_LIGHTSTATE_OFF));
}

// sends lights events to the specified objects when a trigger is used
// designed to be called from a wrapper script (eg. tr_sls2_off_en)
// nEvent: the sls2 light event to send
// oTrigger: the trigger object sending the event
// The trigger variable "fittingTag" defines which objects get the event
// The trigger enter/exit script defines the event sent
void SLS2TriggerLightEvent(int nEvent, object oTrigger) {
	string sFittingTag = GetLocalString(oTrigger,"fittingTag");
	if (sFittingTag!="") {
		int i = 0;
		object oFitting = GetObjectByTag(sFittingTag,i);
		while (oFitting!=OBJECT_INVALID) {
			SignalEvent(oFitting,EventUserDefined(nEvent));
			i++;
			oFitting = GetObjectByTag(sFittingTag,i);
		}
	}
}

// sends a light event to all object within a sphere shape
// nEvent: the sls2 light event to send
// fRange: the sphere radius
// lLocation: the location of the centre of the sphere
void SLS2ShapeLightEvent(int nEvent, float fRange, location lLocation) {
	object oObject = GetFirstObjectInShape(SHAPE_SPHERE,fRange,lLocation,FALSE,OBJECT_TYPE_ALL);
	float fDelay = 0.0f;
	while (oObject != OBJECT_INVALID) {
		DelayCommand(fDelay,SignalEvent(oObject,EventUserDefined(nEvent)));
		fDelay = fDelay + SLS2_EVENT_DELAY;
		oObject = GetNextObjectInShape(SHAPE_SPHERE,fRange,lLocation,FALSE,OBJECT_TYPE_ALL);
	}
}

// change the light/vfx blueprints for the specified objects
// sTag: the tag of the objects to change
//       will attempt to change OBJECT_SELF if blank
// sNewLightBP: new light blueprint, no change if blank
// sNewVfxBP: new vfx blueprint, no change if blank
void SLS2SetBlueprints(string sTag="",string sNewLightBP="",string sNewVfxBP="",int bDelay=0) {
	if (sTag=="") {
		// no tag, change OBJECT_SELF
		SLS2ObjectSetBlueprints(OBJECT_SELF, sNewLightBP, sNewVfxBP);
	} else {
		// change objects with matching tag
		int i = 0;
		float fDelay = 0.0f;
		object oFitting = GetObjectByTag(sTag,i);
		while (oFitting!=OBJECT_INVALID) {
			if (bDelay) {
				DelayCommand(fDelay,SLS2ObjectSetBlueprints(oFitting, sNewLightBP, sNewVfxBP));
				fDelay = fDelay + SLS2_EVENT_DELAY;
			} else {
				SLS2ObjectSetBlueprints(oFitting, sNewLightBP, sNewVfxBP);
			}
			i++;
			oFitting = GetObjectByTag(sTag,i);
		}
	}
}

// This is the main function that does the actual turning on and off
// oFitting: the object of which to set the state
// iState: the state to which the light should be changed
void SLS2SetLightState(object oFitting, int iState) {
	if (GetLocalInt(oFitting,"sls2_state")!=iState) {
		switch (GetObjectType(oFitting)) {
			case OBJECT_TYPE_CREATURE:
				if ((iState==SLS2_LIGHTSTATE_ON)||(iState==SLS2_LIGHTSTATE_PERMAON)) {
					//SpeakString(GetTag(oFitting)+": SLS2 Turning On");
					// turn light on
					// -------------
					object oOtherItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oFitting);
					object oTorch = CreateItemOnObject("nw_it_torch001",oFitting,1,"sls2_torch",FALSE);
					SetLocalObject(oFitting,"sls2_otheritem",oOtherItem);
					AssignCommand(oFitting,ClearAllActions());
					if (oOtherItem!=OBJECT_INVALID) {
						AssignCommand(oFitting,ActionUnequipItem(oOtherItem));
					}
					AssignCommand(oFitting,ActionEquipItem(oTorch,INVENTORY_SLOT_LEFTHAND));
				} else {
					//SpeakString(GetTag(oFitting)+": SLS2 Turning Off");
					// turn light off
					// --------------
					object oTorch = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oFitting);
					object oOtherItem = GetLocalObject(oFitting,"sls2_otheritem");
					AssignCommand(oFitting,ClearAllActions());
					AssignCommand(oFitting,ActionUnequipItem(oTorch));
					DestroyObject(oTorch);
					if (oOtherItem!=OBJECT_INVALID) {
						AssignCommand(oFitting,ActionEquipItem(oOtherItem,INVENTORY_SLOT_LEFTHAND));
					}
				}
				break;
			case OBJECT_TYPE_PLACEABLE:
				string sLightTag = GetLocalString(oFitting,"lightTag");
				string sEffectTag = GetLocalString(oFitting,"vfxTag");
				string sSoundTag = GetLocalString(oFitting,"soundTag");
				string sEffectBP = GetLocalString(oFitting,"vfxBlueprint");
				if ((iState==SLS2_LIGHTSTATE_ON)||(iState==SLS2_LIGHTSTATE_PERMAON)) {
					//SpeakString(GetTag(oFitting)+": SLS2 Turning On");
					// turn light on
					// -------------
					// activate light objects
					if (sLightTag!="") {
						int iLightCount = 0;
						object oLight = GetObjectByTag(sLightTag,iLightCount);
						while (oLight != OBJECT_INVALID) {
							SetLightActive(oLight,TRUE);
							iLightCount++;
							oLight = GetObjectByTag(sLightTag,iLightCount);
						}
					}
					// create vfx
					// note: watch for double spawn, on -> permaon
					if (sEffectTag!="") {
						int iEffectCount = GetLocalInt(oFitting,"sls2_effectcount");
						int i;
						for (i=0; i<iEffectCount; i++) {
							CreateObject(OBJECT_TYPE_PLACED_EFFECT,sEffectBP,GetLocalLocation(oFitting,"sls2_fxloc_"+IntToString(i)),FALSE,sEffectTag);
						}
					}
					// play sounds
					if (sSoundTag!="") {
						int iSoundCount = 0;
						object oSound = GetObjectByTag(sSoundTag,iSoundCount);
						while (oSound != OBJECT_INVALID) {
							SoundObjectPlay(oSound);
							iSoundCount++;
							oSound = GetObjectByTag(sSoundTag,iSoundCount);
						}
					}
					// is this a dual state placeable?
					if (GetLocalInt(oFitting,"sls2_dualstate")==1) {
						// if so, spawn new placeable
						object oNewFitting = CreateObject(OBJECT_TYPE_PLACEABLE,GetLocalString(oFitting,"onBlueprint"),GetLocalLocation(oFitting,"sls2_placeableloc"),FALSE,GetLocalString(oFitting,"sls2_placeabletag"));
						// copy variables from old to new
						SLS2CopyVars(oFitting,oNewFitting);
						// delete old placeable
						DestroyObject(oFitting);
						// make oFitting point to new object
						oFitting = oNewFitting;
					}
				} else {
					//SpeakString(GetTag(oFitting)+": SLS2 Turning Off");
					// turn light off
					// --------------
					// deactivate light objects
					if (sLightTag!="") {
						int iLightCount = 0;
						object oLight = GetObjectByTag(sLightTag,iLightCount);
						while (oLight != OBJECT_INVALID) {
							SetLightActive(oLight,FALSE);
							iLightCount++;
							oLight = GetObjectByTag(sLightTag,iLightCount);
						}
					}
					// destroy vfx
					if (sEffectTag!="") {
						int iEffectCount = GetLocalInt(oFitting,"sls2_effectcount");
						int i;
						for (i=0; i<iEffectCount; i++) {
							DestroyObject(GetObjectByTag(sEffectTag,i));
						}
					}
					// stop sounds
					if (sSoundTag!="") {
						int iSoundCount = 0;
						object oSound = GetObjectByTag(sSoundTag,iSoundCount);
						while (oSound != OBJECT_INVALID) {
							SoundObjectStop(oSound);
							iSoundCount++;
							oSound = GetObjectByTag(sSoundTag,iSoundCount);
						}
					}
					// is this a dual state placeable?
					if (GetLocalInt(oFitting,"sls2_dualstate")==1) {
						// if so, spawn new placeable
						object oNewFitting = CreateObject(OBJECT_TYPE_PLACEABLE,GetLocalString(oFitting,"offBlueprint"),GetLocalLocation(oFitting,"sls2_placeableloc"),FALSE,GetLocalString(oFitting,"sls2_placeabletag"));
						// copy variables from old to new
						SLS2CopyVars(oFitting,oNewFitting);
						// delete old placeable
						DelayCommand(1.0f,DestroyObject(oFitting));
						// make oFitting point to new object
						oFitting = oNewFitting;
					}
					
				}
				break;
		}
		SetLocalInt(oFitting,"sls2_state",iState);
	} else {
		//SpeakString(GetTag(oFitting)+": SLS2 Do Nothing");
	}
}

// based on the variables of oFitting and the current time
// decide if the light should be on or off
// oFitting: the light fitting to check
int SLS2CalcLightState(object oFitting) {
	int nHour = GetTimeHour();
	int nOff = GetLocalInt(oFitting,"offHours");
	int nOn = GetLocalInt(oFitting,"onHours");
	int nState = GetLocalInt(oFitting,"sls2_state");
	if ((nOff==0)&&(nOn==0)) {
		return nState;
	} else {
		if (nState==SLS2_LIGHTSTATE_PERMAON) {
			return SLS2_LIGHTSTATE_PERMAON;
		}
		if (nState==SLS2_LIGHTSTATE_PERMAOFF) {
			return SLS2_LIGHTSTATE_PERMAOFF;
		}
		if (nOff==nOn) {
			return SLS2_LIGHTSTATE_ON;
		} else {
			if (nOff<nOn) {			
				if ((nHour>=0)&&(nHour<nOff)) {
					return SLS2_LIGHTSTATE_ON;
				}
				if ((nHour>=nOff)&&(nHour<=nOn)) {
					return SLS2_LIGHTSTATE_OFF;
				}
				if ((nHour>nOn)&&(nHour<=23)) {
					return SLS2_LIGHTSTATE_ON;
				}
			} else {
				if ((nHour>=0)&&(nHour<nOn)) {
					return SLS2_LIGHTSTATE_OFF;
				}
				if ((nHour>=nOn)&&(nHour<=nOff)) {
					return SLS2_LIGHTSTATE_ON;
				}
				if ((nHour>nOff)&&(nHour<=23)) {
					return SLS2_LIGHTSTATE_OFF;
				}
			}
		}
		return 0;
	}
}

// toggle the light state of oFitting to it's opposite (SLS2_EVENT_TOGGLE)
int SLS2ToggleLightState(object oFitting) {
	int iState = GetLocalInt(oFitting,"sls2_state");
	if (iState==SLS2_LIGHTSTATE_PERMAON) {
		return SLS2_LIGHTSTATE_PERMAON;
	}
	if (iState==SLS2_LIGHTSTATE_PERMAOFF) {
		return SLS2_LIGHTSTATE_PERMAOFF;
	}
	if (iState==SLS2_LIGHTSTATE_ON) {
		return SLS2_LIGHTSTATE_OFF;
	} else {
		return SLS2_LIGHTSTATE_ON;
	}
}

// toggle the light state of oFitting to it's opposite (PC Used)
void SLS2LightUsed(object oFitting) {
	int nState = GetLocalInt(oFitting,"sls2_state");
	int nNewState;
	if (nState==SLS2_LIGHTSTATE_PERMAON) {
		nNewState = SLS2_LIGHTSTATE_PERMAOFF;
	}
	if (nState==SLS2_LIGHTSTATE_PERMAOFF) {
		nNewState = SLS2_LIGHTSTATE_PERMAON;
	}
	if (nState==SLS2_LIGHTSTATE_ON) {
		nNewState = SLS2_LIGHTSTATE_OFF;
	} else {
		nNewState = SLS2_LIGHTSTATE_ON;
	}
	SLS2SetLightState(oFitting,nNewState);
}

// resets oFitting to it's default state based on it's variables
int SLS2ResetLightState(object oFitting) {
	int nHour = GetTimeHour();
	int nOff = GetLocalInt(oFitting,"offHours");
	int nOn = GetLocalInt(oFitting,"onHours");
	if ((nOff==0)&&(nOn==0)) {
		if (GetLocalString(oFitting,"startState")=="off") {
			return SLS2_LIGHTSTATE_PERMAOFF;
		} else {
			if (GetObjectType(oFitting)==OBJECT_TYPE_CREATURE) {
				return SLS2_LIGHTSTATE_PERMAOFF;
			} else {
				return SLS2_LIGHTSTATE_PERMAON;
			}
		}
	}
	if (nOff==nOn) {
		return SLS2_LIGHTSTATE_ON;
	} else {
		if (nOff<nOn) {			
			if ((nHour>=0)&&(nHour<nOff)) {
				return SLS2_LIGHTSTATE_ON;
			}
			if ((nHour>=nOff)&&(nHour<=nOn)) {
				return SLS2_LIGHTSTATE_OFF;
			}
			if ((nHour>nOn)&&(nHour<=23)) {
				return SLS2_LIGHTSTATE_ON;
			}
		} else {
			if ((nHour>=0)&&(nHour<nOn)) {
				return SLS2_LIGHTSTATE_OFF;
			}
			if ((nHour>=nOn)&&(nHour<=nOff)) {
				return SLS2_LIGHTSTATE_ON;
			}
			if ((nHour>nOff)&&(nHour<=23)) {
				return SLS2_LIGHTSTATE_OFF;
			}
		}
	}
	return 0;

}

// print out the current time, properly zero padded
void SLS2SpeakTime() {
	string sTmp;
	string sStr = "Time is ";
	sTmp = IntToString(GetTimeHour());
	if (GetStringLength(sTmp)<2) {
		sStr = sStr + "0";
	}
	sStr = sStr + sTmp + ":";
	sTmp = IntToString(GetTimeMinute());
	if (GetStringLength(sTmp)<2) {
		sStr = sStr + "0";
	}
	sStr = sStr + sTmp + ":";
	sTmp = IntToString(GetTimeSecond());
	if (GetStringLength(sTmp)<2) {
		sStr = sStr + "0";
	}
	sStr = sStr + sTmp;
	SpeakString(sStr);
}

// start a set of chain lights running
// sTag: the tag of the lights in the chain
// nLength: the number of lights in the chain
// sType: the type of the chain (loop/bump)
// nDir: the direction of the chain (0/1)
// designed to be called by a wrapper script (see tr_sls2_chainon_en)
void SLS2StartChain(string sTag,int nLength,string sType,int nDir) {
	
	object oArea = GetArea(OBJECT_SELF);
	// is chain already running?
	if (GetLocalInt(oArea,"chain_"+sTag+"_running")==0) {
	
		// store main chain settings
		if (nDir==1) {
			SetLocalInt(oArea,"chain_"+sTag+"_dir",0);
		} else {
			SetLocalInt(oArea,"chain_"+sTag+"_dir",1);
		}
		SetLocalInt(oArea,"chain_"+sTag+"_running",1);
	
		// set chain light settings
		int i;
		for (i=1; i<=nLength; i++) {
			object oFitting = GetObjectByTag(sTag+IntToString(i));
			// store chain settings
			SetLocalString(oFitting,"chain_tag",sTag);
			SetLocalInt(oFitting,"chain_length",nLength);
			SetLocalString(oFitting,"chain_type",sType);
			SetLocalInt(oFitting,"chain_id",i);	
		}
		
		SLS2ObjectLightEvent(SLS2_EVENT_CHAIN,sTag+"1");
		
	}
}

// stop a set of chain lights from running
// sTag: the tag of the lights in the chain
// designed to be called by a wrapper script (see tr_sls2_chainoff_en)
void SLS2StopChain(string sTag) {
	object oArea = GetArea(OBJECT_SELF);
	// is chain already running?
	if (GetLocalInt(oArea,"chain_"+sTag+"_running")==1) {
		// if so stop it
		SetLocalInt(oArea,"chain_"+sTag+"_running",0);
	}
}

// run a chain event on the specified light fitting
// turn on, wait for specified delay, run chain event end
void SLS2ChainEvent(object oFitting) {
	// check if light has specified delay otherwise default to 0.5 secs
	float fDelay = GetLocalFloat(oFitting,"chainDelay");
	if (fDelay==0.0f) {
		fDelay = 0.5f;
	}
	
	// turn light on
	SLS2SetLightState(oFitting,SLS2_LIGHTSTATE_ON);
	// delay then end
	DelayCommand(fDelay,SLS2ChainEventEnd(oFitting));

}

// end a chain event running on a light fitting
// turn light off, calc next light in chain, send chain event
void SLS2ChainEventEnd(object oFitting) {
	// turn light off
	SLS2SetLightState(oFitting,SLS2_LIGHTSTATE_OFF);

	// get settings
	object oArea = GetArea(oFitting);
	string sTag = GetLocalString(oFitting,"chain_tag");
	int nLen = GetLocalInt(oFitting,"chain_length");
	string sType = GetLocalString(oFitting,"chain_type");
	int nDir = GetLocalInt(oArea,"chain_"+sTag+"_dir");
	int nRun = GetLocalInt(oArea,"chain_"+sTag+"_running");
	int nNext;

	// chain still running?
	if (nRun==1) {
		// which direction?
		if (nDir==1) {
			// up
			nNext = GetLocalInt(oFitting,"chain_id")+1;
			if (nNext>nLen) {
				if (sType=="loop") {
					nNext = 1;
				} else {
					nNext = GetLocalInt(oFitting,"chain_id")-1;
					SetLocalInt(oArea,"chain_"+sTag+"_dir",0);
				}
			}
		} else {
			// down
			nNext = GetLocalInt(oFitting,"chain_id")-1;
			if (nNext<1) {
				if (sType=="loop") {
					nNext = nLen;
				} else {
					nNext = 2;
					SetLocalInt(oArea,"chain_"+sTag+"_dir",1);
				}
			}
		}
		SLS2ObjectLightEvent(SLS2_EVENT_CHAIN,sTag+IntToString(nNext));
	}
}

// internal function, called by SLS2ObjectOnUserDefinedEvent
void SLS2Initialize(object oFitting) {
	// only init if not done already
	if (GetLocalInt(oFitting,"sls2_init")==0) {
		switch (GetObjectType(oFitting)) {
			case OBJECT_TYPE_CREATURE:
				// is a creature
				// spawn a torch on the creature
				// actually can just do that when turing on
				break;
			case OBJECT_TYPE_PLACEABLE:
				// is a placeable
				// Cycle associated effects and save their location
				string sEffectTag = GetLocalString(oFitting,"vfxTag");
				int iEffectCount = 0;
				object oEffect = GetObjectByTag(sEffectTag,iEffectCount);
				while (oEffect != OBJECT_INVALID) {
					SetLocalLocation(oFitting,"sls2_fxloc_"+IntToString(iEffectCount),GetLocation(oEffect));
					iEffectCount++;
					oEffect = GetObjectByTag(sEffectTag,iEffectCount);
				}
				// Check if this is a dual state placeable
				if ((GetLocalString(oFitting,"onBlueprint")!="")&&(GetLocalString(oFitting,"offBlueprint")!="")) {
					// if so, set dualstate var and save placeable location and tag.
					SetLocalInt(oFitting,"sls2_dualstate",1);
					SetLocalString(oFitting,"sls2_placeabletag",GetTag(oFitting));
					SetLocalLocation(oFitting,"sls2_placeableloc",GetLocation(oFitting));
				}
				SetLocalInt(oFitting,"sls2_effectcount",iEffectCount);
				break;			
		}
		// set general variables
		int iOff = GetLocalInt(oFitting,"offHours");
		int iOn = GetLocalInt(oFitting,"onHours");
		string sStartState = GetLocalString(oFitting,"startState");
		if (sStartState=="") {
			if ((iOff==0)&&(iOn==0)) {
				if (GetObjectType(oFitting)==OBJECT_TYPE_CREATURE) {
					SetLocalInt(oFitting,"sls2_state",SLS2_LIGHTSTATE_PERMAOFF);
				} else {
					SetLocalInt(oFitting,"sls2_state",SLS2_LIGHTSTATE_PERMAON);
				}
			} else {
				if (GetObjectType(oFitting)==OBJECT_TYPE_CREATURE) {
					SetLocalInt(oFitting,"sls2_state",SLS2_LIGHTSTATE_OFF);
				} else {
					SetLocalInt(oFitting,"sls2_state",SLS2_LIGHTSTATE_ON);
				}
			}
		} else {
			if (sStartState=="off") {
				SLS2SetLightState(oFitting,SLS2_LIGHTSTATE_PERMAOFF);
				SetLocalInt(oFitting,"sls2_state",SLS2_LIGHTSTATE_PERMAOFF);
			} else {
				SetLocalInt(oFitting,"sls2_state",SLS2_LIGHTSTATE_PERMAON);
			}
		}
		SetLocalInt(oFitting,"sls2_init",1);
		// set light to relavant starting state
		SLS2SetLightState(oFitting,SLS2CalcLightState(oFitting));
	}
}

// internal function, copies variables from one object to another.
void SLS2CopyVars(object oSrc, object oTar) {

	SetLocalInt(oTar,"onHours",GetLocalInt(oSrc,"onHours"));
	SetLocalInt(oTar,"offHours",GetLocalInt(oSrc,"offHours"));

	string sLightTag = GetLocalString(oSrc,"lightTag");
	string sEffectTag = GetLocalString(oSrc,"vfxTag");
	string sSoundTag = GetLocalString(oSrc,"soundTag");
	string sEffectBP = GetLocalString(oSrc,"vfxBlueprint");
	if (sLightTag!="") {
		SetLocalString(oTar,"lightTag",sLightTag);
	}	
	if (sEffectTag!="") {
		SetLocalString(oTar,"vfxTag",sEffectTag);
		int nEffectCount = GetLocalInt(oSrc,"sls2_effectcount");
		int i;
		for (i=0; i<nEffectCount; i++) {
			SetLocalLocation(oTar,"sls2_fxloc_"+IntToString(i),GetLocalLocation(oSrc,"sls2_fxloc_"+IntToString(i)));
		}
		SetLocalInt(oTar,"sls2_effectcount",nEffectCount);	
	}
	if (sSoundTag!="") {
		SetLocalString(oTar,"soundTag",sSoundTag);
	}
	if (sEffectBP!="") {
		SetLocalString(oTar,"vfxBlueprint",sEffectBP);
	}

	string sStartState = GetLocalString(oSrc,"startState");
	if (sStartState!="") {
		SetLocalString(oTar,"startState",sStartState);
	}
	
	SetLocalInt(oTar,"sls2_state",GetLocalInt(oSrc,"sls2_state"));
	SetLocalInt(oTar,"sls2_init",1);
	
	if (GetLocalInt(oSrc,"sls2_dualstate")==1) {
		SetLocalInt(oTar,"sls2_dualstate",1);
		SetLocalString(oTar,"sls2_placeabletag",GetLocalString(oSrc,"sls2_placeabletag"));
		SetLocalLocation(oTar,"sls2_placeableloc",GetLocalLocation(oSrc,"sls2_placeableloc"));
		SetLocalString(oTar,"onBlueprint",GetLocalString(oSrc,"onBlueprint"));
		SetLocalString(oTar,"offBlueprint",GetLocalString(oSrc,"offBlueprint"));
	}
	
	if (GetLocalFloat(oSrc,"oneShotDelay")!=0.0f) {
		SetLocalFloat(oTar,"oneShotDelay",GetLocalFloat(oSrc,"oneShotDelay"));
	}
	if (GetLocalFloat(oSrc,"chainDelay")!=0.0f) {
		SetLocalFloat(oTar,"chainDelay",GetLocalFloat(oSrc,"chainDelay"));
	}
	if (GetLocalInt(oSrc,"chain_length")!=0) {
		SetLocalInt(oTar,"chain_length",GetLocalInt(oSrc,"chain_length"));
	}
	if (GetLocalInt(oSrc,"chain_id")!=0) {
		SetLocalInt(oTar,"chain_id",GetLocalInt(oSrc,"chain_id"));
	}
	if (GetLocalString(oSrc,"chain_tag")!="") {
		SetLocalString(oTar,"chain_tag",GetLocalString(oSrc,"chain_tag"));
	}
	if (GetLocalString(oSrc,"chain_type")!="") {
		SetLocalString(oTar,"chain_type",GetLocalString(oSrc,"chain_type"));
	}
	
}

// internal function, dumps object variable info to chat.
void SLS2VarDump(object oFitting) {
	string sTag = GetTag(oFitting);
	SpeakString("================================");
	SpeakString(sTag+": SLS2 Variable Dump");
	SpeakString("onHours: "+IntToString(GetLocalInt(oFitting,"onHours")));
	SpeakString("offHours: "+IntToString(GetLocalInt(oFitting,"offHours")));
	SpeakString("lightTag: "+GetLocalString(oFitting,"lightTag"));
	SpeakString("vfxTag: "+GetLocalString(oFitting,"vfxTag"));
	SpeakString("soundTag: "+GetLocalString(oFitting,"soundTag"));
	SpeakString("vfxBlueprint: "+GetLocalString(oFitting,"vfxBlueprint"));
	SpeakString("effectCount: "+IntToString(GetLocalInt(oFitting,"sls2_effectcount")));
	SpeakString("startState: "+GetLocalString(oFitting,"startState"));
	string sState = "";
	switch (GetLocalInt(oFitting,"sls2_state")) {
		case SLS2_LIGHTSTATE_ON:
			sState = "ON";
			break;
		case SLS2_LIGHTSTATE_OFF:
			sState = "OFF";
			break;
		case SLS2_LIGHTSTATE_PERMAON:
			sState = "PERMA ON";
			break;
		case SLS2_LIGHTSTATE_PERMAOFF:
			sState = "PERMA OFF";
			break;
		default:
			sState = "UNKNOWN";
			break;
		}
	SpeakString("state: "+sState+" :"+IntToString(GetLocalInt(oFitting,"sls2_state")));
	
	
	SpeakString("================================");
}