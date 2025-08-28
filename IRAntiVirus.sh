#!/bin/bash

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Display banner
clear
echo -e "${RED}"
cat << "EOF"
███╗   ███╗██████╗ ███████╗██╗     ███████╗███╗   ███╗ ██████╗ ███╗   ██╗██╗██████╗ 
████╗ ████║██╔══██╗██╔════╝██║     ██╔════╝████╗ ████║██╔═══██╗████╗  ██║██║██╔══██╗
██╔████╔██║██████╔╝█████╗  ██║     █████╗  ██╔████╔██║██║   ██║██╔██╗ ██║██║██████╔╝
██║╚██╔╝██║██╔══██╗██╔══╝  ██║     ██╔══╝  ██║╚██╔╝██║██║   ██║██║╚██╗██║██║██╔══██╗
██║ ╚═╝ ██║██║  ██║███████╗███████╗███████╗██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║██║  ██║
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
EOF
echo -e "${NC}"
echo -e "${YELLOW}                    Created By MrLeMoNIR${NC}"
echo -e "${YELLOW}                    Rubika : @PluginLemon${NC}"
echo -e "${CYAN}"
echo "══════════════════════════════════════════════════════════════════════════════"
echo "              Professional Android Antivirus - No Root Required"
echo "══════════════════════════════════════════════════════════════════════════════"
echo -e "${NC}"
sleep 2

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}[*] Checking dependencies...${NC}"
    
    # List of required packages
    packages=("python" "curl" "wget" "git" "jq")
    
    for pkg in "${packages[@]}"; do
        if ! command -v $pkg &> /dev/null; then
            echo -e "${RED}[!] $pkg not found. Installing...${NC}"
            pkg install $pkg -y
        fi
    done
    
    # Install Python libraries
    if ! python -c "import requests" 2>/dev/null; then
        echo -e "${RED}[!] Installing Python libraries...${NC}"
        pip install requests beautifulsoup4 lxml pandas numpy
    fi
    
    echo -e "${GREEN}[+] All dependencies installed successfully${NC}"
}

# Function to scan for malicious files
scan_malicious_files() {
    echo -e "${YELLOW}[*] Scanning for malicious files...${NC}"
    
    # Important paths to scan
    scan_paths=(
        "/sdcard/Download"
        "/sdcard/Android/data"
        "/sdcard/Android/media"
        "/sdcard/DCIM"
        "/data/data/com.termux/files/home"
        "/storage/emulated/0"
    )
    
    # Malicious file patterns
    malware_patterns=(
        "*.apk"
        "*.exe"
        "*.bat"
        "*.cmd"
        "*.vbs"
        "*.scr"
        "*.com"
        "*.pif"
        "*.application"
        "*.gadget"
        "*.msi"
        "*.msp"
        "*.com"
        "*.scr"
        "*.hta"
        "*.cpl"
        "*.msc"
        "*.jar"
        "*.class"
        "*.sh"
        "*.py"
    )
    
    malicious_count=0
    echo -e "${BLUE}[+] Starting deep scan...${NC}"
    
    for path in "${scan_paths[@]}"; do
        if [ -d "$path" ]; then
            echo -e "${CYAN}[→] Scanning: $path${NC}"
            
            for pattern in "${malware_patterns[@]}"; do
                find "$path" -name "$pattern" -type f 2>/dev/null | while read file; do
                    if is_file_malicious "$file"; then
                        echo -e "${RED}[⚠] MALWARE DETECTED:${NC}"
                        echo -e "${RED}    File: $file${NC}"
                        echo -e "${RED}    Size: $(du -h "$file" | cut -f1)${NC}"
                        echo -e "${RED}    Type: $(file "$file" | cut -d: -f2-)${NC}"
                        echo -e "${RED}    Timestamp: $(stat -c %y "$file" 2>/dev/null)${NC}"
                        echo -e "${RED}    ──────────────────────────────────────────────────${NC}"
                        malicious_count=$((malicious_count + 1))
                    fi
                done
            done
        fi
    done
    
    if [ $malicious_count -eq 0 ]; then
        echo -e "${GREEN}[✓] No malicious files found${NC}"
    else
        echo -e "${RED}[!] TOTAL MALICIOUS FILES FOUND: $malicious_count${NC}"
    fi
}

