using System;
using System.Drawing;
using System.Windows.Forms;
using ComboFixWinForms.Localization;

namespace ComboFixWinForms.Forms
{
    public partial class SettingsForm : Form
    {
        private LocalizationManager _localization;
        private ComboBox _languageComboBox;
        private CheckBox _enableLoggingCheckBox;
        private CheckBox _autoUpdateCheckBox;
        private CheckBox _deepScanCheckBox;
        private Button _okButton;
        private Button _cancelButton;
        private GroupBox _languageGroupBox;
        private GroupBox _scanOptionsGroupBox;
        
        public SettingsForm(LocalizationManager localization)
        {
            _localization = localization;
            InitializeComponent();
            SetupControls();
            LoadSettings();
            UpdateLanguage();
        }
        
        private void InitializeComponent()
        {
            SuspendLayout();
            
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(450, 350);
            FormBorderStyle = FormBorderStyle.FixedDialog;
            MaximizeBox = false;
            MinimizeBox = false;
            Name = "SettingsForm";
            StartPosition = FormStartPosition.CenterParent;
            Text = "Settings";
            ShowInTaskbar = false;
            
            ResumeLayout(false);
        }
        
        private void SetupControls()
        {
            // Language group box
            _languageGroupBox = new GroupBox
            {
                Text = "Language",
                Location = new Point(20, 20),
                Size = new Size(400, 80),
                Font = new Font("Arial", 9, FontStyle.Bold)
            };
            Controls.Add(_languageGroupBox);
            
            // Language combo box
            _languageComboBox = new ComboBox
            {
                Location = new Point(20, 30),
                Size = new Size(350, 23),
                DropDownStyle = ComboBoxStyle.DropDownList,
                Font = new Font("Arial", 9)
            };
            
            // Populate languages
            _languageComboBox.Items.AddRange(new object[]
            {
                "English",
                "Français (French)",
                "Deutsch (German)", 
                "Español (Spanish)",
                "Italiano (Italian)",
                "Português (Portuguese)",
                "Nederlands (Dutch)",
                "中文简体 (Chinese Simplified)",
                "中文繁體 (Chinese Traditional)",
                "Русский (Russian)",
                "Polski (Polish)",
                "Čeština (Czech)",
                "Suomi (Finnish)",
                "Dansk (Danish)",
                "Norsk (Norwegian)",
                "Svenska (Swedish)"
            });
            
            _languageGroupBox.Controls.Add(_languageComboBox);
            
            // Scan options group box
            _scanOptionsGroupBox = new GroupBox
            {
                Text = "Scan Options",
                Location = new Point(20, 120),
                Size = new Size(400, 150),
                Font = new Font("Arial", 9, FontStyle.Bold)
            };
            Controls.Add(_scanOptionsGroupBox);
            
            // Enable logging checkbox
            _enableLoggingCheckBox = new CheckBox
            {
                Text = "Enable detailed logging",
                Location = new Point(20, 30),
                Size = new Size(350, 20),
                Font = new Font("Arial", 9),
                Checked = true
            };
            _scanOptionsGroupBox.Controls.Add(_enableLoggingCheckBox);
            
            // Auto update checkbox
            _autoUpdateCheckBox = new CheckBox
            {
                Text = "Automatically check for updates",
                Location = new Point(20, 60),
                Size = new Size(350, 20),
                Font = new Font("Arial", 9),
                Checked = true
            };
            _scanOptionsGroupBox.Controls.Add(_autoUpdateCheckBox);
            
            // Deep scan checkbox
            _deepScanCheckBox = new CheckBox
            {
                Text = "Perform deep system scan",
                Location = new Point(20, 90),
                Size = new Size(350, 20),
                Font = new Font("Arial", 9),
                Checked = false
            };
            _scanOptionsGroupBox.Controls.Add(_deepScanCheckBox);
            
            // OK button
            _okButton = new Button
            {
                Text = "OK",
                Location = new Point(270, 290),
                Size = new Size(75, 30),
                BackColor = Color.Green,
                ForeColor = Color.White,
                Font = new Font("Arial", 9, FontStyle.Bold),
                UseVisualStyleBackColor = false,
                DialogResult = DialogResult.OK
            };
            _okButton.Click += OkButton_Click;
            Controls.Add(_okButton);
            
            // Cancel button
            _cancelButton = new Button
            {
                Text = "Cancel",
                Location = new Point(355, 290),
                Size = new Size(75, 30),
                BackColor = Color.Gray,
                ForeColor = Color.White,
                Font = new Font("Arial", 9, FontStyle.Bold),
                UseVisualStyleBackColor = false,
                DialogResult = DialogResult.Cancel
            };
            Controls.Add(_cancelButton);
            
            AcceptButton = _okButton;
            CancelButton = _cancelButton;
        }
        
        private void LoadSettings()
        {
            // Load current language setting
            var currentLanguage = _localization.CurrentLanguage;
            var languageMap = new Dictionary<string, int>
            {
                { "EN", 0 }, { "FR", 1 }, { "DE", 2 }, { "ES", 3 }, { "IT", 4 },
                { "PT", 5 }, { "NL", 6 }, { "CN", 7 }, { "TW", 8 }, { "RU", 9 },
                { "PL", 10 }, { "CS", 11 }, { "FI", 12 }, { "DA", 13 }, { "NO", 14 }, { "SE", 15 }
            };
            
            if (languageMap.TryGetValue(currentLanguage, out int index))
            {
                _languageComboBox.SelectedIndex = index;
            }
            else
            {
                _languageComboBox.SelectedIndex = 0; // Default to English
            }
            
            // Load other settings from configuration
            // This would typically read from a config file or registry
            _enableLoggingCheckBox.Checked = true;
            _autoUpdateCheckBox.Checked = true;
            _deepScanCheckBox.Checked = false;
        }
        
        private void UpdateLanguage()
        {
            Text = _localization.GetString("Settings");
            _languageGroupBox.Text = _localization.GetString("Language");
            _scanOptionsGroupBox.Text = _localization.GetString("ScanOptions");
            _enableLoggingCheckBox.Text = _localization.GetString("EnableLogging");
            _autoUpdateCheckBox.Text = _localization.GetString("AutoUpdate");
            _deepScanCheckBox.Text = _localization.GetString("DeepScan");
            _okButton.Text = _localization.GetString("OK");
            _cancelButton.Text = _localization.GetString("Cancel");
        }
        
        private void OkButton_Click(object sender, EventArgs e)
        {
            // Save language setting
            var languageCodes = new[] { "EN", "FR", "DE", "ES", "IT", "PT", "NL", "CN", "TW", "RU", "PL", "CS", "FI", "DA", "NO", "SE" };
            if (_languageComboBox.SelectedIndex >= 0 && _languageComboBox.SelectedIndex < languageCodes.Length)
            {
                _localization.SetLanguage(languageCodes[_languageComboBox.SelectedIndex]);
            }
            
            // Save other settings
            // This would typically save to a config file or registry
            SaveSetting("EnableLogging", _enableLoggingCheckBox.Checked.ToString());
            SaveSetting("AutoUpdate", _autoUpdateCheckBox.Checked.ToString());
            SaveSetting("DeepScan", _deepScanCheckBox.Checked.ToString());
        }
        
        private void SaveSetting(string key, string value)
        {
            // Placeholder for saving settings
            // In a real implementation, this would save to registry or config file
            try
            {
                // For now, we'll just acknowledge the setting
                System.Diagnostics.Debug.WriteLine($"Setting saved: {key} = {value}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error saving setting {key}: {ex.Message}");
            }
        }
    }
}