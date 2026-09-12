import type { Metadata } from "next";
import { PlaceholderPage } from "@/components/shared/placeholder-page";

export const metadata: Metadata = {
  title: "Practice with confidence",
};

export default function Page() {
  return (
    <PlaceholderPage
      title="Practice with confidence"
      description="Your mock test platform is taking shape. Choose a development screen below to preview the application structure."
    />
  );
}
