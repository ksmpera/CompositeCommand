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
    public partial class MicroCommandForm : Form
    {
        public MicroCommandForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Command cmd = CreateMicroCommand(tabControl1.SelectedIndex);
            //tabControl1.TabPages[tabControl1.SelectedIndex]
           

            int id = InsertMicrocommand(cmd);
            cmd.Id = id;
        }
        public Command CreateMicroCommand(int p)
        {
            Command cmd;
            switch (p)
            {
                case 0:
                    cmd = CreateDownloadFileMicroCommand();                    
                    break;
                case 1:
                    cmd = CreateMsgBoxMicroCommand();
                    break;
                case 2:
                    cmd = CreateNewMicroCommand();
                    break;
                default:
                    throw new Exception("Unsupported index!");
            }
            return cmd;
        }

        private Command CreateNewMicroCommand()
        {
            return new NewMicroCommand(textBox7.Text, textBox8.Text);
        }

        private Command CreateMsgBoxMicroCommand()
        {
            return new MsgBoxMicroCommand(textBox4.Text, textBox5.Text, textBox6.Text, MessageBoxButtons.OKCancel);
        }

        private Command CreateDownloadFileMicroCommand()
        {
            ToolStripProgressBar pb = ((Form1)this.Tag).toolStripProgressBar1;
            ToolStripLabel tsl1 = ((Form1)this.Tag).toolStripStatusLabel1;
            ToolStripLabel tsl2 = ((Form1)this.Tag).toolStripStatusLabel2;
            StatusStrip ss = ((Form1)this.Tag).statusStrip1; 
            return new DownloadFileMicroCommand(textBox1.Text, textBox3.Text, textBox2.Text, ss);
        }

        private void AddCmdParams(Command cmd, SqlCommand sqlCmd)
        {
            if (cmd is MsgBoxMicroCommand)
            {
                sqlCmd.Parameters.AddWithValue("@Val3", ((MsgBoxMicroCommand)cmd).Text);
                sqlCmd.Parameters.AddWithValue("@Val4", ((MsgBoxMicroCommand)cmd).Caption);
                sqlCmd.Parameters.AddWithValue("@Val5", ((MsgBoxMicroCommand)cmd).MsgBoxButtons);
            }
            else if (cmd is DownloadFileMicroCommand)
            {
                sqlCmd.Parameters.AddWithValue("@Val3", ((DownloadFileMicroCommand)cmd).DownloadPath);
                sqlCmd.Parameters.AddWithValue("@Val4", ((DownloadFileMicroCommand)cmd).SaveTo);
                sqlCmd.Parameters.AddWithValue("@Val5", DBNull.Value);
            }
            else if (cmd is NewMicroCommand)
            {
                sqlCmd.Parameters.AddWithValue("@Val3", ((NewMicroCommand)cmd).ExePath);
                sqlCmd.Parameters.AddWithValue("@Val4", DBNull.Value);
                sqlCmd.Parameters.AddWithValue("@Val5", DBNull.Value);
            }
            else throw new Exception("Unsupported command type!");
        }
        private int InsertMicrocommand(Command cmd)
        {
            SqlConnection conn = new SqlConnection(@"Data Source= WS-DEVNS-22;Initial Catalog=Command;Integrated Security=True");
            //string sql = "INSERT INTO MicroCommands (MicroCommandName, MicroCommandType, MicroParameter1, MicroParameter2, MicroParameter3 ) VALUES (@Val1, @Val2, @Val3, @Val4, @Val5); SELECT SCOPE_IDENTITY();";
            try
            {
                conn.Open();
                SqlCommand sql = new SqlCommand("spMicroCommandName", conn);
                sql.CommandType = CommandType.StoredProcedure;
                //SqlCommand sqlCmd = new SqlCommand(sql, conn);
                //sqlCmd.Parameters.AddWithValue("@Val1", ((Command)cmd).Name); 
                //sql.Parameters.AddWithValue("@Val1", textBox1.Text);
                sql.Parameters.AddWithValue("@Val1", ((Command)cmd).Name); 

                string fullTypeName = cmd.GetType().ToString();
                string simpleTypeName1 = fullTypeName.Substring(fullTypeName.LastIndexOf('.') + 1);
                //sqlCmd.Parameters.AddWithValue("@Val2", simpleTypeName1);
                sql.Parameters.AddWithValue("@Val2", simpleTypeName1);

                //AddCmdParams(cmd, sqlCmd);
                AddCmdParams(cmd, sql);
            
                //sqlCmd.CommandType = CommandType.Text;
                //sql.CommandType = CommandType.Text;
                //int id = Convert.ToInt32(sqlCmd.ExecuteScalar());
                int id = Convert.ToInt32(sql.ExecuteScalar());

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
