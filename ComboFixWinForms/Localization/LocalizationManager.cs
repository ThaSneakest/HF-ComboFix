using System;
using System.Collections.Generic;
using System.Globalization;

namespace ComboFixWinForms.Localization
{
    public class LocalizationManager
    {
        private Dictionary<string, Dictionary<string, string>> _translations;
        private string _currentLanguage;
        
        public string CurrentLanguage => _currentLanguage;
        
        public LocalizationManager()
        {
            _currentLanguage = "EN";
            InitializeTranslations();
        }
        
        private void InitializeTranslations()
        {
            _translations = new Dictionary<string, Dictionary<string, string>>();
            
            // English translations (base)
            _translations["EN"] = new Dictionary<string, string>
            {
                { "MainTitle", "ComboFix - Malware Removal Tool" },
                { "Ready", "Ready to scan" },
                { "StartScan", "Start Scan" },
                { "Settings", "Settings" },
                { "Exit", "Exit" },
                { "ConfirmExit", "Are you sure you want to exit ComboFix?" },
                { "ScanInProgress", "A scan is currently in progress. Do you want to stop it and exit?" },
                { "Warning", "Warning" },
                { "Language", "Language" },
                { "ScanOptions", "Scan Options" },
                { "EnableLogging", "Enable detailed logging" },
                { "AutoUpdate", "Automatically check for updates" },
                { "DeepScan", "Perform deep system scan" },
                { "OK", "OK" },
                { "Cancel", "Cancel" },
                { "AdminRequired", "Administrative privileges required to run ComboFix." },
                { "RestorePoint", "Created a new restore point" },
                { "ScanComplete", "Scan completed successfully" },
                { "ThreatsFound", "threats found and removed" },
                { "NoThreats", "No threats detected" },
                { "Error", "Error" },
                { "Information", "Information" }
            };
            
            // French translations
            _translations["FR"] = new Dictionary<string, string>
            {
                { "MainTitle", "ComboFix - Outil de suppression de logiciels malveillants" },
                { "Ready", "Prêt à analyser" },
                { "StartScan", "Démarrer l'analyse" },
                { "Settings", "Paramètres" },
                { "Exit", "Quitter" },
                { "ConfirmExit", "Êtes-vous sûr de vouloir quitter ComboFix?" },
                { "ScanInProgress", "Une analyse est en cours. Voulez-vous l'arrêter et quitter?" },
                { "Warning", "Avertissement" },
                { "Language", "Langue" },
                { "ScanOptions", "Options d'analyse" },
                { "EnableLogging", "Activer la journalisation détaillée" },
                { "AutoUpdate", "Vérifier automatiquement les mises à jour" },
                { "DeepScan", "Effectuer une analyse approfondie du système" },
                { "OK", "OK" },
                { "Cancel", "Annuler" },
                { "AdminRequired", "Privilèges administrateur requis pour exécuter ComboFix." },
                { "RestorePoint", "Nouveau point de restauration créé" },
                { "ScanComplete", "Analyse terminée avec succès" },
                { "ThreatsFound", "menaces trouvées et supprimées" },
                { "NoThreats", "Aucune menace détectée" },
                { "Error", "Erreur" },
                { "Information", "Information" }
            };
            
            // German translations
            _translations["DE"] = new Dictionary<string, string>
            {
                { "MainTitle", "ComboFix - Malware-Entfernungstool" },
                { "Ready", "Bereit zum Scannen" },
                { "StartScan", "Scan starten" },
                { "Settings", "Einstellungen" },
                { "Exit", "Beenden" },
                { "ConfirmExit", "Sind Sie sicher, dass Sie ComboFix beenden möchten?" },
                { "ScanInProgress", "Ein Scan läuft gerade. Möchten Sie ihn stoppen und beenden?" },
                { "Warning", "Warnung" },
                { "Language", "Sprache" },
                { "ScanOptions", "Scan-Optionen" },
                { "EnableLogging", "Detaillierte Protokollierung aktivieren" },
                { "AutoUpdate", "Automatisch nach Updates suchen" },
                { "DeepScan", "Tiefgreifende Systemanalyse durchführen" },
                { "OK", "OK" },
                { "Cancel", "Abbrechen" },
                { "AdminRequired", "Administratorrechte erforderlich, um ComboFix auszuführen." },
                { "RestorePoint", "Neuer Wiederherstellungspunkt erstellt" },
                { "ScanComplete", "Scan erfolgreich abgeschlossen" },
                { "ThreatsFound", "Bedrohungen gefunden und entfernt" },
                { "NoThreats", "Keine Bedrohungen erkannt" },
                { "Error", "Fehler" },
                { "Information", "Information" }
            };
            
            // Spanish translations
            _translations["ES"] = new Dictionary<string, string>
            {
                { "MainTitle", "ComboFix - Herramienta de eliminación de malware" },
                { "Ready", "Listo para escanear" },
                { "StartScan", "Iniciar escaneo" },
                { "Settings", "Configuración" },
                { "Exit", "Salir" },
                { "ConfirmExit", "¿Está seguro de que desea salir de ComboFix?" },
                { "ScanInProgress", "Un escaneo está en progreso. ¿Desea detenerlo y salir?" },
                { "Warning", "Advertencia" },
                { "Language", "Idioma" },
                { "ScanOptions", "Opciones de escaneo" },
                { "EnableLogging", "Habilitar registro detallado" },
                { "AutoUpdate", "Buscar actualizaciones automáticamente" },
                { "DeepScan", "Realizar escaneo profundo del sistema" },
                { "OK", "Aceptar" },
                { "Cancel", "Cancelar" },
                { "AdminRequired", "Se requieren privilegios de administrador para ejecutar ComboFix." },
                { "RestorePoint", "Nuevo punto de restauración creado" },
                { "ScanComplete", "Escaneo completado exitosamente" },
                { "ThreatsFound", "amenazas encontradas y eliminadas" },
                { "NoThreats", "No se detectaron amenazas" },
                { "Error", "Error" },
                { "Information", "Información" }
            };
            
            // Chinese Simplified translations
            _translations["CN"] = new Dictionary<string, string>
            {
                { "MainTitle", "ComboFix - 恶意软件清除工具" },
                { "Ready", "准备扫描" },
                { "StartScan", "开始扫描" },
                { "Settings", "设置" },
                { "Exit", "退出" },
                { "ConfirmExit", "您确定要退出 ComboFix 吗？" },
                { "ScanInProgress", "正在进行扫描。您要停止扫描并退出吗？" },
                { "Warning", "警告" },
                { "Language", "语言" },
                { "ScanOptions", "扫描选项" },
                { "EnableLogging", "启用详细日志记录" },
                { "AutoUpdate", "自动检查更新" },
                { "DeepScan", "执行深度系统扫描" },
                { "OK", "确定" },
                { "Cancel", "取消" },
                { "AdminRequired", "运行 ComboFix 需要管理员权限。" },
                { "RestorePoint", "已创建新的还原点" },
                { "ScanComplete", "扫描成功完成" },
                { "ThreatsFound", "发现并清除了威胁" },
                { "NoThreats", "未检测到威胁" },
                { "Error", "错误" },
                { "Information", "信息" }
            };
            
            // Russian translations
            _translations["RU"] = new Dictionary<string, string>
            {
                { "MainTitle", "ComboFix - Инструмент удаления вредоносного ПО" },
                { "Ready", "Готов к сканированию" },
                { "StartScan", "Начать сканирование" },
                { "Settings", "Настройки" },
                { "Exit", "Выход" },
                { "ConfirmExit", "Вы уверены, что хотите выйти из ComboFix?" },
                { "ScanInProgress", "Идет сканирование. Вы хотите остановить его и выйти?" },
                { "Warning", "Предупреждение" },
                { "Language", "Язык" },
                { "ScanOptions", "Параметры сканирования" },
                { "EnableLogging", "Включить подробное журналирование" },
                { "AutoUpdate", "Автоматически проверять обновления" },
                { "DeepScan", "Выполнить глубокое сканирование системы" },
                { "OK", "ОК" },
                { "Cancel", "Отмена" },
                { "AdminRequired", "Для запуска ComboFix требуются права администратора." },
                { "RestorePoint", "Создана новая точка восстановления" },
                { "ScanComplete", "Сканирование успешно завершено" },
                { "ThreatsFound", "угроз найдено и удалено" },
                { "NoThreats", "Угрозы не обнаружены" },
                { "Error", "Ошибка" },
                { "Information", "Информация" }
            };
        }
        
