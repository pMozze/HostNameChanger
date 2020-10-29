#include <sourcemod>

char g_szConfigHostName[128];
ConVar g_cvHostName = null;

public Plugin myinfo =  {
	name = "HostName Changer", 
	author = "Mozze",
	description = "", 
	version = "1.0", 
	url = "t.me/pMozze"
};

public void OnPluginStart() {
	File configFile = OpenFile("addons/sourcemod/configs/HostNameChanger.cfg", "r");

	if (configFile != null && configFile.ReadLine(g_szConfigHostName, sizeof(g_szConfigHostName))) {
		TrimString(g_szConfigHostName);
		delete configFile;
	} else {
		SetFailState("Файл конфигурации не найден или оказался пуст");
	}

	g_cvHostName = FindConVar("hostname");
}

public void OnConfigsExecuted() {
	updateHostName();
}

public void OnClientConnected(int Client) {
	updateHostName();
}

public void OnClientDisconnect_Post(int Client) {
	updateHostName();
}

void updateHostName() {
	char hostName[128];
	char currentMap[64];
	char playersCount[4];
	char playersMax[4];
	
	strcopy(hostName, sizeof(hostName), g_szConfigHostName);
	GetCurrentMap(currentMap, sizeof(currentMap));
	IntToString(GetClientCount(false), playersCount, sizeof(playersCount));
	IntToString(MaxClients, playersMax, sizeof(playersMax));

	ReplaceString(hostName, sizeof(hostName), "{currentMap}", currentMap);
	ReplaceString(hostName, sizeof(hostName), "{playersCount}", playersCount);
	ReplaceString(hostName, sizeof(hostName), "{maxPlayers}", playersMax);

	g_cvHostName.SetString(hostName);
} 