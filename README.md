# Malicious PowerShell Script Dataset

## Description

This repository contains a collection of malicious PowerShell scripts used for research paper in "Detection of malicious PowerShell scripts using deep learning". The dataset consists of samples obtained from various sources, including GitHub repositories and online sandbox services. The dataset includes both original samples and obfuscated versions to ensure diversity and real-world similarity.

## Dataset Collection

### GitHub Repositories

The dataset includes PowerShell samples obtained from offensive security repositories on GitHub. The following repositories were used:

- [ADMap](https://github.com/tmenochet/ADMap)
- [BloodHound](https://github.com/BloodHoundAD/BloodHound)
- [Empire](https://github.com/EmpireProject/Empire)
- [Invoke-Apex](https://github.com/password-reset/Invoke-Apex)
- [invoke-atomicredteam](https://github.com/redcanaryco/invoke-atomicredteam)
- [Invoke-Bof](https://github.com/airbus-cert/Invoke-Bof)
- [mimikittenz](https://github.com/orlyjamie/mimikittenz)
- [Minimalistic-offensive-security-tools](https://github.com/InfosecMatter/Minimalistic-offensive-security-tools)
- [nishang](https://github.com/samratashok/nishang)
- [OffensiveDLR](https://github.com/byt3bl33d3r/OffensiveDLR)
- [offensive-powershell](https://github.com/staaldraad/offensive-powershell)
- [OffensivePowershell](https://github.com/BjornNordblom/OffensivePowershell)
- [offensive-security-utilities](https://github.com/minkione/offensive-security-utilities)
- [Offensive-Snippets](https://github.com/0xAbdullah/Offensive-Snippets)
- [OFFSEC-PowerShell](https://github.com/IAMinZoho/OFFSEC-PowerShell)
- [PersistenceSniper](https://github.com/last-byte/PersistenceSniper)
- [PoshC2](https://github.com/nettitude/PoshC2/)
- [PowerAvails](https://github.com/homjxi0e/PowerAvails)
- [PowerExec](https://github.com/tmenochet/PowerExec)
- [PowerSharpPack](https://github.com/S3cur3Th1sSh1t/PowerSharpPack/)
- [PowerShell-Red-Team](https://github.com/tobor88/PowerShell-Red-Team)
- [PowerSploit](https://github.com/PowerShellMafia/PowerSploit/)
- [PowerSpray](https://github.com/tmenochet/PowerSpray)
- [PowerTools](https://github.com/PowerShellEmpire/PowerTools/)
- [RandomPS-Scripts](https://github.com/xorrior/RandomPS-Scripts)
- [redronin](https://github.com/salvemorte/redronin)
- [stub-Repositores](https://github.com/INotGreen/stub-Repositores)

### Public Dataset

We also included samples from the public dataset created by Fang Yong, Zhou Xiangyu, Huang Cheng available at [MPSD](https://github.com/das-lab/mpsd).

### Online Sandbox Services

We collected samples from online sandbox services to cover a wider range of malicious scripts. The sources include:

- **Triage**: We scraped the website with specific filters to obtain relevant PowerShell samples related to trojans and known families such as Metasploit and CobaltStrike.
- **Hybrid Analysis**: We also scraped the website using filters to obtain PowerShell samples with a malicious verdict.
- **Malware Bazaar**: We used the Bazaar API to query and download samples with the PS1 file type.

### Dataset Assembly

All samples were hashed and assembled in the `malicious_samples` directory in the format `{sha256}.ps1` to avoid duplicates. To enhance real-world similarity, we obfuscated approximately 25% of the samples using tools such as Chameleon and Invoke-Obfuscation.

## Content Description

- `bazaar_out`: This directory contains PowerShell script samples downloaded from Malware Bazaar (bazaar.abuse.ch) using the script download_mb_samples.py. The samples were obtained from the Bazaar API by querying for PS1 filetype files.
- `dataset-obfuscator.py`: This script was used to perform obfuscation on a portion of the original PowerShell script samples. It utilizes the Chameleon tool to obfuscate the samples and create a new set of obfuscated PowerShell scripts.
- `download_mb_samples.py`: This script is responsible for downloading PowerShell script samples from Malware Bazaar. It uses the Bazaar API to query for PS1 filetype files and then downloads them to the local directory.
- `download_triage.py`: This script was used to download PowerShell script samples from Triage website. It utilizes the website's filters to scrape samples with specific tags and families related to trojans, metasploit, and cobaltstrike.
- `hybrid_analysis_data.json`: This file contains the data collected from Hybrid Analysis website using the script scrape_hybrid_analysis_ui.py. It includes information about the downloaded samples such as their sample IDs, hashes, submission times, filenames, kinds, and tags.
- `hybrid_analysis_out`: This directory contains PowerShell script samples downloaded from Hybrid Analysis website using the script scrape_hybrid_analysis_ui.py. The samples were obtained with the filter "filetype:ps and verdict: malicious" and saved to this directory.
  PS: Unfortunately during the collection there was an issue with the website that limited me to only get 200 samples. I have reported it to them and they responded that they would take a look at it, last time i checked (6th August 2023) it hasn't been fixed yet.
- `Invoke-ObfuscateRandomFiles.ps1`: This PowerShell script was used to obfuscate 5% of the original PowerShell script samples using the Invoke-Obfuscation tool. The obfuscated samples are suffixed with the term "obf-out-{technique of obfuscation}".
- `malicious_samples`: This directory contains the PowerShell script samples collected from various sources, such as GitHub repositories and online sandbox services. Each script is named with its corresponding SHA-256 hash for uniqueness.
- `scrape_hybrid_analysis_ui.py`: This script was used to scrape PowerShell script samples from Hybrid Analysis website. It utilizes the website's UI with the filter "filetype:ps and verdict: malicious" to collect the samples.
- `scrape_triage.py`: This script was used to scrape PowerShell script samples from Triage website. It uses the website's filters to scrape samples with specific tags and families related to trojans, metasploit, and cobaltstrike.
- `triage_data.json`: This file contains the data collected from Triage website using the script scrape_triage.py. It includes information about the downloaded samples such as their sample IDs, hashes, submission times, filenames, kinds, and tags.
- `triage_out`: This directory contains PowerShell script samples downloaded from Triage website using the script scrape_triage.py. The samples were obtained by scraping the website with specific filters and saved to this directory.

## Contributors

- [![](https://images.weserv.nl/?url=avatars.githubusercontent.com/u/37297471?v=4&h=50&w=50&fit=cover&mask=circle&maxage=7d)](https://github.com/Fa2y) Ahmed Yasser Merzouk Benselloua.
- [![](https://images.weserv.nl/?url=avatars.githubusercontent.com/u/59362802?v=4&h=50&w=50&fit=cover&mask=circle&maxage=7d)](https://github.com/MessadiSaidAbdesslem) Messadi Said Abdesslem.

## Acknowledgements

We would like to thank all contributors to the repositories and online sandbox services, without whom this research would not have been possible.

Please note that this dataset is intended for research purposes only and should be used responsibly and ethically.

## Citation

If you use this dataset in your research, please consider citing our work.

`TODO`

For more details about the research and how the dataset was collected, please refer to our thesis and accompanying code repository.

For questions or inquiries, please contact [a.merzoukbenselloua@esi-sba.dz](mailto:a.merzoukbenselloua@esi-sba.dz).
