# os-as-ide

Operation System as my Integrated Development Environment

## Installation of Dev Tools

Git clone recursively

1. `ssh-keygen` to generate an shh key if missing
2. `git clone --recursive-submodules <repo-SSH-address>`

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

## ZSHRC might not work!

In some cases zsh doesn't get set as default shell with the current script, so you might need to set it as default manually

## Copilot

`:Copilot`

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

- https://medium.com/@chrisatmachine/lunarvim-as-a-java-ide-da65c4a77fb4
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

```
asdf plugin-add pnpm
```

TODO:

Most important:
make some corrections:

1. asdf doesn't install the plugins, which is necessary for mason
2. asdf might need to be installed by running its script manually
3. alacritty should be installed automatically - but now you have to run its script
4. stow-ing doesn't work automatically, because .zshrc file must be removed from the root5. FIX THE FOLLOWING:

```
 ervin@192  ~/Workspace/overcast/front-end  git worktree add feature/PLA-2419-markers-on-timeline-for-selection feature/PLA-2419-markers-on-timeline-for-selection
Preparing worktree (checking out 'feature/PLA-2419-markers-on-timeline-for-selection')
HEAD is now at f9e189fc PLA-2499: remove unused imports
hint: The '/home/ervin/Workspace/overcast/front-end/.bare/hooks/post-checkout' hook was ignored because it's not set as executable.
hint: You can disable this warning with `git config advice.ignoredHook false`.
```

- Bind LSP keycombinations like refactoring
- use :GcLog -S text for looking for something in log
- Make the fzf work on Ctrl+f that is normally assigned to Ctrl+t by default
- use grammarely
- inspiration: https://github.com/soofaloofa/dotfiles/blob/master/.config/nvim/lua/plugins/init.lua
- make dap use telescope
- make remote docs in java be fetched

## Troubleshooting

### Debug LSP

- use `showkey -a` to debug key-combos
- Check the log files. Use :LspLoga or :JdtShowLogs or open the log file manually. :lua print(vim.fn.stdpath('cache')) lists the path, there should be a lsp.log. You may have to increase the log level. See :help vim.lsp.set_log_level().
- Remove Java Project Cache with :JdtWipeDataAndRestart
- Debug plugin configuration inserting in the after lua files: `print(vim.inspect(require('formatter.config').values.filetype))`

## For go, install the packages

```
asdf plugin-add golang
asdf list-all golnag
asdf install .....
asdf global golang ....


go install mvdan.cc/gofumpt@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/segmentio/golines@latest
```

## My Git workflow:

### Use worktrees

- use worktrees so that when you need to checkout, do a code-review for a colleague, you don't have to put away / stash you current work. You just change the directory!
- use worktrees so that you can have a current feature branch that you are working on, and then another one, let's say, for reference

`git worktree add reference devel`
`git worktree add -f work devel`

Name the worktree directories for example as: `reference`, `review` and `work`.

### Use stacked branches with the git --update-refs option:

https://andrewlock.net/working-with-stacked-branches-in-git-is-easier-with-update-refs/

Use `git rebase dev -i --update-refs` to move a change down the stack
