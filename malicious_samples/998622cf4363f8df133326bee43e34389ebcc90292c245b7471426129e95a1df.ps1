import os, time, glob, shutil, json, getpass, requests, sys, ctypes, platform, struct, urllib.request # Import libraries

# Define constants for console colors and styles on Windows
if platform.system() == 'Windows':
    STD_OUTPUT_HANDLE = -11
    FOREGROUND_BLACK = 0x0000
    FOREGROUND_BLUE = 0x0001
    FOREGROUND_GREEN = 0x0002
    FOREGROUND_CYAN = 0x0003
    FOREGROUND_RED = 0x0004
    FOREGROUND_MAGENTA = 0x0005
    FOREGROUND_YELLOW = 0x0006
    FOREGROUND_WHITE = 0x0007
    FOREGROUND_GRAY = 0x0008
    FOREGROUND_INTENSITY = 0x0008
    BACKGROUND_BLACK = 0x0000
    BACKGROUND_BLUE = 0x0010
    BACKGROUND_GREEN = 0x0020
    BACKGROUND_CYAN = 0x0030
    BACKGROUND_RED = 0x0040
    BACKGROUND_MAGENTA = 0x0050
    BACKGROUND_YELLOW = 0x0060
    BACKGROUND_WHITE = 0x0070
    BACKGROUND_GRAY = 0x0080
    BACKGROUND_INTENSITY = 0x0080
    ctypes.windll.kernel32.GetStdHandle.restype = ctypes.c_ulong
    handle = ctypes.windll.kernel32.GetStdHandle(STD_OUTPUT_HANDLE)

    # Define color and style codes for Windows
    styles = {
        "reset": 0,
        "bold": FOREGROUND_INTENSITY,
        "underline": 0x80000000 | BACKGROUND_INTENSITY,
        "bold_underline": FOREGROUND_INTENSITY | 0x80000000 | BACKGROUND_INTENSITY,
    }
    colors = {
        "black": FOREGROUND_BLACK,
        "blue": FOREGROUND_BLUE,
        "green": FOREGROUND_GREEN,
        "cyan": FOREGROUND_CYAN,
        "red": FOREGROUND_RED,
        "magenta": FOREGROUND_MAGENTA,
        "yellow": FOREGROUND_YELLOW,
        "white": FOREGROUND_WHITE,
        "gray": FOREGROUND_GRAY,
        "bg_black": BACKGROUND_BLACK,
        "bg_blue": BACKGROUND_BLUE,
        "bg_green": BACKGROUND_GREEN,
        "bg_cyan": BACKGROUND_CYAN,
        "bg_red": BACKGROUND_RED,
        "bg_magenta": BACKGROUND_MAGENTA,
        "bg_yellow": BACKGROUND_YELLOW,
        "bg_white": BACKGROUND_WHITE,
        "bg_gray": BACKGROUND_GRAY,
    }

# Define color and style codes for Unix-based systems
else:
    styles = {
        "reset": "\033[0m",
        "bold": "\033[1m",
        "underline": "\033[4m",
        "bold_underline": "\033[1m\033[4m",
    }
    colors = {
        "black": "30",
        "red": "31",
        "green": "32",
        "yellow": "33",
        "blue": "34",
        "magenta": "35",
        "cyan": "36",
        "white": "37",
        "gray": "90",
        "bg_black": "40",
        "bg_red": "41",
        "bg_green": "42",
        "bg_yellow": "43",
        "bg_blue": "44",
        "bg_magenta": "45",
        "bg_cyan": "46",
        "bg_white": "47",
        "bg_gray": "100",
    }
    
# Settings variables
variable_names = ["beta"]
default_values = ["beta = False"]
file_name = "settings"
if not os.path.isfile(file_name):
    # Create file with default values
    with open(file_name, 'w') as file:
        file.write('\n'.join(default_values))
        
with open(file_name, "r") as f:
    # Read the contents of the file into a dictionary
    variables = {}
    
    for line in f:
        name, value = line.strip().split(" = ")
        variables[name] = value
        if value == "True":
            value = True
        elif value == "False":
            value = False
        elif value.isdigit():
            value = int(value)
        else:
            value = str(value)
        locals()[name] = value

