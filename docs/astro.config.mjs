// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
export default defineConfig({
        integrations: [
                starlight({
                        title: "NixDots",
                        favicon: "/favicon.svg",
                        logo: {src: "./public/favicon.svg", replacesTitle: false},
                        social: [{ icon: "github", label: "GitHub", href: "https://github.com/voxi0/vodots" }],
                    sidebar: [
                        {
                            label: "Getting Started",
                            autogenerate: { directory: "getting-started", collapsed: true },
                            collapsed: false,
                        },
                    ],
                }),
        ],
});
