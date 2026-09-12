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