# Define variables used throughout
version = "1.1.1"
user = getpass.getuser()
option_selected = 0

# Color functions (print)
def print_color(text, color="white", style="reset", bg_color=None):
    # Check if the specified color and style are valid
    if color not in colors:
        raise ValueError("Invalid color: {}".format(color))
    if style not in styles:
        raise ValueError("Invalid style: {}".format(style))
    if bg_color is not None and bg_color not in colors:
        raise ValueError("Invalid background color: {}".format(bg_color))

    # Define the color and style codes
    color_code = colors[color]
    style_code = styles[style]
    bg_color_code = colors.get(bg_color, None)

    # Set the console color and style and print the text
    if platform.system() == 'Windows':
        ctypes.windll.kernel32.SetConsoleTextAttribute(handle, color_code | style_code | (bg_color_code or 0))
        print(text)
        ctypes.windll.kernel32.SetConsoleTextAttribute(handle, colors["white"] | styles["reset"])
    # Use ANSI escape codes on other platforms
    else:
        escape_code = "\033[{};{}{}m".format(style_code, color_code, ";{}" .format(bg_color_code) if bg_color_code is not None else "")
        reset_code = "\033[0m"
        print(escape_code + text + reset_code)
        #print_color("Hello, {}!".format(name), color="blue", style="underline", bg_color="bg_white")
        
        
# Color functions (input)
def input_color(prompt, color="white", style="reset", bg_color=None):
    # Check if the specified color and style are valid
    if color not in colors:
        raise ValueError("Invalid color: {}".format(color))
    if style not in styles:
        raise ValueError("Invalid style: {}".format(style))
    if bg_color is not None and bg_color not in colors:
        raise ValueError("Invalid background color: {}".format(bg_color))

    # Define the color and style codes
    color_code = colors[color]
    style_code = styles[style]
    bg_color_code = colors.get(bg_color, None)

    # Set the console color and style
    if platform.system() == 'Windows':
        ctypes.windll.kernel32.SetConsoleTextAttribute(handle, color_code | style_code | (bg_color_code or 0))

    # Use ANSI escape codes on other platforms
    else:
        escape_code = "\033[{};{}{}m".format(style_code, color_code, ";{}" .format(bg_color_code) if bg_color_code is not None else "")
        print(escape_code, end='')

    # Get user input with the specified prompt
    user_input = input(prompt)

    # Reset the console color and style
    if platform.system() == 'Windows':
        ctypes.windll.kernel32.SetConsoleTextAttribute(handle, colors["white"] | styles["reset"])

    # Use ANSI escape codes on other platforms
    else:
        reset_code = "\033[0m"
        print(reset_code, end='')

    return user_input
    #name = input_color("What is your name? ", color="green", style="bold", bg_color="bg_black")

def clear():
    os.system('cls' if os.name == 'nt' else 'clear')   

def get_user_option():
    clear()
    print_color("Roblox Fast Flag Tuner (v"+version+")",color="cyan")
    print()
    global option_selected
    # Give the user their options
    option_values = ["Install Full", "Install Lite", "Read Current", "Settings", "Uninstall", "Version Loader", "Exit"]
    option_indexes = [1,2,3,4,5,6,7]
    for i,v in zip(option_indexes,option_values):
        print_color("{} {}".format(i, v),color="cyan",style="bold")
        time.sleep(0.1)
    print()
    option_selected = None
    # Ask the user what they want to do and give a response
    while option_selected not in [1, 2, 3, 4, 5, 6, 7]:
        print_color("Please select an option (1-7): ",color="cyan",style="bold")
        option_selected = int(input_color("> ",color="green"))
        if option_selected not in [1, 2, 3, 4, 5, 6, 7]:
            print_color("Invalid option",color="red")
    return option_selected

def close():
    print()
    time.sleep(0.25)
    input_color("Press enter to exit",color="red")
    time.sleep(0.6)
    sys.exit()

clear()

if platform.system() != "Windows":
    print_color("You are on an unsupported platform!",color="red",style="bold")
    for i in range(3):
        print_color("{} {}".format("Exiting in",str(3-i)+"..."),color="red",style="bold")
        time.sleep(1)
    sys.exit()