# Function to check if file is malicious
is_file_malicious() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Malicious keywords and patterns
    malicious_keywords=(
        "hack"
        "crack"
        "virus"
        "trojan"
        "malware"
        "spyware"
        "keylogger"
        "rat"
        "remote"
        "exploit"
        "payload"
        "backdoor"
        "rootkit"
        "worm"
        "adware"
        "ransomware"
        "stealer"
        "injector"
        "botnet"
        "ddos"
    )
    
    # Suspicious file names
    suspicious_names=(
        "update"
        "install"
        "setup"
        "patch"
        "crack"
        "keygen"
        "serial"
        "loader"
        "activator"
        "patch"
        "hack"
        "mod"
        "premium"
        "unlocker"
    )
    
    # Check filename
    filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    for keyword in "${malicious_keywords[@]}"; do
        if echo "$filename_lower" | grep -q "$keyword"; then
            return 0
        fi
    done
    
    for name in "${suspicious_names[@]}"; do
        if echo "$filename_lower" | grep -q "$name"; then
            return 0
        fi
    done
    
    # Check file content (for text files)
    if file "$file" | grep -q "text"; then
        for keyword in "${malicious_keywords[@]}"; do
            if grep -qi "$keyword" "$file" 2>/dev/null; then
                return 0
            fi
        done
    fi
    
    return 1
}

# Function to scan installed applications
scan_installed_apps() {
    echo -e "${YELLOW}[*] Scanning installed applications...${NC}"
    
    # Get installed apps
    apps=$(pm list packages -f 2>/dev/null)
    
    if [ -z "$apps" ]; then
        echo -e "${RED}[!] Cannot access package manager${NC}"
        return
    fi
    
    suspicious_count=0
    
    echo "$apps" | while read line; do
        if echo "$line" | grep -q "package:"; then
            package_path=$(echo "$line" | cut -d: -f2- | cut -d= -f1)
            package_name=$(echo "$line" | cut -d= -f2)
            
            if is_package_suspicious "$package_name"; then
                echo -e "${RED}[⚠] SUSPICIOUS APP:${NC}"
                echo -e "${RED}    Package: $package_name${NC}"
                echo -e "${RED}    Path: $package_path${NC}"
                echo -e "${RED}    ──────────────────────────────────────────────────${NC}"
                suspicious_count=$((suspicious_count + 1))
            fi
        fi
    done
    
    if [ $suspicious_count -eq 0 ]; then
        echo -e "${GREEN}[✓] No suspicious applications found${NC}"
    else
        echo -e "${RED}[!] TOTAL SUSPICIOUS APPS: $suspicious_count${NC}"
    fi
}

# Function to check suspicious packages
is_package_suspicious() {
    local package_name="$1"
    
    # Suspicious package patterns
    suspicious_packages=(
        "com.unknown."
        "com.hack."
        "com.crack."
        "com.virus."
        "com.malware."
        "com.spy."
        "com.trojan."
        "com.keylogger."
        "com.rat."
        "com.exploit."
        "com.remote."
        "com.backdoor."
        "com.rootkit."
        "com.worm."
        "com.adware."
        "com.ransomware."
        "com.stealer."
        "com.injector."
        "com.botnet."
        "com.ddos."
    )
    
    package_lower=$(echo "$package_name" | tr '[:upper:]' '[:lower:]')
    for suspicious in "${suspicious_packages[@]}"; do
        if echo "$package_lower" | grep -q "$suspicious"; then
            return 0
        fi
    done
    
    return 1
}

