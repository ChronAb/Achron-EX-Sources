
//general unit specific values
#include ../ais_src/common/include/unit_common_header.aih

//unit_creator specific values
#include ../ais_src/common/include/unit_creator.aih


//SM specific values
//PLAYER DEAD MODE
#define NON_PRODUCING 1
#define NON_PRODUCING_NON_GATES 2

//END GAME MODE
#define ANYTIME_DEFEAT 1
#define TOTAL_DEFEAT 2


#define ACHRONAL_UI_CONTROLS 80
#define PRE_GAME_SETTINGS_AF 48


#define CONTROLFLAGS_FOG_OF_WAR 0
#define CONTROLFLAGS_PLAYER_CONTROL 1

//player speed rates 
// EXAMPLE:  player = 0; PERFORM SET_PLAYER_TIME_RATE $RATE_FAST;  //force player 1 to play in fast-forward
#define RATE_PAUSE 0 
#define RATE_SLOW 1
#define RATE_NORMAL 2
#define RATE_FAST 3

/******  CODE TEMPLATE FOR CHANGING OWNER FOR SEVERAL MATCHING UNITS (cycle-heavy, order one/tick instead if possible)
	while (1) {
		target = $GET_UNIT [ query->Owner == 1 && query->Carrier==unit_creator ];
		if (target->IsAlive==1) { PERFORM SET_UNIT_OWNER 0; 
			PERFORM SET_OTHER_ADDITIONAL_PARAMS 0; PERFORM SET_OTHER_OBJECTIVE 0; //neutral units only
		} else { break; } }
*/		

/****** CODE TEMPLATE FOR ORDERING SEVERAL MATCHING UNITS (cycle-heavy, order one/tick instead if possible):
		while (1) {
			target = $GET_UNIT [ query->Owner == 1 && query->Objective == 0]; //find all idle units for player 2
			if (target->IsAlive==1) { $_ORDER }  //$GO_ATTACK or $DISPATCH_OBJECTIVE
			else { break; } }
*/	


//SM specific code 
#define CALCULATE_MIN_SEC_HOUR int min = 0;int sec = 0;int hour = 0;\
			if (totalSecs < 3600) { min = totalSecs / 60; sec = totalSecs % 60; } \
			else { hour = totalSecs / 3600; totalSecs = totalSecs % 3600; min = totalSecs / 60;sec = totalSecs % 60; }

#define SAY_CALCULATED_TIME if (hour>0) { say "0",hour,":"; } if (min<10) { say "0"; } say min, ":";\
					if (sec<10) { say "0"; } say sec; 

					
int _x = 0;
int _y = 0;
int _z = 0;
int _dest = 0;
int _obj = 0;

#define SM_SET_OBJECTIVE af1[0,4] = 

#define SM_SET_STEP af1[4,6] = 

#define SM_SET_MAX_STEP af1[10,6] = 

#define PERFORM_SET_SM_OBJECTIVE target = 1; PERFORM SET_ACHRONAL_FIELD af1;

/*
dispatch target on objective _obj to _x, _y, _z Or to unit stored in _dest
example:
	_dest = 0; _x = 153; _y = 164; _obj = $OBJECTIVE_TELEPORT; $DISPATCH_OBJECTIVE 
*/
#define DISPATCH_OBJECTIVE if(target) { \
	if (_dest==0) { _dest[$Xpos] = _x; _dest[$Ypos] = _y; _dest[$Zpos] = _z; }\
	PERFORM SET_OTHER_ADDITIONAL_PARAMS 0;\
	PERFORM SET_OTHER_OBJECTIVE_PARAMS _dest;\
	PERFORM SET_OTHER_OBJECTIVE _obj; }
	
/*
make target attack position at _x, _y, or unit if _dest is set
example:
   _z = -1; _x = 204; _y = 256; _dest = 0; $GO_ATTACK //attack position
   _x = 0; _y = 0; _dest = enemy; $GO_ATTACK //attack unit
*/
#define GO_ATTACK \
		if(_dest==0) { \
			if(_z==-1) { \
				_dest[$Xpos] = _x; _dest[$Ypos] = _y;\
				if (target->ZPosition==0) { _z = 0; } \
				else { \
					PERFORM GET_MAP_NEXT_Z_POSITION_UP _dest; _z = perf_ret[$Zpos]; } \
			}\
			_obj = $OBJECTIVE_ATTACKPOS_DISPATCH; \
		}\
		else { _obj = $OBJECTIVE_ATTACKUNIT_DISPATCH; }\
		$DISPATCH_OBJECTIVE\
		_uc_ap = 0; _dest = 0;
		



