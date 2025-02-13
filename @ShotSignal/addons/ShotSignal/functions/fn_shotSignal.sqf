// Author: Kamber
// Date: 11.02.2025
// Bu script, oyuncuya yönelen mermilerin geldiği yönü ekranda ok simgesiyle gösterir. Bu Script ABRA CO-OP Birlikleri için yazılmıştır.

SAM_INDICATOR_ENABLED = true;
VEHICLE_INDICATOR_ENABLED = true;
FRIENDLY_INDICATOR_ENABLED = true;

[] spawn {
    waitUntil {!isNull findDisplay 46};
    (findDisplay 46) displayAddEventHandler ["KeyDown", {
        params ["_display", "_key", "_shift", "_ctrl", "_alt"];
        
        // Düşman Sinyal Toggle: CTRL+O
        if (_key == 24 && _ctrl && !_shift && !_alt) then { 
            SAM_INDICATOR_ENABLED = !SAM_INDICATOR_ENABLED;
            systemChat format ["Shot Signal: %1", ["OFF","ON"] select SAM_INDICATOR_ENABLED];
            true 
        };
        
        // Araç Sinyal Toggle: CTRL+L
        if (_key == 38 && _ctrl && !_shift && !_alt) then { 
            VEHICLE_INDICATOR_ENABLED = !VEHICLE_INDICATOR_ENABLED;
            systemChat format ["Shot Signal (Vehicle): %1", ["OFF","ON"] select VEHICLE_INDICATOR_ENABLED];
            true 
        };
        
        // Dost Sinyal Toggle: CTRL+H
        if (_key == 35 && _ctrl && !_shift && !_alt) then { 
            FRIENDLY_INDICATOR_ENABLED = !FRIENDLY_INDICATOR_ENABLED;
            systemChat format ["Shot Signal (Friend): %1", ["OFF","ON"] select FRIENDLY_INDICATOR_ENABLED];
            true 
        };
        
        false
    }];
};

// Mermi takip sistemi
addMissionEventHandler ["ProjectileCreated", {
    params ["_projectile"];
    _projectile spawn {
        private _shooter = getShotParents _this select 0;
        private _target = player;
        waitUntil {!isNull _this && {alive _this}};

        while {alive _this} do {
            if (SAM_INDICATOR_ENABLED 
                && _shooter != _target 
                && side _shooter != west 
                && (_this distance _target < 6) 
                && (vehicle _target == _target || VEHICLE_INDICATOR_ENABLED)) then {
                
                private _dirToShooter = _target getDir _shooter;
                private _angle = (_dirToShooter - getDir _target + 360) % 360;
                private _centerX = safeZoneX + safeZoneW / 2;
                private _centerY = safeZoneY + safeZoneH / 2;
                private _handle = findDisplay 46 ctrlCreate ["RscPicture", -1];
                
                _handle ctrlSetText "\ShotSignal\functions\markup1.paa";
                _handle ctrlSetPosition [
                    _centerX + sin(_angle * (pi/180)) * 0 - 1.15,
                    _centerY - cos(_angle * (pi/180)) * 0 - 0.85,
                    2.3, 
                    1.7
                ];
                _handle ctrlSetAngle [_angle, 0.5, 0.5];
                _handle ctrlSetFade 0;
                _handle ctrlCommit 0;

                for "_i" from 0 to 1 step 0.05 do {
                    _handle ctrlSetFade _i;
                    _handle ctrlCommit 0.05;
                    sleep 0.05;
                };
                ctrlDelete _handle; 
            };

            if (FRIENDLY_INDICATOR_ENABLED
                && _shooter != _target 
                && side _shooter == west 
                && (_this distance _target < 2) 
                && (vehicle _target == _target || VEHICLE_INDICATOR_ENABLED)) then {
                
                private _dirToShooter = _target getDir _shooter;
                private _angle = (_dirToShooter - getDir _target + 360) % 360;
                private _centerX = safeZoneX + safeZoneW / 2;
                private _centerY = safeZoneY + safeZoneH / 2;
                private _handle = findDisplay 46 ctrlCreate ["RscPicture", -1];
                
                _handle ctrlSetText "\ShotSignal\functions\markup2.paa";
                _handle ctrlSetPosition [
                    _centerX + sin(_angle * (pi/180)) * 0 - 1.15,
                    _centerY - cos(_angle * (pi/180)) * 0 - 0.85,
                    2.3, 
                    1.7
                ];
                _handle ctrlSetAngle [_angle, 0.5, 0.5];
                _handle ctrlSetFade 0;
                _handle ctrlCommit 0;

                for "_i" from 0 to 1 step 0.05 do {
                    _handle ctrlSetFade _i;
                    _handle ctrlCommit 0.05;
                    sleep 0.05;
                };
                ctrlDelete _handle; 
            };
            sleep 0.01;
        };
    };
}];