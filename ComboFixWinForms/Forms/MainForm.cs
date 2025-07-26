using System;
using System.Drawing;
using System.Windows.Forms;
using ComboFixWinForms.Core;
using ComboFixWinForms.Localization;

namespace ComboFixWinForms.Forms
{
    public partial class MainForm : Form
    {
        private ComboFixEngine _engine;
        private LocalizationManager _localization;
        private ProgressBar _progressBar;
        private TextBox _logTextBox;
        private Button _startButton;
        private Button _exitButton;
        private Button _settingsButton;
        private Label _statusLabel;
        private Label _titleLabel;
        private Panel _mainPanel;
        private Panel _buttonPanel;
        
        public MainForm()
        {
            InitializeComponent();
            _engine = new ComboFixEngine();
            _localization = new LocalizationManager();
            
            SetupForm();
            SetupControls();
            UpdateLanguage();
            
            _engine.ProgressChanged += OnProgressChanged;
            _engine.StatusChanged += OnStatusChanged;
            _engine.LogMessage += OnLogMessage;
        }
        
        private void InitializeComponent()
        {
            SuspendLayout();
            
            // Form properties
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 600);
            FormBorderStyle = FormBorderStyle.FixedSingle;
            MaximizeBox = false;
            Name = "MainForm";
            StartPosition = FormStartPosition.CenterScreen;
            Text = "ComboFix - Malware Removal Tool";
            
            ResumeLayout(false);
        }
        
        private void SetupForm()
        {
            Icon = SystemIcons.Shield;
            BackColor = Color.White;
            
            // Set window properties
            MinimumSize = new Size(800, 600);
            MaximumSize = new Size(800, 600);
        }
        
        private void SetupControls()
        {
            // Main panel
            _mainPanel = new Panel
            {
                Dock = DockStyle.Fill,
                Padding = new Padding(10)
            };
            Controls.Add(_mainPanel);
            
            // Title label
            _titleLabel = new Label
            {
                Text = "ComboFix - Malware Removal Tool",
                Font = new Font("Arial", 16, FontStyle.Bold),
                ForeColor = Color.DarkBlue,
                AutoSize = true,
                Location = new Point(10, 10)
            };
            _mainPanel.Controls.Add(_titleLabel);
            
            // Status label
            _statusLabel = new Label
            {
                Text = "Ready to scan",
                Font = new Font("Arial", 10),
                ForeColor = Color.DarkGreen,
                AutoSize = true,
                Location = new Point(10, 50)
            };
            _mainPanel.Controls.Add(_statusLabel);
            
            // Progress bar
            _progressBar = new ProgressBar
            {
                Location = new Point(10, 80),
                Size = new Size(760, 23),
                Style = ProgressBarStyle.Continuous,
                Minimum = 0,
                Maximum = 100,
                Value = 0
            };
            _mainPanel.Controls.Add(_progressBar);
            
            // Log text box
            _logTextBox = new TextBox
            {
                Location = new Point(10, 120),
                Size = new Size(760, 400),
                Multiline = true,
                ScrollBars = ScrollBars.Vertical,
                ReadOnly = true,
                BackColor = Color.Black,
                ForeColor = Color.Lime,
                Font = new Font("Consolas", 9),
                Text = "ComboFix initialization complete.\r\nReady to begin malware removal process.\r\n"
            };
            _mainPanel.Controls.Add(_logTextBox);
            
            // Button panel
            _buttonPanel = new Panel
            {
                Location = new Point(10, 530),
                Size = new Size(760, 40),
                BackColor = Color.Transparent
            };
            _mainPanel.Controls.Add(_buttonPanel);
            
            // Start button
            _startButton = new Button
            {
                Text = "Start Scan",
                Size = new Size(100, 30),
                Location = new Point(0, 5),
                BackColor = Color.Green,
                ForeColor = Color.White,
                Font = new Font("Arial", 9, FontStyle.Bold),
                UseVisualStyleBackColor = false
            };
            _startButton.Click += StartButton_Click;
            _buttonPanel.Controls.Add(_startButton);
            
            // Settings button
            _settingsButton = new Button
            {
                Text = "Settings",
                Size = new Size(100, 30),
                Location = new Point(110, 5),
                BackColor = Color.Gray,
                ForeColor = Color.White,
                Font = new Font("Arial", 9, FontStyle.Bold),
                UseVisualStyleBackColor = false
            };
            _settingsButton.Click += SettingsButton_Click;
            _buttonPanel.Controls.Add(_settingsButton);
            
            // Exit button
            _exitButton = new Button
            {
                Text = "Exit",
                Size = new Size(100, 30),
                Location = new Point(660, 5),
                BackColor = Color.Red,
                ForeColor = Color.White,
                Font = new Font("Arial", 9, FontStyle.Bold),
                UseVisualStyleBackColor = false
            };
            _exitButton.Click += ExitButton_Click;
            _buttonPanel.Controls.Add(_exitButton);
        }
        
