-- Next.js App Router カスタムスニペット
return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    ls.add_snippets("typescriptreact", {
      -- npage: app/page.tsx 用
      s("npage", {
        t({ "export default function " }),
        i(1, "Page"),
        t({ "() {", "  return (", "    <main>", "      " }),
        i(2),
        t({ "", "    </main>", "  )", "}" }),
      }),

      -- nlayout: app/layout.tsx 用
      s("nlayout", {
        t({ "export default function " }),
        i(1, "Layout"),
        t({
          "({",
          "  children,",
          "}: {",
          "  children: React.ReactNode",
          "}) {",
          "  return (",
          "    ",
        }),
        i(2, "{children}"),
        t({ "", "  )", "}" }),
      }),

      -- nloading: loading.tsx 用
      s("nloading", {
        t({
          "export default function Loading() {",
          "  return (",
          "    <div>",
          "      ",
        }),
        i(1, "Loading..."),
        t({ "", "    </div>", "  )", "}" }),
      }),

      -- nerror: error.tsx 用 ("use client" 付き)
      s("nerror", {
        t({
          '"use client"',
          "",
          "export default function Error({",
          "  error,",
          "  reset,",
          "}: {",
          "  error: Error & { digest?: string }",
          "  reset: () => void",
          "}) {",
          "  return (",
          "    <div>",
          "      <h2>Something went wrong!</h2>",
          "      <button onClick={() => reset()}>Try again</button>",
          "    </div>",
          "  )",
          "}",
        }),
      }),

      -- nsc: Server Component
      s("nsc", {
        t({ "export default async function " }),
        i(1, "Component"),
        t({ "() {", "  return (", "    <div>", "      " }),
        i(2),
        t({ "", "    </div>", "  )", "}" }),
      }),

      -- ncc: Client Component ("use client" 付き)
      s("ncc", {
        t({ '"use client"', "", "export default function " }),
        i(1, "Component"),
        t({ "() {", "  return (", "    <div>", "      " }),
        i(2),
        t({ "", "    </div>", "  )", "}" }),
      }),
    })
  end,
}
