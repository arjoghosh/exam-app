$ErrorActionPreference = "Stop"

# Resolve the project from this script's location.
$Root = $PSScriptRoot

if (-not $Root) {
    $Root = (Get-Location).Path
}

if (-not (Test-Path -LiteralPath (Join-Path $Root "package.json") -PathType Leaf)) {
    throw "Run this script from your mock-test-app project."
}

$ProjectName = Split-Path $Root -Leaf
$Parent = Split-Path $Root -Parent
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss-fff"
$BackupRoot = Join-Path $Parent "$ProjectName-base-backup-$Timestamp"

$Utf8 = New-Object System.Text.UTF8Encoding($false)

function Backup-ProjectFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RelativePath
    )

    $Source = Join-Path $Root $RelativePath

    if (-not [System.IO.File]::Exists($Source)) {
        return
    }

    $Destination = Join-Path $BackupRoot $RelativePath
    $DestinationDirectory = [System.IO.Path]::GetDirectoryName($Destination)

    [System.IO.Directory]::CreateDirectory($DestinationDirectory) | Out-Null
    [System.IO.File]::Copy($Source, $Destination, $true)
}

function Write-ProjectFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RelativePath,

        [Parameter(Mandatory = $true)]
        [string]$Content
    )

    $FullPath = Join-Path $Root $RelativePath
    $Directory = [System.IO.Path]::GetDirectoryName($FullPath)

    [System.IO.Directory]::CreateDirectory($Directory) | Out-Null

    Backup-ProjectFile -RelativePath $RelativePath

    [System.IO.File]::WriteAllText(
        $FullPath,
        $Content.Trim() + "`n",
        $Utf8
    )

    Write-Host "Written: $RelativePath" -ForegroundColor Green
}

# Remove alternate config filenames after backing them up.
# This script uses next.config.ts, postcss.config.mjs,
# eslint.config.mjs, and tsconfig.json.
$AlternateConfigs = @(
    "next.config.js"
    "next.config.mjs"
    "postcss.config.js"
    "postcss.config.cjs"
    "postcss.config.json"
    "eslint.config.js"
    "eslint.config.cjs"
    "eslint.config.ts"
    ".eslintrc"
    ".eslintrc.json"
    ".eslintrc.js"
    ".eslintrc.cjs"
    "jsconfig.json"
)

foreach ($RelativePath in $AlternateConfigs) {
    $FullPath = Join-Path $Root $RelativePath

    if ([System.IO.File]::Exists($FullPath)) {
        Backup-ProjectFile -RelativePath $RelativePath
        [System.IO.File]::Delete($FullPath)

        Write-Host "Backed up and removed alternate config: $RelativePath" `
            -ForegroundColor Yellow
    }
}

# ------------------------------------------------------------
# Framework and tooling configuration
# ------------------------------------------------------------

Write-ProjectFile "next.config.ts" @'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
};

export default nextConfig;
'@

Write-ProjectFile "tsconfig.json" @'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "react-jsx",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    "**/*.mts",
    ".next/types/**/*.ts",
    ".next/dev/types/**/*.ts"
  ],
  "exclude": ["node_modules"]
}
'@

Write-ProjectFile "postcss.config.mjs" @'
const config = {
  plugins: {
    "@tailwindcss/postcss": {},
  },
};

export default config;
'@

Write-ProjectFile "eslint.config.mjs" @'
import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTypeScript from "eslint-config-next/typescript";

export default defineConfig([
  ...nextVitals,
  ...nextTypeScript,
  globalIgnores([
    ".next/**",
    "out/**",
    "build/**",
    "coverage/**",
    "playwright-report/**",
    "test-results/**",
    "next-env.d.ts",
  ]),
]);
'@

Write-ProjectFile ".prettierrc.json" @'
{
  "semi": true,
  "singleQuote": false,
  "trailingComma": "all",
  "tabWidth": 2,
  "printWidth": 100,
  "endOfLine": "lf"
}
'@

Write-ProjectFile ".prettierignore" @'
node_modules
.next
out
build
coverage
playwright-report
test-results
package-lock.json
next-env.d.ts
.env*
!.env.example
'@

# Preserve existing gitignore entries and append project entries.
$GitIgnorePath = Join-Path $Root ".gitignore"
$ExistingGitIgnore = ""

if ([System.IO.File]::Exists($GitIgnorePath)) {
    $ExistingGitIgnore = [System.IO.File]::ReadAllText($GitIgnorePath)
}

$GitIgnoreMarker = "# Mock test app base setup"

if (-not $ExistingGitIgnore.Contains($GitIgnoreMarker)) {
    $AdditionalGitIgnore = @'
# Mock test app base setup
node_modules/
.next/
out/
build/
coverage/
playwright-report/
test-results/
*.tsbuildinfo
next-env.d.ts
.env*
!.env.example
'@

    Write-ProjectFile ".gitignore" (
        $ExistingGitIgnore + "`n" + $AdditionalGitIgnore
    )
}

