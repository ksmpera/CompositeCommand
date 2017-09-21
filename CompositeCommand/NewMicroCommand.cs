using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;

namespace CompositeCommand
{
    class NewMicroCommand : MicroCommand
    {        
        private string _exePath;
       
        public NewMicroCommand(string name, string exePath) : base(name)
        {           
            _exePath = exePath;
        }

        public string ExePath { get { return _exePath; } }

        public override void Execute()
        {
            Process.Start(_exePath);
            //Process.Start("E:/pera/Home Task/FirstGame/bin/Debug/FirstGame.exe");
        }
    }
}