int queryPos = 0;
int _uowner = 0;
int _uclass = 0;
int _leftX = 0;
int _topY = 0;
int _rightX = 0;
int _bottomY = 0;

// looks for idle unit specified by _uowner and the x/y area coords and tells it to attack a random spot in that area
#define RANDOM_ATTACK_IN_AREA target = QUERY UNIT [unit] MIN [1] \
	WHERE [ query->Owner == _uowner && query->Objective==0 &&\
		  (queryPos=query->Position)[$Xpos] >= _leftX && \
		  queryPos[$Xpos] <= _rightX && \
		  queryPos[$Ypos] >= _topY && \
		  queryPos[$Ypos] <= _bottomY ];\
	if (target->IsAlive==1) {\
		PERFORM RAND;  _x = _leftX + perf_ret % (_rightX - _leftX);\
		PERFORM RAND;  _y = _topY + perf_ret % (_bottomY - _topY);\
		_dest = 0; $GO_ATTACK\
	}

#define GET_ANY_UNIT_AT_POSITION QUERY UNIT [unit] MIN [1] \
							WHERE [ query->Owner == _uowner && \
                                  (queryPos=query->Position)[$Xpos] >= _leftX && \
                                  queryPos[$Xpos] <= _rightX && \
                                  queryPos[$Ypos] >= _topY && \
                                  queryPos[$Ypos] <= _bottomY \
                                ]; 

#define GET_UNIT_AT_POSITION QUERY UNIT [unit] MIN [1] \
							WHERE [query->Class == _uclass && \
                                  query->Owner == _uowner && \
                                  (queryPos=query->Position)[$Xpos] >= _leftX && \
                                  queryPos[$Xpos] <= _rightX && \
                                  queryPos[$Ypos] >= _topY && \
                                  queryPos[$Ypos] <= _bottomY \
                                ]; 

#define GET_ANY_NONOBJ_UNIT_AT_POSITION QUERY UNIT [unit] MIN [1] \
							WHERE [ query->Owner == _uowner && query->Objective!=_obj &&\
                                  (queryPos=query->Position)[$Xpos] >= _leftX && \
                                  queryPos[$Xpos] <= _rightX && \
                                  queryPos[$Ypos] >= _topY && \
                                  queryPos[$Ypos] <= _bottomY \
                                ]; 								

#define GET_ANY_OBJ_UNIT_AT_POSITION QUERY UNIT [unit] MIN [1] \
							WHERE [ query->Owner == _uowner && query->Objective==_obj &&\
                                  (queryPos=query->Position)[$Xpos] >= _leftX && \
                                  queryPos[$Xpos] <= _rightX && \
                                  queryPos[$Ypos] >= _topY && \
                                  queryPos[$Ypos] <= _bottomY \
                                ]; 								
								
#define GET_ANY_NOCOMMANDER_UNIT_AT_POSITION QUERY UNIT [unit] MIN [1] \
							WHERE [ query->Owner == _uowner && query->Commander!=_dest &&\
                                  (queryPos=query->Position)[$Xpos] >= _leftX && \
                                  queryPos[$Xpos] <= _rightX && \
                                  queryPos[$Ypos] >= _topY && \
                                  queryPos[$Ypos] <= _bottomY \
                                ]; 						
								
#define GET_UNIT_ANYWHERE QUERY UNIT [unit] MIN [1] \
							WHERE [query->Class == _uclass && query->Owner == _uowner ]; 
                                    		

// GET_UNIT_COUNT Macro to get a count of unit that match some criteria
// int number_of_units =  $GET_UNIT_COUNT [ <YOUR_CRITERIA_LOGIC_GOES_HERE> ];
// EXAMPLE: int num_player1_marines  = $GET_UNIT_COUNT [query.Rank == $MARINE_RANK && query->Owner == 0 ]; 
//          returns the number of marines that player 1 owns (player numbers are 0-based)
#define GET_UNIT_COUNT QUERY VALUE [unit] SUM [1] WHERE 		

