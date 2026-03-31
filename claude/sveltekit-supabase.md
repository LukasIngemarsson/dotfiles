# SvelteKit + Supabase + DaisyUI — Practices & Patterns

Reusable conventions for projects using this stack. Not project-specific — these apply to any SvelteKit app with Supabase and DaisyUI/Tailwind.

## Svelte 5 (Runes)

### State Management

- Use `$props()`, `$state()`, `$derived()` — not legacy Svelte 4 reactive syntax (`$:`, `export let`).
- **Avoid `$effect` for side effects.** Use explicit triggers instead:
  - `onMount` / `onDestroy` for lifecycle work (subscriptions, timers)
  - `beforeNavigate` / `afterNavigate` for navigation events
  - `use:enhance` callbacks for form submission responses
  - `$derived` / `$derived.by` for computed values
- Effects lose control and locality — you can't easily know when they trigger as the program grows. Prefer callbacks that run at known points.

### Const Enum Pattern

Svelte doesn't support TypeScript `enum` in `.svelte` files. Use `as const` objects with a derived type:

```ts
const Status = { Active: 'active', Inactive: 'inactive' } as const;
type Status = (typeof Status)[keyof typeof Status];
```

Reference values as `Status.Active` instead of raw string literals.

### Props with Destructuring

Types go on the whole destructured pattern, not individual fields:

```ts
let { size = 'md' }: { size?: 'sm' | 'md' | 'lg' } = $props();
```

## Project Structure

### Component Organization

Co-locate components by usage, not in a single folder:

- **`$lib/components/`** — only shared, multi-use components (used by 2+ routes).
- **`$lib/components/icons/`** — reusable SVG icon components. Each accepts a `class` prop for sizing. Avoids inline SVG duplication.
- **Route-local components** — components used by a single page live next to that page. Any `.svelte` file in a route directory that doesn't start with `+` is a regular component, not a route.

### When to Extract a Component

Extract when:
- A section has **its own state and logic** (e.g. search with debounce, edit/delete state machine, modal with form state)
- **Nesting makes the code hard to follow** (3+ levels of `{#if}` inside `{#each}`)

Don't extract:
- Flat markup that renders a list with no local state — the props interface would add complexity without reducing it
- Sections where the parent and child share tightly coupled state that would need extensive binding

### File Layout

```
src/
├── lib/
│   ├── assets/          # static assets (images, icons)
│   ├── components/      # shared components
│   │   └── icons/       # SVG icon components
│   ├── stores/          # Svelte stores (.svelte.ts for runes)
│   ├── types/           # generated types (e.g. database.ts)
│   └── *.ts             # shared utilities, constants
├── routes/
│   ├── +layout.svelte   # root layout (navbar, loading bar, toast)
│   ├── +layout.server.ts # session, user data for all pages
│   ├── +layout.ts       # creates browser-side Supabase client
│   ├── some-route/
│   │   ├── +page.svelte
│   │   ├── +page.server.ts
│   │   └── LocalComponent.svelte  # co-located component
```

## Supabase Integration

### Auth Setup

1. **Server hook** (`hooks.server.ts`): Create a per-request Supabase client. Expose `supabase` + `safeGetSession()` on `event.locals`. Use `getUser()` (server-validated) not `getSession()` (client JWT only).
2. **Layout data flow**: Server layout calls `safeGetSession()`, passes `user` + `cookies`. Client layout creates a browser-side Supabase client. All pages receive `supabase` and `user`.
3. **Auth callback** route: Exchange OAuth code for session, upsert user profile.
4. **Microsoft (Azure) OAuth quirk**: Email is in `user_metadata.email`, not `user.email`. Always fall back: `user.email || user.user_metadata?.email`.

### Migrations

- Always run migrations through the Supabase CLI (`supabase db push` or `supabase migration up`), not by pasting SQL into the dashboard SQL editor. The CLI tracks which migrations have been applied and ensures they run in order.
- Store migrations in `supabase/migrations/` with sequential naming (e.g. `00001_initial_schema.sql`).
- When dropping a column that an RLS policy references, drop the policy first in the same migration.

