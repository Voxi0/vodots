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
					footerText: "",
					navLinks: [{
						label: "docs",
						link: "/getting-started",
					}],
				}),
			],
			sidebar: [
				{
					label: "Getting Started",
					collapsed: false,
					items: [
						{ autogenerate: { directory: "getting-started" } },
					],
				},

				{
					label: "Packages",
					collapsed: true,
					items: [
						{ autogenerate: {directory: "packages" } },
					],
				}
			],
		}),
	],
});