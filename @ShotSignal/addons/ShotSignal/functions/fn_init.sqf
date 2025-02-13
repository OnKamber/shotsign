if (!hasInterface) exitWith {};
private _target = player; 

// CBA Ayarlarını Yükle
private _fnc_getSetting = {
    params ["_setting"];
    ["ShotSignal", _setting] call CBA_Settings_fnc_get
};

private _enemyEnabled = ["EnableEnemy"] call _fnc_getSetting;
private _friendlyEnabled = ["EnableFriendly"] call _fnc_getSetting;
private _iconDuration = ["IconDuration"] call _fnc_getSetting;
private _detectionRange = ["DetectionRange"] call _fnc_getSetting;

// Keybind Handler'ları
["ShotSignal", "ToggleEnemy", {
    ["EnableEnemy", !(["EnableEnemy"] call _fnc_getSetting)] call CBA_Settings_fnc_set;
    systemChat format["Düşman Uyarı Sistemi: %1", ["KAPALI","AÇIK"] select (["EnableEnemy"] call _fnc_getSetting)];
}] call CBA_fnc_addKeyHandler;

["ShotSignal", "ToggleFriendly", {
    ["EnableFriendly", !(["EnableFriendly"] call _fnc_getSetting)] call CBA_Settings_fnc_set;
    systemChat format["Dost Uyarı Sistemi: %1", ["KAPALI","AÇIK"] select (["EnableFriendly"] call _fnc_getSetting)];
}] call CBA_fnc_addKeyHandler;

// Mermi Takip Sistemi
addMissionEventHandler ["ProjectileCreated", {
    params ["_projectile"];
    
    if (isNull _projectile || {!alive _projectile}) exitWith {};
    
    private _shooter = getShotParents _projectile param [0, objNull];
    
    if (isNull _shooter || {_shooter == _target}) exitWith {};
    
    private _distance = _projectile distance _target;
    if (_distance > _detectionRange) exitWith {};
    
    private _isEnemy = (side _shooter getFriend side _target) < 0.6;
    private _isFriendly = (side _shooter getFriend side _target) >= 0.6;
    
    if ((_isEnemy && !_enemyEnabled) || (_isFriendly && !_friendlyEnabled)) exitWith {};
    
    private _icon = if (_isEnemy) then {"ShotSignal\markup1.paa"} else {"ShotSignal\markup2.paa"};
    private _dir = _target getDir _shooter;
    private _angle = (_dir - getDir _target + 360) % 360;
    
    // Görsel Efekt
    [{
        params ["_projectile", "_target", "_icon", "_angle"];
        
        if (isNull _projectile || {!alive _projectile}) exitWith {};
        
        private _display = findDisplay 46;
        if (isNull _display) exitWith {};
        
        private _ctrl = _display ctrlCreate ["RscPicture", -1];
        _ctrl ctrlSetText _icon;
        _ctrl ctrlSetPosition [
            safeZoneX + safeZoneW/2 - 1.15,
            safeZoneY + safeZoneH/2 - 0.85,
            2.3, 
            1.7
        ];
        _ctrl ctrlSetAngle [_angle, 0.5, 0.5];
        _ctrl ctrlSetFade 0;
        _ctrl ctrlCommit 0;
        
        // Fade Animasyonu
        [{
            params ["_args", "_pfhID"];
            _args params ["_ctrl", "_startTime", "_duration"];
    
            // Hata koruması
            if (isNull _ctrl || {_duration <= 0}) exitWith {
            diag_log format ["[ShotSignal] Hata: _ctrl=%1 | _duration=%2", _ctrl, _duration];
            [_pfhID] call CBA_fnc_removePerFrameHandler;
            };
    
            // Süre hesaplama
            private _elapsed = diag_tickTime - _startTime;
            private _fade = linearConversion [0, _duration, _elapsed, 0, 1, true];
    
            _ctrl ctrlSetFade _fade;
            _ctrl ctrlCommit 0.05;
    
           // Silme koşulu
           if (_fade >= 1) then {
           ctrlDelete _ctrl;
           [_pfhID] call CBA_fnc_removePerFrameHandler;
           };
        }, 0.05, [_ctrl, diag_tickTime, _iconDuration]] call CBA_fnc_addPerFrameHandler;
        
    }, [_projectile, _target, _icon, _angle], 0.1] call CBA_fnc_waitAndExecute;
}];