        public string GetString(string key)
        {
            if (_translations.TryGetValue(_currentLanguage, out var languageDict))
            {
                if (languageDict.TryGetValue(key, out var translation))
                {
                    return translation;
                }
            }
            
            // Fallback to English
            if (_translations.TryGetValue("EN", out var englishDict))
            {
                if (englishDict.TryGetValue(key, out var englishTranslation))
                {
                    return englishTranslation;
                }
            }
            
            // Ultimate fallback
            return key;
        }
        
        public void SetLanguage(string languageCode)
        {
            if (_translations.ContainsKey(languageCode))
            {
                _currentLanguage = languageCode;
                
                // Save to configuration
                SaveLanguageSetting(languageCode);
            }
        }
        
        public List<string> GetAvailableLanguages()
        {
            return new List<string>(_translations.Keys);
        }
        
        public string GetLanguageName(string languageCode)
        {
            var languageNames = new Dictionary<string, string>
            {
                { "EN", "English" },
                { "FR", "Français" },
                { "DE", "Deutsch" },
                { "ES", "Español" },
                { "IT", "Italiano" },
                { "PT", "Português" },
                { "NL", "Nederlands" },
                { "CN", "中文简体" },
                { "TW", "中文繁體" },
                { "RU", "Русский" },
                { "PL", "Polski" },
                { "CS", "Čeština" },
                { "FI", "Suomi" },
                { "DA", "Dansk" },
                { "NO", "Norsk" },
                { "SE", "Svenska" }
            };
            
            return languageNames.TryGetValue(languageCode, out var name) ? name : languageCode;
        }
        
        private void SaveLanguageSetting(string languageCode)
        {
            try
            {
                // In a real implementation, this would save to registry or config file
                System.Diagnostics.Debug.WriteLine($"Language setting saved: {languageCode}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error saving language setting: {ex.Message}");
            }
        }
        
        public void LoadLanguageSetting()
        {
            try
            {
                // In a real implementation, this would load from registry or config file
                // For now, detect system language
                var systemLanguage = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName.ToUpper();
                
                if (_translations.ContainsKey(systemLanguage))
                {
                    _currentLanguage = systemLanguage;
                }
                else
                {
                    _currentLanguage = "EN"; // Default to English
                }
            }
            catch
            {
                _currentLanguage = "EN";
            }
        }
    }
}