# Function to check system health
check_system_health() {
    echo -e "${YELLOW}[*] Checking system health...${NC}"
    
    # Storage space
    storage=$(df /data 2>/dev/null | awk 'NR==2{print $5}' | cut -d'%' -f1)
    if [ -n "$storage" ]; then
        if [ $storage -gt 90 ]; then
            echo -e "${RED}[!] WARNING: Storage space critical ($storage% used)${NC}"
        elif [ $storage -gt 80 ]; then
            echo -e "${YELLOW}[!] Warning: Storage space low ($storage% used)${NC}"
        else
            echo -e "${GREEN}[✓] Storage space: $storage% used${NC}"
        fi
    fi
    
    # RAM usage
    ram_total=$(free | awk '/Mem/{print $2}')
    ram_used=$(free | awk '/Mem/{print $3}')
    if [ -n "$ram_total" ] && [ $ram_total -gt 0 ]; then
        ram_percent=$((ram_used * 100 / ram_total))
        if [ $ram_percent -gt 90 ]; then
            echo -e "${RED}[!] WARNING: High RAM usage ($ram_percent%)${NC}"
        elif [ $ram_percent -gt 80 ]; then
            echo -e "${YELLOW}[!] Warning: RAM usage high ($ram_percent%)${NC}"
        else
            echo -e "${GREEN}[✓] RAM usage: $ram_percent%${NC}"
        fi
    fi
    
    # Battery health
    if [ -f "/sys/class/power_supply/battery/capacity" ]; then
        battery=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null)
        if [ -n "$battery" ]; then
            echo -e "${BLUE}[+] Battery level: $battery%${NC}"
        fi
    fi
    
    # Device temperature
    temp_files=(
        "/sys/class/thermal/thermal_zone0/temp"
        "/sys/class/thermal/thermal_zone1/temp"
        "/sys/devices/virtual/thermal/thermal_zone0/temp"
    )
    
    for temp_file in "${temp_files[@]}"; do
        if [ -f "$temp_file" ]; then
            temp=$(cat "$temp_file")
            if [ -n "$temp" ]; then
                temp_c=$((temp/1000))
                if [ $temp_c -gt 70 ]; then
                    echo -e "${RED}[!] CRITICAL: High device temperature ($temp_c°C)${NC}"
                elif [ $temp_c -gt 60 ]; then
                    echo -e "${YELLOW}[!] Warning: Device temperature high ($temp_c°C)${NC}"
                else
                    echo -e "${GREEN}[✓] Device temperature: $temp_c°C${NC}"
                fi
                break
            fi
        fi
    done
}

