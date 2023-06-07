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

## Vimium browser plugin
https://github.com/philc/vimium/wiki

My setup:
```
map <c-o> goBack
map <c-i> goForward
unmap b
unmap B
unmap <c-B>
unmap <c-b>
unmap <c-p>
```

TODO:
- Bind LSP keycombinations like refactoring 
- use :GcLog -S text for looking for something in log
- possible comment out plugin
