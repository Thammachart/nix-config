up: update-flake switch

git:
	git pull --ff-only

update-flake:
	nix flake update

switch:
	sudo nixos-rebuild switch --flake . --show-trace

rebuild-only:
	sudo nixos-rebuild boot --flake . --show-trace

gc:
	sudo nix store gc --debug
	sudo nix-collect-garbage --delete-old
	nix-collect-garbage --delete-old

diff:
	nix profile diff-closures --profile /nix/var/nix/profiles/system
