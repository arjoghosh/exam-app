import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Admin dashboard",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Admin dashboard"
      description="Exam management, student management, and attempt summaries will appear here."
    />
  );
}