// GET_UNIT Macro to get a specific unit that matches some criteria
// object someunit = $GET_UNIT [ <YOUR_CRITERIA_LOGIC_GOES_HERE> ];
// EXAMPLE: object tank = $GET_UNIT [query->Class == $TANK_CLASS && query->Owner == 3 && 
//									(query->Commander)->IsAlive == 1 && query->YPosition <= 30 ];
//          finds player 4's tank ,that has a commander and is located in the north-most 30 tiles on the map
#define GET_UNIT QUERY UNIT [unit] MIN [1] WHERE 

//use this in single player levels 
//example: _uclass = $UNITCREATOR_CLASS; _uowner = 1; $INITIALIZE_UNIT_CREATOR_AND_UI
#define INITIALIZE_UNIT_CREATOR_AND_UI PERFORM GET_ACHRONAL_FIELD $ACHRONAL_UI_CONTROLS;\
		int AchronalUIControls = perf_ret;\
		if (current==0 && present==0) {\
			object _uc = $GET_UNIT_ANYWHERE\
			AchronalUIControls[$STOREDUNIT] = _uc;\
			target = $ACHRONAL_UI_CONTROLS; \
			PERFORM SET_ACHRONAL_FIELD AchronalUIControls;\
		}\
		object unit_creator = AchronalUIControls[$STOREDUNIT];
			

/* 

move target in specified direction a set number of tiles
example: will move a unit 12 tiles north-east of it's current location
    int _dist = 12; _obj = $TERRAIN_NORTHEAST; $MOVE_UNIT_DIRECTION  
*/
#define MOVE_UNIT_DIRECTION _dest = 0; int _tpos = target->Position;\
	if (_obj==$TERRAIN_WEST) {	_x = _tpos[$Xpos] - _dist; _y = _tpos[$Ypos]; _z = _tpos[$Zpos]; }\
	else if (_obj==$TERRAIN_EAST) {	_x = _tpos[$Xpos] + _dist; _y = _tpos[$Ypos]; _z = _tpos[$Zpos]; }\
	else if (_obj==$TERRAIN_NORTH) { _x = _tpos[$Xpos]; _y = _tpos[$Ypos] - _dist; _z = _tpos[$Zpos]; }\
	else if (_obj==$TERRAIN_SOUTH) { _x = _tpos[$Xpos]; _y = _tpos[$Ypos] + _dist; _z = _tpos[$Zpos]; }\
	else if (_obj==$TERRAIN_SOUTHWEST) { _x = _tpos[$Xpos] - _dist; _y = _tpos[$Ypos] + _dist; _z = _tpos[$Zpos]; }\
	else if (_obj==$TERRAIN_NORTHWEST) { _x = _tpos[$Xpos] - _dist; _y = _tpos[$Ypos] - _dist; _z = _tpos[$Zpos]; }\
	else if (_obj==$TERRAIN_SOUTHEAST) { _x = _tpos[$Xpos] + _dist; _y = _tpos[$Ypos] + _dist; _z = _tpos[$Zpos]; }\
	else if (_obj==$TERRAIN_NORTHEAST) { _x = _tpos[$Xpos] + _dist; _y = _tpos[$Ypos] - _dist; _z = _tpos[$Zpos]; }\
	else if (_obj==$TERRAIN_UP) {	_x = _tpos[$Xpos]; _y = _tpos[$Ypos]; _z = _tpos[$Zpos] + _dist; }\
	else if (_obj==$TERRAIN_DOWN) {	_x = _tpos[$Xpos]; _y = _tpos[$Ypos]; _z = _tpos[$Zpos] - _dist; }\
	_obj = $OBJECTIVE_MOVE_DISPATCH; $DISPATCH_OBJECTIVE

			
		
