document.addEventListener("DOMContentLoaded", () => {
  const sidebar = document.querySelector(".docs-sidebar") || document.querySelector("nav");
  if (!sidebar) {
    return;
  }

  const base = (window.documenterBaseURL || ".").replace(/\/$/, "");

  const header =
    sidebar.querySelector(".docs-package-name") ||
    sidebar.querySelector(".docs-sidebar-header") ||
    sidebar.querySelector(".docs-header") ||
    sidebar;

  if (header.querySelector("#jcge-sidebar-logo")) {
    return;
  }

  header.innerHTML = "";

  const link =
    document.querySelector("a.docs-logo") ||
    document.querySelector("a.docs-sidebar-title") ||
    document.querySelector("a#documenter-home");

  const logoLink = document.createElement("a");
  logoLink.id = "jcge-sidebar-logo";
  logoLink.className = "jcge-logo";
  logoLink.href = link ? link.href : "/";

  const logoLight = document.createElement("img");
  logoLight.className = "jcge-logo-light";
  logoLight.src = `${base}/assets/jcge_logo_light.png`;
  logoLight.alt = "JCGE";

  const logoDark = document.createElement("img");
  logoDark.className = "jcge-logo-dark";
  logoDark.src = `${base}/assets/jcge_logo_dark.png`;
  logoDark.alt = "JCGE";

  logoLink.appendChild(logoLight);
  logoLink.appendChild(logoDark);
  header.prepend(logoLink);
});
