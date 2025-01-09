_default:
	just --list sync

[confirm("Sync?")]
_files in from file:
	find \
		./{{ in }} \
		-maxdepth 1 \
		-type d \
		-not -wholename './{{ in }}' \
		-not -wholename './{{ in }}/{{ from }}' \
		-exec cp ./{{ in }}/{{ from }}/{{ file }} {} \;

_cmp in from file:
	find \
		./{{ in }} \
		-maxdepth 1 \
		-type d \
		-not -wholename './{{ in }}' \
		-not -wholename './{{ in }}/{{ from }}' \
		-exec cmp ./{{ in }}/{{ from }}/{{ file }} {}/{{ file }} \;

src from="bash-prompt" file="library_scripts.sh": (_cmp "src" from file) (_files "src" from file)
	@echo done

test from="bash-prompt" file="test_scripts.sh": (_cmp "test" from file) (_files "test" from file)
	@echo done
