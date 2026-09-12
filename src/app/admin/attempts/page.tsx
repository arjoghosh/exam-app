import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Review attempts",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Review attempts"
      description="Student submissions and report access will appear here."
    />
  );
}