### Database Types

- Auto-generate from schema: `npx supabase gen types typescript --project-id <id> > src/lib/types/database.ts`
- Run after every migration.
- If you need to update types before applying a migration (e.g. for type checking), manually edit the types file temporarily.

### Realtime Subscriptions

- Subscribe in `onMount`, unsubscribe in `onDestroy`.
- Call `invalidateAll()` on changes to re-run load functions.
- **Critical**: Unsubscribe before navigating away via form submissions (leave, delete) to avoid `invalidateAll()` racing with the navigation and hitting a 404 on a deleted resource.

### RLS Patterns

- Use a `security definer` helper function (e.g. `is_group_member()`) for policies that need to check related tables.
- Keep policies simple: `auth.uid() = user_id` for write, broader for read.
- When dropping a column that an RLS policy references, drop the policy first.

## SvelteKit Patterns

### Form Actions with `use:enhance`

- Use `use:enhance` for form submissions to avoid full page reloads.
- Handle success/error in the enhance callback, not with `$effect` watching `form`.
- Pattern for loading states:

```ts
function handleSubmit() {
    saving = true;
    return async ({ result, update }) => {
        await update();
        saving = false;
        if (result.type === 'success') toasts.push('success', 'Done!');
        else if (result.type === 'failure' && result.data?.error)
            toasts.push('error', result.data.error as string);
    };
}
```

- Extract a reusable `toastEnhance(successMessage)` helper for simple cases.

### Server Load Functions

- Always check auth at the top: `if (!user) redirect(303, '/login');`
- Return only what the page needs — don't over-fetch.
- Sort queries server-side: `.order('date', { ascending: false })`.

### Navigation Loading Bar

Use `beforeNavigate` / `afterNavigate` instead of `$effect` watching `navigating`:

```ts
beforeNavigate(() => { showLoadingBar = true; });
afterNavigate(() => {
    if (!showLoadingBar) return;
    loadingDone = true;
    setTimeout(() => { showLoadingBar = false; }, 300);
});
```

### Redirect After Auth

Pass a `?redirect=` param to the login page, thread it through OAuth via the callback URL (`?next=`), then redirect after auth. Validate that `next` starts with `/` to prevent open redirect attacks.

## UI / DaisyUI Patterns

### Cards

- `bg-base-200` for input/action cards (forms, submit areas)
- `border border-base-300` for display cards (tables, lists, stats)

### Notifications

- Use a toast system for all user feedback. No inline alerts.
- Toast store pattern: `toasts.push('success' | 'error', message)`.

### Destructive Actions

- Wrap in a confirmation modal.
- Delete button: `btn-error btn-outline btn-sm`.

### Icons

- Store as individual Svelte components with a `class` prop.
- Use proportional rounding: `rounded` for larger icons (32px+), `rounded-sm` for small icons (16px) to avoid corner clipping.

### Tabs

- Client-side state, no URL changes.
- Active tab: `border-b-2 border-primary text-primary`.
- Inactive: `opacity-60 hover:opacity-100`.
- Use `{#if}` to swap content (components are destroyed/recreated on tab switch).

### Pagination

- Client-side "Show more" pattern — render a slice of the data, increment on click.
- All data fetched upfront; DOM-only pagination.

```ts
const PAGE_SIZE = 20;
let visibleCount = $state(PAGE_SIZE);
let visible = $derived(items.slice(0, visibleCount));
let hasMore = $derived(items.length > visibleCount);
```

## Formatting

- Prettier with `prettier-plugin-svelte`.
- Add `npm run format` script: `prettier --write "src/**/*.{svelte,ts,js,css}"`.
- `.prettierrc`:

```json
{
    "plugins": ["prettier-plugin-svelte"],
    "overrides": [{ "files": "*.svelte", "options": { "parser": "svelte" } }],
    "printWidth": 100,
    "singleQuote": true,
    "tabWidth": 2,
    "useTabs": true,
    "trailingComma": "none"
}
```
