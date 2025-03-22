# USB Duplicator for DJs

A high-performance tool for duplicating DJ USB drives quickly and efficiently. This tool is designed specifically for DJs who need to create backup copies of their Rekordbox libraries on multiple USB drives.

## Requirements

- macOS (primary support)
- Terminal access
- Bash or Zsh shell (Zsh is default on macOS Catalina and newer)
- **At least 2 USB drives**:
  - One source USB drive with your DJ library
  - One or more destination USB drives to copy to
  - *Note: The script handles one destination at a time, so if you need to copy to multiple destinations, you'll need to run the script once for each destination drive*

## Features

- **Fast copying** using `rsync` for maximum performance
- **Interactive selection** of source and destination drives 
- **Progress tracking** with detailed statistics during copy
- **Verification** to ensure all files were copied correctly
- **Space checking** to prevent failed copies due to insufficient space
- **Minimal dependencies** - uses only built-in macOS tools
- **Complete duplication** - includes hidden files and preserves file attributes

## Installation

No installation needed! The script runs directly without any additional dependencies.

### Making the Script Executable

Before running the script for the first time, you need to make it executable:

```bash
chmod +x scripts/usb-duplicator/usb_duplicator.sh
```

**What does this do?** 
- The `chmod` command changes the permissions of the file
- The `+x` flag adds executable permission
- This tells your system that the file is a program that can be run, not just a text file
- You only need to do this once (unless you download the script again)

### Optional: Creating a Convenient Command

For easier access, you can create a symbolic link (shortcut) to the script:

**Option 1: System-wide access (requires admin privileges)**
```bash
sudo ln -s "$(pwd)/scripts/usb-duplicator/usb_duplicator.sh" /usr/local/bin/usb-duplicator
```

**Option 2: Personal bin directory (recommended)**
```bash
# Create bin directory if it doesn't exist
mkdir -p ~/bin

# Create the symbolic link
ln -s "$(pwd)/scripts/usb-duplicator/usb_duplicator.sh" ~/bin/usb-duplicator
```

**Adding to your PATH:**

**For Zsh users (macOS Catalina and newer):**
```bash
# Open your Zsh configuration file
open -e ~/.zshrc

# Add this line to the file and save
export PATH="$HOME/bin:$PATH"

# Apply changes to current terminal session
source ~/.zshrc
```

**For Bash users (older macOS versions):**
```bash
# Open your Bash configuration file
open -e ~/.bash_profile

# Add this line to the file and save
export PATH="$HOME/bin:$PATH"

# Apply changes to current terminal session
source ~/.bash_profile
```

## Usage

### Basic Usage

Run the script from the terminal without arguments to get an interactive prompt:

```bash
./scripts/usb-duplicator/usb_duplicator.sh
```

Or if you created the symbolic link:

```bash
usb-duplicator
```

The script will:
1. List all available drives
2. Prompt you to select a source drive
3. Prompt you to select a destination drive
4. Check if there's enough space
5. Copy all files with progress updates
6. Verify the copy was successful

### Advanced Usage

You can specify source and destination directly:

```bash
./scripts/usb-duplicator/usb_duplicator.sh /Volumes/SOURCE_USB /Volumes/DESTINATION_USB
```

### Help

For help information:

```bash
./scripts/usb-duplicator/usb_duplicator.sh --help
```

## For Beginner Terminal Users

### Step-by-Step Instructions

1. **Open Terminal app**: 
   - Find it in Applications → Utilities → Terminal
   - Or use Spotlight (Cmd+Space) and type "Terminal"

2. **Navigate to this repository**:
   ```bash
   cd path/to/dj-tools
   ```
   
   > If you're not sure of the path, you can drag the folder into the terminal window after typing `cd `.

3. **Make the script executable** (first time only):
   ```bash
   chmod +x scripts/usb-duplicator/usb_duplicator.sh
   ```
   
   You'll need to do this only once. This step is necessary because by default, text files aren't allowed to run as programs for security reasons. This command specifically allows this script to run.

4. **Run the script**:
   ```bash
   ./scripts/usb-duplicator/usb_duplicator.sh
   ```
   
   The `./` at the beginning tells the terminal to look for the script in the current directory.

5. **Follow the on-screen prompts**:
   - You'll see a list of available drives
   - Enter the number for your source USB
   - Enter the number for your destination USB 
   - The copy process will begin with a progress bar

### Common Questions

**Q: Can I cancel the copy once it starts?**  
A: Yes, press Ctrl+C to cancel the operation at any time.

**Q: How do I know if it worked?**  
A: The script performs verification after copying and will tell you if all files were copied correctly.

**Q: Is it safe to unplug my drives after copying?**  
A: Always eject drives properly by right-clicking on them in Finder and selecting "Eject".

**Q: I get "permission denied" when trying to run the script?**  
A: You probably forgot to make the script executable. Run the command in step 3 above.

**Q: Do I need to be an admin on my computer to use this?**  
A: No, the basic usage doesn't require admin privileges. Only the optional system-wide installation does.

**Q: How many USBs do I need?**  
A: You need at least 2 USB drives - one source (with your DJ library) and one destination. If you need to copy to multiple USBs, run the script once for each destination drive.

## For Experienced Users

The script uses `rsync` with the following options:
- `-a` (archive mode): preserves permissions, ownership, timestamps, etc.
- `-h` (human-readable): outputs file sizes in a readable format
- `--include='.*'`: ensures hidden files (dot files) are copied
- `--info=progress2`: shows overall progress
- `--stats`: provides detailed statistics about the transfer

For verification, it uses `rsync` with dry-run mode and checksum comparison.

The script handles paths with spaces correctly and provides meaningful error messages for common issues.

## Performance Considerations

This script is optimized for performance by:
- Using `rsync` which is significantly faster than `cp` for large transfers
- Avoiding unnecessary file operations
- Optimizing verification to be fast yet thorough
- Using native filesystem operations where possible

## Troubleshooting

- **"Permission denied" errors**: Make sure the script is executable with `chmod +x`
- **Drive not showing up**: Ensure the drive is properly mounted in Finder
- **Verification failures**: Check if the source drive was modified during copying
- **Script hangs**: For very large libraries (10,000+ tracks), the script may take longer to calculate sizes
- **Command not found**: If you created a symbolic link but get "command not found", you may need to restart your terminal or run `source ~/.zshrc` (for Zsh) or `source ~/.bash_profile` (for Bash)

## License

This tool is part of the DJ Tools project and is available under the same license as the parent project. 