class CfgPatches {
    class ShotSignal {
        name = "Shot Signal";
        author = "Kamber";
        requiredVersion = 1.0;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class ShotSignal {
        class Functions {
            file = "\ShotSignal\functions";
            class shotSignal { postInit = 1; };
        };
    };
};