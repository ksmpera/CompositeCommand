using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CompositeCommand
{
    public abstract class MicroCommand : Command
        {
            // Constructor
            public MicroCommand(string name)
                : base(name)
            {

            }

            public override bool IsMacroCommand { get { return false; } }

        }
    }

