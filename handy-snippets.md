## find and execute some commands for each entry
```bash
find /usr/share/nano/ -name "*.nanorc" -exec echo include {} \;
```