up: update-flake rebuild

update-flake:
	nix flake update

rebuild:
	sudo nixos-rebuild switch --flake .

gc:
	sudo nix store gc --debug
	sudo nix-collect-garbage --delete-old

diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system
