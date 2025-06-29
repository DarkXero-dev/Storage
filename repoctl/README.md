### Install Repoctl

yay -S [repoctl](https://github.com/cassava/repoctl)

### Set up Repo :  

- Create new config : `repoctl conf new path/to/repo`
- Initialize reo : `repoctl reset -P xerolinux`
- Update repo : `repoctl update -P xerolinux`

#### Example config.toml

```toml
columnate = false
color = "auto"
quiet = false
default_profile = "xerolinux"

[profiles.xerolinux]
  repo = "/home/techxero/Work/Repos/xerolinux/x86_64/xerolinux.db.tar.zst"
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

### Add Alias :

in either `.bashrc` or `.zshrc` add the following alias

```Bash
alias rrepo='repoctl reset -P xerolinux'
alias urepo='repoctl update -P xerolinux && rm ~/Work/Repos/xerolinux/x86_64/*.old'
```
