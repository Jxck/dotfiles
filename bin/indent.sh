# indent files with vim gg=G in parallel
echo $@ | xargs -I{} -L 1 -P 30 vim -c "argdo execute 'normal! gg=G' | update" {} -c quitall