search_dirs = [
    f"C:/Users/{user}/AppData/Local",
    "C:/Program Files (x86)"
]
roblox_dirs = []

for search_dir in search_dirs:
    roblox_dir = os.path.join(search_dir, "Roblox")
    if os.path.exists(roblox_dir):
        roblox_dirs.append(roblox_dir)

# Search for AppSettings.xml and RobloxPlayerLauncher.exe in each Roblox folder
launcher_dir = None
latest_mod_time = 0

for roblox_dir in roblox_dirs:
    versions_dir = os.path.join(roblox_dir, "Versions")
    if not os.path.exists(versions_dir):
        continue

    for version_dir in os.listdir(versions_dir):
        version_dir = os.path.join(versions_dir, version_dir)
        app_settings_file = os.path.join(version_dir, "AppSettings.xml")
        launcher_file = os.path.join(version_dir, "RobloxPlayerLauncher.exe")

        if not os.path.exists(app_settings_file) or not os.path.exists(launcher_file):
            continue

        mod_time = os.path.getmtime(launcher_file)
        if mod_time > latest_mod_time:
            launcher_dir = version_dir
            latest_mod_time = mod_time

if launcher_dir:
    global dir
    global dir_to_search
    launcher_dir = launcher_dir[:launcher_dir.rfind("version")-1]
    dir = launcher_dir.replace("\\", "/")
    launcher_dir = launcher_dir.replace("\\", "/")
    dir_to_search = launcher_dir.replace("\\", "/")
else:
    print_color("Roblox not found.",color="red")
    time.sleep(0.25)
    input_color("Press enter to exit",color="green")
    time.sleep(0.6)
    sys.exit()
    

def uninstall():
    # Define the names of the files to search for
    file_names = ['AppSettings.xml', 'RobloxPlayerLauncher.exe']

    # Loop through all folders in the directory
    for folder_name in os.listdir(dir_to_search):
        folder_path = os.path.join(dir_to_search, folder_name)

        # Check if the folder contains both files
        files_found = all([os.path.isfile(os.path.join(folder_path, f)) for f in file_names])

        if files_found:
            # Remove the contents of the "ClientSettings" folder if it exists
            client_settings_path = os.path.join(folder_path, 'ClientSettings')
            print_color('Uninstalling optimisations...',color="magenta")
            if os.path.exists(client_settings_path):
                shutil.rmtree(client_settings_path)

            # Delete the "ClientSettings" folder if it exists
            print_color('Optimisations Uninstalled.',color="magenta")
            if os.path.exists(client_settings_path):
                os.rmdir(client_settings_path)
                
get_user_option()
 
