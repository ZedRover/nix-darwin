deploy:
	# nix store gc                                        
	
	# nix flake update

	nix build .#darwinConfigurations.zeds.system --extra-experimental-features 'nix-command flakes'

	./result/sw/bin/darwin-rebuild switch --flake .#zeds
