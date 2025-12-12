up: update-flake rebuild

git:
	git pull --ff-only

update-flake:
	nix flake update

rebuild:
	sudo nixos-rebuild switch --flake . --show-trace

gc:
	sudo nix store gc --debug
	sudo nix-collect-garbage --delete-old
	nix-collect-garbage --delete-old

diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system