while True:
    # Check if settings are up to date
    with open(file_name, "r") as f:
        # Read the contents of the file into a dictionary
        variables = {}
        
        for line in f:
            name, value = line.strip().split(" = ")
            variables[name] = value
            if value == "True":
                value = True
            elif value == "False":
                value = False
            elif value.isdigit():
                value = int(value)
            else:
                value = str(value)
            locals()[name] = value
    
    # Main program
    if option_selected == 1:
        url = "https://robloxfastflagtuner.000webhostapp.com/versions/configurations/full.json"
        clear()
        print_color("-- main > install full",color="yellow")
        print()
        
        try:
            uninstall()
         
            print_color("Installing client optimiser lite...",color="magenta")
     

            # Search for AppSettings.xml and RobloxPlayerLauncher.exe in C:/Users/user/AppData/Local/Roblox/Versions
            for root, dirs, files in os.walk(dir):
                if "AppSettings.xml" in files and "RobloxPlayerLauncher.exe" in files:
                    dir = root
                    break
         
            # Create the ClientSettings folder
            if dir:
                client_settings_dir = os.path.join(dir, "ClientSettings")
                os.makedirs(client_settings_dir, exist_ok=True)
         
                # Get the contents of the Pastebin URL and remove extra spaces between lines
                response = requests.get(url)
                lines = response.text.splitlines()
                for i in range(len(lines) - 1):
                    if lines[i].isspace() and lines[i + 1].isspace():
                        lines[i] = ""
                text = "\n".join(lines)
         
                # Replace the desired FPS value in the text
                print_color("Enter your desired frame rate limit:",color="magenta")
                fps = input_color("> ",color="green")
                text = text.replace('"DFIntTaskSchedulerTargetFps": 60,', f'"DFIntTaskSchedulerTargetFps": {fps},')
         
                # Write the contents to the ClientAppSettings.json file
                filename = os.path.join(client_settings_dir, "ClientAppSettings.json")
                with open(filename, "w") as f:
                    f.write(text)
                filename = filename.replace("/", "\\")
                print_color(f"File created! ({filename})",color="magenta")
                
        except PermissionError:
            print_color("Permission denied to create file. Try the application as administrator.",color="red")
            time.sleep(0.25)
            input_color("Press enter to exit",color="green")
            time.sleep(0.6)
            sys.exit()
            
        print()
        print_color("Press enter to go back to the main menu",color="green")
        input()
        get_user_option()
     
    elif option_selected == 2:
        url = "https://robloxfastflagtuner.000webhostapp.com/versions/configurations/lite.json"
        clear()
        print_color("-- main > install lite",color="yellow")
        print()
        
        try:
            uninstall()
         
            print_color("Installing client optimiser lite...",color="magenta")
     

            # Search for AppSettings.xml and RobloxPlayerLauncher.exe in C:/Users/user/AppData/Local/Roblox/Versions
            for root, dirs, files in os.walk(dir):
                if "AppSettings.xml" in files and "RobloxPlayerLauncher.exe" in files:
                    dir = root
                    break
         
            # Create the ClientSettings folder
            if dir:
                client_settings_dir = os.path.join(dir, "ClientSettings")
                os.makedirs(client_settings_dir, exist_ok=True)
         
                # Get the contents of the Pastebin URL and remove extra spaces between lines
                response = requests.get(url)
                lines = response.text.splitlines()
                for i in range(len(lines) - 1):
                    if lines[i].isspace() and lines[i + 1].isspace():
                        lines[i] = ""
                text = "\n".join(lines)
         
                # Replace the desired FPS value in the text
                print_color("Enter your desired frame rate limit:",color="magenta")
                fps = input_color("> ",color="green")
                text = text.replace('"DFIntTaskSchedulerTargetFps": 60,', f'"DFIntTaskSchedulerTargetFps": {fps},')
         
                # Write the contents to the ClientAppSettings.json file
                filename = os.path.join(client_settings_dir, "ClientAppSettings.json")
                with open(filename, "w") as f:
                    f.write(text)
                filename = filename.replace("/", "\\")
                print_color(f"File created! ({filename})",color="magenta")
                
        except PermissionError:
            print_color("Permission denied to create file. Try the application as administrator.",color="red")
            time.sleep(0.25)
            input_color("Press enter to exit",color="green")
            time.sleep(0.6)
            sys.exit()

        print()
        print_color("Press enter to go back to the main menu",color="green")
        input()
        get_user_option()
     
    elif option_selected == 3:
        clear()
        print_color("-- main > read current",color="yellow")
        print()
        file_names = ['RobloxPlayerLauncher.exe', 'AppSettings.xml']
        client_settings_printed = False

        for foldername, subfolders, filenames in os.walk(dir_to_search):
            if all(file_name in filenames for file_name in file_names):
                client_settings = os.path.join(foldername, "ClientSettings", "ClientAppSettings.json")
                if os.path.exists(client_settings) and not client_settings_printed:
                    with open(client_settings, "r") as f:
                        print_color(f.read(),color="magenta")
                    client_settings_printed = True


        print()
        print_color("Press enter to go back to the main menu",color="green")
        input()
        get_user_option()

    elif option_selected == 4:
        clear()
        print_color("-- main > settings",color="yellow")
        print()
        def get_user_option_settings():
            global option_selected_settings
            # Give the user their options
            option_values_settings = ["Edit", "Revert to default", "Read Current", "Exit Settings"]
            option_indexes_settings = [1,2,3,4]
            for i,v in zip(option_indexes_settings,option_values_settings):
                print_color("{} {}".format(i, v),color="gray")
                time.sleep(0.1)
            print()
            option_selected_settings = None
            # Ask the user what they want to do and give a response
            while option_selected_settings not in [1, 2, 3, 4]:
                print_color("Please select an option (1-4): ",color="gray")
                option_selected_settings = int(input_color("> ",color="green"))
                if option_selected_settings not in [1, 2, 3, 4]:
                    print_color("Invalid option",color="red")
            return option_selected_settings

        # Check if file exists
        if not os.path.isfile(file_name):
            # Create file with default values
            with open(file_name, 'w') as file:
                file.write('\n'.join(default_values))


        with open(file_name, "r") as f:
            contents = f.read()
            # Split the contents of the file into separate lines
            lines = contents.split("\n")
            # Initialize an empty dictionary to store the variable names and values
            variables = {}
            # Iterate over each line and extract the variable name and value
            for line in lines:
                if "=" in line:
                    name, value = line.split(" = ")
                    variables[name] = value.strip()
                        
        get_user_option_settings()

        if option_selected_settings == 1:
            clear()
            print_color("-- main > settings > edit",color="yellow")
            print()
            for name in variable_names:
                value = variables.get(name, "True")
                while True:
                    print_color(f"Enter a new value for {name} ({value}): ",color="magenta")
                    new_value = input_color("> ",color="green")
                    if new_value.lower() == "true":
                        variables[name] = "True"
                        break
                    elif new_value.lower() == "false":
                        variables[name] = "False"
                        break
                    else:
                        print_color("Invalid input. Please enter 'True' or 'False'",color="red")
            # Write the variables to the settings file
            with open(file_name, "w") as f:
                for name in variable_names:
                    value = variables.get(name, "True")
                    f.write(f"{name} = {value}\n")
            print_color("Settings saved.",color="magenta")
            print()
            print_color("Press enter to go back to the settings menu",color="green")
            input()
            
        elif option_selected_settings == 2:
            clear()
            print_color("-- main > settings > revert to default",color="yellow")
            print()
            with open(file_name, 'w') as file:
                file.write('\n'.join(default_values))
            print_color("Settings saved.",color="magenta")
            print()
            print_color("Press enter to go back to the settings menu",color="green")
            input()
            
        elif option_selected_settings == 3:
            clear()
            print_color("-- main > settings > read current",color="yellow")
            print()
            # Open the settings file and read its contents
            with open(file_name, 'r') as f:
                contents = f.read()
                print_color(contents,color="magenta")
            print()
            print_color("Press enter to go back to the settings menu",color="green")
            input()

        elif option_selected_settings == 4:
            clear()
            get_user_option()
        
    elif option_selected == 5:
        clear()
        print_color("-- main > uninstall",color="yellow")
        print()
        uninstall()

        print()
        print_color("Press enter to go back to the main menu",color="green")
        input()
        get_user_option()
        
    elif option_selected == 6:
        clear()
        url = "https://robloxfastflagtuner.000webhostapp.com/versions/RFFT_VersionManager.py"
        attempts = 6
        while True:
            try:
                # Download the script
                with urllib.request.urlopen(url, timeout=10) as response:
                    script = response.read().decode()

                # Execute the script using exec
                global_vars = {}
                exec(script, global_vars)
                

                # Copy the global variables into the current namespace
                for var_name, var_value in global_vars.items():
                    globals()[var_name] = var_value

            except Exception as e:
                attempts -= 1
                clear()
                if attempts <= 0:
                    print_color(f'Error when retrieving file contents: "{e}"',color="red")
                    time.sleep(0.25)
                    input_color("Press enter to exit",color="red")
                    sys.exit()
                else:
                    if attempts == 1:
                        print_color(f'An error occurred while executing the code ({attempts} attempt left): "{e}"',color="red")
                        time.sleep(1)
                    else:
                        print_color(f'An error occurred while executing the code ({attempts} attempts left): "{e}"',color="red")
                        time.sleep(1)
                    for i in range(3):
                        print_color("{} {}".format("Retrying in",str(3-i)+"..."),color="red")
                        time.sleep(1)
                    print("Attempting to reconnect...")
                    time.sleep(1)
                        
    elif option_selected == 7:
        clear()
        print_color("Exiting...",color="red")
        time.sleep(1)
        sys.exit()
        
    else:
        clear()
        print_color("Invalid option entered!",color="red")
        time.sleep(0.25)
        input_color("Press enter to exit",color="green")
        time.sleep(0.6)
        sys.exit()