int _uc_ap = 0;
int _change_owner = 0;		//UNIT_CREATOR_CHANGE_CONTROLLER , UNIT_CREATOR_RELEASE_UNIT
int _owner = 0;				//UNIT_CREATOR_CHANGE_CONTROLLER , UNIT_CREATOR_RELEASE_UNIT
int _change_commander = 0;	//UNIT_CREATOR_CHANGE_CONTROLLER , UNIT_CREATOR_RELEASE_UNIT
int _commander = 0;			//UNIT_CREATOR_CHANGE_CONTROLLER
int _all = 0;				//UNIT_CREATOR_CHANGE_CONTROLLER
//int _dest = 0;			//UNIT_CREATOR_RELOCATE , UNIT_CREATOR_RELEASE_UNIT
int _release_next = 0;		//UNIT_CREATOR_RELEASE_UNIT
int _release_teleport = 0;	//UNIT_CREATOR_RELEASE_UNIT
int _create_action = 0; 	//UNIT_CREATOR_CREATE_UNIT
object _uc_target = 0;		//UNIT_CREATOR_CHANGE_CONTROLLER , UNIT_CREATOR_RELEASE_UNIT 
							//UNIT_CREATOR_TAKE_UNIT, UNIT_CREATOR_TELEPORT_UNIT


#define UNIT_CREATOR_CHANGE_CONTROLLER target = unit_creator;\
		_uc_ap = 0;\
		_uc_ap[$UC_AP_CHANGE_OWNER] = _change_owner;\
		_uc_ap[$UC_AP_OWNER] = _owner;\
		_uc_ap[$UC_AP_CHANGE_COMMANDER] = _change_commander;\
		_uc_ap[$UC_AP_TARGET] = _commander;\
		_uc_ap[$UC_AP_CHANGE_ALL] = _all; \
		PERFORM SET_OTHER_OBJECTIVE_PARAMS _uc_target;\
		PERFORM SET_OTHER_ADDITIONAL_PARAMS _uc_ap;\
		PERFORM SET_OTHER_OBJECTIVE $UC_OBJECTIVE_CHANGE_CONTROLLER;\
		_uc_ap = 0;

#define UNIT_CREATOR_RELEASE_UNIT target = unit_creator;\
		_uc_ap = 0;\
		_uc_ap[$UC_AP_CHANGE_OWNER] = _change_owner;\
		_uc_ap[$UC_AP_OWNER] = _owner;\
		_uc_ap[$UC_AP_CHANGE_COMMANDER] = _change_commander;\
		_uc_ap[$UC_AP_TARGET] = _uc_target;\
		_uc_ap[$UC_AP_RELEASE_NEXT] = _release_next;\
		_uc_ap[$UC_AP_RELEASE_TELEPORT] = _release_teleport;\
		PERFORM SET_OTHER_OBJECTIVE_PARAMS _dest;\
		PERFORM SET_OTHER_ADDITIONAL_PARAMS _uc_ap;\
		PERFORM SET_OTHER_OBJECTIVE $UC_OBJECTIVE_RELEASE_UNIT;\
		_uc_ap = 0;
		
#define UNIT_CREATOR_TAKE_UNIT target = unit_creator;\
		PERFORM SET_OTHER_OBJECTIVE_PARAMS _uc_target;\
		PERFORM SET_OTHER_ADDITIONAL_PARAMS 0;\
		PERFORM SET_OTHER_OBJECTIVE $UC_OBJECTIVE_TAKE_UNIT;

#define UNIT_CREATOR_RELOCATE target = unit_creator;\
		PERFORM SET_OTHER_OBJECTIVE_PARAMS _dest;\
		PERFORM SET_OTHER_ADDITIONAL_PARAMS 0;\
		PERFORM SET_OTHER_OBJECTIVE $UC_OBJECTIVE_RELOCATE;
		
#define UNIT_CREATOR_CREATE_UNIT target = unit_creator;\
		_uc_ap[$UC_AP_CREATE] = _create_action;\
		PERFORM SET_OTHER_ADDITIONAL_PARAMS _uc_ap;\
		PERFORM SET_OTHER_OBJECTIVE $UC_OBJECTIVE_CREATE_UNIT;\
		_uc_ap = 0;

#define UNIT_CREATOR_TELEPORT_UNIT target = unit_creator;\
		_uc_ap = 0;\
		_uc_ap[$UC_AP_TARGET] = _uc_target;\
		PERFORM SET_OTHER_OBJECTIVE_PARAMS _dest;\
		PERFORM SET_OTHER_ADDITIONAL_PARAMS _uc_ap;\
		PERFORM SET_OTHER_OBJECTIVE $UC_OBJECTIVE_TELEPORT_UNIT;\
		_uc_ap = 0;

		