# Function to scan network connections
scan_network() {
    echo -e "${YELLOW}[*] Scanning network connections...${NC}"
    
    # Check active connections
    echo -e "${BLUE}[+] Active network connections:${NC}"
    netstat -tunp 2>/dev/null | head -15 | awk '{printf "%-20s %-20s %-15s %-15s\n", $1, $4, $5, $6}'
    
    # Check public IP
    public_ip=$(curl -s --connect-timeout 5 https://api.ipify.org)
    if [ -n "$public_ip" ]; then
        echo -e "${BLUE}[+] Public IP: $public_ip${NC}"
        
        # Get IP information
        ip_info=$(curl -s "http://ip-api.com/json/$public_ip")
        if [ -n "$ip_info" ]; then
            country=$(echo "$ip_info" | jq -r '.country // "Unknown"')
            city=$(echo "$ip_info" | jq -r '.city // "Unknown"')
            isp=$(echo "$ip_info" | jq -r '.isp // "Unknown"')
            echo -e "${BLUE}[+] Location: $city, $country${NC}"
            echo -e "${BLUE}[+] ISP: $isp${NC}"
        fi
    fi
}

# Function to generate comprehensive report
generate_comprehensive_report() {
    echo -e "${CYAN}"
    echo "══════════════════════════════════════════════════════════════════════════════"
    echo "                 COMPREHENSIVE SECURITY SCAN REPORT"
    echo "══════════════════════════════════════════════════════════════════════════════"
    echo -e "${NC}"
    
    echo -e "${WHITE}Scan Date: $(date)${NC}"
    echo -e "${WHITE}Device: $(getprop ro.product.model 2>/dev/null || echo "Unknown")${NC}"
    echo -e "${WHITE}Android Version: $(getprop ro.build.version.release 2>/dev/null || echo "Unknown")${NC}"
    echo ""
    
    # Run all scans
    check_system_health
    echo ""
    scan_network
    echo ""
    scan_installed_apps
    echo ""
    scan_malicious_files
    echo ""
    
    echo -e "${GREEN}[✓] Comprehensive scan completed successfully${NC}"
}

# Main menu function
main_menu() {
    while true; do
        echo -e "${CYAN}"
        echo "══════════════════════════════════════════════════════════════════════════════"
        echo "                   MRLeMoNIR ANDROID ANTIVIRUS - MAIN MENU"
        echo "══════════════════════════════════════════════════════════════════════════════"
        echo -e "${NC}"
        
        echo -e "${WHITE}1. Run Complete Security Scan${NC}"
        echo -e "${WHITE}2. Scan for Malicious Files${NC}"
        echo -e "${WHITE}3. Scan Installed Applications${NC}"
        echo -e "${WHITE}4. Check System Health${NC}"
        echo -e "${WHITE}5. Scan Network Connections${NC}"
        echo -e "${WHITE}6. Update Antivirus${NC}"
        echo -e "${WHITE}7. Exit${NC}"
        
        echo -e "${CYAN}══════════════════════════════════════════════════════════════════════════════${NC}"
        
        read -p $'\e[36m[?] Select option (1-7): \e[0m' choice
        
        case $choice in
            1)
                generate_comprehensive_report
                ;;
            2)
                scan_malicious_files
                ;;
            3)
                scan_installed_apps
                ;;
            4)
                check_system_health
                ;;
            5)
                scan_network
                ;;
            6)
                echo -e "${YELLOW}[*] Updating antivirus...${NC}"
                curl -O https://raw.githubusercontent.com/MrLeMoNIR/android-antivirus/main/antivirus.sh
                chmod +x antivirus.sh
                echo -e "${GREEN}[✓] Update completed${NC}"
                ;;
            7)
                echo -e "${GREEN}[✓] Exiting MRLeMoNIR Antivirus...${NC}"
                echo -e "${YELLOW}Thank you for using our security solution!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Invalid option!${NC}"
                ;;
        esac
        
        echo ""
        read -p $'\e[36m[?] Press Enter to continue... \e[0m'
        clear
        
        # Show banner again
        echo -e "${RED}"
        cat << "EOF"
███╗   ███╗██████╗ ███████╗██╗     ███████╗███╗   ███╗ ██████╗ ███╗   ██╗██╗██████╗ 
████╗ ████║██╔══██╗██╔════╝██║     ██╔════╝████╗ ████║██╔═══██╗████╗  ██║██║██╔══██╗
██╔████╔██║██████╔╝█████╗  ██║     █████╗  ██╔████╔██║██║   ██║██╔██╗ ██║██║██████╔╝
██║╚██╔╝██║██╔══██╗██╔══╝  ██║     ██╔══╝  ██║╚██╔╝██║██║   ██║██║╚██╗██║██║██╔══██╗
██║ ╚═╝ ██║██║  ██║███████╗███████╗███████╗██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║██║  ██║
╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
EOF
        echo -e "${NC}"
        echo -e "${YELLOW}                    Created By MrLeMoNIR${NC}"
        echo -e "${YELLOW}                    Rubika : @PluginLemon${NC}"
    done
}

# Start the application
install_dependencies
main_menu