# indent files with vim gg=G
vim -c "argdo execute 'normal! gg=G' | update" $@ -c quitall
