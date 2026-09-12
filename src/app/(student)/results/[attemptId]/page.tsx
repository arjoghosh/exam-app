import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Exam result",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Exam result"
      description="Question-wise results, explanations, and the PDF download action will appear here."
    />
  );
}