Write-ProjectFile ".env.example" @'
# Copy this file to .env.local when configuring the database and auth.
# These are local development placeholders, not production credentials.

NEXT_PUBLIC_APP_URL=http://localhost:3000

DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mock_test_app

BETTER_AUTH_URL=http://localhost:3000
BETTER_AUTH_SECRET=
'@

# ------------------------------------------------------------
# Global styles and root layout
# ------------------------------------------------------------

Write-ProjectFile "src/app/globals.css" @'
@import "tailwindcss";

:root {
  color-scheme: light;
  --background: #f8fafc;
  --foreground: #0f172a;
}

@theme inline {
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  --font-sans: Arial, Helvetica, sans-serif;
}

body {
  min-height: 100vh;
  background: var(--background);
  color: var(--foreground);
  font-family: Arial, Helvetica, sans-serif;
}

button,
input,
select,
textarea {
  font: inherit;
}

:focus-visible {
  outline: 3px solid #4f46e5;
  outline-offset: 4px;
}

::selection {
  background: #c7d2fe;
  color: #1e1b4b;
}
'@

Write-ProjectFile "src/app/layout.tsx" @'
import type { Metadata, Viewport } from "next";
import type { ReactNode } from "react";
import "./globals.css";

export const metadata: Metadata = {
  title: {
    default: "Mock Test App",
    template: "%s | Mock Test App",
  },
  description: "Practice exams with detailed explanations and PDF reports.",
  applicationName: "Mock Test App",
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  themeColor: "#4f46e5",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}
'@

# ------------------------------------------------------------
# Shared placeholder screen
# ------------------------------------------------------------

Write-ProjectFile "src/components/shared/placeholder-page.tsx" @'
import Link from "next/link";

type PlaceholderPageProps = {
  title: string;
  description: string;
};

const links = [
  { href: "/", label: "Home" },
  { href: "/login", label: "Student login" },
  { href: "/dashboard", label: "Student dashboard" },
  { href: "/admin-login", label: "Admin login" },
  { href: "/admin", label: "Admin dashboard" },
];

export function PlaceholderPage({
  title,
  description,
}: PlaceholderPageProps) {
  return (
    <main className="mx-auto flex min-h-[75vh] max-w-5xl items-center px-4 py-12 sm:px-6">
      <section className="w-full rounded-3xl border border-slate-200 bg-white p-6 shadow-sm sm:p-10">
        <p className="text-sm font-semibold tracking-wide text-indigo-600">
          MOCK TEST APP
        </p>

        <h1 className="mt-4 text-3xl font-bold tracking-tight text-slate-950 sm:text-4xl">
          {title}
        </h1>

        <p className="mt-4 max-w-2xl leading-7 text-slate-600">
          {description}
        </p>

        <div className="mt-6 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm leading-6 text-amber-950">
          Development placeholder. Authentication, exam processing, and
          report generation are not enabled.
        </div>

        <nav
          aria-label="Development navigation"
          className="mt-8 flex flex-wrap gap-3"
        >
          {links.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className="rounded-xl border border-slate-200 px-4 py-3 text-sm font-medium text-slate-700 transition-colors hover:border-indigo-300 hover:bg-indigo-50 hover:text-indigo-700"
            >
              {link.label}
            </Link>
          ))}
        </nav>
      </section>
    </main>
  );
}
'@

