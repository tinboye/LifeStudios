/*
	File: fn_pulloutAction.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Pulls civilians out of a car if it's stopped.
*/
private["_crew"];
_crew = crew cursorTarget;

{
	if(side _x != independent) then
	{
		_x setVariable ["transporting",false,true]; _x setVariable ["Escorting",false,true];
[_x] remoteExec ["life_fnc_pulloutVeh",_x];
	};
} foreach _crew;
