# os-as-ide
Operation System as my Integrated Development Environment

## Installation of Dev Tools
### To get Started
```sh
sudo dnf update -y
sudo reboot
sudo dnf install -y ansible
ansible --version
```
Then install the essentials: zsh, oh-my-zsh, their plugins:
```sh
ansible-playbook -K install-essentials.yaml
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
