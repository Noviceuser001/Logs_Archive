# Log Archive Tool

A simple, efficient command-line utility for archiving log files on Unix-based systems. This tool compresses log directories into timestamped tar.gz archives while maintaining detailed operation logs.

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Output](#output)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

- **Simple CLI Interface**: Easy-to-use command-line tool
- **Timestamped Archives**: Creates archives with format `logs_archive_YYYYMMDD_HHMMSS.tar.gz`
- **Automatic Compression**: Uses tar.gz compression for efficient storage
- **Operation Logging**: Maintains detailed logs of all archive operations
- **Verbose Mode**: Optional detailed output for monitoring operations
- **Error Handling**: Comprehensive error checking and user-friendly messages
- **Safe Operations**: Validates directories and permissions before proceeding

## 🔧 Requirements

### System Requirements
- Unix-based operating system (Linux, macOS, BSD)
- Bash shell (version 4.0 or higher)
- Standard utilities: `tar`, `gzip`, `date`, `mkdir`, `du`

### Permissions
- Read access to source log directory
- Write access to archive destination directory
- Execute permissions for the script

## 📦 Installation

### Quick Install

1. **Download the script**:
   ```bash
   # Save the script as 'log_archive'
   download using 'git clone'<repository link>
   # or copy and paste the script into a new file
   ```

2. **Make it executable**:
   ```bash
   chmod +x log_archive
   ```

3. **Optional: Install system-wide**:
   ```bash
   sudo cp log_archive /usr/local/bin/
   ```

### For System-wide Access with Sudo

If you need to archive system logs (like `/var/log`), see the [Sudo Setup](#sudo-setup) section below.

## 🚀 Usage

### Basic Syntax

```bash
./log_archive <log-directory> [options]
```

### Arguments

- `<log-directory>`: Path to the directory containing logs to archive *(required)*

### Options

- `-h, --help`: Display help information and exit
- `-v, --verbose`: Enable verbose output showing detailed operations

### Exit Codes

- `0`: Success
- `1`: Error (invalid arguments, permission denied, operation failed)

## 📝 Examples

### Basic Usage

```bash
# Archive logs from /var/log (requires appropriate permissions)
./log_archive /var/log

# Archive logs with detailed output
./log_archive /var/log --verbose

# Archive custom log directory
./log_archive /home/user/app-logs

# Show help
./log_archive --help
```

### With Sudo (for system logs)

```bash
# Archive system logs
sudo ./log_archive /var/log

# Archive with verbose output
sudo ./log_archive /var/log --verbose
```

## 📤 Output

### Archive Files

Archives are created with the naming convention:
```
logs_archive_YYYYMMDD_HHMMSS.tar.gz
```

**Example**: `logs_archive_20240816_143022.tar.gz`

### Default Locations

- **Archives**: `$HOME/log-archives/`
- **Log file**: `$HOME/log-archives/archive.log`

### Console Output

```bash
$ ./log_archive /var/log --verbose
=== Log Archive Tool ===
Started at: Wed Aug 16 14:30:22 UTC 2024

Creating archive from: /var/log
Archive location: /home/user/log-archives/logs_archive_20240816_143022.tar.gz
Running: tar -czf '/home/user/log-archives/logs_archive_20240816_143022.tar.gz' -C '/' 'var/log'
var/log/
var/log/syslog
var/log/auth.log
var/log/kern.log
Archive created successfully: /home/user/log-archives/logs_archive_20240816_143022.tar.gz (2.3M)

Log archive completed successfully.
Log file: /home/user/log-archives/archive.log
Archive directory: /home/user/log-archives
End time: Wed Aug 16 14:30:25 UTC 2024
```

### Log File Format

```
[2024-08-16 14:30:22] Validated log directory: /var/log
[2024-08-16 14:30:25] SUCCESS: Archived /var/log to /home/user/log-archives/logs_archive_20240816_143022.tar.gz (2.3M)
[2024-08-16 14:30:25] Log archive completed successfully
```

## ⚙️ Configuration

### Environment Variables

You can customize the default archive directory by modifying the script:

```bash
# Edit the DEFAULT_ARCHIVE_DIR variable in the script
DEFAULT_ARCHIVE_DIR="$HOME/log-archives"  # Default
DEFAULT_ARCHIVE_DIR="/backup/logs"        # Custom location
```

### Archive Directory Structure

```
$HOME/log-archives/
├── archive.log                           # Operation log
├── logs_archive_20240816_143022.tar.gz   # Archive files
├── logs_archive_20240817_090015.tar.gz
└── logs_archive_20240818_120330.tar.gz
```

## 🔐 Sudo Setup

To allow regular users to archive system logs, set up sudo permissions:

### 1. Create a user group

```bash
sudo groupadd logarchive
sudo usermod -a -G logarchive $USER
```

### 2. Configure sudo permissions

```bash
sudo visudo
# Add this line:
%logarchive ALL=(root) NOPASSWD: /usr/local/bin/log_archive
```

### 3. Install script system-wide

```bash
sudo cp log_archive /usr/local/bin/
sudo chmod +x /usr/local/bin/log_archive
sudo chown root:root /usr/local/bin/log_archive
```

### 4. Users can now run

```bash
sudo log_archive /var/log --verbose
```

## 🔍 Troubleshooting

### Common Issues

#### Permission Denied
```
Error: Log directory is not readable: /var/log
```
**Solution**: Run with sudo or adjust directory permissions

#### Directory Not Found
```
Error: Log directory does not exist: /path/to/logs
```
**Solution**: Verify the directory path exists

#### Empty Directory
```
Error: Log directory is empty: /path/to/logs
```
**Solution**: Ensure the directory contains files to archive

#### Archive Creation Failed
```
Error: Failed to create archive from /var/log
```
**Solutions**:
- Check available disk space
- Verify write permissions to archive directory
- Ensure tar command is available

### Debug Information

For troubleshooting, run with verbose mode:
```bash
./log_archive /var/log --verbose
```

Check the log file for detailed operation history:
```bash
cat $HOME/log-archives/archive.log
```

## 🔄 Automation

### Cron Job Setup

Archive logs automatically with cron:

```bash
# Edit crontab
crontab -e

# Daily archive at 2 AM
0 2 * * * /usr/local/bin/log_archive /var/log >/dev/null 2>&1

# Weekly archive every Sunday at 3 AM
0 3 * * 0 /usr/local/bin/log_archive /var/log
```

### Systemd Timer (Alternative)

Create a systemd service and timer for more advanced scheduling.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Development Guidelines

- Follow existing code style
- Add error handling for new features
- Include examples in documentation
- Test with various directory types and sizes


**Version**: 1.0.0    
**Compatibility**: Unix-based systems (Linux, macOS, BSD)
# Logs_Archive
