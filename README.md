# ISSP - Vulnerable Active Directory Testing Lab

ISSP is an intentionally vulnerable Active Directory testing lab. It is designed for myself or others to explore and practice AD exploitation techniques in a controlled environment.

## What I use
- [VirtualBox](https://www.virtualbox.org/)
- [Ansible](https://www.ansible.com/)
- [Packer](https://developer.hashicorp.com/packer)
- [Windows Server 2025](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2025)
- [Windows 10 Enterprise](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise)
- [Kali Linux](https://www.kali.org/)

## Vulnerabilities
inspired by [this script](https://github.com/safebuffer/vulnerable-AD)
- Weak Password Policy
- Kerberoasting
- AS-REP Roasting
- SMB Signing disabled
- Privilege Escalation (DNS Admins)

## How to run
```bash
plugin install github.com/hashicorp/virtualbox
cd packer/[jet-dc and spike-clt and ed-atk]
packer build -force .
cd ../ansible
ansible [dc or client] -i inventory.ini -m win_ping
ansible-playbook -i inventory.ini issp.yml
```

## Other resources that helped me
- [Create the answer file for Windows Server](https://github.com/chef/bento/blob/main/packer_templates/win_answer_files/2025/Autounattend.xml)
- [Similar project](https://github.com/dteslya/win-iac-lab)
- [Packer Docs for VirtualBox](https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox/latest/components/builder/iso)
- [Ansible modules for Active Directory](https://galaxy.ansible.com/ui/repo/published/microsoft/ad/docs/?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW)
