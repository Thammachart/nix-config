up: update-flake rebuild

update-flake:
	nix flake update

rebuild:
	sudo nixos-rebuild switch --flake .

gc:
	sudo nix store gc --debug
	sudo nix-collect-garbage --delete-old
