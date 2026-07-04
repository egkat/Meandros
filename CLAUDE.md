# RoMaze

A Roblox Studio plugin that generates mazes with configurable algorithms and settings.

## Toolchain

Managed by [Rokit](https://github.com/rojo-rbx/rokit) (`rokit.toml`):
- **rojo** — syncs `plugin/src/` into Roblox Studio and builds the plugin binary
- **wally** — Luau package manager
- **wally-package-types** — generates Luau types for Wally packages

## Build & develop

```bash
# Watch plugin/ and auto-rebuild the plugin on every file change
npm run watch

# One-off build
rojo build plugin.project.json --output ~/Documents/Roblox/Plugins/RoMaze.rbxm

# Run the Lune test suite (.lune/tests)
npm test

# Install/update Wally packages
wally install

# Lint
selene plugin/src/
```

The watch script (`tools/watch.js`) builds into `~/Documents/Roblox/Plugins/RoMaze.rbxm`. Reload the plugin in Roblox Studio manually after each build (Plugin tab → Manage Plugins, or via the Reload button if you have one configured).

## Project structure

```
plugin/
  Version.txt                   -- plugin version; must be bumped every commit
  Packages/                     -- Wally-managed packages; do not edit
  src/
    init.server.luau            -- entry point; mounts the React root into CoreGui
    App/
      init.luau                 -- root App React component
      Page.luau                 -- page wrapper/transition component
      Theme.luau                -- theme colors and styling values
      Components/
        Navigation/             -- sidebar and sidebar buttons
        PrimitiveComponents/    -- generic UI building blocks (Button, Dropdown, TextLabel, ...)
        StudioComponents/       -- thin React wrappers around Studio API objects
      Hooks/                    -- custom React hooks (useSpring)
      StatusPages/              -- one page per sidebar section (Home, Build, Structure, Appearance, Settings)
    Assets/
      Icons.luau                -- icon asset ID references
    Builder/                    -- turns generated grids into Parts in the workspace
    Classes/                    -- generic data structures (Stack)
    Data/
      Constants.luau            -- shared constant values
    Generators/                 -- maze grid + generation algorithms
      Algorithms/               -- one module per maze algorithm (RandomizedDepthFirstSearch)
    Utils/                      -- small pure helper functions
.lune/
  tests/                        -- automated tests, run with Lune via `npm test`
  manual-tests/                 -- tests run by hand during development
PCAssets/                       -- source images (plugin icons, cursors) uploaded as Roblox assets
tools/
  watch.js                      -- file watcher; runs rojo build on any plugin/ change
  test.js                       -- runs every .luau file in .lune/tests via Lune
plugin.project.json             -- Rojo project definition
wally.toml                      -- Luau package dependencies
rokit.toml                      -- toolchain pin (rojo, wally, wally-package-types)
```

## Architecture

The plugin is a single-context Roblox Studio plugin (no client/server split). The entry point (`init.server.luau`) creates a React root mounted to `CoreGui` and tears it down when the plugin unloads.

All UI is built with React (`jsdotlua/react` + `jsdotlua/react-roblox`). `StudioComponents/` wraps imperative Studio API calls (e.g. `plugin:CreateToolbar`) in React components using `useEffect` so they are created/destroyed with the component lifecycle.

## Key conventions

**Naming**:
- Files: `PascalCase.luau`
- React components: PascalCase functions exported as the module itself (`return MyComponent`)
- Variables and function params: `camelCase`
- Luau types: `PascalCase` with `export type`

**Requires**: Use relative `script.Parent` chains. No path aliases.

**React elements**: Use `local e = React.createElement` at the top of each component file.

**Plugin context**: The `plugin` global is passed as a prop from the entry point down through the tree. Use `StudioPluginContext` to avoid prop-drilling when it gets deep.

## Dependencies (Wally)

| Package | Purpose |
|---|---|
| React | UI framework |
| ReactRoblox | React renderer for Roblox |
| Sift | Immutable table utilities (arrays, dictionaries, sets) |
| Ripple | Spring/tween motion library (backs the `useSpring` hook) |
| Charm | Atomic state management (the `*Slice.luau` modules) |
| ReactCharm | React bindings for Charm atoms |

## Linting & formatting

- **Selene**: `selene.toml` with `std = "roblox"`.
- **StyLua**: Configured in `.vscode/settings.json`. Format on save is expected.

## Workflow

**Commit messages**: Prefix with `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, or `test:` (e.g. `feat: add Kruskal maze generator`). Enforced by the `commit-msg` hook in `.githooks/` — run `git config core.hooksPath .githooks` once after cloning to enable it.

**Version bump**: `plugin/Version.txt` must be raised on every commit (the same hook compares the staged version against `HEAD`'s). Bump patch for fixes/chores, minor for features, per semver.

**Plan before multi-file changes**: For anything touching more than one file (a new generation algorithm, a new Studio component tree, a cross-cutting refactor), write a short plan first — expected behavior, affected files, how it'll be verified — before writing code. Single-file fixes and small tweaks don't need this.

## What to avoid

- Don't edit `plugin/Packages/` — managed by Wally.
- Don't hand-edit `plugin.project.json` without also checking that `rojo build` still succeeds.
- Don't use `game:GetService()` for services that don't exist in a plugin context — prefer the `plugin` API directly.
- Don't add global state at module level; keep all state inside React components or contexts.
