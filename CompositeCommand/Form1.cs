using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;
using System.Data.SqlClient;


namespace CompositeCommand
{
    public partial class Form1 : Form
    {
        SqlConnection obj = new SqlConnection(@"Data Source=PETAR-PC\SQLEXPRESS;Initial Catalog=Command;Integrated Security=True;Column Encryption Setting=Enabled");
        private ListViewColumnSorter ColumnSorter;

        private Dictionary<int, MacroCommand> macroCommands;
        private Dictionary<int, MicroCommand> microCommands;

        public class Test
        {
        }

        public Form1()
        {
            macroCommands = new Dictionary<int, CompositeCommand.MacroCommand>();
            microCommands = new Dictionary<int, CompositeCommand.MicroCommand>();
            InitializeComponent();
            ColumnSorter = new ListViewColumnSorter();
            this.listView1.ListViewItemSorter = ColumnSorter;          
        }      
       

        private void Form1_Load(object sender, EventArgs e)
        {
            SqlConnection obj = new SqlConnection(@"Data Source=WS-DEVNS-22;Initial Catalog=Command;Integrated Security=True");
            try
            {
                obj.Open();
                SqlCommand objcommand = new SqlCommand("procMicroCommands", obj);
                objcommand.CommandType = CommandType.StoredProcedure;
                //SqlCommand objcommand = new SqlCommand("Select * from Microcommands", obj);
                SqlDataReader dr = objcommand.ExecuteReader();
                while (dr.Read())
                {
                    int idxID = dr.GetOrdinal("MicroCommandID");
                    Command cmd = CreateMicroCommand(dr.GetInt32(idxID),
                        dr["MicroCommandName"].ToString(),
                        dr["MicroCommandType"].ToString(),
                        dr["MicroParameter1"].ToString(),
                        dr["MicroParameter2"].ToString(),
                        dr["MicroParameter3"].ToString(), statusStrip1);
                    microCommands.Add((int)cmd.Id, (MicroCommand)cmd);
                    ListViewItem item = CommandToListViewItem(cmd);

                    listView1.Items.Add(item);
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                string msg = "Insert Error:";
                msg += ex.Message;
                throw new Exception(msg);
            }
            finally
            {
                obj.Close();
            }         
            try
            {
                obj.Open();

                SqlCommand objcommand2 = new SqlCommand("procMacroCommands", obj);
                objcommand2.CommandType = CommandType.StoredProcedure;
                //SqlCommand objcommand2 = new SqlCommand("Select * from Macrocommands", obj);
                SqlDataReader dr2 = objcommand2.ExecuteReader();
               
                while (dr2.Read())
                {
                    int idxId = dr2.GetOrdinal("MacroCommandId");
                    int idxParentId = dr2.GetOrdinal("ParentId");
                    MacroCommand cmd = new MacroCommand(dr2["MacroCommandName"].ToString());                  
                    cmd.Id = dr2.GetInt32(idxId);
                    cmd.ParentId = dr2.IsDBNull(idxParentId) ? (int?)null : dr2.GetInt32(idxParentId);
                    macroCommands.Add((int)cmd.Id, cmd);
                                                 
                 }
                dr2.Close();

                foreach (var cmd in macroCommands.Values)
                {
                    if (cmd.ParentId.HasValue)
                    {
                        var parent = macroCommands[(int)cmd.ParentId];
                        parent.Add(cmd);
                    }    
                }
                SqlCommand objcommand1 = new SqlCommand("procMacroMicro", obj);
                objcommand1.CommandType = CommandType.StoredProcedure;
                //SqlCommand objcommand1 = new SqlCommand("select MacroCommandId, MicroCommandId from MacroMicro", obj);
                SqlDataReader dr1 = objcommand1.ExecuteReader();
                while (dr1.Read())
                {
                    int idxMacroId = dr1.GetOrdinal("MacroCommandID");
                    int idxMicroId = dr1.GetOrdinal("MicroCommandId");
                    // gat actual ids
                    int macroId = dr1.GetInt32(idxMacroId);
                    int microId = dr1.GetInt32(idxMicroId);

                    var macroCmd = macroCommands[macroId];
                    var microCmd = microCommands[microId];
                    macroCmd.Add(microCmd);
                }
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                string msg = "Insert Error:";
                msg += ex.Message;
                throw new Exception(msg);               
            }
            finally
            {
                obj.Close();               
            }

            // try to draw tree view
            DrawTreeView();
        }

        private void DrawTreeView()
        {
            var rootCommands = macroCommands.Values.Where(c => !c.ParentId.HasValue);
            foreach (var cmd in rootCommands)
            {
                DrawSubTree(cmd, null);
            }
        }

        private void DrawSubTree(Command cmd, TreeNode parent)
        {
            TreeNode node = new TreeNode(cmd.Name);
            node.Tag = cmd;
            int added = (parent == null) ? treeView1.Nodes.Add(node) : parent.Nodes.Add(node);
            // check if the command is MacroCommand
            if (cmd.IsMacroCommand)
            {
                // draw the children
                foreach (var childCmd in ((MacroCommand)cmd).Commands)
                {
                    DrawSubTree(childCmd, node);
                }
            }
        }
       


        private ListViewItem CommandToListViewItem(Command cmd)
        {
            ListViewItem item = new ListViewItem(cmd.Name);
            item.SubItems.Add(DateTime.Now.ToString());
            item.SubItems.Add(GetShortTypeName(cmd.GetType()));
            item.Tag = cmd;
            if (cmd is MsgBoxMicroCommand)
            {
                item.SubItems.Add( ((MsgBoxMicroCommand)cmd).Text);
                item.SubItems.Add(((MsgBoxMicroCommand)cmd).Caption);               
            }
            else if (cmd is DownloadFileMicroCommand)
            {
                item.SubItems.Add(((DownloadFileMicroCommand)cmd).DownloadPath);
                item.SubItems.Add(((DownloadFileMicroCommand)cmd).SaveTo);
            }
            else if (cmd is NewMicroCommand)
            {
                item.SubItems.Add(((NewMicroCommand)cmd).ExePath);
            }
            else throw new Exception("Unsupported command type!");

            return item;
        }

        public Command CreateMicroCommand(int id, string microCommandName, string microCommandType, string microParameter1, string microParameter2, string microParameter3, StatusStrip ss)
        {          
            Command cmd;
           
            switch (microCommandType)
            {
                case "DownloadFileMicroCommand":
                    cmd = CreateDownloadFileMicroCommand(id, microCommandName, microParameter1, microParameter2, ss);
                    break;
                case "MsgBoxMicroCommand":
                    cmd = CreateMsgBoxMicroCommand(id, microCommandName, microParameter1, microParameter2, microParameter3);
                    break;
                case "NewMicroCommand":
                    cmd = CreateNewMicroCommand(id, microCommandName, microParameter1);
                    break;
                default:
                    throw new Exception("Unsupported index!");
            }
            return cmd;
        }
        private Command CreateNewMicroCommand(int id, string microCommandName, string microParameter1)
        {
            var cmd = new NewMicroCommand(microCommandName, microParameter1);
            cmd.Id = id;
            return cmd;
        }
        private Command CreateMsgBoxMicroCommand(int id, string microCommandName, string microParameter1, string microParameter2, string microParameter3)
        {
            var cmd = new MsgBoxMicroCommand(microCommandName, microParameter1, microParameter2, (MessageBoxButtons)Enum.Parse(typeof(MessageBoxButtons), microParameter3, true)); 
            cmd.Id = id;
            return cmd;
            
        }
        private Command CreateDownloadFileMicroCommand(int id, string microCommandName, string microParameter1, string microParameter2, StatusStrip ss)
        {          
             var cmd = new DownloadFileMicroCommand(microCommandName, microParameter1, microParameter2, ss);
              cmd.Id = id;
              return cmd;       
        }    


        private void notifyIcon1_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            // When icon is double-clicked, show this message.
            MessageBox.Show("Doing something important on double-click...");
            // Then, hide the icon.
            notifyIcon1.Visible = false;
        }
        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == (Keys.Control | Keys.F))
            {
                MessageBox.Show("What the Ctrl+F?");
                return true;
            }
            return base.ProcessCmdKey(ref msg, keyData);
        }


        public void macrocommand(object sender, EventArgs e)
        {
            MacroCommandForm macrocommand = new MacroCommandForm();
            if (macrocommand.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                Command mac = macrocommand.CreateMacroCommand();
                TreeNode node = new TreeNode(mac.Name);
                node.Tag = mac;
                treeView1.Nodes.Add(node);
            }        
        }
        private void cgcgcToolStripMenuItem_Click(object sender, EventArgs e)
        {
            macrocommand(sender, e);
        }
        private void toolStripButton1_Click(object sender, EventArgs e)
        {
            macrocommand(sender, e);
        }


        private void listView1_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                cmListView.Show(e.Location);
            }
        }     
       
        private void treeView1_MouseDoubleClick(object sender, MouseEventArgs e)
        {            
            // string url = "https://www.java.com/en/download/manual.jsp";
            //string saveTo = "D:/test/manual.jsp";
            //Process.Start("E:/pera/Home Task/FirstGame/bin/Debug/FirstGame.exe");
        }

        private void listView1_ItemDrag(object sender, ItemDragEventArgs e)
        {
            listView1.DoDragDrop(listView1.SelectedItems, DragDropEffects.All);
        }
        private void treeView1_DragEnter(object sender, DragEventArgs e)
        {
            e.Effect = DragDropEffects.All;            
        }

        private void treeView1_DragDrop(object sender, DragEventArgs e)
        {
            TreeNode n;

            if (e.Data.GetDataPresent("System.Windows.Forms.ListView+SelectedListViewItemCollection", false))
            {
                Point pt = ((TreeView)sender).PointToClient(new Point(e.X, e.Y));
                TreeNode dn = ((TreeView)sender).GetNodeAt(pt);

                ListView.SelectedListViewItemCollection lvi = (ListView.SelectedListViewItemCollection)e.Data.GetData("System.Windows.Forms.ListView+SelectedListViewItemCollection");


                if (dn.Tag is MacroCommand)
                {
                    foreach (ListViewItem item in lvi)
                    {
                        n = new TreeNode(item.Text);
                        n.Tag = item.Tag;
                        // bind nodes visually
                        dn.Nodes.Add(n);
                        // bind MacroCommand with it's child (MicroCommand)
                        ((MacroCommand)dn.Tag).Add((Command)n.Tag);
                        InsertMacroMicro(((MacroCommand)dn.Tag), (Command)n.Tag);
                    }
                    dn.Expand();
                }
            }
            else if (e.Data.GetDataPresent(typeof(TreeNode)))
            {
                Point pt = ((TreeView)sender).PointToClient(new Point(e.X, e.Y));
                // find destination node
                TreeNode dn = ((TreeView)sender).GetNodeAt(pt);
                // find source node
                TreeNode srcNode = (TreeNode)e.Data.GetData(typeof(TreeNode));

                if (srcNode.Tag is MicroCommand)
                {
                    if (dn == null || dn.Tag is MicroCommand) return;
                }

                n = (TreeNode)srcNode.Clone();
                if (dn == null)
                {
                    if (srcNode.Tag is MacroCommand)
                    {
                        treeView1.Nodes.Add(n);
                        //InsertMacroMicro((null), (Command)n.Tag);                      
                    }                    
                }
                else if (dn.Tag is MacroCommand)
                {
                    ((MacroCommand)dn.Tag).Add((Command)n.Tag);
                    dn.Nodes.Add(n);
                    if (n.Tag is MicroCommand)
                    {
                        // bug!!!
                        InsertMacroMicro(((MacroCommand)dn.Tag), (Command)n.Tag);
                    }
                    else
                    {
                        // update ParentId
                        InsertMacroMicro((MacroCommand)dn.Tag, (MacroCommand)n.Tag);
                    }

                    dn.Expand();                     
                }

                // first remove the child from the parent's MacroCommand
                TreeNode parent = srcNode.Parent;
                if (parent != null)
                {
                    ((MacroCommand)parent.Tag).Remove((Command)srcNode.Tag);

                    DeleteCommand((MacroCommand)parent.Tag, (Command)srcNode.Tag);                    
                }
                srcNode.Remove();
                InsertMacroMicro((null), (Command)n.Tag);          
            }
        }
               

        private void DeleteCommand(MacroCommand mac, Command cmd)
        {
            SqlConnection conn = new SqlConnection(@"Data Source= WS-DEVNS-22;Initial Catalog=Command;Integrated Security=True");
            conn.Open();
           
            SqlCommand sql = new SqlCommand("spCommandDelete", conn);
            sql.CommandType = CommandType.StoredProcedure;

            //string commanddelete = "delete top (1) from MacroMicro where MacroCommandID = @Val1 and MicroCommandID = @Val2";
            
            //SqlCommand sql = new SqlCommand(commanddelete, conn);
            int? MacroID = mac.Id;
            int? MicroID = cmd.Id;
            sql.Parameters.AddWithValue("@MacroCommandId", MacroID);
            sql.Parameters.AddWithValue("@MicroCommandId", MicroID);
            int ret = sql.ExecuteNonQuery();   
            conn.Close();           
        }

        private void InsertMacroMicro(MacroCommand mac, Command cmd)
        {
            if (!cmd.IsMacroCommand)
            {
                SqlConnection conn = new SqlConnection(@"Data Source= WS-DEVNS-22;Initial Catalog=Command;Integrated Security=True");               

                //string command = "INSERT INTO MacroMicro (MacroCommandID, MicroCommandID) VALUES (@Val1, @Val2)";
                try
                {
                    conn.Open();
                    //SqlCommand sql = new SqlCommand(command, conn);
                    SqlCommand sql = new SqlCommand("spCommandInsert", conn);
                    sql.CommandType = CommandType.StoredProcedure;
                    int? MacroID = mac.Id;
                    int? MicroID = cmd.Id;
                    sql.Parameters.AddWithValue("@MacroCommandID", MacroID);
                    sql.Parameters.AddWithValue("@MicroCommandID", MicroID);
                    sql.ExecuteNonQuery();
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
            else
            {
                SqlConnection conn = new SqlConnection(@"Data Source= WS-DEVNS-22;Initial Catalog=Command;Integrated Security=True");

                //string command = "UPDATE MacroCommands SET ParentId = @Val1 WHERE MacroCommandId = @Val2";
                try
                {
                    conn.Open();
                    SqlCommand sql = new SqlCommand("spCommandUpdate", conn);
                    sql.CommandType = CommandType.StoredProcedure;
                    //SqlCommand sql = new SqlCommand(command, conn);
                    int? MacroID = mac.Id;
                    int? MacroChildId = cmd.Id;
                    sql.Parameters.AddWithValue("@MacrocomandID1", MacroID);
                    sql.Parameters.AddWithValue("@MacrocomandID2", MacroChildId);
                    sql.ExecuteNonQuery();
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

        public void executemicrocmd(object sender, EventArgs e)
          {
            if (listView1.SelectedItems.Count > 0)
                {
                        foreach (ListViewItem it in listView1.SelectedItems)
                        {
                            Command cmd = (Command)it.Tag;
                            cmd.Execute();
                        }
                 }
            }
        private void listView1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.A && e.Control)
            {
                executemicrocmd(sender, e);
            }
        }
        private void executeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            executemicrocmd(sender, e);          
        }

        private string GetShortTypeName(Type type)
        {
            string fullTypeName = type.ToString();
            return fullTypeName.Substring(fullTypeName.LastIndexOf('.') + 1);
        }

        private void microcommand(object sender, EventArgs e)
        {
            MicroCommandForm microcommand = new MicroCommandForm();
            microcommand.Tag = this;
            if (microcommand.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                Command cmd = microcommand.CreateMicroCommand(microcommand.tabControl1.SelectedIndex);
                //string fullTypeName = cmd.GetType().ToString();
                //string simpleTypeName = fullTypeName.Substring(fullTypeName.LastIndexOf('.') + 1);
                ListViewItem item = new ListViewItem(new[] { cmd.Name, (DateTime.Now.ToString()), GetShortTypeName(cmd.GetType()) });
                //this.listView1.Items.Add(new ListViewItem(new[] { cmd.name, (DateTime.Now.ToString()), cmd.GetType().ToString() }));
                item.Tag = cmd;
                this.listView1.Items.Add(item);
            }
        }
        private void microCommandToolStripMenuItem_Click(object sender, EventArgs e)
        {
            microcommand(sender, e);           
        }
        private void toolStripButton2_Click(object sender, EventArgs e)
        {
            microcommand(sender, e);
        }



        private void executemacrocmd(object sender, EventArgs e)
        {
            if (treeView1.SelectedNode != null)
            {
                Command cmd = (Command)treeView1.SelectedNode.Tag;
                cmd.Execute();
            }
        }
        private void executeToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            executemacrocmd(sender, e);
        }
        private void treeView1_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Q && e.Control)
            {
                executemacrocmd(sender, e);               
            }
        }


        private void treeView1_MouseClick(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                //Point pt = treeView1.PointToClient(new Point(e.X, e.Y));
                TreeNode dn = treeView1.GetNodeAt(e.X, e.Y);
                treeView1.SelectedNode = dn;
                cmTreeView.Show(e.Location);
            }
        }
        private void treeView1_ItemDrag(object sender, ItemDragEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                treeView1.DoDragDrop(e.Item, DragDropEffects.Move);
            }
            else if (e.Button == MouseButtons.Right)
            {
                treeView1.DoDragDrop(e.Item, DragDropEffects.Copy);
            }
            //treeView1.DoDragDrop(treeView1.SelectedNode, DragDropEffects.All);
        }

        private void listView1_ColumnClick(object sender, ColumnClickEventArgs e)
        {          

            if (e.Column == ColumnSorter.SortColumn)
            {
                // Reverse the current sort direction for this column.
                if (ColumnSorter.Order == System.Windows.Forms.SortOrder.Ascending)
                {
                    ColumnSorter.Order = System.Windows.Forms.SortOrder.Descending;
                }
                else
                {
                    ColumnSorter.Order = System.Windows.Forms.SortOrder.Ascending;
                }
            }
            else
            {
                // Set the column number that is to be sorted; default to ascending.
                ColumnSorter.SortColumn = e.Column;
                ColumnSorter.Order = System.Windows.Forms.SortOrder.Ascending;
            }

            // Perform the sort with these new sort options.
            this.listView1.Sort();
        }      
    }   
}
  
      
        
      

