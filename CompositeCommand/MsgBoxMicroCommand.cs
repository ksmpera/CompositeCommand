using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CompositeCommand
{
    class MsgBoxMicroCommand : MicroCommand
    {
        private string _text;
        private string _caption;
        private MessageBoxButtons _msgBoxButtons;

        public MsgBoxMicroCommand(string name, string text, string caption, MessageBoxButtons msgBoxButtons)
            : base(name)
        {
            _text = text;
            _caption = caption;
            _msgBoxButtons = msgBoxButtons;
        }

        public string Text { get { return _text; } }
        public string Caption { get { return _caption; } }
        public string MsgBoxButtons { get { return _msgBoxButtons.ToString(); } }

        public override void Execute()
        {
            MessageBox.Show(_text, _caption, _msgBoxButtons);
        }
    }
}
