```
image_name=core
true && docker build -t $image_name .; docker run -v /home/user/.ssh:/home/main/.ssh -v /home/user/git/:/home/main/volumes/git --name $image_name -it $image_name /bin/zsh || docker exec -it $image_name /bin/zsh || docker start -i $image_name
```