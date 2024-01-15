yay -S [repoctl](https://github.com/cassava/repoctl)

Set up Repo :  

- Create new config : 
```
repoctl conf new /run/media/techxero/XeroROG/Repos/Github/xerolinux/x86_64/xerolinux.db.tar.zst
```
- Initialize reo : `repoctl reset -P xerolinux`
- Update repo : `repoctl update -P xerolinux`

#### Example config.toml
```
columnate = false
color = "auto"
quiet = false
default_profile = "xerolinux"

[profiles.xerolinux]
  repo = "/run/media/techxero/XeroROG/Repos/Github/xerolinux/x86_64/xerolinux.db.tar.zst"
  add_params = []
  rm_params = []
  ignore_aur = []
  require_signature = false
  backup = false
  backup_dir = ""
  interactive = false
  pre_action = ""
  post_action = ""
```