#define UNIT_CREATOR_KILL_UNIT target = unit_creator;\
		PERFORM SET_OTHER_OBJECTIVE_PARAMS _uc_target;\
		PERFORM SET_OTHER_ADDITIONAL_PARAMS 0;\
		PERFORM SET_OTHER_OBJECTIVE $UC_OBJECTIVE_KILL_UNIT;

//_uc_ap[$UC_AP_NUKE] = 1;  visually drop a nuke, otherwise set _uc_ap to 0 to insta-nuke a location
#define UNIT_CREATOR_ATTACK target = unit_creator;\
		PERFORM SET_OTHER_OBJECTIVE_PARAMS _dest;\
		PERFORM SET_OTHER_ADDITIONAL_PARAMS _uc_ap;\
		PERFORM SET_OTHER_OBJECTIVE $UC_OBJECTIVE_ATTACK;

#define UNIT_CREATOR_ROTATE_UNIT target = unit_creator;\
		PERFORM SET_OTHER_OBJECTIVE_PARAMS _dest;\
		PERFORM SET_OTHER_ADDITIONAL_PARAMS _uc_ap;\
		PERFORM SET_OTHER_OBJECTIVE $UC_OBJECTIVE_ROTATE_UNIT;

#define UI_DISABLE_FOG_OF_WAR int ctrlFlags = player->ControlFlags;\
		if (!ctrlFlags[$CONTROLFLAGS_FOG_OF_WAR]) { \
			ctrlFlags[$CONTROLFLAGS_FOG_OF_WAR] = 1;\
			PERFORM SET_PLAYER_CONTROL_FLAGS ctrlFlags; } \
		if (!AchronalUIControls[$CONTROLFLAGS_FOG_OF_WAR]) {\
			say_to_var "SMHideFogOfWar"; say 1; say_to_var "";\
			AchronalUIControls[$CONTROLFLAGS_FOG_OF_WAR] = 1;\
			target = $ACHRONAL_UI_CONTROLS; PERFORM SET_ACHRONAL_FIELD AchronalUIControls; }

#define UI_ENABLE_FOG_OF_WAR int ctrlFlags = player->ControlFlags;\
		if (ctrlFlags[$CONTROLFLAGS_FOG_OF_WAR]) { \
			ctrlFlags[$CONTROLFLAGS_FOG_OF_WAR] = 0;\
			PERFORM SET_PLAYER_CONTROL_FLAGS ctrlFlags; } \
		if (AchronalUIControls[$CONTROLFLAGS_FOG_OF_WAR]) {\
			say_to_var "SMShowFogOfWar"; say 1; say_to_var "";\
			AchronalUIControls[$CONTROLFLAGS_FOG_OF_WAR] = 0;\
			target = $ACHRONAL_UI_CONTROLS; PERFORM SET_ACHRONAL_FIELD AchronalUIControls; }
			
			
#define UI_BLACKOUT_SCREEN PERFORM UI_SELECT_UNIT 0;\
		int ctrlFlags = player->ControlFlags;\
		if (!ctrlFlags[$CONTROLFLAGS_PLAYER_CONTROL]) { \
			ctrlFlags[$CONTROLFLAGS_PLAYER_CONTROL] = 1;\
			PERFORM SET_PLAYER_CONTROL_FLAGS ctrlFlags; }\
		if (!AchronalUIControls[$CONTROLFLAGS_PLAYER_CONTROL]) {\
			say_to_var "SMblackout"; say 1; say_to_var "";\
			AchronalUIControls[$CONTROLFLAGS_PLAYER_CONTROL] = 1;\
			target = $ACHRONAL_UI_CONTROLS; PERFORM SET_ACHRONAL_FIELD AchronalUIControls; }

