# ISSP - Vulnerable Active Directory Testing Lab

ISSP is an intentionally vulnerable Active Directory testing lab. It is designed for myself or others to explore and practice AD exploitation techniques in a controlled environment.

## What I use
- [VirtualBox](https://www.virtualbox.org/)
- [Ansible](https://www.ansible.com/)
- [Windows Server 2022](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022)
- [Windows 10 Enterprise](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise)
- [Kali Linux](https://www.kali.org/)

## Vulnerabilities
- Weak Password Policy
- Kerberoasting
- AS-REP Roasting
- SMB Signing disabled
- Privilege Escalation (DNS Admins)

## Useful Ansible Commands
```bash
ansible [dc or client] -i inventory.yml -m win_ping
ansible-playbook -i inventory.yml issp.yml
```

## Basic WinRM Setup
```bash
winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="512"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth @{Basic="true"}
```
