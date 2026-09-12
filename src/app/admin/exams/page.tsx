import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Manage exams",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Manage exams"
      description="Create exams and upload validated question CSV files here."
    />
  );
}
