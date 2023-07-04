```
image_name=core
true && docker build -t $image_name .; \
docker run \
    -v "$HOME"/.zsh_history:/home/main/.zsh_history \
    -v "$HOME"/.aws:/home/main/.aws \
    -v "$HOME"/.ssh:/home/main/.ssh \
    -v "$HOME"/git/:/home/main/volumes/git \
--name $image_name -it $image_name /bin/zsh \
|| docker exec -it $image_name /bin/zsh \
|| docker start -i $image_name
```