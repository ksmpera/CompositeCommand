using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace CompositeCommand
{
    public partial class MacroCommandForm : Form
    {
        public MacroCommandForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Command mac = CreateMacroCommand();

            int id = InsertMacroCommand();
            mac.Id = id;
        }

        public Command CreateMacroCommand()
        {           
           return new MacroCommand(textBox1.Text);
        }

        private int InsertMacroCommand()
        {

            SqlConnection conn = new SqlConnection(@"Data Source= WS-DEVNS-22;Initial Catalog=Command;Integrated Security=True");
            //string sql = "INSERT INTO MacroCommands (MacroCommandName) VALUES (@Val1); SELECT SCOPE_IDENTITY();";
            try
            {
                conn.Open();
                SqlCommand sql = new SqlCommand("spMacroCommandName", conn);
                sql.CommandType = CommandType.StoredProcedure;
                //SqlCommand cmd = new SqlCommand(sql, conn);
                sql.Parameters.AddWithValue("@Val1", textBox1.Text);
                //cmd.Parameters.AddWithValue("@Val1", textBox1.Text);
                //cmd.CommandType = CommandType.Text;
                //int id = cmd.ExecuteNonQuery();
                int id = sql.ExecuteNonQuery();

                return id;
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                string msg = "Insert Error:";
                msg += ex.Message;
                throw new Exception(msg);

            }
            finally
            {
                conn.Close();
            }
        }
    }
}
