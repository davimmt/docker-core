```bash
image_name=core

# if changes where made
docker build -t $image_name --build-arg CACHEBUST=$(date +%s) .

# run container || if error (container already exists), exec into it || if error (container stopped), start it
docker run \
    -v "$HOME"/.zsh_history:/home/main/.zsh_history \
    -v "$HOME"/.aws:/home/main/.aws \
    -v "$HOME"/.ssh:/home/main/.ssh \
    -v "$HOME"/git/:/home/main/volumes/git \
--name $image_name -it $image_name /bin/zsh \
|| docker exec -it $image_name /bin/zsh \
|| docker start -i $image_name
```

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
