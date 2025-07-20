# Blocker-Core

## Windows Protection Script Documentation

This documentation describes how to use the `protect.bat` script to manage domain blocking and DNS settings on Windows systems.

### Prerequisites

-   Windows Operating System
-   Administrator privileges
-   Required files in the same directory as protect.bat:
    -   `domains.txt`: Contains the list of domains to block
    -   `youtube.txt`: Contains YouTube-specific domains (used when YouTube blocking is enabled)

### Usage

```batch
protect.bat [subcommand] [options]
```

#### Available Subcommands

1. **apply**: Apply protection with specified settings

    ```batch
    protect.bat apply [level] [youtube]
    ```

    - `level`: Either "high" or "low"
    - `youtube`: Either "true" or "false" to enable/disable YouTube safe mode

    Example:

    ```batch
    protect.bat apply high true
    ```

2. **deactivate**: Remove protection and reset DNS settings

    ```batch
    protect.bat deactivate
    ```

3. **add_domain**: Add a single domain to the hosts file

    ```batch
    protect.bat add_domain [IP] [domain]
    ```

    Example:

    ```batch
    protect.bat add_domain "216.239.38.120 www.google.com"
    ```

    To block a specific domain, run the `protect.bat` script with the `add_domain` subcommand and use `0.0.0.0` as the IP address for the domain you want to block. For example:

    ```batch
    protect.bat add_domain "0.0.0.0 example.com"
    ```

    This command will add an entry to the hosts file that blocks `example.com` on your system.

### What the Script Does

1. Checks for administrator privileges
2. Modifies the hosts file (`C:\Windows\System32\drivers\etc\hosts`)
3. Configures DNS settings for network adapters
4. Sets up DNS-over-HTTPS for Chrome and Brave browsers
5. If YouTube blocking is enabled, adds YouTube-specific domains

### File Dependencies

1. **domains.txt**

    - Must exist in the same directory as protect.bat
    - Must start with `#mafazaa-hosts-start`
    - Must end with `#mafazaa-hosts-end`
    - Each line should contain IP and domain(s)

2. **youtube.txt**
    - Must exist in the same directory as protect.bat
    - Must start with `#mafazaa-youtube-enable-start`
    - Must end with `#mafazaa-youtube-enable-end`
    - Contains YouTube-specific domain entries

### File Structure

#### domains.txt

Contains the main list of domains to block. Must follow this format:

```plaintext
#mafazaa-hosts-start
216.239.38.120 www.google.com
216.239.38.120 www.google.ad
...other domains...
20.207.72.188 duckduckgo.com
204.79.197.220 www.bing.com bing.com
#mafazaa-hosts-end
```

#### youtube.txt

Contains YouTube-specific domains. Must follow this format:

```plaintext
#mafazaa-youtube-enable-start
172.217.19.142 www.youtube.com
142.250.200.238 m.youtube.com
172.217.21.10 youtubei.googleapis.com
172.217.21.10 youtube.googleapis.com
142.250.201.46 www.youtube-nocookie.com
#mafazaa-youtube-enable-end
```
