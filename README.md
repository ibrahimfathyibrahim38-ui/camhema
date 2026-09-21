<div align="center">

# 📸 Hema Cam

<img src="https://github.com/daxxtropezz/CamHacker/raw/main/files/banner.png" alt="Hema Cam Banner" width="600">

### 🎯 Advanced Camera Phishing Tool for Security Research

</div>

---

<p align="center">
  <img src="https://img.shields.io/badge/Version-2.3-2E8B57?style=for-the-badge&logo=semantic-release" alt="Version">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/👨‍💻_Author-daxxtropezz-FF6B6B?style=flat-square&logo=github" alt="Author">
  <img src="https://img.shields.io/badge/📖_Open_Source-Yes-4ECDC4?style=flat-square" alt="Open Source">
  <img src="https://img.shields.io/badge/🔧_Maintained-Yes-45B7D1?style=flat-square" alt="Maintained">
  <img src="https://img.shields.io/badge/⚡_Shell-Bash-FFA07A?style=flat-square&logo=gnu-bash" alt="Shell">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20Termux%20%7C%20Docker-lightgrey?style=flat-square" alt="Platform">
</p>

---

## 📋 Table of Contents

- [📖 Description](#-description)
- [📢 Important Announcement](#-important-announcement)
- [🚀 Quick Start](#-quick-start)
- [🐳 Docker Installation](#-docker-installation)
- [💻 Usage](#-usage)
- [✨ Features](#-features)
- [🔗 Related Tools](#-related-tools)
- [📱 Preview](#-preview)
- [⚙️ Dependencies](#️-dependencies)
- [📝 Important Notes](#-important-notes)
- [🙏 Credits](#-credits)
- [⚠️ Disclaimer](#️-disclaimer)
- [📬 Contact](#-contact)

---

## 📖 Description

**Hema Cam** is a sophisticated phishing tool designed for security research and educational purposes. It generates malicious links that, when accessed, can capture photos through the victim's camera upon permission grant.

> ⚠️ **Educational Use Only** - This tool is intended for cybersecurity education and authorized penetration testing only.

---

## 📢 Important Announcement

> 🔄 **Project Status**: This project is now integrated into [**MaxPhisher**](https://github.com/daxxtropezz/MaxPhisher)
>
> All future updates, bug fixes, and new features will be available in the MaxPhisher repository.

---

## 🚀 Quick Start

### 📥 Installation

```bash
# Clone the repository
git clone https://github.com/daxxtropezz/CamHacker
cd CamHacker

# For Termux users (additional step required)
termux-setup-storage

# Run the tool
bash hema.sh
```

> 📌 **Note**: The local build is branded **Hema Cam** — the main script is `hema.sh`.
> The `ch.sh` file (used by the original upstream repository) does not exist in this build.

### ⚡ One-Line Installation

```bash
wget https://raw.githubusercontent.com/daxxtropezz/CamHacker/main/ch.sh && bash ch.sh
```

---

## 🐳 Docker Installation

```bash
# Pull the Docker image
sudo docker pull daxxtropezz/camhacker

# Run the container
sudo docker run --rm -it --name camhacker daxxtropezz/camhacker

# Copy captured images (run in another terminal)
sudo docker cp camhacker:/CamHacker imgfiles
```

---

## 💻 Usage

```bash
Usage: bash hema.sh [OPTIONS]

Options:
  -h, --help                           📋 Show help message and exit
  -o, --option OPTION                  🎨 Select template index
  -p, --port PORT                      🌐 Set server port (Default: 8080)
  -t, --tunneler TUNNELER              🔗 Choose tunneler (Default: cloudflared)
  -d, --directory DIRECTORY            📁 Set image save directory
  -u, --update                         ⬆️  Check for updates (Default: true)
  -nu, --no-update                     ⏹️  Skip update check
```

### 📚 Examples

```bash
# Use specific template and port
bash hema.sh -o 2 -p 9090

# Set custom directory and tunneler
bash hema.sh -d /custom/path -t loclx

# Skip updates
bash hema.sh --no-update
```

---

## ✨ Features

<div align="center">

|  🎨 **Templates**  | 🌍 **Information Gathering** |  🔗 **Networking**  |    🛠️ **Tools**    |
| :----------------: | :--------------------------: | :-----------------: | :----------------: |
| 3 Modern Templates |          IP Address          |   Dual Tunneling    |  Error Diagnosis   |
| Responsive Design  |         Geolocation          | Cloudflared & Loclx |  Argument Support  |
|  Mobile Optimized  |      Device Information      |   URL Shortening    | Custom Directories |
| Browser Compatible |          User Agent          | Port Configuration  |   Update Checker   |

</div>

### 🔥 Key Highlights

- ✅ **Three Professional Templates** - Choose from multiple designs
- 🌐 **Complete Target Profiling** - IP, location, device, and browser info
- 🔄 **Concurrent Dual Tunneling** - Cloudflared and Loclx support
- 📁 **Custom Save Locations** - Choose where to store captured images
- 🔍 **Advanced Error Diagnosis** - Built-in troubleshooting
- ⚡ **Full CLI Support** - Complete argument-based operation

---

## 🔗 Related Tools

Explore more security research tools by the same author:

<div align="center">

|       Tool        |            Description            |                             Link                             |
| :---------------: | :-------------------------------: | :----------------------------------------------------------: |
| 🎣 **PyPhisher**  | Advanced login phishing framework | [View Repository](https://github.com/daxxtropezz/PyPhisher)  |
| 🎬 **VidPhisher** |  Video-based phishing campaigns   | [View Repository](https://github.com/daxxtropezz/VidPhisher) |
| 🎯 **MaxPhisher** |     Complete phishing toolkit     | [View Repository](https://github.com/daxxtropezz/MaxPhisher) |

</div>

---

## 📱 Preview

<div align="center">
<img src="https://github.com/daxxtropezz/CamHacker/raw/main/files/ch.gif" alt="Hema Cam Demo" width="800">
</div>

---

## ⚙️ Dependencies

All dependencies are automatically installed on first run:

- 🐘 **PHP** - Server-side scripting
- 🌐 **cURL** - Data transfer tool
- ⬇️ **wget** - File retrieval utility
- 📦 **unzip** - Archive extraction

---

## 📝 Important Notes

> 🌐 **Browser Compatibility**: Use full-featured browsers (Chrome, Firefox, Brave, Safari)
>
> ⚠️ **Mini Browsers**: Opera Mini and similar lightweight browsers may not work properly
>
> 🛡️ **Security**: Some modern browsers may block camera access - this is normal behavior

---

## 🙏 Credits

Special thanks to the open-source community:

- 1️⃣ [**KasRoudra**](https://github.com/KasRoudra) - Various contributions
- 🎖️ [**Noob-Hackers**](https://github.com/noob-hackers/grabcam) - Grabcam project
- 💻 [**Technochip**](https://github.com/Techchipnet/camphish) - Camphish inspiration
- 🐧 [**Linux Choice**](https://github.com/TheLinuxChoice) - Various contributions

---

## ⚠️ Disclaimer

<div align="center">

### 🎓 Educational Purpose Only

</div>

> **This tool is developed exclusively for educational and authorized security testing purposes.**
>
> 📚 It demonstrates camera phishing techniques for cybersecurity awareness
>
> ⚖️ **Legal Responsibility**: Users are solely responsible for any misuse
>
> 🚫 **Unauthorized Use**: The author disclaims responsibility for any illegal activities
>
> ✅ **Ethical Use**: Only use with explicit permission and in controlled environments

---

## 📬 Contact

<div align="center">

### 🤝 Connect with the Developer

[![GitHub](https://img.shields.io/badge/GitHub-daxxtropezz-181717?style=for-the-badge&logo=github)](https://github.com/daxxtropezz)
[![Email](https://img.shields.io/badge/Email-miraflores.john@gmail.com-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:miraflores.john@gmail.com)
[![Facebook](https://img.shields.io/badge/Facebook-daxxtropezz-1877F2?style=for-the-badge&logo=facebook&logoColor=white)](https://facebook.com/daxxtropezz)
[![Messenger](https://img.shields.io/badge/Messenger-daxxtropezz-0078FF?style=for-the-badge&logo=messenger&logoColor=white)](https://m.me/daxxtropezz)

</div>

---

<div align="center">

### ⭐ Star this repository if you found it helpful!

**Made with ❤️ for the cybersecurity community**

</div>
