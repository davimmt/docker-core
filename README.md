This Dockerfile will build (in base debian) the following main assets (not
exhaustive list), by default:

- (bin) kubectl:1.20.9
- (apt) zsh
- (apt) neovim
- (bin) awscliv2:latest
- (bin) aws session manager plugin:latest
- (bin) jq:1.6
- (bin) yq:4.2.0
- (bin) helm3:latest
- (bin) terraform:1.3.7
- (config/plugin) on-my-zsh
- (config/plugin) antigen
- (config/plugin) diff-so-fancy:master
- (config/plugin) vim-plug:master
- (bin) navi:master
- (bin) nvim:stable
- (config/plugin) AstroNvim3:master

I recommend downloading and using
[this font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip)
in your terminal so you can see all the pretty icons.

### Using Dockerfile

The configurations defined in the repo will be git cloned and sys-linked inside
the container.

```bash
git clone --single-branch --depth 1 https://github.com/davimmt/docker-core.git
cd docker-core

# define docker image name
image_name=core

# build the image
## the build-arg CACHEBUST is a workaround so that Docker will
## always clone the newest version of git repos
docker build -t $image_name --build-arg CACHEBUST=$(date +%s) .

# run container 
# || if error (container already exists), exec into it 
# || if error (container stopped), start and exec into it
docker run \
    -v "$HOME"/.kube:/home/main/.kube \
    -v "$HOME"/.zsh_history:/home/main/.zsh_history \
    -v "$HOME"/.aws:/home/main/.aws \
    -v "$HOME"/.ssh:/home/main/.ssh \
--name $image_name -it $image_name /bin/zsh \
|| docker exec -it $image_name /bin/zsh \
|| docker start -i $image_name

# you can user "$HOME"/.mnt as entrypoint
# -v /path/to/your/dir:/home/main/.mnt/dir
```

### Using Dockerfile.confless

You will mount your own configurations.

```bash
git clone --single-branch --depth 1 https://github.com/davimmt/docker-core.git
cd docker-core

# change it temporarily
# so that your nvim config will auto run at init
cat <<'EOF' >> nvim/.zshrc

## BEGIN TMP ##
# init nvim config
sh -c 'nvim --headless -c 'quitall'' ${USER}
# install lsp servers
sh -c 'nvim --headless +"LspInstall terraformls tflint" +qa' ${USER}
## END TMP ##
EOF

# build docker image 
image_name=core-confless
docker build -t $image_name -f Dockerfile.confless .

# run container 
# || if error (container already exists), exec into it 
# || if error (container stopped), start and exec into it
docker run \
    -v "$HOME"/.config/:/home/main/.config \
    -v "$HOME"/.local/share:/home/main/.local/share \
    -v "$HOME"/.local/state:/home/main/.local/state \
    -v "$(pwd)"/nvim/astronvim:/home/main/.config/nvim/lua/user \
    -v "$HOME"/.ssh:/home/main/.ssh \
    -v "$HOME"/.aws:/home/main/.aws \
    -v "$HOME"/.kube:/home/main/.kube \
    -v "$(pwd)"/zsh/.p10k.zsh:/home/main/.p10k.zsh \
    -v "$(pwd)"/zsh/.zprofile:/home/main/.zprofile \
    -v "$(pwd)"/zsh/.zshrc:/home/main/.zshrc \
    -v "$HOME"/.zsh_history:/home/main/.zsh_history \
--name $image_name -it $image_name /bin/zsh \
|| docker exec -it $image_name /bin/zsh \
|| docker start -i $image_name

# you can user "$HOME"/.mnt as entrypoint
# -v /path/to/your/dir:/home/main/.mnt/dir
```
