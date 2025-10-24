# Crowdsec public VPS blacklist
This is a shell script which will download daily actualized list of IP adresses for favorite Virtual Private Server (VPS) providers:
- AWS
- Azure
- CloudFlare
- DigitalOcean
- Fastly
- Google Cloud
- Linode
- Oracle Cloud

and convert this list to CrowdSec blacklist of IP ranges to defend against attack on your NAS or home lab. 
Every connection from VPS providers is blocked on your firewall.

## CRON
Script is configured to block IPs for 24h and to be run by CRON daily. Example is run under root everyday at 4:30

`30 4 * * *  /usr/local/bin/crowdsec-cloud-blacklist.sh >> /var/log/crowdsec-cloud-blacklist.log 2>&1`

## Thanks
List is based on GitHub project [tobilg/public-cloud-provider-ip-ranges](https://github.com/tobilg/public-cloud-provider-ip-ranges?tab=readme-ov-file)

Firewall rules are aplied by program [CrowdSec](https://www.crowdsec.net/blog/crowdsec-waf-the-collaborative-future-of-web-application-security?gad_campaignid=22821348674). Must be configured to block on [firewall](https://docs.crowdsec.net/u/bouncers/firewall/) before use.

