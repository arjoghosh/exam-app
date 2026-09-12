import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Student dashboard",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Student dashboard"
      description="Available exams, attempt history, and profile information will appear here."
    />
  );
}
