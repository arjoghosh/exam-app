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
