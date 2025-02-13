class CfgPatches {
    class ShotSignal {
		name = "Shot Signal";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.14;
        requiredAddons[] = {"CBA_MAIN","CBA_Settings","CBA_Keybinding"};
        author = "Kamber";
        version = "2.0.1";
        versionStr = "2.0.1";
        versionAr[] = {2,0,1};
    };
};

class CfgFunctions {
    class ShotSignal {
        class Main {
            file = "ShotSignal\functions";
            class Init {
                postInit = 1;
            };
        };
    };
};

class CBA_Settings {
    #include "CBA_Settings.hpp"
};

class CBA_Keybinding {
    #include "CBA_Keybinds.hpp"
};