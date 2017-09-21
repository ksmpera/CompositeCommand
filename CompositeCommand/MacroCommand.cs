using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CompositeCommand
{
    public class MacroCommand : Command
    {
        public List<Command> Commands { get; private set; }

        public int? ParentId { get; set; }

        // Constructor
        public MacroCommand(string name) : base(name)
        {
            Commands  = new List<Command>();
        }

        public override void Execute()
        {
            foreach (var cmd in Commands)
            {
                cmd.Execute();
            }
        }

        public void Add(Command component)
        {
            Commands.Add(component);
        }

        public void Remove(Command component)
        {
            Commands.Remove(component);
        }

        public override bool IsMacroCommand { get { return true; } }
    }
}

