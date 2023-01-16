push: #param: msg 
	bash ./protoc.sh
	git add -A
	git commit -m "${msg}"
	git push