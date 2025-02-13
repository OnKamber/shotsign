class CBA_Settings {
    class ShotSignal {
        category = "ShotSignal";
        
        class EnableEnemy {
            title = "Düşman Uyarı Sistemi";
            tooltip = "Düşman mermileri için ikaz sistemini aç/kapat";
            typeName = "BOOL";
            value = 1;
        };
        
        class EnableFriendly {
            title = "Dost Uyarı Sistemi";
            tooltip = "Dost ateşi uyarılarını aç/kapat";
            typeName = "BOOL";
            value = 1;
        };
        
        class IconDuration {
            title = "İkon Görünme Süresi";
            tooltip = "İkonların ekranda kalma süresi (saniye)";
            typeName = "SCALAR";
            value = 1.5;
            values[] = {0.1, 5, 1.5, 1};
        };
        
        class DetectionRange {
            title = "Tespit Mesafesi";
            tooltip = "Mermilerin tespit edilebileceği maksimum mesafe (metre)";
            typeName = "SCALAR";
            value = 50;
            values[] = {5, 1000, 50, 2};
        };
    };
};