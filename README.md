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
- (bin) navi:master
- (bin) nvim:stable

I recommend downloading and using
[this font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip)
in your terminal so you can see all the pretty icons.

How to
```bash
# 1. Clone these repo
git clone --single-branch --depth 1 https://github.com/davimmt/docker-core "$(pwd)"/docker-core
git clone --single-branch --depth 1 https://github.com/davimmt/dotfiles "$(pwd)"/dotfiles
git clone --single-branch --depth 1 https://github.com/NvChad/NvChad "$(pwd)"/nvchad

# 2. Go into its dir
cd docker-core

# 3. Define image name var
image_name=core

# 4. Build docker image 
docker build -t $image_name .

# NOTE
# You can user /home/main/.mnt as entrypoint for you shared dir/files, e.g:
# -v /path/to/your/shared-dir:/home/main/.mnt/shared-dir

# 5. Run container (choose to mount whatever you want as your dotfiles, I like this)
docker run \
    -v "$(pwd)"/../nvchad/:/home/main/.config/nvim \
    -v "$(pwd)"/../dotfiles/nvim/nvchad:/home/main/.config/nvim/lua/custom \
    -v "$(pwd)"/../dotfiles/zsh/.p10k.zsh:/home/main/.p10k.zsh \
    -v "$(pwd)"/../dotfiles/zsh/.zprofile:/home/main/.zprofile \
    -v "$(pwd)"/../dotfiles/zsh/.zshrc:/home/main/.zshrc \
    -v "$HOME"/.local/share:/home/main/.local/share \
    -v "$HOME"/.local/state:/home/main/.local/state \
    -v "$HOME"/.ssh:/home/main/.ssh \
    -v "$HOME"/.aws:/home/main/.aws \
    -v "$HOME"/.kube:/home/main/.kube \
    -v "$HOME"/.zsh_history:/home/main/.zsh_history \
--name $image_name -it $image_name /bin/zsh

# NOTE
# If the container ir already running, you can:
# docker exec -it $image_name /bin/zsh
# And if its stopped, you can:
# docker start -i $image_name
```
