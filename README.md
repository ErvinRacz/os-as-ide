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
- https://sookocheff.com/post/vim/neovim-java-ide/
- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/guides/setup-with-nvim-jdtls.md
