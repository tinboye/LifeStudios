/*
	File: fn_insertVehicle.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Inserts the vehicle into the database
*/
A3L_Insert =
{ 
	private["_uid","_side","_type","_className","_color","_plate","_query","_sql"];
	_uid = [_this,0,"",[""]] call BIS_fnc_param;
	_side = [_this,1,"",[""]] call BIS_fnc_param;
	_type = [_this,2,"",[""]] call BIS_fnc_param;
	_className = [_this,3,"",[""]] call BIS_fnc_param;
	_color = [_this,4,-1,[0]] call BIS_fnc_param;
	_plate = [_this,5,-1,[0]] call BIS_fnc_param;

	//Stop bad data being passed.
	if(_uid == "" OR _side == "" OR _type == "" OR _className == "" OR _color == -1 OR _plate == -1) exitWith {};

	_query = format["INSERT INTO vehicles (side, classname, type, pid, alive, active, inventory, color, plate) VALUES ('%1', '%2', '%3', '%4', '1','0','""[]""', '%5', '%6')",_side,_className,_type,_uid,_color,_plate];
	//_sql = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['%2', '%1']", _query,(call LIFE_SCHEMA_NAME)];

	waitUntil {sleep (random 0.3); !DB_Async_Active};
	[_query,1] call DB_fnc_asyncCall;
};

A3L_createVehicle = 
{
	private["_uid","_side","_type","_classname","_color","_plate"];
	_uid = _this select 0;
	_side = _this select 1;
	_classname = _this select 2;
	_color = _this select 3;

	_type = switch(true) do
	{
		case (_classname isKindOf "Car"): {"Car"};
		case (_classname isKindOf "Air"): {"Air"};
		case (_classname isKindOf "Ship"): {"Ship"};
	};

	_side = switch(_side) do
	{
		case west:{"cop"};
		case civilian: {"civ"};
		case independent: {"med"};
		default {"Error"};
	};

	_plate = round(random(1000000));

	[_uid,_side,_type,_classname,_color,_plate] spawn A3L_Insert;
};