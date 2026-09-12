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
