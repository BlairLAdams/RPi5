function initMermaid() {
  if (window.mermaid) {
    mermaid.initialize({
      startOnLoad: true,
      theme: document.documentElement.getAttribute("data-md-color-scheme") === "slate" ? "dark" : "default",
      securityLevel: "loose",
      flowchart: { useMaxWidth: true },
      logLevel: 1
    });
    mermaid.run(); // re-render existing blocks
  }
}

// Initialize on page load
document.addEventListener("DOMContentLoaded", initMermaid);

// Reinitialize after theme toggle
document.addEventListener("change", (event) => {
  if (event.target.matches('[data-md-toggle="color-scheme"]')) {
    setTimeout(initMermaid, 200);
  }
});
