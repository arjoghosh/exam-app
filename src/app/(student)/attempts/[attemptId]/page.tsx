import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Exam attempt",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Exam attempt"
      description="The single-choice question interface, answer navigation, and submission confirmation will appear here."
    />
  );
}
