return {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
	nixd = {
	    nixpkgs = {
		expr = 'import (builtins.getFlake "/home/david/nix-config").inputs.nixpkgs { }',
	    },
	    options = {
		nixos = {
		    expr = '(builtins.getFlake "/home/david/nix-config").nixosConfigurations.nixos-pc.options',
		},
		home_manager = {
		    expr = '(builtins.getFlake "/home/david/nix-config").nixosConfigurations.nixos-pc.options.home-manager.users.type.getSubOptions []',
		},
	    },
	    formatting = { command = { "nixfmt" } },
	},
    },
}
