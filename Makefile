up: update-flake rebuild

update-flake:
	nix flake update

rebuild:
	sudo nixos-rebuild switch --flake .
