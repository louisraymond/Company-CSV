import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "results"];
  previousQuery = "";
  timeout = null;

  search() {
    const query = this.inputTarget.value.trim();

    if (query === this.previousQuery && query !== "") return;
    this.previousQuery = query;

    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => this.performSearch(query), 300);
  }

  performSearch(query) {
    fetch(`/companies/search?query=${encodeURIComponent(query)}`, {
      headers: { Accept: "text/vnd.turbo-stream.html" }
    })
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok");
        return response.text();
      })
      .then((html) => {
        Turbo.renderStreamMessage(html);
      })
      .catch((error) => {
        console.error("Search failed:", error);
        this.resultsTarget.innerHTML = "<p>An error occurred. Please try again later.</p>";
      });
  }
}

