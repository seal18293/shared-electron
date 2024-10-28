#pragma comment(linker, "/SUBSYSTEM:windows /ENTRY:mainCRTStartup")
#pragma warning(disable : 4996)

#include <iostream>
#include <windows.h>
#include <string>

using namespace std;

string versionStr = "33";
string regPrefix = "Software\\SharedElectron";

string errMsgPrefix = "Could not find Shared Electron v";
string errMsgSuffix = ". Make sure you have installed it.";

int main(int argc, char *argv[])
{
	HKEY hKey;
	string path = regPrefix + versionStr;
	if (RegOpenKeyExA(HKEY_CURRENT_USER, path.c_str(), 0, KEY_READ, &hKey) == ERROR_SUCCESS)
	{
		DWORD size;
		if (RegGetValueA(hKey, nullptr, "ExecutablePath", RRF_RT_REG_SZ, nullptr, nullptr, &size) == ERROR_SUCCESS)
		{
			char *data = new char[size];
			LSTATUS err = RegGetValueA(hKey, nullptr, "ExecutablePath", RRF_RT_REG_SZ, nullptr, data, &size);
			if (err == ERROR_SUCCESS)
			{
				STARTUPINFO si = {sizeof(si)};
				PROCESS_INFORMATION pi;
				if (CreateProcessA(NULL, (LPSTR)(string(data) + " app.asar").c_str(), NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
				{
					CloseHandle(pi.hProcess);
					CloseHandle(pi.hThread);
				}
				else
				{
					LPSTR messageBuffer = nullptr;

					FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
												 NULL, GetLastError(), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPSTR)&messageBuffer, 0, NULL);

					MessageBoxA(0, messageBuffer, "Error when launching Shared Electron", MB_ICONERROR);
				}
			}
			else
			{
				MessageBoxA(0, "Error reading ExecutablePath registry value.", nullptr, MB_ICONERROR);
			}
		}
		else
		{
			MessageBoxA(0, (string("Could not find ExecutablePath value in registry. Reinstall Shared Electron v") + versionStr + ".").c_str(), nullptr, MB_ICONERROR);
		}
	}
	else
	{
		MessageBoxA(0, (errMsgPrefix + versionStr + errMsgSuffix).c_str(), nullptr, MB_ICONERROR);
	}
}