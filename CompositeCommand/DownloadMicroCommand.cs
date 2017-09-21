using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CompositeCommand
{
    public class DownloadFileMicroCommand : MicroCommand
    {
        private string _downloadPath;
        private string _saveTo;
        private ToolStripProgressBar _progressBar;
        private ToolStripLabel _tsl1;
        private ToolStripLabel _tsl2;
        private StatusStrip _ss;

        public DownloadFileMicroCommand(string name, string downloadPath, string saveTo, ToolStripProgressBar progressBar, ToolStripLabel tsl1, ToolStripLabel tsl2)
            : base(name)
        {
            _downloadPath = downloadPath;
            _saveTo = saveTo;
            _progressBar = progressBar;
            _tsl1 = tsl1;
            _tsl2 = tsl2;
        }
        public string DownloadPath { get { return _downloadPath; } }
        public string SaveTo { get { return _saveTo; } }

        public DownloadFileMicroCommand(string name, string downloadPath, string saveTo, StatusStrip ss)
            : base(name)
        {
            _downloadPath = downloadPath;
            _saveTo = saveTo;
            _ss = ss;
            _progressBar = (ToolStripProgressBar)_ss.Items[0]; ;
            _tsl1 = (ToolStripLabel)_ss.Items[1];
            _tsl2 = (ToolStripLabel)_ss.Items[2];
        }

        public override void Execute()
        {
            WebClient wc = new WebClient();
            wc.DownloadFileCompleted += wc_DownloadFileCompleted;
            wc.DownloadProgressChanged += wc_DownloadProgressChanged;
            _progressBar.Value = _progressBar.Minimum;
            _tsl1.Text = "";
            _tsl2.Text = "";
            wc.DownloadFileAsync( new Uri(_downloadPath), _saveTo);
        }

        public void wc_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            double bytesIn = double.Parse(e.BytesReceived.ToString());
            double totalBytes = double.Parse(e.TotalBytesToReceive.ToString());
            double percentage = bytesIn / totalBytes * 100;
            _tsl1.Text = e.BytesReceived.ToString();
            _tsl2.Text = e.TotalBytesToReceive.ToString();
            _progressBar.Value = int.Parse(Math.Truncate(percentage).ToString());          

        }

        void wc_DownloadFileCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs e)
        {
            _progressBar.Value = _progressBar.Maximum;
        }
    }   
}
    