# ------------------------------------------------------------
# Generate all placeholder pages
# ------------------------------------------------------------

$Pages = @(
    @{
        Path = "src/app/page.tsx"
        Title = "Practice with confidence"
        Description = "Your mock test platform is taking shape. Choose a development screen below to preview the application structure."
    }
    @{
        Path = "src/app/(auth)/login/page.tsx"
        Title = "Student login"
        Description = "Students will sign in here to access available exams and their previous results."
    }
    @{
        Path = "src/app/(auth)/admin-login/page.tsx"
        Title = "Admin login"
        Description = "Administrators will sign in here. Server-side role checks will be added with authentication."
    }
    @{
        Path = "src/app/(student)/dashboard/page.tsx"
        Title = "Student dashboard"
        Description = "Available exams, attempt history, and profile information will appear here."
    }
    @{
        Path = "src/app/(student)/exams/[examId]/page.tsx"
        Title = "Exam overview"
        Description = "Exam instructions and the start action will appear here."
    }
    @{
        Path = "src/app/(student)/attempts/[attemptId]/page.tsx"
        Title = "Exam attempt"
        Description = "The single-choice question interface, answer navigation, and submission confirmation will appear here."
    }
    @{
        Path = "src/app/(student)/results/[attemptId]/page.tsx"
        Title = "Exam result"
        Description = "Question-wise results, explanations, and the PDF download action will appear here."
    }
    @{
        Path = "src/app/admin/page.tsx"
        Title = "Admin dashboard"
        Description = "Exam management, student management, and attempt summaries will appear here."
    }
    @{
        Path = "src/app/admin/exams/page.tsx"
        Title = "Manage exams"
        Description = "Create exams and upload validated question CSV files here."
    }
    @{
        Path = "src/app/admin/students/page.tsx"
        Title = "Manage students"
        Description = "Student accounts and profiles will be managed here."
    }
    @{
        Path = "src/app/admin/attempts/page.tsx"
        Title = "Review attempts"
        Description = "Student submissions and report access will appear here."
    }
)

$PageTemplate = @'
import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "__TITLE__",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="__TITLE__"
      description="__DESCRIPTION__"
    />
  );
}
'@

foreach ($Page in $Pages) {
    $Content = $PageTemplate.Replace(
        "__TITLE__",
        $Page.Title
    ).Replace(
        "__DESCRIPTION__",
        $Page.Description
    )

    Write-ProjectFile $Page.Path $Content
}

# ------------------------------------------------------------
# Admin layout - intentionally not an authorization boundary yet
# ------------------------------------------------------------

Write-ProjectFile "src/app/admin/layout.tsx" @'
import Link from "next/link";
import type { ReactNode } from "react";

const links = [
  { href: "/admin", label: "Overview" },
  { href: "/admin/exams", label: "Exams" },
  { href: "/admin/students", label: "Students" },
  { href: "/admin/attempts", label: "Attempts" },
];

export default function AdminLayout({
  children,
}: Readonly<{
  children: ReactNode;
}>) {
  return (
    <>
      <header className="border-b border-slate-200 bg-white">
        <div className="mx-auto max-w-5xl px-4 py-5 sm:px-6">
          <p className="font-semibold text-slate-950">
            Admin portal preview
          </p>

          <p className="mt-1 text-sm text-amber-800">
            Public scaffold only. Admin authentication is not implemented.
          </p>

          <nav
            aria-label="Admin navigation"
            className="mt-4 flex flex-wrap gap-4"
          >
            {links.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="text-sm font-medium text-indigo-700 underline-offset-4 hover:underline"
              >
                {link.label}
              </Link>
            ))}
          </nav>
        </div>
      </header>

      {children}
    </>
  );
}
'@

# ------------------------------------------------------------
# API placeholders
# No fake sessions, reports, or successful submissions.
# ------------------------------------------------------------

Write-ProjectFile "src/app/api/auth/[...all]/route.ts" @'
export const runtime = "nodejs";
export const dynamic = "force-dynamic";

