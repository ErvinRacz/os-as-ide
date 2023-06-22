# os-as-ide
Operation System as my Integrated Development Environment

## Installation of Dev Tools
### To get started on Fedora
```sh
sudo dnf update -y
sudo reboot
sudo dnf install -y ansible
ansible --version
```
### On MacOS
Install Homebrew: https://brew.sh/
```sh
brew install ansible
ansible --version
```

Then install the essentials: zsh, oh-my-zsh, their plugins:
```sh
ansible-playbook -K install-essentials.yaml
```

Stow .dotfiles
```shell
sudo rm -rf ~/.zshrc
stow -d "{{ playbook_dir }}"/.dotfiles/target-home/ -t ~/ .
stow -d "{{ playbook_dir }}"/.dotfiles/alacritty-fedora/ -t ~/.config .
-- OR if you are on MAC
stow -d "{{ playbook_dir }}"/.dotfiles/alacritty-mac/ -t ~/.config .
```
## MacOs Alt-Tab plugin
https://alt-tab-macos.netlify.app/

## Vimium browser plugin
https://github.com/philc/vimium/wiki

My setup:
```
# In case of Mac
# map <c-t> createTab
# map <c-w> removeTab

map <c-o> goBack
map <c-i> goForward
unmap b
unmap B
unmap <c-B>
unmap <c-b>
unmap <c-p>
```

## ASDF package manager

### Java
```shell
asdf plugin-add java
asdf list-all java
asdf install java zulu-17.42.x
asdf global java zulu-17.42.x
. ~/.asdf/plugins/java/set-java-home.zsh
```

Made Neovim useful for Java based on the following guides:
- https://github.com/mfussenegger/nvim-jdtls
- https://sookocheff.com/post/vim/neovim-java-ide/
- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/guides/setup-with-nvim-jdtls.md

### NodeJs

```shell
asdf plugin-add nodejs
asdf list-all nodejs
asdf install nodejs 18.x.y
asdf global nodejs 18.x.y
```

TODO:
- Bind LSP keycombinations like refactoring 
- use :GcLog -S text for looking for something in log
- Make the fzf work on Ctrl+f that is normally assigned to Ctrl+t by default
- use grammarely
- make 'C' work in java files
- inspiration: https://github.com/soofaloofa/dotfiles/blob/master/.config/nvim/lua/plugins/init.lua
- make dap use telescope

## Troubleshooting
### Debug LSP
- Check the log files. Use :LspLoga or :JdtShowLogs or open the log file manually. :lua print(vim.fn.stdpath('cache')) lists the path, there should be a lsp.log. You may have to increase the log level. See :help vim.lsp.set_log_level().
- Remove Java Project Cache with :JdtWipeDataAndRestart