#define UI_CLEAR_BLACKOUT_SCREEN \
		int ctrlFlags = player->ControlFlags;\
		if (ctrlFlags[$CONTROLFLAGS_PLAYER_CONTROL]) { \
			ctrlFlags[$CONTROLFLAGS_PLAYER_CONTROL] = 0;\
			PERFORM SET_PLAYER_CONTROL_FLAGS ctrlFlags; }\
		if (AchronalUIControls[$CONTROLFLAGS_PLAYER_CONTROL]) {\
			say_to_var "SMblackout"; say 0; say_to_var "";\
			AchronalUIControls[$CONTROLFLAGS_PLAYER_CONTROL] = 0;\
			target = $ACHRONAL_UI_CONTROLS; PERFORM SET_ACHRONAL_FIELD AchronalUIControls; }
			
			
//called by assassinCheck.rsi - assumes x is the player number whose screen should be blacked out
#define UI_BLACKOUT_SCREEN_ASSASSIN PERFORM UI_SELECT_UNIT 0;\
		int ctrlFlags = player->ControlFlags;\
		if (!ctrlFlags[$CONTROLFLAGS_PLAYER_CONTROL]) { \
			ctrlFlags[$CONTROLFLAGS_PLAYER_CONTROL] = 1;\
			PERFORM SET_PLAYER_CONTROL_FLAGS ctrlFlags; }\
		PERFORM GET_ACHRONAL_FIELD $ACHRONAL_UI_CONTROLS;\
		int AchronalUIControls = perf_ret;\
		if (!AchronalUIControls & (1<<x) ) {\
			say_to_var "SMblackout"; say 1; say_to_var "";\
			AchronalUIControls = AchronalUIControls | ( 1 << x);\
			target = $ACHRONAL_UI_CONTROLS; PERFORM SET_ACHRONAL_FIELD AchronalUIControls; }

#define UI_CLEAR_BLACKOUT_SCREEN_ASSASSIN \
		int ctrlFlags = player->ControlFlags;\
		if (ctrlFlags[$CONTROLFLAGS_PLAYER_CONTROL]) { \
			ctrlFlags[$CONTROLFLAGS_PLAYER_CONTROL] = 0;\
			PERFORM SET_PLAYER_CONTROL_FLAGS ctrlFlags; }\
		PERFORM GET_ACHRONAL_FIELD $ACHRONAL_UI_CONTROLS;\
		int AchronalUIControls = perf_ret;\
		if (AchronalUIControls & (1<<x)) {\
			say_to_var "SMblackout"; say 0; say_to_var "";\
			AchronalUIControls = AchronalUIControls & ~(1 << x);\
			target = $ACHRONAL_UI_CONTROLS; PERFORM SET_ACHRONAL_FIELD AchronalUIControls; }			
						

//example: _x = 50; _y = 170; $UI_LOOK_AT
#define UI_LOOK_AT \
		say_to_var "SMLookAtX"; say _x; \
		say_to_var "SMLookAtY"; say _y; \
		say_to_var "SMLookAt"; say 1; say_to_var "";

//example:  $UI_SELECT_UNIT target; $UI_LOOK_AT_UNIT;
#define UI_LOOK_AT_UNIT say_to_var "SMLookAtSelected"; say 1; say_to_var ""; 


#define UI_MOVE_CAMERA  \
				say_to_var "SMCameraPositionX"; say _x;\
				say_to_var "SMCameraPositionY"; say _y;\
				say_to_var "SMCameraPositionZ"; say _z; \
				say_to_var "SMMoveCamera"; say 1; say_to_var "";
				


//example: $UI_MSG "Watch your step and beware the Shrike";
#define UI_MSG 						say_to_var "playSaySound"; say 1; say_to_var ""; say 

//example: $UI_MISSION_FAILED "Mission Failed: You lost all your mables";
#define UI_MISSION_FAILED			say_to_var "SMObjectiveFailText"; say 

//example: $UI_ROTATE_AROUND_SELECTED "This is a tank, that's how it rolls";
#define UI_ROTATE_AROUND_SELECTED	say_to_var "SMRotateAroundUnit"; say 1; say_to_var "";\
									say_to_var "SMUnitDescriptionText"; say 

#define UI_UNLOCK_SCREEN 			PERFORM ENABLE_PLAYER_CHRONAL_INPUT; PERFORM ENABLE_PLAYER_METATIME_INPUT; say_to_var "SMScreenLock"; say 0; \
									say_to_var "SMScreenLockShowMap"; say 0; \
									say_to_var "SMScreenLockShowTimeline"; say 0; say_to_var "";
									