function unavailable() {
  return Response.json(
    {
      error: {
        code: "AUTH_NOT_CONFIGURED",
        message: "Authentication has not been configured.",
      },
    },
    {
      status: 501,
      headers: {
        "Cache-Control": "no-store",
      },
    },
  );
}

export function GET() {
  return unavailable();
}

export function POST() {
  return unavailable();
}
'@

Write-ProjectFile "src/app/api/reports/[attemptId]/route.ts" @'
export const runtime = "nodejs";
export const dynamic = "force-dynamic";

export function GET() {
  return Response.json(
    {
      error: {
        code: "REPORTS_NOT_CONFIGURED",
        message: "PDF report generation has not been configured.",
      },
    },
    {
      status: 501,
      headers: {
        "Cache-Control": "no-store",
      },
    },
  );
}
'@

# ------------------------------------------------------------
# Manifest foundation
# Icons and service-worker registration come in the PWA step.
# ------------------------------------------------------------

Write-ProjectFile "src/app/manifest.ts" @'
import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    id: "/",
    name: "Mock Test App",
    short_name: "Mock Tests",
    description: "Practice exams with detailed results and explanations.",
    lang: "en",
    start_url: "/",
    scope: "/",
    display: "standalone",
    background_color: "#f8fafc",
    theme_color: "#4f46e5",
  };
}
'@

Write-ProjectFile "public/sw.js" @'
// Intentionally inactive.
//
// Do not register this file yet.
// The PWA step will add an explicit caching policy.
// Authenticated responses, exam data, and PDF reports must not be cached.
'@

# ------------------------------------------------------------
# Not-found page
# ------------------------------------------------------------

Write-ProjectFile "src/app/not-found.tsx" @'
import Link from "next/link";

export default function NotFound() {
  return (
    <main className="mx-auto max-w-3xl px-6 py-24 text-center">
      <p className="text-sm font-semibold text-indigo-600">404</p>

      <h1 className="mt-3 text-3xl font-bold">Page not found</h1>

      <p className="mt-4 text-slate-600">
        The requested page does not exist.
      </p>

      <Link
        href="/"
        className="mt-8 inline-flex rounded-xl bg-indigo-600 px-5 py-3 font-medium text-white hover:bg-indigo-700"
      >
        Return home
      </Link>
    </main>
  );
}
'@

# ------------------------------------------------------------
# Drizzle configuration
# Database access is deferred to the next step.
# ------------------------------------------------------------

Write-ProjectFile "drizzle.config.ts" @'
import { config } from "dotenv";
import { defineConfig } from "drizzle-kit";

config({ path: ".env.local" });
config({ path: ".env" });

const databaseUrl = process.env.DATABASE_URL;

export default defineConfig({
  dialect: "postgresql",
  schema: "./src/db/schema/**/*.ts",
  out: "./drizzle",
  ...(databaseUrl
    ? {
        dbCredentials: {
          url: databaseUrl,
        },
      }
    : {}),
  strict: true,
  verbose: true,
});
'@

# Convert future implementation files into valid empty modules.
# Do not overwrite any non-empty implementation.
$FutureModules = @(
    "src/db/index.ts"
    "src/lib/auth.ts"
    "src/lib/auth-client.ts"
    "src/lib/permissions.ts"
    "src/lib/env.ts"
)

foreach ($RelativePath in $FutureModules) {
    $FullPath = Join-Path $Root $RelativePath
    $ShouldInitialize = $true

    if ([System.IO.File]::Exists($FullPath)) {
        $ExistingContent = [System.IO.File]::ReadAllText($FullPath)
        $ShouldInitialize = [string]::IsNullOrWhiteSpace($ExistingContent)
    }

    if ($ShouldInitialize) {
        Write-ProjectFile $RelativePath @'
// Reserved for the database and authentication implementation step.
export {};
'@
    }
}

Write-Host ""
Write-Host "Base setup completed." -ForegroundColor Green
Write-Host "Backup location: $BackupRoot" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next:"
Write-Host "  npm run format"
Write-Host "  npm run lint"
Write-Host "  npx next typegen"
Write-Host "  npm run typecheck"
Write-Host "  npm run build"
Write-Host "  npm run dev"