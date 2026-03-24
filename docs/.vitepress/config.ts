import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'Podman Sandbox',
  description: 'Podman examples and tutorials - A repository for comparing and learning Podman vs Docker',
  lang: 'en-US',

  // Ignore dead links for example references that point to external repo files
  ignoreDeadLinks: true,

  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/podman-sandbox/podman-sandbox-icon.svg' }],
    ['link', { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&icon_names=dns_off,lock_open,sync,view_module,settings_suggest' }]
  ],

  base: '/podman-sandbox/',

  locales: {
    root: {
      label: 'English',
      lang: 'en',
      themeConfig: {
        nav: [
          { text: 'Home', link: '/' },
          { text: 'Guide', link: '/guide/getting-started' },
          { text: 'Examples', link: '/examples/' },
          { text: 'Architecture', link: '/guide/architecture' }
        ],
        sidebar: {
          '/guide/': [
            {
              text: 'Guide',
              items: [
                { text: 'Getting Started', link: '/guide/getting-started' },
                { text: 'Architecture', link: '/guide/architecture' },
                { text: 'Memory Efficiency', link: '/guide/memory' },
                { text: 'systemd Integration', link: '/guide/systemd' }
              ]
            }
          ],
          '/examples/': [
            {
              text: 'Examples',
              items: [
                { text: 'Overview', link: '/examples/' },
                { text: 'Basic Container', link: '/examples/01-basic' },
                { text: 'Pod Example', link: '/examples/02-pod' },
                { text: 'systemd Service', link: '/examples/03-systemd' },
                { text: 'Dockerfile', link: '/examples/04-dockerfile' },
                { text: 'Claude Code', link: '/examples/05-claudecode' },
                { text: 'Environment Files', link: '/examples/06-envfile' },
                { text: 'Compose', link: '/examples/07-compose' }
              ]
            }
          ]
        }
      }
    },
    ja: {
      label: '日本語',
      lang: 'ja',
      link: '/ja/',
      themeConfig: {
        nav: [
          { text: 'ホーム', link: '/ja/' },
          { text: 'ガイド', link: '/ja/guide/getting-started' },
          { text: 'サンプル', link: '/ja/examples/' },
          { text: 'アーキテクチャ', link: '/ja/guide/architecture' }
        ],
        sidebar: {
          '/ja/guide/': [
            {
              text: 'ガイド',
              items: [
                { text: 'はじめに', link: '/ja/guide/getting-started' },
                { text: 'アーキテクチャ', link: '/ja/guide/architecture' },
                { text: 'メモリ効率', link: '/ja/guide/memory' },
                { text: 'systemd 統合', link: '/ja/guide/systemd' }
              ]
            }
          ],
          '/ja/examples/': [
            {
              text: 'サンプル一覧',
              items: [
                { text: '概要', link: '/ja/examples/' },
                { text: '基本コンテナ', link: '/ja/examples/01-basic' },
                { text: 'Pod', link: '/ja/examples/02-pod' },
                { text: 'systemdサービス', link: '/ja/examples/03-systemd' },
                { text: 'Dockerfile', link: '/ja/examples/04-dockerfile' },
                { text: 'Claude Code', link: '/ja/examples/05-claudecode' },
                { text: '環境変数ファイル', link: '/ja/examples/06-envfile' },
                { text: 'Compose', link: '/ja/examples/07-compose' }
              ]
            }
          ]
        }
      }
    }
  },

  themeConfig: {
    logo: '/podman-sandbox-icon.svg',
    socialLinks: [
      { icon: 'github', link: 'https://github.com/Sunwood-ai-labs/podman-sandbox' }
    ],
    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2024-2025 Sunwood-ai-labs'
    }
  }
})
