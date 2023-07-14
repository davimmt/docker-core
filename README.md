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
- (config/plugin) vim-plug:master (not at BYOC)
- (bin) navi:master
- (bin) nvim:stable
- (config/plugin) AstroNvim3:master (not at BYOC)

I recommend downloading and using
[this font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip)
in your terminal so you can see all the pretty icons.

You have two methods to work with this repo: MANAGED or BYOC (Bring Your Own
Configuration):

- In BYOC, you will mount your own configurations (I like this method better).
- In MANAGED, the configurations defined in the repo will be git cloned to
  /home/.docker-core and sys-linked inside the container.

```bash
# 1. Clone this repo
git clone --single-branch --depth 1 https://github.com/davimmt/docker-core.git

# 2. Go into its dir
cd docker-core

# 2.1 (Optional) If you choose BYOC method
## Clean your Dockerfile by removing the aread marked as '## START ! BYOC ##' and '## END ! BYOC ##'
## You can do it manually or use sed
sed -i '/## START ! BYOC ##/,/## END ! BYOC ##/d' Dockerfile

# 3. Define image name var
image_name=core

# 4. Build docker image 
docker build -t $image_name .

# 4.1 (Optional) If you choose BYOC method
## Change zsh config file temporarily
## so that your nvim config will auto run at init
cat <<'EOF' >> nvim/.zshrc
## BEGIN TMP ##
# init nvim config
sh -c 'nvim --headless -c 'quitall'' ${USER}
# install lsp servers
sh -c 'nvim --headless +"LspInstall terraformls tflint" +qa' ${USER}
## END TMP ##
EOF

# NOTE
# You can user /home/main/.mnt as entrypoint for you shared dir/files, e.g:
# -v /path/to/your/shared-dir:/home/main/.mnt/shared-dir

# 5.1 (BYOC) Run container 
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
--name $image_name -it $image_name /bin/zsh

# 5.2 (MANAGED) Run container 
docker run \
    -v "$HOME"/.kube:/home/main/.kube \
    -v "$HOME"/.zsh_history:/home/main/.zsh_history \
    -v "$HOME"/.aws:/home/main/.aws \
    -v "$HOME"/.ssh:/home/main/.ssh \
--name $image_name -it $image_name /bin/zsh

# NOTE
# If the container ir already running, you can:
# docker exec -it $image_name /bin/zsh
# And if its stopped, you can:
# docker start -i $image_name
```
