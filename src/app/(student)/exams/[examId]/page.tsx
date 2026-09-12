import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Exam overview",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Exam overview"
      description="Exam instructions and the start action will appear here."
    />
  );
}
