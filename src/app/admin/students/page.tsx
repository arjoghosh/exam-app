import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Manage students",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Manage students"
      description="Student accounts and profiles will be managed here."
    />
  );
}
