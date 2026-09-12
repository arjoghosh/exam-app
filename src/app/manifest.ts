import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    id: "/",
    name: "Mock Test App",
    short_name: "Mock Tests",
    description: "Practice exams with detailed results and explanations.",
    lang: "en",
    start_url: "/",
    scope: "/",
    display: "standalone",
    background_color: "#f8fafc",
    theme_color: "#4f46e5",
  };
}