#define UI_NEW_OBJECTIVE_SOUND		say_to_var "playObjSound"; say 1; say_to_var "";
#define UI_LOCK_SCREEN 				PERFORM DISABLE_PLAYER_CHRONAL_INPUT; PERFORM DISABLE_PLAYER_METATIME_INPUT; say_to_var "SMScreenLock"; say 1; say_to_var "";
#define UI_LOCK_SCREEN_SHOW_MAP		say_to_var "SMScreenLockShowMap"; say 1; say_to_var "";
#define UI_LOCK_SCREEN_SHOW_TIMELINE say_to_var "SMScreenLockShowTimeline"; say 1; say_to_var "";
#define UI_HIDE_SPEED_CONTROLS 		say_to_var "SMDisableSpeedControls"; say 1;
#define UI_SHOW_SPEED_CONTROLS		say_to_var "SMDisableSpeedControls"; say 0;
#define UI_CENTER_CAMERA_SELECTED	say_to_var "SMcenterCamera"; say 1; say_to_var "";
#define UI_SELECT_UNIT 				PERFORM UI_SELECT_UNIT 0; PERFORM UI_SELECT_UNIT 
#define UI_FREE_CAMERA 				say_to_var "SMfreeCamera"; say 1; say_to_var "";
#define UI_START_ZOOM_IN 			say_to_var "SMzoomIn"; say 1; say_to_var "";
#define UI_STOP_ZOOM_IN 			say_to_var "SMzoomIn"; say 0; say_to_var "SMResetZoomToCursor"; say 1; say_to_var "";
#define UI_START_ZOOM_OUT 			say_to_var "SMzoomOut"; say 1; say_to_var "";
#define UI_STOP_ZOOM_OUT 			say_to_var "SMzoomOut"; say 0; say_to_var "";
#define UI_RESET_CAMERA				say_to_var "SMResetCameraOrientation"; say 1; say_to_var "";

#define UI_SOUND_ALERT				say_to_var "SMWarningAlert"; say 1; say_to_var "";

#define CAMPAIGN_START_CUTSCENE		player = $PLAYER; if (player1time!=current) { PERFORM SET_PLAYER_TIME current; } \
									PERFORM SET_PLAYER_TIME_RATE $RATE_NORMAL; $UI_RESET_CAMERA $UI_LOCK_SCREEN 
									
//example: _dest[$Xpos] = 180; _dest[$Ypos] = 200; $PLACE_WAYPOINT
#define PLACE_WAYPOINT _uc_target = $GET_UNIT [ query.Rank==$WAYPOINT_RANK && query->Carrier==unit_creator ];  \
						if (_uc_target->IsAlive==1) { _release_teleport = 0; _change_owner = 1; _owner = $PLAYER; $UNIT_CREATOR_RELEASE_UNIT }\
						else { $RELOCATE_WAYPOINT }
						
#define RELOCATE_WAYPOINT target = $GET_UNIT [ query.Rank==$WAYPOINT_RANK && query->Carrier<= 0]; if (target->IsAlive==1) { PERFORM $ACTION_TELEPORT _dest; }

#define HIDE_WAYPOINT _uc_target = $GET_UNIT [ query.Rank==$WAYPOINT_RANK && query->Carrier<=0 ];  $UNIT_CREATOR_TAKE_UNIT									

#define EXIT_LEVEL_TRIGGER target = 133; PERFORM SET_ACHRONAL_FIELD present;

#define CHECK_EXIT_LEVEL PERFORM GET_ACHRONAL_FIELD 133; int EXIT_LEVEL = perf_ret;\
	if (EXIT_LEVEL>0) { \
	if (present==(EXIT_LEVEL+2)) {	PERFORM EXIT_ENGINE; } \
	PERFORM NOTHING; } //if (current==present && current>=2) {	PERFORM PLAYER_LOST 30; PERFORM END_SCENARIO;	PERFORM EXIT_ENGINE; } //insta-end-level

//autosave at this point
#define AUTO_SAVE_POINT config_property_int "AutoSavingEnabled"; if (perf_ret) { say_to_var "SMAutoSave"; say 1; PERFORM CREATE_SAVE_POINT;  }

