using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CompositeCommand
{
    public abstract class Command
    {
        public string Name { get; set; }

        public int? Id { get; set; }

        public abstract bool IsMacroCommand { get; }

        // Constructor
        public Command(string name)
        {
            this.Name = name;
            Id = null;
        }

        public abstract void Execute();
        //public abstract void Add(Command c);
        //public abstract void Remove(Command c);
        //public abstract void Display(int depth);
    }   

}
