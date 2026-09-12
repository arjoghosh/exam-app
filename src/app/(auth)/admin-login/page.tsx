import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Admin login",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Admin login"
      description="Administrators will sign in here. Server-side role checks will be added with authentication."
    />
  );
}