        private void UpdateLanguage()
        {
            Text = _localization.GetString("MainTitle");
            _titleLabel.Text = _localization.GetString("MainTitle");
            _statusLabel.Text = _localization.GetString("Ready");
            _startButton.Text = _localization.GetString("StartScan");
            _settingsButton.Text = _localization.GetString("Settings");
            _exitButton.Text = _localization.GetString("Exit");
        }
        
        private async void StartButton_Click(object sender, EventArgs e)
        {
            try
            {
                _startButton.Enabled = false;
                _settingsButton.Enabled = false;
                
                await _engine.StartScanAsync();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error starting scan: {ex.Message}", "Error", 
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                _startButton.Enabled = true;
                _settingsButton.Enabled = true;
            }
        }
        
        private void SettingsButton_Click(object sender, EventArgs e)
        {
            using var settingsForm = new SettingsForm(_localization);
            if (settingsForm.ShowDialog() == DialogResult.OK)
            {
                UpdateLanguage();
            }
        }
        
        private void ExitButton_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show(_localization.GetString("ConfirmExit"), 
                _localization.GetString("Exit"), 
                MessageBoxButtons.YesNo, 
                MessageBoxIcon.Question) == DialogResult.Yes)
            {
                Application.Exit();
            }
        }
        
        private void OnProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            if (InvokeRequired)
            {
                Invoke(new Action<object, ProgressChangedEventArgs>(OnProgressChanged), sender, e);
                return;
            }
            
            _progressBar.Value = Math.Min(100, Math.Max(0, e.ProgressPercentage));
        }
        
        private void OnStatusChanged(object sender, StatusChangedEventArgs e)
        {
            if (InvokeRequired)
            {
                Invoke(new Action<object, StatusChangedEventArgs>(OnStatusChanged), sender, e);
                return;
            }
            
            _statusLabel.Text = e.Status;
            _statusLabel.ForeColor = e.IsError ? Color.Red : Color.DarkGreen;
        }
        
        private void OnLogMessage(object sender, LogMessageEventArgs e)
        {
            if (InvokeRequired)
            {
                Invoke(new Action<object, LogMessageEventArgs>(OnLogMessage), sender, e);
                return;
            }
            
            var timestamp = DateTime.Now.ToString("HH:mm:ss");
            var logLine = $"[{timestamp}] {e.Message}\r\n";
            
            _logTextBox.AppendText(logLine);
            _logTextBox.SelectionStart = _logTextBox.Text.Length;
            _logTextBox.ScrollToCaret();
        }
        
        protected override void OnFormClosing(FormClosingEventArgs e)
        {
            if (_engine.IsRunning)
            {
                if (MessageBox.Show(_localization.GetString("ScanInProgress"), 
                    _localization.GetString("Warning"), 
                    MessageBoxButtons.YesNo, 
                    MessageBoxIcon.Warning) == DialogResult.No)
                {
                    e.Cancel = true;
                    return;
                }
                
                _engine.Stop();
            }
            
            base.OnFormClosing(e);
        }
    }
}