require("ui")
require("general")
require("mappings")
require("lze").load({
	{ import = "plugins.ui" },

	-- Code-aware features, LSP and autocompletion
	{ import = "plugins.core" },

	-- Quality of life plugins
	{ import = "plugins.useful" },
	{ import = "plugins.mini" },
	{ import = "plugins.snacks" },

	-- Miscellaneous
	{ import = "plugins.misc" },
})
