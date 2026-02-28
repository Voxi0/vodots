// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import starlightThemeBlack from "starlight-theme-black"
export default defineConfig({
	integrations: [
		starlight({
			title: "vodots",
			favicon: "/favicon.svg",
			logo: {src: "./public/favicon.svg", replacesTitle: false},
			social: [{ icon: "github", label: "GitHub", href: "https://github.com/Voxi0/vodots" }],
			plugins: [
				starlightThemeBlack({
					navLinks: [{
						label: "docs",
						link: "/getting-started",
					}],
					footerText: ""
				})
			],
			sidebar: [
				{
					label: "Getting Started",
					autogenerate: { directory: "getting-started" },
					collapsed: false,
				},
			],
		}),
	],
});
